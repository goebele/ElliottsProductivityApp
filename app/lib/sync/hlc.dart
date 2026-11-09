/// Hybrid logical clock (DESIGN.md §7.1).
///
/// Serialized as `<millis:15 digits>-<counter:4 hex>-<nodeId>`, so plain
/// string comparison gives the total order used for last-writer-wins.
class Hlc implements Comparable<Hlc> {
  const Hlc(this.millis, this.counter, this.nodeId)
    : assert(counter >= 0 && counter <= maxCounter);

  static const maxCounter = 0xFFFF;

  final int millis;
  final int counter;

  /// The device ID that produced this stamp; breaks ties between devices.
  final String nodeId;

  factory Hlc.parse(String s) {
    final first = s.indexOf('-');
    final second = s.indexOf('-', first + 1);
    if (first != 15 || second != 20) {
      throw FormatException('Not an HLC stamp', s);
    }
    return Hlc(
      int.parse(s.substring(0, first)),
      int.parse(s.substring(first + 1, second), radix: 16),
      s.substring(second + 1),
    );
  }

  @override
  int compareTo(Hlc other) => toString().compareTo(other.toString());

  @override
  bool operator ==(Object other) =>
      other is Hlc && other.toString() == toString();

  @override
  int get hashCode => toString().hashCode;

  @override
  String toString() =>
      '${millis.toString().padLeft(15, '0')}-'
      '${counter.toRadixString(16).padLeft(4, '0')}-$nodeId';
}

/// Issues HLC stamps for one device.
class HlcClock {
  HlcClock(this.nodeId, {int Function()? wallClock, Hlc? last})
    : _wallClock = wallClock ?? (() => DateTime.now().millisecondsSinceEpoch),
      _last = last ?? Hlc(0, 0, nodeId);

  final String nodeId;
  final int Function() _wallClock;
  Hlc _last;

  Hlc get last => _last;

  /// Stamp for a local change.
  Hlc now() => _advance(_last.millis, _last.counter);

  /// Merge a stamp received from a peer so later local stamps sort after it.
  Hlc receive(Hlc remote) {
    if (remote.millis > _last.millis ||
        (remote.millis == _last.millis && remote.counter > _last.counter)) {
      return _advance(remote.millis, remote.counter);
    }
    return _advance(_last.millis, _last.counter);
  }

  Hlc _advance(int millis, int counter) {
    final wall = _wallClock();
    if (wall > millis) {
      _last = Hlc(wall, 0, nodeId);
    } else {
      if (counter >= Hlc.maxCounter) {
        throw StateError('HLC counter overflow');
      }
      _last = Hlc(millis, counter + 1, nodeId);
    }
    return _last;
  }
}
