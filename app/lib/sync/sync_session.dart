import 'dart:async';

import 'blob_sync.dart';
import 'sync_engine.dart';

/// A two-way message pipe to one peer: the secured connection in the app,
/// an in-memory pair in tests. Messages are JSON-shaped maps.
abstract class SyncChannel {
  Stream<Map<String, dynamic>> get incoming;
  void send(Map<String, Object?> message);

  /// Resolves once what was sent has gone out: senders wait on it so they
  /// never pile a whole history (or file) up in memory.
  Future<void> flush();
  Future<void> close();
}

/// The peer runs a version this one can't sync with (§7.5). Nothing was
/// applied.
class SyncVersionException implements Exception {
  const SyncVersionException(this.message);
  final String message;
  @override
  String toString() => message;
}

/// The peer stopped making sense (closed early, wrong user, bad message).
class SyncProtocolException implements Exception {
  const SyncProtocolException(this.message);
  final String message;
  @override
  String toString() => message;
}

/// What one exchange did.
class SyncReport {
  const SyncReport({
    required this.peerDeviceId,
    required this.sent,
    required this.received,
    required this.unknown,
    this.filesReceived = 0,
    this.peerLabel,
  });

  /// The other device's name, as it calls itself.
  final String? peerLabel;

  final String peerDeviceId;
  final int sent;
  final int received;
  final int unknown;

  /// Attachment files that arrived whole.
  final int filesReceived;
}

/// One exchange with a peer (§7.3): hello and version check, swap version
/// vectors, send what the peer is missing in batches, apply what arrives.
/// Both sides run the same steps. Ops from the peer are applied together
/// once all have arrived, so a cut-off exchange applies nothing.
class SyncSession {
  SyncSession(
    this._engine, {
    required this.deviceId,
    required this.userId,
    required this.schemaVersion,
    this.blobs,
    this.label,
  });

  /// This device's name, shown on the other one (sent encrypted).
  final String? label;

  /// Attachment files; null leaves them out (tests of changes alone).
  final BlobSync? blobs;

  /// Bump when messages change; [minProtocol] is the oldest this version
  /// still talks to.
  static const protocol = 1;
  static const minProtocol = 1;
  final SyncEngine _engine;
  final String deviceId;
  final String userId;
  final int schemaVersion;

  Future<SyncReport> run(
    SyncChannel channel, {
    Duration timeout = const Duration(minutes: 2),
  }) async {
    final inbox = StreamIterator(channel.incoming);
    Future<Map<String, dynamic>> next() async {
      if (!await inbox.moveNext().timeout(timeout)) {
        throw const SyncProtocolException('The other device hung up.');
      }
      final m = inbox.current;
      if (m['type'] == 'error') {
        final message = m['message'] as String? ?? 'Sync failed.';
        if (m['code'] == 'version') throw SyncVersionException(message);
        throw SyncProtocolException(message);
      }
      return m;
    }

    try {
      // 1. Hello and version check.
      channel.send({
        'type': 'hello',
        'protocol': protocol,
        'minProtocol': minProtocol,
        'schema': schemaVersion,
        'device': deviceId,
        'user': userId,
        'files': this.blobs != null,
        'label': label,
      });
      final hello = await next();
      if (hello['type'] != 'hello') {
        throw const SyncProtocolException('Expected hello.');
      }
      final theirs = hello['protocol'] as int;
      final theirMin = hello['minProtocol'] as int;
      if (theirs < minProtocol || protocol < theirMin) {
        const message =
            'The apps are too far apart to sync. Update the older one.';
        channel.send({'type': 'error', 'code': 'version', 'message': message});
        throw const SyncVersionException(message);
      }
      if (hello['user'] != userId) {
        channel.send({'type': 'error', 'message': 'Not the same user.'});
        throw const SyncProtocolException('Not the same user.');
      }
      final peer = hello['device'] as String;

      // 2. What each side has.
      channel.send({'type': 'vector', 'vector': await _engine.vector()});
      final v = await next();
      if (v['type'] != 'vector') {
        throw const SyncProtocolException('Expected a version vector.');
      }
      final theirVector = (v['vector'] as Map).cast<String, String>();

      // 3–4. Send what they're missing a page at a time (waiting for each
      // to go out, so memory stays flat), while taking theirs and applying
      // each batch as it arrives. Both run at once.
      Future<int> sendAll() async {
        var sent = 0;
        await for (final page in _engine.missingPages(theirVector)) {
          channel.send({
            'type': 'ops',
            'ops': [for (final op in page) op.toJson()],
          });
          sent += page.length;
          await channel.flush();
        }
        channel.send({'type': 'done', 'count': sent});
        return sent;
      }

      Future<ApplyResult> takeAll() async {
        final pending = PendingFixups();
        var count = 0;
        var received = 0;
        var unknown = 0;
        while (true) {
          final m = await next();
          if (m['type'] == 'ops') {
            final batch = [
              for (final o in m['ops'] as List)
                SyncOp.fromJson((o as Map).cast<String, dynamic>()),
            ];
            count += batch.length;
            final r = await _engine.applyBatch(batch, pending);
            received += r.received;
            unknown += r.unknown;
          } else if (m['type'] == 'done') {
            if (m['count'] != count) {
              throw const SyncProtocolException('Some changes went missing.');
            }
            break;
          } else {
            throw SyncProtocolException('Unexpected ${m['type']}.');
          }
        }
        await _engine.runFixups(pending);
        return ApplyResult(received: received, applied: 0, unknown: unknown);
      }

      final sending = sendAll();
      final result = await takeAll();
      final sentCount = await sending;

      // 5. Files: what each side's attachments need (§7.3 step 6).
      var files = 0;
      final blobs = this.blobs;
      if (blobs != null && hello['files'] == true) {
        channel.send({'type': 'blobs-want', 'items': await blobs.wants()});
        final want = await next();
        if (want['type'] != 'blobs-want') {
          throw const SyncProtocolException('Expected a file list.');
        }
        await for (final chunk in blobs.serve(want['items'] as List)) {
          channel.send(chunk);
          await channel.flush(); // one chunk in memory at a time
        }
        channel.send({'type': 'blobs-done'});
        while (true) {
          final m = await next();
          if (m['type'] == 'blobs-done') break;
          if (m['type'] != 'blob') {
            throw SyncProtocolException('Unexpected ${m['type']}.');
          }
          if (await blobs.receive(m)) files++;
        }
      }
      return SyncReport(
        peerDeviceId: peer,
        sent: sentCount,
        received: result.received,
        unknown: result.unknown,
        filesReceived: files,
        peerLabel: hello['label'] as String?,
      );
    } finally {
      await inbox.cancel();
    }
  }
}
