import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart' as hash;
import 'package:drift/drift.dart';

import '../data/blob_store.dart';
import '../data/database.dart';
import '../platform/app_log.dart';
import '../identity/identity_service.dart';
import '../identity/secret_store.dart';
import 'blob_sync.dart';
import 'change_writer.dart';
import 'discovery.dart';
import 'pairing.dart';
import 'secure_channel.dart';
import 'sync_engine.dart';
import 'sync_session.dart';

enum SyncPhase { starting, idle, syncing, error, off }

/// What the sync status icon and the Devices page show.
class SyncStatus {
  const SyncStatus({
    required this.phase,
    this.lastSync,
    this.message,
    this.address,
  });

  final SyncPhase phase;
  final DateTime? lastSync;

  /// The last problem, in words.
  final String? message;

  /// Where other devices can reach this one ("192.168.1.20:47913"), for
  /// connecting by address when the network hides discovery.
  final String? address;

  SyncStatus copyWith({
    SyncPhase? phase,
    DateTime? lastSync,
    String? message,
    bool clearMessage = false,
    String? address,
  }) => SyncStatus(
    phase: phase ?? this.phase,
    lastSync: lastSync ?? this.lastSync,
    message: clearMessage ? null : message ?? this.message,
    address: address ?? this.address,
  );
}

/// Asks the person on this device (hosting) to compare a pairing code.
typedef PairRequestHandler = Future<bool> Function(PeerInfo peer, String code);

/// LAN sync while the app runs (§7.3, §7.6 step 5): listens for your other
/// devices, announces itself over mDNS, finds them, and syncs on start,
/// every few minutes, shortly after edits and when one appears. Also hosts
/// and joins pairings.
///
/// Phones call [suspend] when the app goes to the background (no
/// listening, announcing or timers then: battery) and [resume] when it
/// comes back.
class SyncService {
  /// Off in widget tests (no sockets or mDNS there).
  static bool enabled = true;

  SyncService({
    required AppDatabase db,
    required ChangeWriter writer,
    required this.identity,
    required this.secrets,
    required this.blobStore,
    required this.deviceId,
    required this.userId,
    required this.userPublicKey,
    required this.personalSpaceId,
    this.backupDir,
    PeerDiscovery? discovery,
    this.preferredPort = 47913,
    this.interval = const Duration(minutes: 5),
    this.afterEdits = const Duration(seconds: 15),
  }) : _db = db,
       _discovery = discovery ?? BonsoirPeerDiscovery(),
       _engine = SyncEngine(db, writer);

  final AppDatabase _db;
  final IdentityService identity;
  final SecretStore secrets;
  final BlobStore blobStore;

  /// Where a copy of the database goes before joining (null: no copy).
  final Directory? backupDir;
  final PeerDiscovery _discovery;
  final SyncEngine _engine;

  final String deviceId;
  final String userId;
  final String userPublicKey;
  final String personalSpaceId;
  final int preferredPort;
  final Duration interval;
  final Duration afterEdits;

  /// Strangers allowed to be mid-handshake at once.
  static const maxHandshakes = 4;

  // ------------------------------------------------------------------ tags

  /// Keyed from the user's private key, so only your devices can tell
  /// that today's tags and yesterday's belong together (§9): on a public
  /// network the announcements can't be used to follow a device around.
  List<int>? _tagKey;

  static String _day(DateTime t) =>
      t.toUtc().toIso8601String().substring(0, 10);

  String _tag(String what, DateTime at) => hash.Hmac(
    hash.sha256,
    _tagKey ?? const [0],
  ).convert(utf8.encode('$what|${_day(at)}')).toString().substring(0, 16);

  static const _days = [-1, 0, 1]; // clocks a day apart still match

  /// Today's tag for your user: the same on all your devices.
  String get userTag => _tag('user', DateTime.now());

  /// Today's tag for one of your devices.
  String deviceTag(String id, [DateTime? at]) =>
      _tag('device|$id', at ?? DateTime.now());

  /// Four characters from this device's tag, shown on both screens while
  /// pairing, to pick the right device from the list.
  String get shortCode => deviceTag(deviceId).substring(12).toUpperCase();

  /// Whether [d] is one of your devices.
  bool isMine(NearbyDevice d) => _days.any(
    (o) => d.userTag == _tag('user', DateTime.now().add(Duration(days: o))),
  );

  /// This device's own announcement, seen back: one of its tags for
  /// yesterday, today or tomorrow (an old record mDNS still holds), or one
  /// of its own network addresses. Never synced with.
  bool isSelf(NearbyDevice d) =>
      _ownHosts.contains(d.host) ||
      _days.any(
        (o) =>
            d.tag == deviceTag(deviceId, DateTime.now().add(Duration(days: o))),
      );

  /// Whether your device [id] is on the network now.
  bool isNearby(String id) => _nearby.any(
    (n) => _days.any(
      (o) => n.tag == deviceTag(id, DateTime.now().add(Duration(days: o))),
    ),
  );

  // ---------------------------------------------------------------- state

  ServerSocket? _server;
  Timer? _periodic;
  Timer? _editDebounce;
  StreamSubscription<Object?>? _edits;
  StreamSubscription<List<NearbyDevice>>? _nearbySub;
  String? _announcedDay;
  final _busy = <String>{};
  int _handshaking = 0;

  /// Until then (shortly after coming up), every device that appears is
  /// synced with, not just those this one leads: the other side may have
  /// dropped this one while it was away.
  DateTime _greetUntil = DateTime(0);

  /// This device's addresses (not loopback), refreshed on coming up.
  var _ownHosts = const <String>{};
  bool _up = false;
  bool _closed = false;
  Future<DeviceCredentials>? _credentials;

  Future<DeviceCredentials> _me() => _credentials ??= identity.credentials();

  var _status = const SyncStatus(phase: SyncPhase.starting);
  final _statusOut = StreamController<SyncStatus>.broadcast();
  SyncStatus get status => _status;
  Stream<SyncStatus> get statusChanges => _statusOut.stream;
  void _set(SyncStatus s) {
    if (s.message != null && s.message != _status.message) {
      AppLog.write('sync', '${s.phase.name}: ${s.message}');
    }
    _status = s;
    if (!_statusOut.isClosed) _statusOut.add(s);
  }

  var _nearby = const <NearbyDevice>[];
  final _nearbyOut = StreamController<List<NearbyDevice>>.broadcast();
  List<NearbyDevice> get nearby => _nearby;
  Stream<List<NearbyDevice>> get nearbyChanges => _nearbyOut.stream;
  void _setNearby(List<NearbyDevice> list) {
    _nearby = list;
    if (!_nearbyOut.isClosed) _nearbyOut.add(list);
  }

  /// Set while "Let a device join" is open here: pairing requests are
  /// only taken then, and this asks the person to compare the code.
  PairRequestHandler? pairingHost;

  /// How each pairing hosted here ended: null = joined, else why not.
  final _pairings = StreamController<String?>.broadcast();
  Stream<String?> get pairingOutcomes => _pairings.stream;

  int? get port => _server?.port;

  BlobSync get _blobs => BlobSync(_db, blobStore);

  Future<String> label() async =>
      (await _thisDevice())?.label ?? defaultLabel();

  static String defaultLabel() => Platform.isWindows
      ? Platform.localHostname
      : Platform.isAndroid
      ? 'Android phone'
      : Platform.operatingSystem;

  Future<Device?> _thisDevice() => (_db.select(
    _db.devices,
  )..where((d) => d.isThisDevice.equals(true))).getSingleOrNull();

  // ------------------------------------------------------------ lifecycle

  /// Starts listening, announcing and finding.
  Future<void> start() async {
    try {
      final seed = await identity.userPrivateKey();
      _tagKey = hash.Hmac(
        hash.sha256,
        base64Decode(seed),
      ).convert(utf8.encode('epa discovery tags v1')).bytes;
      await _engine.applyPending();
    } catch (e) {
      _set(SyncStatus(phase: SyncPhase.off, message: 'Sync is off: $e'));
      return;
    }
    await _goUp();
  }

  /// The app went to the background (phones): stop listening, announcing
  /// and timers until [resume].
  Future<void> suspend() => _goDown();

  /// Back in the foreground: start again, and sync.
  Future<void> resume() async {
    if (_closed) return;
    await _goUp();
    unawaited(syncNow());
  }

  Future<void> _goUp() async {
    if (_up || _closed) return;
    _up = true;
    _greetUntil = DateTime.now().add(const Duration(seconds: 30));
    try {
      try {
        _server = await ServerSocket.bind(
          InternetAddress.anyIPv4,
          preferredPort,
        );
      } on SocketException {
        _server = await ServerSocket.bind(InternetAddress.anyIPv4, 0);
      }
      _server!.listen(_accept);
      _set(_status.copyWith(phase: SyncPhase.idle, address: await _address()));
      _ownHosts = await _localHosts();

      _nearbySub = _discovery.devices.listen((all) {
        final list = [...all.where((d) => !isSelf(d))];
        final greet = DateTime.now().isBefore(_greetUntil);
        final appeared = list.where(
          (d) =>
              (greet ? isMine(d) : _leads(d)) &&
              !_nearby.any((n) => n.key == d.key),
        );
        _setNearby(list);
        for (final d in appeared) {
          unawaited(syncWith(d.host, d.port, quiet: true));
        }
      });
      await _announce();

      _periodic = Timer.periodic(interval, (_) async {
        // New tags each day: announce again after midnight.
        if (_announcedDay != _day(DateTime.now())) {
          await _discovery.stop();
          await _announce();
        }
        await syncNow(scheduled: true);
      });
      // Shortly after this device's own edits.
      _edits = _db
          .customSelect(
            'SELECT MAX(hlc) AS h FROM change_log WHERE origin_device_id = ?',
            variables: [Variable.withString(deviceId)],
            readsFrom: {_db.changeLog},
          )
          .watchSingle()
          .skip(1)
          .listen((_) {
            _editDebounce?.cancel();
            _editDebounce = Timer(afterEdits, syncNow);
          });
    } catch (e) {
      _set(SyncStatus(phase: SyncPhase.off, message: 'Sync is off: $e'));
    }
  }

  Future<void> _announce() async {
    _announcedDay = _day(DateTime.now());
    try {
      await _discovery.start(
        Announcement(tag: deviceTag(deviceId), userTag: userTag, port: port!),
      );
    } catch (e) {
      _set(
        _status.copyWith(
          message:
              'Finding devices isn\'t working here ($e). '
              'Connect by address instead.',
        ),
      );
    }
  }

  Future<void> _goDown() async {
    if (!_up) return;
    _up = false;
    _periodic?.cancel();
    _editDebounce?.cancel();
    await _edits?.cancel();
    await _nearbySub?.cancel();
    try {
      await _discovery.stop();
    } catch (_) {}
    await _server?.close();
    _server = null;
    _setNearby(const []);
  }

  Future<void> stop() async {
    _closed = true;
    await _goDown();
    await _statusOut.close();
    await _nearbyOut.close();
    await _pairings.close();
  }

  Future<Set<String>> _localHosts() async {
    try {
      return {
        for (final i in await NetworkInterface.list(
          type: InternetAddressType.any,
        ))
          for (final a in i.addresses)
            if (!a.isLoopback) a.address,
      };
    } catch (_) {
      return const {};
    }
  }

  /// This device's LAN address and port.
  Future<String?> _address() async {
    try {
      for (final i in await NetworkInterface.list(
        type: InternetAddressType.IPv4,
      )) {
        for (final a in i.addresses) {
          if (!a.isLoopback && !a.isLinkLocal) return '${a.address}:$port';
        }
      }
    } catch (_) {}
    return null;
  }

  // ----------------------------------------------------------------- sync

  /// For syncs nobody asked for (a device appeared, the timer), only one
  /// of the two starts one: the one with the smaller tag. Saves doing
  /// everything twice (battery). Edits, Sync now and coming back to the app
  /// always start one.
  bool _leads(NearbyDevice d) =>
      isMine(d) && deviceTag(deviceId).compareTo(d.tag) < 0;

  /// Syncs with every one of your devices currently seen ([scheduled]: only
  /// those this device leads). [quiet] (all but Sync now): a device that
  /// can't be reached isn't an error; it has most likely just left.
  Future<void> syncNow({bool scheduled = false, bool quiet = true}) async {
    for (final d in [..._nearby.where(scheduled ? _leads : isMine)]) {
      await syncWith(d.host, d.port, quiet: quiet);
    }
  }

  /// One exchange with the device at [host]:[port]. Returns null if one
  /// with it is already running.
  ///
  /// [quiet]: if the device can't be reached at all (refused, timed out),
  /// it's logged and dropped from [nearby] until it announces itself again,
  /// instead of showing an error.
  Future<SyncReport?> syncWith(
    String host,
    int port, {
    bool quiet = false,
  }) async {
    final key = '$host:$port';
    if (_closed || !_busy.add(key)) return null;
    _set(_status.copyWith(phase: SyncPhase.syncing));
    try {
      final SecureChannel ch;
      try {
        ch = await SecureChannel.connect(
          host,
          port,
          me: await _me(),
          mode: ChannelMode.sync,
        );
      } on Exception catch (e) {
        if (!quiet || (e is! SocketException && e is! TimeoutException)) {
          rethrow;
        }
        AppLog.write('sync', 'not reachable, dropped until seen again: $e');
        _setNearby([..._nearby.where((n) => n.key != key)]);
        _set(_status.copyWith(phase: SyncPhase.idle));
        return null;
      }
      try {
        return await _run(ch);
      } finally {
        await ch.close();
      }
    } catch (e) {
      _set(_status.copyWith(phase: SyncPhase.error, message: '$e'));
      return null;
    } finally {
      _busy.remove(key);
    }
  }

  Future<SyncReport> _run(SecureChannel ch) async {
    final report = await SyncSession(
      _engine,
      deviceId: deviceId,
      userId: userId,
      schemaVersion: _db.schemaVersion,
      blobs: _blobs,
      label: await label(),
    ).run(ch);
    await rememberDevice(
      _db,
      ch.peer,
      userId: userId,
      signature: ch.peer.deviceSignature,
      label: report.peerLabel,
    );
    await markSynced(_db, ch.peer.deviceId);
    _set(
      _status.copyWith(
        phase: SyncPhase.idle,
        lastSync: DateTime.now(),
        clearMessage: true,
      ),
    );
    return report;
  }

  Future<void> _accept(Socket socket) async {
    // Strangers can connect: only a few handshakes at once, and their
    // failures aren't shown as sync problems.
    if (_handshaking >= maxHandshakes) {
      socket.destroy();
      return;
    }
    _handshaking++;
    SecureChannel ch;
    try {
      ch = await SecureChannel.accept(
        socket,
        me: await _me(),
        allow: (m) => m == ChannelMode.sync || pairingHost != null,
      );
    } catch (_) {
      return;
    } finally {
      _handshaking--;
    }
    try {
      if (ch.mode == ChannelMode.pair) {
        final host = pairingHost;
        if (host == null) return;
        try {
          await hostPairing(
            ch,
            db: _db,
            identity: identity,
            secrets: secrets,
            engine: _engine,
            deviceId: deviceId,
            userId: userId,
            personalSpaceId: personalSpaceId,
            confirm: host,
            label: await label(),
            blobs: _blobs,
          );
          if (!_pairings.isClosed) _pairings.add(null);
          _set(
            _status.copyWith(
              phase: SyncPhase.idle,
              lastSync: DateTime.now(),
              clearMessage: true,
            ),
          );
        } catch (e) {
          if (!_pairings.isClosed) _pairings.add('$e');
        }
      } else {
        _set(_status.copyWith(phase: SyncPhase.syncing));
        await _run(ch);
      }
    } catch (e) {
      _set(_status.copyWith(phase: SyncPhase.error, message: '$e'));
    } finally {
      await ch.close();
    }
  }

  // -------------------------------------------------------------- joining

  /// Joins the device at [host]:[port] (§7.2): this device becomes one of
  /// that user's, keeping its items. A copy of this device's database is
  /// kept first. The app must reload its identity afterwards.
  Future<SyncReport> join(
    String host,
    int port, {
    required ConfirmCode confirm,
    required AskPin askPin,
  }) async {
    await backupDatabase('before-join');
    final ch = await SecureChannel.connect(
      host,
      port,
      me: await _me(),
      mode: ChannelMode.pair,
    );
    try {
      return await joinPairing(
        ch,
        db: _db,
        secrets: secrets,
        deviceId: deviceId,
        confirm: confirm,
        askPin: askPin,
        label: await label(),
        blobs: (engine) => BlobSync(_db, blobStore),
      );
    } finally {
      await ch.close();
    }
  }

  /// Copies the database to [backupDir] (`epa-<why>-<time>.sqlite`),
  /// keeping the newest three.
  Future<File?> backupDatabase(String why) async {
    final dir = backupDir;
    if (dir == null) return null;
    await dir.create(recursive: true);
    final stamp = DateTime.now().toIso8601String().replaceAll(
      RegExp(r'[:.]'),
      '-',
    );
    final file = File(
      '${dir.path}${Platform.pathSeparator}epa-$why-$stamp.sqlite',
    );
    await _db.customStatement('VACUUM INTO ?', [file.path]);
    final old =
        dir
            .listSync()
            .whereType<File>()
            .where((f) => f.path.endsWith('.sqlite'))
            .toList()
          ..sort((a, b) => b.path.compareTo(a.path));
    for (final f in old.skip(3)) {
      await f.delete();
    }
    return file;
  }

  /// Renames this device (shown on your others after the next sync).
  Future<void> setLabel(String label) =>
      (_db.update(_db.devices)..where((d) => d.isThisDevice.equals(true)))
          .write(DevicesCompanion(label: Value(label)));
}
