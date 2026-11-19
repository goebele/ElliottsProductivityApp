import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:crypto/crypto.dart' as hash;
import 'package:cryptography/cryptography.dart';

import 'sync_session.dart';

/// What this device proves about itself when it connects (§7.2): its device
/// key, and the user key's signature over it.
class DeviceCredentials {
  const DeviceCredentials({
    required this.deviceId,
    required this.deviceKey,
    required this.devicePublicKey,
    required this.userPublicKey,
    required this.deviceSignature,
  });

  final String deviceId;
  final SimpleKeyPair deviceKey;

  /// Base64 Ed25519 public keys, and the user key's signature (base64)
  /// over the device public key.
  final String devicePublicKey;
  final String userPublicKey;
  final String deviceSignature;
}

/// Why a connection is made: to sync (both sides must be the same user) or
/// to pair (anyone; the people check a code on both screens).
enum ChannelMode { sync, pair }

/// Who's on the other end, as proven in the handshake.
class PeerInfo {
  const PeerInfo({
    required this.deviceId,
    required this.devicePublicKey,
    required this.userPublicKey,
    required this.deviceSignature,
  });

  final String deviceId;
  final String devicePublicKey;
  final String userPublicKey;
  final String deviceSignature;
}

class HandshakeException implements Exception {
  const HandshakeException(this.message);
  final String message;
  @override
  String toString() => message;
}

/// A TCP connection secured from the pairing keys (§7.2, v0.23): instead of
/// TLS, a small handshake in the style of Noise XX:
///
/// 1. The connecting side **commits** to a fresh X25519 key (sends its
///    hash) and says why it's connecting.
/// 2. The listening side sends its fresh key.
/// 3. The connecting side reveals its key; it must match the commitment.
///    Neither side could pick its key after seeing the other's, so the
///    six-digit [pairingCode] can't be steered by someone in the middle.
/// 4. Both derive two session keys (X25519 + HKDF-SHA256). From here every
///    frame is sealed with ChaCha20-Poly1305 under a counting nonce.
/// 5. The connecting side proves who it is (device key, the user key's
///    signature over it, a signature over this handshake); to sync, it must
///    be one of your devices. Only then does the listening side prove who
///    it is. So a stranger who connects learns nothing about this device.
///
/// Frames are length-prefixed (4 bytes, big-endian); messages are JSON.
/// Frames are kept small until the other side has proven itself.
class SecureChannel implements SyncChannel {
  SecureChannel._(
    this._socket,
    this._frames,
    this._sendKey,
    this._receiveKey,
    this.peer,
    this.pairingCode,
    this.mode,
    this._sendCount,
    this._receiveCount,
  ) {
    unawaited(_pump());
  }

  /// Opens frames one at a time, in order, and hands them on as messages.
  Future<void> _pump() async {
    try {
      while (await _frames.moveNext()) {
        final clear = await _open(_frames.current);
        if (_incoming.isClosed) return;
        _incoming.add(
          (jsonDecode(utf8.decode(clear)) as Map).cast<String, dynamic>(),
        );
      }
    } catch (e) {
      if (!_incoming.isClosed) {
        _incoming.addError(
          e is SocketException
              ? const SyncProtocolException('The connection dropped.')
              : const SyncProtocolException('A message failed its check.'),
        );
      }
      _socket.destroy();
    }
    if (!_incoming.isClosed) await _incoming.close();
  }

  static const _version = 2;
  // With cryptography_flutter in the app (it registers itself), these use
  // Android's own code, or a background isolate: lighter on a phone.
  static final _aead = Chacha20.poly1305Aead();
  static final _ed25519 = Ed25519();
  static final _x25519 = X25519();

  /// Largest frame before the other side has proven itself, and after.
  static const handshakeFrameLimit = 4 * 1024;
  static const frameLimit = 16 * 1024 * 1024;

  final Socket _socket;
  final StreamIterator<Uint8List> _frames;
  final SecretKey _sendKey;
  final SecretKey _receiveKey;
  final _incoming = StreamController<Map<String, dynamic>>();
  int _sendCount;
  int _receiveCount;
  Future<void> _sending = Future.value();

  final PeerInfo peer;

  /// Six digits, the same on both ends: shown while pairing.
  final String pairingCode;

  /// Why the other side connected.
  final ChannelMode mode;

  @override
  Stream<Map<String, dynamic>> get incoming => _incoming.stream;

  /// Connects to a peer at [host]:[port] and runs the handshake.
  static Future<SecureChannel> connect(
    String host,
    int port, {
    required DeviceCredentials me,
    required ChannelMode mode,
    Duration timeout = const Duration(seconds: 10),
  }) async {
    final socket = await Socket.connect(host, port, timeout: timeout);
    return _handshake(socket, me: me, mode: mode, client: true);
  }

  /// The listening side's handshake on an accepted [socket]. [allow] says
  /// whether this device takes that kind of connection now (pairing only
  /// while "Let a device join" is open). Labels are exchanged later.
  static Future<SecureChannel> accept(
    Socket socket, {
    required DeviceCredentials me,
    required bool Function(ChannelMode mode) allow,
  }) => _handshake(socket, me: me, client: false, allow: allow);

  static Future<SecureChannel> _handshake(
    Socket socket, {
    required DeviceCredentials me,
    ChannelMode? mode,
    required bool client,
    bool Function(ChannelMode mode)? allow,
  }) async {
    socket.setOption(SocketOption.tcpNoDelay, true);
    var limit = handshakeFrameLimit;
    final frames = StreamIterator(_deframe(socket, () => limit));
    Future<Uint8List> nextFrame() async {
      if (!await frames.moveNext().timeout(_wait)) {
        throw const HandshakeException('The other device hung up.');
      }
      return frames.current;
    }

    void sendClear(Map<String, Object?> m) =>
        _writeFrame(socket, utf8.encode(jsonEncode(m)));

    try {
      final eph = await _x25519.newKeyPair();
      final ephPub = (await eph.extractPublicKey()).bytes;

      // 1–3: commit, answer, reveal.
      ChannelMode m;
      List<int> theirEph;
      if (client) {
        m = mode!;
        sendClear({
          'v': _version,
          'mode': m.name,
          'commit': base64Encode(hash.sha256.convert(ephPub).bytes),
        });
        final answer = _decode(await nextFrame());
        if (answer['v'] != _version) {
          throw const HandshakeException(
            'The other device runs a version that can\'t sync with this one.',
          );
        }
        theirEph = _bytes(answer['eph'], 32);
        sendClear({'eph': base64Encode(ephPub)});
      } else {
        final first = _decode(await nextFrame());
        if (first['v'] != _version) {
          throw const HandshakeException('Another version connected.');
        }
        m = ChannelMode.values.firstWhere(
          (x) => x.name == first['mode'],
          orElse: () => throw const HandshakeException('Unknown mode.'),
        );
        if (allow != null && !allow(m)) {
          throw const HandshakeException('Not accepting that now.');
        }
        final commit = _bytes(first['commit'], 32);
        sendClear({'v': _version, 'eph': base64Encode(ephPub)});
        theirEph = _bytes(_decode(await nextFrame())['eph'], 32);
        final opened = hash.sha256.convert(theirEph).bytes;
        if (!_same(opened, commit)) {
          throw const HandshakeException('The other device broke its word.');
        }
      }

      // 4: session keys and the code.
      final shared = await _x25519.sharedSecretKey(
        keyPair: eph,
        remotePublicKey: SimplePublicKey(theirEph, type: KeyPairType.x25519),
      );
      final clientEph = client ? ephPub : theirEph;
      final serverEph = client ? theirEph : ephPub;
      final salt = [...clientEph, ...serverEph];
      final okm = await Hkdf(hmac: Hmac.sha256(), outputLength: 64).deriveKey(
        secretKey: shared,
        nonce: salt,
        info: utf8.encode('epa-sync ${m.name} v$_version'),
      );
      final keyBytes = await okm.extractBytes();
      final c2s = SecretKey(keyBytes.sublist(0, 32));
      final s2c = SecretKey(keyBytes.sublist(32, 64));
      final sendKey = client ? c2s : s2c;
      final receiveKey = client ? s2c : c2s;
      final transcript = hash.sha256.convert([
        ...utf8.encode('epa-sync v$_version ${m.name}'),
        ...salt,
      ]).bytes;
      final digest = hash.sha256.convert(salt).bytes;
      final code =
          ((digest[0] << 24 | digest[1] << 16 | digest[2] << 8 | digest[3]) %
                  1000000)
              .toString()
              .padLeft(6, '0');

      // 5: identities, sealed. The connecting side goes first.
      Future<void> sendIdentity() async {
        final role = client ? 'client' : 'server';
        final sig = await _ed25519.sign([
          ...transcript,
          ...utf8.encode(role),
        ], keyPair: me.deviceKey);
        final box = await _aead.encrypt(
          utf8.encode(
            jsonEncode({
              'device': me.deviceId,
              'devicePub': me.devicePublicKey,
              'userPub': me.userPublicKey,
              'devSig': me.deviceSignature,
              'sig': base64Encode(sig.bytes),
            }),
          ),
          secretKey: sendKey,
          nonce: _nonceFor(0),
        );
        _writeFrame(socket, [...box.cipherText, ...box.mac.bytes]);
      }

      Future<PeerInfo> readIdentity() async {
        final frame = await nextFrame();
        if (frame.length < 16) throw const HandshakeException('Bad message.');
        final List<int> clear;
        try {
          clear = await _aead.decrypt(
            SecretBox(
              frame.sublist(0, frame.length - 16),
              nonce: _nonceFor(0),
              mac: Mac(frame.sublist(frame.length - 16)),
            ),
            secretKey: receiveKey,
          );
        } catch (_) {
          throw const HandshakeException('Bad message.');
        }
        final id = _decode(Uint8List.fromList(clear));
        final role = client ? 'server' : 'client';
        final devicePub = _bytes(id['devicePub'], 32);
        final ok = await _ed25519.verify(
          [...transcript, ...utf8.encode(role)],
          signature: Signature(
            _bytes(id['sig'], 64),
            publicKey: SimplePublicKey(devicePub, type: KeyPairType.ed25519),
          ),
        );
        if (!ok) throw const HandshakeException('Bad signature.');
        // To sync, they must be one of your devices: your user key signed
        // their device key.
        if (m == ChannelMode.sync) {
          if (id['userPub'] != me.userPublicKey) {
            throw const HandshakeException('Not one of your devices.');
          }
          final devOk = await _ed25519.verify(
            devicePub,
            signature: Signature(
              _bytes(id['devSig'], 64),
              publicKey: SimplePublicKey(
                base64Decode(me.userPublicKey),
                type: KeyPairType.ed25519,
              ),
            ),
          );
          if (!devOk) {
            throw const HandshakeException('Not one of your devices.');
          }
        }
        return PeerInfo(
          deviceId: id['device'] as String,
          devicePublicKey: id['devicePub'] as String,
          userPublicKey: id['userPub'] as String,
          deviceSignature: id['devSig'] as String,
        );
      }

      final PeerInfo peer;
      if (client) {
        await sendIdentity();
        peer = await readIdentity();
      } else {
        peer = await readIdentity();
        await sendIdentity();
      }

      limit = frameLimit;
      return SecureChannel._(
        socket,
        frames,
        sendKey,
        receiveKey,
        peer,
        code,
        m,
        1,
        1,
      );
    } catch (e) {
      await frames.cancel();
      socket.destroy();
      if (e is HandshakeException) rethrow;
      if (e is TimeoutException) {
        throw const HandshakeException('The other device didn\'t answer.');
      }
      throw HandshakeException('Couldn\'t connect: $e');
    }
  }

  static const _wait = Duration(seconds: 10);

  static Map<String, dynamic> _decode(Uint8List frame) {
    try {
      return (jsonDecode(utf8.decode(frame)) as Map).cast<String, dynamic>();
    } catch (_) {
      throw const HandshakeException('Not the app on the other end.');
    }
  }

  /// Base64 [value] of exactly [length] bytes, or a handshake error.
  static List<int> _bytes(Object? value, int length) {
    try {
      final b = base64Decode(value as String);
      if (b.length == length) return b;
    } catch (_) {}
    throw const HandshakeException('Not the app on the other end.');
  }

  static bool _same(List<int> a, List<int> b) {
    if (a.length != b.length) return false;
    var diff = 0;
    for (var i = 0; i < a.length; i++) {
      diff |= a[i] ^ b[i];
    }
    return diff == 0;
  }

  static List<int> _nonceFor(int n) {
    final b = ByteData(12)..setUint64(4, n);
    return b.buffer.asUint8List();
  }

  Future<List<int>> _open(Uint8List frame) async {
    if (frame.length < 16) throw const FormatException('short');
    final box = SecretBox(
      frame.sublist(0, frame.length - 16),
      nonce: _nonceFor(_receiveCount++),
      mac: Mac(frame.sublist(frame.length - 16)),
    );
    return _aead.decrypt(box, secretKey: _receiveKey);
  }

  @override
  void send(Map<String, Object?> message) {
    final clear = utf8.encode(jsonEncode(message));
    final n = _sendCount++;
    // Sealed in order, so nonces and frames line up.
    _sending = _sending.then((_) async {
      final box = await _aead.encrypt(
        clear,
        secretKey: _sendKey,
        nonce: _nonceFor(n),
      );
      _writeFrame(_socket, [...box.cipherText, ...box.mac.bytes]);
    });
  }

  /// Waits until everything sent so far is sealed and handed to the
  /// network, so a sender never runs far ahead of the connection.
  @override
  Future<void> flush() async {
    await _sending;
    await _socket.flush();
  }

  @override
  Future<void> close() async {
    try {
      await flush();
    } catch (_) {}
    if (!_incoming.isClosed) await _incoming.close();
    _socket.destroy();
    await _frames.cancel();
  }

  // --------------------------------------------------------------- framing

  static void _writeFrame(Socket socket, List<int> payload) {
    final header = ByteData(4)..setUint32(0, payload.length);
    socket.add(header.buffer.asUint8List());
    socket.add(payload);
  }

  /// Splits the byte stream into frames, each byte copied once. A frame
  /// over [limit] ends the connection before it's buffered.
  static Stream<Uint8List> _deframe(
    Stream<Uint8List> input,
    int Function() limit,
  ) async* {
    final buffer = BytesBuilder(copy: false);
    int? need;
    await for (final chunk in input) {
      buffer.add(chunk);
      while (true) {
        if (need == null) {
          if (buffer.length < 4) break;
          final all = buffer.takeBytes();
          need = ByteData.sublistView(all, 0, 4).getUint32(0);
          if (need > limit()) throw const FormatException('frame too large');
          if (all.length > 4) buffer.add(Uint8List.sublistView(all, 4));
        }
        if (buffer.length < need) break;
        final all = buffer.takeBytes();
        yield Uint8List.sublistView(all, 0, need);
        if (all.length > need) buffer.add(Uint8List.sublistView(all, need));
        need = null;
      }
    }
  }
}
