import 'dart:math';

import 'package:elliotts_productivity_app/domain/sort_keys.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('first key is a0, matching the design doc', () {
    expect(keyBetween(null, null), 'a0');
  });

  test('keys land strictly between their bounds', () {
    expect(keyBetween('a0', null), 'a1');
    expect(keyBetween(null, 'a0'), 'Zz');
    expect(keyBetween('a0', 'a1'), 'a0V');
    expect(keyBetween('a0', 'a0V'), 'a0G');
    expect(keyBetween('a0V', 'a1'), 'a0l');
  });

  test('appending 1000 times keeps keys short and ordered', () {
    String? last;
    for (var i = 0; i < 1000; i++) {
      final next = keyBetween(last, null);
      if (last != null) expect(next.compareTo(last), greaterThan(0));
      last = next;
    }
    expect(last!.length, lessThanOrEqualTo(4));
  });

  test('prepending 1000 times keeps keys short and ordered', () {
    String? first;
    for (var i = 0; i < 1000; i++) {
      final next = keyBetween(null, first);
      if (first != null) expect(next.compareTo(first), lessThan(0));
      first = next;
    }
    expect(first!.length, lessThanOrEqualTo(4));
  });

  test('random inserts always keep the list sorted', () {
    final random = Random(42);
    final keys = <String>[];
    for (var i = 0; i < 2000; i++) {
      final at = random.nextInt(keys.length + 1);
      final key = keyBetween(
        at == 0 ? null : keys[at - 1],
        at == keys.length ? null : keys[at],
      );
      keys.insert(at, key);
    }
    final sorted = [...keys]..sort();
    expect(keys, sorted);
    expect(keys.toSet(), hasLength(keys.length));
  });

  test('keysBetween returns ordered keys inside the range', () {
    final keys = keysBetween('a0', 'a1', 5);
    expect(keys, hasLength(5));
    expect(['a0', ...keys, 'a1'], [...['a0', ...keys, 'a1']]..sort());
  });

  test('rejects reversed or malformed bounds', () {
    expect(() => keyBetween('a1', 'a0'), throwsArgumentError);
    expect(() => keyBetween('a0', 'a0'), throwsArgumentError);
    expect(() => keyBetween('a00', null), throwsArgumentError);
    expect(() => keyBetween('!', null), throwsArgumentError);
  });
}
