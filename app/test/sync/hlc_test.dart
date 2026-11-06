import 'package:elliotts_productivity_app/sync/hlc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('round-trips through its string form', () {
    const hlc = Hlc(1730851200000, 42, 'device-a');
    expect(Hlc.parse(hlc.toString()), hlc);
  });

  test('string order matches clock order', () {
    final stamps = [
      const Hlc(5, 0, 'b'),
      const Hlc(5, 1, 'a'),
      const Hlc(1000, 0, 'a'),
      const Hlc(5, 0, 'a'),
    ];
    final byString = [...stamps]
      ..sort((x, y) => x.toString().compareTo(y.toString()));
    expect(byString, [
      const Hlc(5, 0, 'a'),
      const Hlc(5, 0, 'b'),
      const Hlc(5, 1, 'a'),
      const Hlc(1000, 0, 'a'),
    ]);
  });

  test('stamps keep increasing when the wall clock stands still or goes back',
      () {
    var wall = 100;
    final clock = HlcClock('a', wallClock: () => wall);
    final first = clock.now();
    final second = clock.now();
    wall = 50;
    final third = clock.now();
    expect(first.compareTo(second), lessThan(0));
    expect(second.compareTo(third), lessThan(0));
  });

  test('receive moves past a remote stamp from the future', () {
    final clock = HlcClock('a', wallClock: () => 100);
    final remote = const Hlc(500, 3, 'b');
    final merged = clock.receive(remote);
    expect(merged.compareTo(remote), greaterThan(0));
    expect(clock.now().compareTo(merged), greaterThan(0));
  });
}
