import 'dart:async';
import 'dart:io';

import 'package:bonsoir/bonsoir.dart';

/// A device of this app seen on the network (§7.2).
class NearbyDevice {
  const NearbyDevice({
    required this.tag,
    required this.host,
    required this.port,
    required this.userTag,
    required this.platform,
  });

  /// Today's opaque tag for the device (it changes daily, §9).
  final String tag;
  final String host;
  final int port;

  /// Today's opaque tag for its user: equal to yours means it's one of your
  /// devices. Nothing personal, and it changes daily.
  final String userTag;

  /// "windows", "android"…: enough to tell devices apart before pairing,
  /// without announcing a name. Names travel encrypted.
  final String platform;

  /// A short, stable code from the id, to tell two of a kind apart.
  String get shortId => tag.substring(tag.length - 4).toUpperCase();

  String get key => '$host:$port';
}

/// What this device announces: opaque ids and its port, nothing personal.
class Announcement {
  const Announcement({
    required this.tag,
    required this.userTag,
    required this.port,
  });

  final String tag;
  final String userTag;
  final int port;
}

/// Finding the app on the network. mDNS in the app; tests and the "connect
/// by address" fallback don't need it.
abstract class PeerDiscovery {
  Stream<List<NearbyDevice>> get devices;
  Future<void> start(Announcement me);
  Future<void> stop();
}

/// mDNS / DNS-SD via `bonsoir` (§7.2): advertises `_epa-sync._tcp` and
/// lists the others.
class BonsoirPeerDiscovery implements PeerDiscovery {
  static const type = '_epa-sync._tcp';

  BonsoirBroadcast? _broadcast;
  BonsoirDiscovery? _discovery;
  StreamSubscription<BonsoirDiscoveryEvent>? _sub;
  final _found = <String, NearbyDevice>{};
  final _devices = StreamController<List<NearbyDevice>>.broadcast();
  String? _myId;

  @override
  Stream<List<NearbyDevice>> get devices => _devices.stream;

  @override
  Future<void> start(Announcement me) async {
    _myId = me.tag;
    final service = BonsoirService(
      // Opaque ids only (§9): no names in the announcement.
      name: 'epa-${me.tag}',
      type: type,
      port: me.port,
      attributes: {'d': me.tag, 'u': me.userTag, 'p': Platform.operatingSystem},
    );
    final broadcast = _broadcast = BonsoirBroadcast(service: service);
    await broadcast.initialize();
    await broadcast.start();

    final discovery = _discovery = BonsoirDiscovery(type: type);
    await discovery.initialize();
    _sub = discovery.eventStream?.listen((event) {
      switch (event) {
        case BonsoirDiscoveryServiceFoundEvent(:final service):
          unawaited(service.resolve(discovery.serviceResolver));
        case BonsoirDiscoveryServiceResolvedEvent(:final service) ||
            BonsoirDiscoveryServiceUpdatedEvent(:final service):
          _add(service);
        case BonsoirDiscoveryServiceLostEvent(:final service):
          // Lost events often come without attributes (Windows): match
          // the name too.
          _found.removeWhere(
            (_, d) =>
                d.tag == service.attributes['d'] ||
                service.name == 'epa-${d.tag}',
          );
          _devices.add(_found.values.toList());
        default:
          break;
      }
    });
    await discovery.start();
  }

  void _add(BonsoirService? service) {
    if (service == null) return;
    final id = service.attributes['d'];
    if (id == null || id == _myId) return;
    // IPv4 first: the simplest to connect to on a home network.
    final addresses = [...service.hostAddresses]
      ..sort((a, b) {
        int rank(String x) =>
            InternetAddress.tryParse(x)?.type == InternetAddressType.IPv4
            ? 0
            : 1;
        return rank(a) - rank(b);
      });
    final host = addresses.firstOrNull ?? service.hostname;
    if (host == null) return;
    _found[id] = NearbyDevice(
      tag: id,
      host: host,
      port: service.port,
      userTag: service.attributes['u'] ?? '',
      platform: service.attributes['p'] ?? '',
    );
    _devices.add(_found.values.toList());
  }

  @override
  Future<void> stop() async {
    await _sub?.cancel();
    await _discovery?.stop();
    await _broadcast?.stop();
    _found.clear();
  }
}
