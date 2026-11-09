/// Fractional sort keys for ordering siblings (DESIGN.md §5.2 `sort_key`).
///
/// Keys compare with plain string (and SQLite BINARY) order, and there is
/// always room for a new key between any two, so inserting or moving a node
/// writes only that node's key. Keys look like `a0`, `a1`, `a0V`.
///
/// Format (from the widely used "fractional-indexing" scheme): an integer
/// part, whose first character encodes its length (`a`–`z` = 2–27 chars for
/// non-negative, `Z`–`A` for negative), then an optional base-62 fraction
/// that never ends in `0`. Appending at either end grows the integer part, so
/// long lists keep short keys.
library;

const _digits =
    '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';
final _smallestInteger = 'A${_digits[0] * 26}';

/// A key that sorts after [a] and before [b]. Null means "no bound".
///
/// Throws [ArgumentError] if `a >= b` or either key is malformed.
String keyBetween(String? a, String? b) {
  if (a != null) _validateKey(a);
  if (b != null) _validateKey(b);
  if (a != null && b != null && a.compareTo(b) >= 0) {
    throw ArgumentError('$a is not before $b');
  }

  if (a == null) {
    if (b == null) return 'a${_digits[0]}';
    final ib = _integerPart(b);
    final fb = b.substring(ib.length);
    if (ib == _smallestInteger) return ib + _midpoint('', fb);
    if (ib.compareTo(b) < 0) return ib;
    final decremented = _decrementInteger(ib);
    if (decremented == null) throw StateError('Cannot go below $b');
    return decremented;
  }

  if (b == null) {
    final ia = _integerPart(a);
    final fa = a.substring(ia.length);
    return _incrementInteger(ia) ?? ia + _midpoint(fa, null);
  }

  final ia = _integerPart(a);
  final fa = a.substring(ia.length);
  final ib = _integerPart(b);
  final fb = b.substring(ib.length);
  if (ia == ib) return ia + _midpoint(fa, fb);
  final incremented = _incrementInteger(ia);
  if (incremented == null) throw StateError('Cannot go above $a');
  if (incremented.compareTo(b) < 0) return incremented;
  return ia + _midpoint(fa, null);
}

/// [count] keys in order, all between [a] and [b].
List<String> keysBetween(String? a, String? b, int count) {
  final keys = <String>[];
  var previous = a;
  for (var i = 0; i < count; i++) {
    // Fill from the left; fine for the small batches the UI creates.
    previous = keyBetween(previous, b);
    keys.add(previous);
  }
  return keys;
}

/// A digit-string midpoint of two fractions; [b] null means "1.0".
String _midpoint(String a, String? b) {
  final zero = _digits[0];
  if (b != null && a.compareTo(b) >= 0) {
    throw ArgumentError('$a is not before $b');
  }
  if ((a.isNotEmpty && a[a.length - 1] == zero) ||
      (b != null && b.isNotEmpty && b[b.length - 1] == zero)) {
    throw ArgumentError('Fractions may not end in $zero');
  }

  if (b != null) {
    // Shared prefix (treating a missing digit in a as zero).
    var n = 0;
    while (n < b.length && (n < a.length ? a[n] : zero) == b[n]) {
      n++;
    }
    if (n > 0) {
      return b.substring(0, n) +
          _midpoint(n < a.length ? a.substring(n) : '', b.substring(n));
    }
  }

  final digitA = a.isNotEmpty ? _digits.indexOf(a[0]) : 0;
  final digitB = b != null ? _digits.indexOf(b[0]) : _digits.length;
  if (digitB - digitA > 1) {
    return _digits[((digitA + digitB) / 2).round()];
  }
  if (b != null && b.length > 1) return b.substring(0, 1);
  return _digits[digitA] + _midpoint(a.isNotEmpty ? a.substring(1) : '', null);
}

int _integerLength(String head) {
  final c = head.codeUnitAt(0);
  if (c >= 0x61 && c <= 0x7A) return c - 0x61 + 2; // a–z
  if (c >= 0x41 && c <= 0x5A) return 0x5A - c + 2; // Z–A
  throw ArgumentError('Invalid sort key head: $head');
}

String _integerPart(String key) {
  final length = _integerLength(key[0]);
  if (length > key.length) throw ArgumentError('Invalid sort key: $key');
  return key.substring(0, length);
}

void _validateKey(String key) {
  if (key.isEmpty || key == _smallestInteger) {
    throw ArgumentError('Invalid sort key: "$key"');
  }
  final integer = _integerPart(key);
  for (final ch in key.split('')) {
    if (!_digits.contains(ch)) throw ArgumentError('Invalid sort key: $key');
  }
  if (key.length > integer.length && key.endsWith(_digits[0])) {
    throw ArgumentError('Invalid sort key: $key');
  }
}

String? _incrementInteger(String x) {
  final head = x[0];
  final digits = x.substring(1).split('');
  var carry = true;
  for (var i = digits.length - 1; carry && i >= 0; i--) {
    final d = _digits.indexOf(digits[i]) + 1;
    if (d == _digits.length) {
      digits[i] = _digits[0];
    } else {
      digits[i] = _digits[d];
      carry = false;
    }
  }
  if (!carry) return head + digits.join();
  if (head == 'Z') return 'a${_digits[0]}';
  if (head == 'z') return null;
  final next = String.fromCharCode(head.codeUnitAt(0) + 1);
  if (next.compareTo('a') > 0) {
    digits.add(_digits[0]);
  } else {
    digits.removeLast();
  }
  return next + digits.join();
}

String? _decrementInteger(String x) {
  final head = x[0];
  final digits = x.substring(1).split('');
  final last = _digits[_digits.length - 1];
  var borrow = true;
  for (var i = digits.length - 1; borrow && i >= 0; i--) {
    final d = _digits.indexOf(digits[i]) - 1;
    if (d == -1) {
      digits[i] = last;
    } else {
      digits[i] = _digits[d];
      borrow = false;
    }
  }
  if (!borrow) return head + digits.join();
  if (head == 'a') return 'Z$last';
  if (head == 'A') return null;
  final next = String.fromCharCode(head.codeUnitAt(0) - 1);
  if (next.compareTo('Z') < 0) {
    digits.add(last);
  } else {
    digits.removeLast();
  }
  return next + digits.join();
}
