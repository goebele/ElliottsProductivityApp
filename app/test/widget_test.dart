import 'dart:convert';

import 'package:elliotts_productivity_app/data/blob_store.dart';
import 'package:elliotts_productivity_app/data/database.dart';
import 'package:elliotts_productivity_app/domain/node_repository.dart';
import 'package:elliotts_productivity_app/domain/repeat_rule.dart';
import 'package:elliotts_productivity_app/platform/reminder_notifier.dart';
import 'package:elliotts_productivity_app/providers.dart';
import 'package:elliotts_productivity_app/ui/app.dart';
import 'package:elliotts_productivity_app/ui/calendar_page.dart';
import 'package:elliotts_productivity_app/ui/files.dart';
import 'package:elliotts_productivity_app/ui/markup.dart';
import 'package:elliotts_productivity_app/ui/tree_pane.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_support.dart';

/// Lets debounced saves, stream updates and page transitions land.
/// (Not pumpAndSettle: a focused field's blinking cursor never settles.)
Future<void> settle(WidgetTester tester) async {
  for (var i = 0; i < 12; i++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
}

const wide = Size(1200, 800);
const phone = Size(400, 800);

void main() {
  late TestEnv env;

  /// Creates the database (and any [seed] data) with real async, before the
  /// app mounts. Once the app's live queries run on the fake clock, database
  /// calls go through the normal test zone instead; mixing in runAsync then
  /// deadlocks on Drift's lock.
  Future<void> startApp(
    WidgetTester tester, {
    required Size size,
    Future<void> Function(TestEnv env)? seed,
  }) async {
    ReminderNotifier.enabled = false;
    env = (await tester.runAsync(() async {
      final env = await TestEnv.create();
      await seed?.call(env);
      return env;
    }))!;
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWith((ref) => env.db),
          identityProvider.overrideWith((ref) async => env.identity),
          changeWriterProvider.overrideWith((ref) async => env.writer),
          blobStoreProvider.overrideWith((ref) async => BlobStore(env.blobDir)),
        ],
        child: const App(),
      ),
    );
    await settle(tester);
  }

  /// Unmounts, lets Drift's timer for dropping cancelled queries fire on the
  /// fake clock, then closes the database for real.
  Future<void> stopApp(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 1));
    await tester.runAsync(env.close);
  }

  Finder inTree(String text) => find.descendant(
    of: find.byType(SingleChildScrollView),
    matching: find.text(text),
  );

  /// Lets real file reads (attachment text) finish, then rebuilds.
  Future<void> letFilesLoad(WidgetTester tester) async {
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 100)),
    );
    await settle(tester);
  }

  Finder titleField(String text) => find.widgetWithText(TextField, text);
  final addField = find.widgetWithText(
    TextField,
    'Add an item and press Enter',
  );

  testWidgets('wide: create an item, title it, and add children', (
    tester,
  ) async {
    await startApp(tester, size: wide);
    expect(find.textContaining('Nothing here yet'), findsOneWidget);
    expect(find.text('Select an item to see its details.'), findsOneWidget);

    await tester.tap(find.text('New item'));
    await settle(tester);
    await tester.enterText(titleField('Title'), 'Plan holiday');
    await settle(tester);
    expect(inTree('Plan holiday'), findsOneWidget);

    await tester.enterText(addField, 'Book flights');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await settle(tester);
    await tester.enterText(addField, 'Pack');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await settle(tester);

    // Children show in the detail list and, auto-expanded, in the tree.
    expect(inTree('Book flights'), findsOneWidget);
    expect(inTree('Pack'), findsOneWidget);
    expect(find.text('Pack'), findsNWidgets(2));

    final top = await env.nodes.children(null);
    expect(top.single.title, 'Plan holiday');
    final children = await env.nodes.children(top.single.id);
    expect(children.map((n) => n.title), ['Book flights', 'Pack']);

    await stopApp(tester);
  });

  testWidgets('wide: open a child, see breadcrumbs, jump back up', (
    tester,
  ) async {
    await startApp(
      tester,
      size: wide,
      seed: (env) async {
        final project = await env.nodes.create(title: 'Garden');
        final task = await env.nodes.create(
          title: 'Fix fence',
          parentId: project,
        );
        await env.nodes.create(title: 'Buy posts', parentId: task);
      },
    );

    await tester.tap(inTree('Garden'));
    await settle(tester);
    expect(titleField('Garden'), findsOneWidget);

    await tester.tap(find.widgetWithText(Card, 'Fix fence'));
    await settle(tester);
    expect(titleField('Fix fence'), findsOneWidget);
    expect(find.widgetWithText(Card, 'Buy posts'), findsOneWidget);
    // The tree revealed the opened node under its parent.
    expect(inTree('Fix fence'), findsOneWidget);

    final breadcrumb = find.descendant(
      of: find.byType(Wrap),
      matching: find.text('Garden'),
    );
    expect(breadcrumb, findsOneWidget);
    await tester.tap(breadcrumb);
    await settle(tester);
    expect(titleField('Garden'), findsOneWidget);

    await stopApp(tester);
  });

  testWidgets('phone: drill down into pages and back', (tester) async {
    await startApp(
      tester,
      size: phone,
      seed: (env) async {
        final project = await env.nodes.create(title: 'Garden');
        await env.nodes.create(title: 'Fix fence', parentId: project);
      },
    );

    await tester.tap(find.text('Garden'));
    await settle(tester);
    expect(titleField('Garden'), findsOneWidget);

    await tester.tap(find.widgetWithText(Card, 'Fix fence'));
    await settle(tester);
    expect(titleField('Fix fence'), findsOneWidget);

    await tester.pageBack();
    await settle(tester);
    expect(titleField('Garden'), findsOneWidget);

    await stopApp(tester);
  });

  testWidgets('add-ons: description, list layout, and one dates dialog', (
    tester,
  ) async {
    late String id;
    await startApp(
      tester,
      size: wide,
      seed: (env) async {
        id = await env.nodes.create(title: 'Gym');
      },
    );
    await tester.tap(inTree('Gym'));
    await settle(tester);

    // The description is hidden until added.
    final description = find.widgetWithText(
      TextField,
      'Description (Markdown)',
    );
    expect(description, findsNothing);
    await tester.tap(find.widgetWithText(ActionChip, 'Description'));
    await settle(tester);
    await tester.enterText(description, 'Leg day');
    await settle(tester);

    // The view switcher by the Items heading.
    await tester.tap(find.byTooltip('Checklist'));
    await settle(tester);

    // One dialog for deadline, time slot and repeat.
    await tester.tap(find.widgetWithText(ActionChip, 'Date & time'));
    await settle(tester);
    expect(find.widgetWithText(SwitchListTile, 'Time slot'), findsOneWidget);
    await tester.tap(find.widgetWithText(SwitchListTile, 'Deadline'));
    await tester.tap(find.widgetWithText(SwitchListTile, 'Repeat'));
    await tester.pump();
    await tester.tap(find.widgetWithText(ChoiceChip, 'Every weekday'));
    await tester.pump();
    await tester.tap(find.text('OK'));
    await settle(tester);

    var node = (await env.nodes.get(id))!;
    expect(node.bodyMd, 'Leg day');
    expect(node.childView, ChildView.checklist);
    expect(node.dueDate, dateKey(DateTime.now()));
    expect(node.startAt, isNull, reason: 'time slot left off');
    expect(node.rrule, 'FREQ=WEEKLY;BYDAY=MO,TU,WE,TH,FR');
    expect(find.widgetWithText(InputChip, 'Every weekday'), findsOneWidget);
    expect(find.widgetWithText(ActionChip, 'Date & time'), findsNothing);
    // The tree icon follows what the task has: it repeats, so a routine.
    expect(
      find.descendant(
        of: find.byType(SingleChildScrollView),
        matching: find.byIcon(Icons.repeat),
      ),
      findsOneWidget,
    );

    // Each chip's ✕ removes just its part.
    await tester.tap(
      find.descendant(
        of: find.widgetWithText(InputChip, 'Every weekday'),
        matching: find.byTooltip('Remove'),
      ),
    );
    await settle(tester);
    node = (await env.nodes.get(id))!;
    expect(node.rrule, isNull);
    expect(node.dueDate, isNotNull);

    // Tapping a chip reopens the same dialog with the current values.
    await tester.tap(
      find.byWidgetPredicate(
        (w) => w is InputChip && (w.label as Text).data!.startsWith('Due '),
      ),
    );
    await settle(tester);
    final deadlineSwitch = tester.widget<SwitchListTile>(
      find.widgetWithText(SwitchListTile, 'Deadline'),
    );
    expect(deadlineSwitch.value, isTrue);
    await tester.tap(find.text('Cancel'));
    await settle(tester);

    await stopApp(tester);
  });

  testWidgets('notes live in a collapsed column, not among items', (
    tester,
  ) async {
    late String trip;
    await startApp(
      tester,
      size: const Size(1500, 900),
      seed: (env) async {
        trip = await env.nodes.create(title: 'Trip');
        await env.nodes.create(title: 'Book hotel', parentId: trip);
        await env.nodes.create(
          title: 'Packing ideas',
          type: NodeType.note,
          parentId: trip,
          bodyMd: 'Sunscreen',
        );
      },
    );

    // The tree counts and shows items only.
    expect(
      find.descendant(
        of: find.byType(SingleChildScrollView),
        matching: find.text('1'),
      ),
      findsOneWidget,
    );
    await tester.tap(inTree('Trip'));
    await settle(tester);
    expect(find.widgetWithText(Card, 'Book hotel'), findsOneWidget);
    expect(
      find.text('Packing ideas'),
      findsNothing,
      reason: 'notes column starts collapsed',
    );
    expect(inTree('Packing ideas'), findsNothing);

    await tester.tap(find.text('Notes & files (1)'));
    await settle(tester);
    expect(find.widgetWithText(Card, 'Packing ideas'), findsOneWidget);
    expect(find.text('Sunscreen'), findsOneWidget);

    // A new note opens as a note: just a title and its text.
    await tester.tap(find.text('New note'));
    await settle(tester);
    expect(
      find.widgetWithText(TextField, 'Write your note (Markdown)'),
      findsOneWidget,
    );
    expect(find.text('Status'), findsNothing);
    expect(find.widgetWithText(ActionChip, 'Date & time'), findsNothing);
    await tester.enterText(
      find.widgetWithText(TextField, 'Title'),
      'Questions',
    );
    await settle(tester);

    await tester.tap(
      find.descendant(of: find.byType(Wrap).first, matching: find.text('Trip')),
    );
    await settle(tester);
    expect(find.text('Notes & files (2)'), findsOneWidget);
    expect(find.widgetWithText(Card, 'Questions'), findsOneWidget);
    expect((await env.nodes.notes(trip)).map((n) => n.title), [
      'Packing ideas',
      'Questions',
    ]);
    expect((await env.nodes.children(trip)).map((n) => n.title), [
      'Book hotel',
    ]);

    await stopApp(tester);
  });

  testWidgets('phone: notes are a collapsed section under the items', (
    tester,
  ) async {
    await startApp(
      tester,
      size: phone,
      seed: (env) async {
        final trip = await env.nodes.create(title: 'Trip');
        await env.nodes.create(
          title: 'Packing ideas',
          type: NodeType.note,
          parentId: trip,
        );
      },
    );
    await tester.tap(find.text('Trip'));
    await settle(tester);

    expect(find.text('Notes & files (1)'), findsOneWidget);
    expect(find.text('Packing ideas'), findsNothing);
    await tester.tap(find.text('Notes & files (1)'));
    await settle(tester);
    expect(find.text('Packing ideas'), findsOneWidget);

    await stopApp(tester);
  });

  testWidgets('dialog: a fortnightly weekly pattern with turns', (
    tester,
  ) async {
    late String id;
    await startApp(
      tester,
      size: wide,
      seed: (env) async {
        id = await env.nodes.create(title: 'Swim');
      },
    );
    await tester.tap(inTree('Swim'));
    await settle(tester);

    await tester.tap(find.widgetWithText(ActionChip, 'Date & time'));
    await settle(tester);
    await tester.tap(find.widgetWithText(SwitchListTile, 'Repeat'));
    await tester.pump();
    await tester.tap(find.widgetWithText(ChoiceChip, 'Weekly pattern'));
    await tester.pump();
    expect(find.text('week'), findsOneWidget);
    await tester.tap(find.byTooltip('More'));
    await tester.pump();
    expect(find.text('weeks'), findsOneWidget);
    await tester.ensureVisible(
      find.widgetWithText(SwitchListTile, 'One sub-item at a time'),
    );
    await tester.tap(
      find.widgetWithText(SwitchListTile, 'One sub-item at a time'),
    );
    await tester.pump();
    await tester.tap(find.text('OK'));
    await settle(tester);

    final node = (await env.nodes.get(id))!;
    expect(node.rrule, startsWith('FREQ=WEEKLY;INTERVAL=2;BYDAY='));
    expect(node.repeatStart, dateKey(DateTime.now()));
    expect(node.exclusiveChildren, isTrue);
    expect(
      find.byWidgetPredicate(
        (w) =>
            w is InputChip &&
            (w.label as Text).data!.startsWith('Every 2 weeks on') &&
            (w.label as Text).data!.endsWith('· one at a time'),
      ),
      findsOneWidget,
    );

    await stopApp(tester);
  });

  testWidgets('the workout: next up, mark done, undo', (tester) async {
    await startApp(
      tester,
      size: wide,
      seed: (env) async {
        final workout = await env.nodes.create(
          title: 'Workout',
          type: NodeType.goal,
        );
        final arms = await env.nodes.create(title: 'Arms', parentId: workout);
        await env.nodes.create(title: 'Core', parentId: workout);
        await env.nodes.setRepeat(arms, 'FREQ=DAILY;INTERVAL=3');
        await env.nodes.setDates(
          workout,
          NodeDates(
            rrule: 'FREQ=DAILY',
            repeatStart: DateTime.now(),
            exclusiveChildren: true,
          ),
        );
      },
    );
    await tester.tap(inTree('Workout'));
    await settle(tester);

    expect(find.text('Next up: Arms'), findsOneWidget);
    expect(find.text('Every 3 days · not done yet'), findsOneWidget);
    expect(find.text("Parent's schedule · not done yet"), findsOneWidget);
    expect(
      find.byType(Checkbox),
      findsNothing,
      reason: 'turns are completed on the card, per occurrence',
    );

    await tester.tap(find.text('Mark done'));
    await settle(tester);
    expect(find.text('Done: Arms'), findsOneWidget);
    expect(find.textContaining('Every 3 days · last done'), findsOneWidget);
    // The parent is done for today too, once its pick is (Q-L).
    expect(find.text('Completed for today'), findsOneWidget);

    await tester.tap(
      find.descendant(
        of: find.ancestor(
          of: find.text('Done: Arms'),
          matching: find.byType(Card),
        ),
        matching: find.text('Undo'),
      ),
    );
    await settle(tester);
    expect(find.text('Next up: Arms'), findsOneWidget);

    await stopApp(tester);
  });

  testWidgets('ticking a child marks it done', (tester) async {
    late String taskId;
    await startApp(
      tester,
      size: wide,
      seed: (env) async {
        final list = await env.nodes.create(title: 'Groceries');
        taskId = await env.nodes.create(title: 'Milk', parentId: list);
      },
    );

    await tester.tap(inTree('Groceries'));
    await settle(tester);
    await tester.tap(find.byTooltip('Checklist'));
    await settle(tester);
    await tester.tap(find.byType(Checkbox));
    await settle(tester);

    expect((await env.nodes.get(taskId))!.status, NodeStatus.done);

    await stopApp(tester);
  });

  testWidgets('header: an explicit Done button, then Completed and Reopen', (
    tester,
  ) async {
    late String taskId;
    await startApp(
      tester,
      size: wide,
      seed: (env) async {
        taskId = await env.nodes.create(title: 'Call plumber');
      },
    );
    await tester.tap(inTree('Call plumber'));
    await settle(tester);
    expect(
      find.byIcon(Icons.check_box_outline_blank),
      findsNothing,
      reason: 'nothing looks like a checkbox you could tick',
    );

    await tester.tap(find.widgetWithText(FilledButton, 'Done'));
    await settle(tester);
    expect((await env.nodes.get(taskId))!.status, NodeStatus.done);
    expect(find.textContaining('Completed '), findsOneWidget);
    expect(
      find.widgetWithText(FilledButton, 'Done'),
      findsNothing,
      reason: 'a button that only completes, not a toggle',
    );

    // Undo from the snack bar puts it back as it was.
    await tester.tap(find.widgetWithText(SnackBarAction, 'Undo'));
    await settle(tester);
    expect((await env.nodes.get(taskId))!.status, NodeStatus.open);

    await tester.tap(find.widgetWithText(FilledButton, 'Done'));
    await settle(tester);
    await tester.tap(find.widgetWithText(TextButton, 'Reopen'));
    await settle(tester);
    expect((await env.nodes.get(taskId))!.status, NodeStatus.open);

    // The compact menu beside the title sets any status.
    await tester.tap(find.widgetWithText(TextButton, 'Open'));
    await settle(tester);
    await tester.tap(find.widgetWithText(MenuItemButton, 'Waiting'));
    await settle(tester);
    expect((await env.nodes.get(taskId))!.status, NodeStatus.waiting);

    // Waiting still completes with one press.
    await tester.tap(find.widgetWithText(FilledButton, 'Done'));
    await settle(tester);
    expect((await env.nodes.get(taskId))!.status, NodeStatus.done);

    await stopApp(tester);
  });

  testWidgets('tree: right-click a row for the full status list', (
    tester,
  ) async {
    late String taskId;
    await startApp(
      tester,
      size: wide,
      seed: (env) async {
        taskId = await env.nodes.create(title: 'Call plumber');
      },
    );

    await tester.tap(inTree('Call plumber'), buttons: kSecondaryButton);
    await settle(tester);
    for (final s in ['Open', 'Active', 'Waiting', 'Done', 'Dropped']) {
      expect(find.widgetWithText(MenuItemButton, s), findsOneWidget);
    }
    await tester.tap(find.widgetWithText(MenuItemButton, 'Active'));
    await settle(tester);
    expect((await env.nodes.get(taskId))!.status, NodeStatus.active);

    await tester.longPress(inTree('Call plumber'));
    await settle(tester);
    await tester.tap(find.widgetWithText(MenuItemButton, 'Done'));
    await settle(tester);
    expect((await env.nodes.get(taskId))!.status, NodeStatus.done);

    await stopApp(tester);
  }, variant: TargetPlatformVariant.only(TargetPlatform.windows));

  testWidgets('header: a routine is done for today and keeps going', (
    tester,
  ) async {
    late String id;
    await startApp(
      tester,
      size: wide,
      seed: (env) async {
        id = await env.nodes.create(title: 'Stretch');
        await env.nodes.setDates(
          id,
          NodeDates(rrule: 'FREQ=DAILY', repeatStart: DateTime.now()),
        );
      },
    );
    await tester.tap(inTree('Stretch'));
    await settle(tester);

    await tester.tap(find.widgetWithText(FilledButton, 'Done for today'));
    await settle(tester);
    expect((await env.nodes.get(id))!.status, NodeStatus.open);
    expect(find.text('Completed for today'), findsWidgets);
    expect(find.widgetWithText(TextButton, 'Open'), findsOneWidget);

    // The inline Undo (the snack bar offers one too).
    await tester.tap(
      find.widgetWithText(TextButton, 'Undo').first.hitTestable(),
    );
    await settle(tester);
    expect(find.widgetWithText(FilledButton, 'Done for today'), findsOneWidget);

    await stopApp(tester);
  });

  testWidgets('description: close the editor, click the text to edit again', (
    tester,
  ) async {
    late String id;
    await startApp(
      tester,
      size: wide,
      seed: (env) async {
        id = await env.nodes.create(title: 'Gym');
      },
    );
    await tester.tap(inTree('Gym'));
    await settle(tester);
    final editor = find.widgetWithText(TextField, 'Description (Markdown)');

    await tester.tap(find.widgetWithText(ActionChip, 'Description'));
    await settle(tester);
    await tester.enterText(editor, 'Leg day');
    await tester.tap(find.byTooltip('Close description'));
    await settle(tester);
    expect(editor, findsNothing);
    expect(
      (await env.nodes.get(id))!.bodyMd,
      'Leg day',
      reason: 'closing saves what was typed',
    );
    expect(find.text('Leg day'), findsOneWidget);

    // Click the text to edit; Esc closes again.
    await tester.tap(find.text('Leg day'));
    await settle(tester);
    expect(editor, findsOneWidget);
    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await settle(tester);
    expect(editor, findsNothing);

    // Emptied and closed: back to the "+ Description" chip.
    await tester.tap(find.text('Leg day'));
    await settle(tester);
    await tester.enterText(editor, '');
    await tester.tap(find.byTooltip('Close description'));
    await settle(tester);
    expect(find.widgetWithText(ActionChip, 'Description'), findsOneWidget);

    await stopApp(tester);
  });

  /// The tree row for [title]: rows are 40 px tall with the title centred.
  Rect rowOf(WidgetTester tester, String title) {
    final c = tester.getCenter(inTree(title));
    return Rect.fromLTRB(c.dx - 100, c.dy - 20, c.dx + 100, c.dy + 20);
  }

  Future<void> dragTo(
    WidgetTester tester,
    Offset from,
    Offset to, {
    bool longPress = false,
  }) async {
    final g = await tester.startGesture(
      from,
      kind: longPress ? PointerDeviceKind.touch : PointerDeviceKind.mouse,
    );
    if (longPress) await tester.pump(kLongPressTimeout * 2);
    for (var i = 1; i <= 10; i++) {
      await g.moveTo(Offset.lerp(from, to, i / 10)!);
      await tester.pump(const Duration(milliseconds: 16));
    }
    await g.up();
    await settle(tester);
  }

  testWidgets('tree: drag to reorder, nest, undo, and back to the top level', (
    tester,
  ) async {
    late String a, b, c;
    await startApp(
      tester,
      size: wide,
      seed: (env) async {
        a = await env.nodes.create(title: 'Alpha');
        b = await env.nodes.create(title: 'Bravo');
        c = await env.nodes.create(title: 'Charlie');
      },
    );
    Future<List<String>> top() async => [
      for (final n in await env.nodes.children(null)) n.title,
    ];

    // Above Alpha (its top quarter).
    await dragTo(
      tester,
      tester.getCenter(inTree('Charlie')),
      rowOf(tester, 'Alpha').topCenter + const Offset(0, 4),
    );
    expect(await top(), ['Charlie', 'Alpha', 'Bravo']);
    expect(find.text('Moved Charlie'), findsOneWidget);

    // Onto the middle of Bravo: inside it, and Bravo opens to show it.
    await dragTo(
      tester,
      tester.getCenter(inTree('Alpha')),
      tester.getCenter(inTree('Bravo')),
    );
    expect((await env.nodes.get(a))!.parentId, b);
    expect(inTree('Alpha'), findsOneWidget, reason: 'Bravo is expanded');

    // Undo puts it back where it was.
    await tester.tap(find.widgetWithText(SnackBarAction, 'Undo'));
    await settle(tester);
    expect(await top(), ['Charlie', 'Alpha', 'Bravo']);

    // Nest again, then drag it out below everything: last at the top level.
    await dragTo(
      tester,
      tester.getCenter(inTree('Alpha')),
      tester.getCenter(inTree('Bravo')),
    );
    await dragTo(
      tester,
      tester.getCenter(inTree('Alpha')),
      rowOf(tester, 'Bravo').bottomCenter + const Offset(0, 60),
    );
    expect(await top(), ['Charlie', 'Bravo', 'Alpha']);

    // A parent can't go inside its own child.
    await dragTo(
      tester,
      tester.getCenter(inTree('Alpha')),
      tester.getCenter(inTree('Charlie')),
    );
    expect((await env.nodes.get(a))!.parentId, c);
    await dragTo(
      tester,
      tester.getCenter(inTree('Charlie')),
      tester.getCenter(inTree('Alpha')),
    );
    expect((await env.nodes.get(c))!.parentId, isNull);

    await stopApp(tester);
  }, variant: TargetPlatformVariant.only(TargetPlatform.windows));

  testWidgets('tree on a phone: long-press drags (no status menu)', (
    tester,
  ) async {
    await startApp(
      tester,
      size: wide,
      seed: (env) async {
        await env.nodes.create(title: 'Alpha');
        await env.nodes.create(title: 'Bravo');
      },
    );
    await dragTo(
      tester,
      tester.getCenter(inTree('Bravo')),
      rowOf(tester, 'Alpha').topCenter + const Offset(0, 4),
      longPress: true,
    );
    expect(
      [for (final n in await env.nodes.children(null)) n.title],
      ['Bravo', 'Alpha'],
    );
    expect(find.byType(MenuItemButton), findsNothing);

    await stopApp(tester);
  });

  testWidgets('items list: drag a handle to reorder', (tester) async {
    late String list;
    await startApp(
      tester,
      size: wide,
      seed: (env) async {
        list = await env.nodes.create(title: 'Packing');
        for (final t in ['Tent', 'Stove', 'Boots']) {
          await env.nodes.create(title: t, parentId: list);
        }
      },
    );
    await tester.tap(inTree('Packing'));
    await settle(tester);

    final handles = find.byIcon(Icons.drag_indicator);
    expect(handles, findsNWidgets(3));
    final tile = tester.getRect(find.widgetWithText(Card, 'Tent'));
    await dragTo(
      tester,
      tester.getCenter(handles.at(2)),
      tester.getCenter(handles.at(2)) - Offset(0, tile.height * 2 + 8),
    );
    expect(
      [for (final n in await env.nodes.children(list)) n.title],
      ['Boots', 'Tent', 'Stove'],
    );

    await stopApp(tester);
  });

  testWidgets('archive, restore, trash and delete forever, all confirmed', (
    tester,
  ) async {
    late String project, task;
    await startApp(
      tester,
      size: wide,
      seed: (env) async {
        project = await env.nodes.create(title: 'Project');
        task = await env.nodes.create(title: 'Task', parentId: project);
      },
    );
    final entries = find.byType(ListTile);
    Finder entry(String label) =>
        find.descendant(of: entries, matching: find.text(label));

    await tester.tap(inTree('Project'));
    await settle(tester);
    await tester.tap(find.byTooltip('More actions'));
    await settle(tester);
    await tester.tap(find.widgetWithText(MenuItemButton, 'Archive'));
    await settle(tester);
    expect(find.text('Archive “Project”?'), findsOneWidget);
    expect(find.textContaining('It and 1 item inside it'), findsOneWidget);

    // Cancel keeps it.
    await tester.tap(find.text('Cancel'));
    await settle(tester);
    expect((await env.nodes.get(project))!.lifecycle, Lifecycle.live);

    await tester.tap(find.byTooltip('More actions'));
    await settle(tester);
    await tester.tap(find.widgetWithText(MenuItemButton, 'Archive'));
    await settle(tester);
    await tester.tap(find.widgetWithText(FilledButton, 'Archive'));
    await settle(tester);
    expect(inTree('Project'), findsNothing);
    expect((await env.nodes.get(task))!.lifecycle, Lifecycle.archived);
    expect(
      find.text('Select an item to see its details.'),
      findsOneWidget,
      reason: 'the page moves away (to nothing at the top level)',
    );

    // The Archive lists the group; Restore brings it back.
    await tester.tap(entry('Archive'));
    await settle(tester);
    expect(find.textContaining('and 1 item · Archived'), findsOneWidget);
    await tester.tap(find.widgetWithText(TextButton, 'Restore'));
    await settle(tester);
    expect(inTree('Project'), findsOneWidget);
    expect(find.text('Nothing archived.'), findsOneWidget);

    // Trash it, then delete it forever from the Trash.
    await tester.tap(inTree('Project'));
    await settle(tester);
    await tester.tap(find.byTooltip('More actions'));
    await settle(tester);
    await tester.tap(find.widgetWithText(MenuItemButton, 'Move to Trash'));
    await settle(tester);
    expect(find.textContaining('deleted after 30 days'), findsOneWidget);
    await tester.tap(find.widgetWithText(FilledButton, 'Move to Trash'));
    await settle(tester);
    expect((await env.nodes.get(project))!.lifecycle, Lifecycle.trashed);

    await tester.tap(entry('Trash'));
    await settle(tester);
    expect(find.textContaining('30 days left'), findsOneWidget);
    await tester.tap(find.byTooltip('Delete forever'));
    await settle(tester);
    expect(find.text('Delete “Project” forever?'), findsOneWidget);
    await tester.tap(find.widgetWithText(FilledButton, 'Delete forever'));
    await settle(tester);
    expect((await env.nodes.get(project))!.deleted, isTrue);
    expect((await env.nodes.get(task))!.deleted, isTrue);
    expect(find.text('Trash is empty.'), findsOneWidget);

    await stopApp(tester);
  });

  testWidgets('an archived item opened from the Archive shows a banner', (
    tester,
  ) async {
    late String id;
    await startApp(
      tester,
      size: wide,
      seed: (env) async {
        id = await env.nodes.create(title: 'Old plan');
        await env.nodes.archive(id);
      },
    );
    await tester.tap(
      find.descendant(
        of: find.byType(ListTile),
        matching: find.text('Archive'),
      ),
    );
    await settle(tester);
    await tester.tap(find.text('Old plan'));
    await settle(tester);
    expect(find.text('In the Archive'), findsOneWidget);
    await tester.tap(find.widgetWithText(FilledButton, 'Restore'));
    await settle(tester);
    expect(find.text('In the Archive'), findsNothing);
    expect((await env.nodes.get(id))!.lifecycle, Lifecycle.live);
    expect(inTree('Old plan'), findsOneWidget);

    await stopApp(tester);
  });

  testWidgets('panels show progress, dates and a description preview', (
    tester,
  ) async {
    await startApp(
      tester,
      size: wide,
      seed: (env) async {
        final home = await env.nodes.create(title: 'Home', type: NodeType.goal);
        final kitchen = await env.nodes.create(
          title: 'Kitchen',
          type: NodeType.project,
          parentId: home,
          bodyMd: 'Redo the cabinets',
        );
        await env.nodes.setDueDate(kitchen, DateTime(2026, 12, 1));
        final a = await env.nodes.create(title: 'Measure', parentId: kitchen);
        await env.nodes.create(title: 'Order', parentId: kitchen);
        await env.nodes.setStatus(a, NodeStatus.done);
      },
    );
    await tester.tap(inTree('Home'));
    await settle(tester);

    final card = find.widgetWithText(Card, 'Kitchen');
    expect(card, findsOneWidget, reason: 'panels are the default');
    Finder inCard(Finder f) => find.descendant(of: card, matching: f);
    expect(inCard(find.text('1/2')), findsOneWidget);
    expect(inCard(find.byType(LinearProgressIndicator)), findsOneWidget);
    expect(inCard(find.textContaining('Due ')), findsOneWidget);
    expect(inCard(find.text('Redo the cabinets')), findsOneWidget);

    await stopApp(tester);
  });

  testWidgets('steps: only the next one is highlighted and can be done', (
    tester,
  ) async {
    late String recipe;
    await startApp(
      tester,
      size: wide,
      seed: (env) async {
        recipe = await env.nodes.create(title: 'Bread');
        for (final t in ['Mix', 'Knead', 'Bake']) {
          await env.nodes.create(title: t, parentId: recipe);
        }
      },
    );
    await tester.tap(inTree('Bread'));
    await settle(tester);
    await tester.tap(find.byTooltip('Steps'));
    await settle(tester);
    expect((await env.nodes.get(recipe))!.childView, ChildView.steps);

    Finder doneIn(String step) => find.descendant(
      of: find.widgetWithText(ListTile, step),
      matching: find.widgetWithText(FilledButton, 'Done'),
    );
    expect(doneIn('Mix'), findsOneWidget);
    expect(doneIn('Knead'), findsNothing);
    expect(find.text('2'), findsOneWidget, reason: 'steps are numbered');

    await tester.tap(doneIn('Mix'));
    await settle(tester);
    expect(doneIn('Knead'), findsOneWidget, reason: 'the next one moves on');
    expect(doneIn('Mix'), findsNothing);

    // A finished step can be unticked; it becomes next again.
    await tester.tap(find.byTooltip('Mark not done'));
    await settle(tester);
    expect(doneIn('Mix'), findsOneWidget);

    await stopApp(tester);
  });

  testWidgets('markdown: toolbar formats, preview renders, closed view too', (
    tester,
  ) async {
    late String id;
    await startApp(
      tester,
      size: wide,
      seed: (env) async {
        id = await env.nodes.create(title: 'Gym');
      },
    );
    await tester.tap(inTree('Gym'));
    await settle(tester);
    await tester.tap(find.widgetWithText(ActionChip, 'Description'));
    await settle(tester);
    final editor = find.widgetWithText(TextField, 'Description (Markdown)');
    await tester.enterText(editor, 'Leg day');
    final controller = tester.widget<TextField>(editor).controller!;
    controller.selection = const TextSelection(baseOffset: 0, extentOffset: 7);

    await tester.tap(find.byTooltip('Bold'));
    await settle(tester);
    expect(controller.text, '**Leg day**');

    await tester.tap(find.text('Preview'));
    await settle(tester);
    expect(editor.hitTestable(), findsNothing);
    expect(find.text('Leg day'), findsOneWidget, reason: 'rendered, no **');
    await tester.tap(find.text('Edit'));
    await settle(tester);

    await tester.tap(find.byTooltip('Close description'));
    await settle(tester);
    expect((await env.nodes.get(id))!.bodyMd, '**Leg day**');
    expect(find.text('Leg day'), findsOneWidget);
    expect(find.text('**Leg day**'), findsNothing);

    await stopApp(tester);
  });

  for (final (label, size) in [('wide', wide), ('phone', phone)]) {
    testWidgets(
      '$label: a note opens formatted; Edit, Save, Back to its item',
      (tester) async {
        late String note;
        await startApp(
          tester,
          size: size,
          seed: (env) async {
            final trip = await env.nodes.create(title: 'Trip');
            note = await env.nodes.create(
              title: 'Packing ideas',
              type: NodeType.note,
              parentId: trip,
              bodyMd: '- **Sunscreen**',
            );
          },
        );
        await tester.tap(find.text('Trip'));
        await settle(tester);
        // The notes column (wide) or notes section (phone).
        await tester.tap(find.text('Notes & files (1)'));
        await settle(tester);
        await tester.tap(find.widgetWithText(Card, 'Packing ideas'));
        await settle(tester);

        final editor = find.widgetWithText(
          TextField,
          'Write your note (Markdown)',
        );
        expect(editor, findsNothing, reason: 'opens read-only');
        expect(find.text('Sunscreen'), findsOneWidget);

        await tester.tap(find.widgetWithText(FilledButton, 'Edit'));
        await settle(tester);
        await tester.enterText(editor, '- **Sunscreen**\n- Hat');
        await tester.tap(find.widgetWithText(FilledButton, 'Save'));
        await settle(tester);
        expect(editor, findsNothing);
        expect(find.text('Hat'), findsOneWidget);
        expect((await env.nodes.get(note))!.bodyMd, '- **Sunscreen**\n- Hat');

        await tester.tap(find.text('Back to Trip'));
        await settle(tester);
        expect(find.text('Back to Trip'), findsNothing);
        expect(
          find.widgetWithText(TextField, 'Trip'),
          findsOneWidget,
          reason: "the item's page",
        );

        await stopApp(tester);
      },
    );
  }

  testWidgets(
    'shortcuts: also show in, ↗ rows, via breadcrumb, drag and remove',
    (tester) async {
      late String paint, errands;
      await startApp(
        tester,
        size: wide,
        seed: (env) async {
          final kitchen = await env.nodes.create(title: 'Kitchen');
          paint = await env.nodes.create(title: 'Buy paint', parentId: kitchen);
          errands = await env.nodes.create(title: 'Errands');
          await env.nodes.create(title: 'Post office', parentId: errands);
        },
      );
      await tester.tap(inTree('Kitchen'));
      await settle(tester);
      await tester.tap(find.widgetWithText(Card, 'Buy paint'));
      await settle(tester);

      await tester.tap(find.byTooltip('More actions'));
      await settle(tester);
      await tester.tap(find.widgetWithText(MenuItemButton, 'Also show in…'));
      await settle(tester);
      expect(find.text('Also show “Buy paint” in…'), findsOneWidget);
      final dialog = find.byType(AlertDialog);
      Finder option(String t) => find.descendant(
        of: dialog,
        matching: find.widgetWithText(ListTile, t),
      );
      expect(
        tester.widget<ListTile>(option('Kitchen')).enabled,
        isFalse,
        reason: 'where it really is',
      );
      await tester.enterText(
        find.descendant(of: dialog, matching: find.byType(TextField)),
        'err',
      );
      await settle(tester);
      expect(option('Kitchen'), findsNothing);
      await tester.tap(option('Errands'));
      await settle(tester);
      expect(find.text('Also shown in Errands'), findsOneWidget);

      // Errands opens to show it, after Post office, with a ↗.
      expect(inTree('Buy paint'), findsNWidgets(2));
      final markers = find.descendant(
        of: find.byType(SingleChildScrollView),
        matching: find.byType(ShortcutMarker),
      );
      expect(markers, findsOneWidget);
      final rows = [
        for (final e
            in find
                .descendant(
                  of: find.byType(SingleChildScrollView),
                  matching: find.byType(Text),
                )
                .evaluate())
          (e.widget as Text).data,
      ];
      expect(
        rows.indexOf('Post office'),
        lessThan(rows.lastIndexOf('Buy paint')),
      );

      // Opening the shortcut row shows the real path plus "via Errands".
      await tester.tap(inTree('Buy paint').last);
      await settle(tester);
      expect(find.widgetWithText(ActionChip, 'via Errands'), findsOneWidget);
      expect(find.text('Kitchen'), findsWidgets);

      // Dragging the ↗ row above Post office moves only the shortcut.
      final postOffice = tester.getCenter(inTree('Post office'));
      await dragTo(
        tester,
        tester.getCenter(inTree('Buy paint').last),
        postOffice - const Offset(0, 16),
      );
      final under = await env.nodes.watchChildrenWithCounts(errands).first;
      expect(
        [for (final r in under) r.node.title],
        ['Buy paint', 'Post office'],
      );
      expect(under.first.isShortcut, isTrue);
      expect((await env.nodes.get(paint))!.parentId, isNot(errands));

      // Right-click → Remove shortcut.
      await tester.tap(inTree('Buy paint').last, buttons: kSecondaryButton);
      await settle(tester);
      await tester.tap(find.widgetWithText(MenuItemButton, 'Remove shortcut'));
      await settle(tester);
      expect(inTree('Buy paint'), findsOneWidget);
      expect(markers, findsNothing);

      await stopApp(tester);
    },
    variant: TargetPlatformVariant.only(TargetPlatform.windows),
  );

  for (final (label, size) in [('wide', wide), ('phone', phone)]) {
    testWidgets('$label: link an ancestor note, open it, go back, unlink', (
      tester,
    ) async {
      late String note;
      await startApp(
        tester,
        size: size,
        seed: (env) async {
          final trip = await env.nodes.create(title: 'Trip');
          note = await env.nodes.create(
            title: 'Packing ideas',
            type: NodeType.note,
            parentId: trip,
            bodyMd: 'Sunscreen',
          );
          await env.nodes.create(title: 'Pack bags', parentId: trip);
        },
      );
      await tester.tap(find.text('Trip'));
      await settle(tester);
      await tester.tap(find.widgetWithText(Card, 'Pack bags'));
      await settle(tester);

      // The notes column (wide) or section (phone) holds "From above".
      await tester.tap(find.text('Notes & files (0)'));
      await settle(tester);
      expect(find.text('From above'), findsOneWidget);
      await tester.ensureVisible(find.text('Link from above…'));
      await settle(tester);
      await tester.tap(find.text('Link from above…'));
      await settle(tester);
      expect(find.text('Trip (parent)'), findsOneWidget);
      await tester.tap(find.widgetWithText(CheckboxListTile, 'Packing ideas'));
      await settle(tester);
      await tester.tap(
        find.descendant(
          of: find.byType(AlertDialog),
          matching: find.widgetWithText(FilledButton, 'Done'),
        ),
      );
      await settle(tester);

      final card = find.widgetWithText(Card, 'Packing ideas');
      expect(card, findsOneWidget);
      expect(
        find.descendant(of: card, matching: find.text('from: Trip')),
        findsOneWidget,
      );

      // Opening it opens the original note; Back returns to Pack bags.
      await tester.ensureVisible(find.text('Sunscreen'));
      await tester.tap(find.text('Sunscreen'));
      await settle(tester);
      expect(find.text('Linked into 1 item:'), findsOneWidget);
      await tester.tap(find.text('Back to Pack bags'));
      await settle(tester);
      expect(find.text('Notes & files (1)'), findsOneWidget);
      // A fresh page starts with its notes section collapsed again.
      if (find.byTooltip('Unlink').evaluate().isEmpty) {
        await tester.tap(find.text('Notes & files (1)'));
        await settle(tester);
      }

      await tester.ensureVisible(find.byTooltip('Unlink'));
      await tester.tap(find.byTooltip('Unlink'));
      await settle(tester);
      expect(card, findsNothing);
      expect((await env.nodes.get(note))!.deleted, isFalse);

      await stopApp(tester);
    });
  }

  testWidgets('a pinned note shows under every sub-item, without Unlink', (
    tester,
  ) async {
    await startApp(
      tester,
      size: wide,
      seed: (env) async {
        final trip = await env.nodes.create(title: 'Trip');
        await env.nodes.create(
          title: 'Packing ideas',
          type: NodeType.note,
          parentId: trip,
        );
        final europe = await env.nodes.create(title: 'Europe', parentId: trip);
        await env.nodes.create(title: 'Pack bags', parentId: europe);
      },
    );
    await tester.tap(inTree('Trip'));
    await settle(tester);
    await tester.tap(find.text('Notes & files (1)'));
    await settle(tester);
    await tester.tap(find.byTooltip('Share with all sub-items'));
    await settle(tester);
    expect(find.byTooltip('Stop sharing with sub-items'), findsOneWidget);

    // Two levels down it is there, pinned, with nothing to unlink.
    await tester.tap(find.widgetWithText(Card, 'Europe'));
    await settle(tester);
    await tester.tap(find.widgetWithText(Card, 'Pack bags'));
    await settle(tester);
    await tester.tap(find.text('Notes & files (1)'));
    await settle(tester);
    expect(find.text('pinned by: Trip'), findsOneWidget);
    expect(find.byTooltip('Unlink'), findsNothing);

    await stopApp(tester);
  });

  testWidgets('archive confirmation names outside links and shortcuts', (
    tester,
  ) async {
    await startApp(
      tester,
      size: wide,
      seed: (env) async {
        final trip = await env.nodes.create(title: 'Trip');
        final note = await env.nodes.create(
          title: 'Packing ideas',
          type: NodeType.note,
          parentId: trip,
        );
        final bags = await env.nodes.create(title: 'Pack bags', parentId: trip);
        await env.nodes.linkNote(bags, note);
        final errands = await env.nodes.create(title: 'Errands');
        await env.nodes.addPlacement(trip, errands);
        await env.nodes.move(bags, newParentId: errands);
      },
    );
    await tester.tap(inTree('Trip'));
    await settle(tester);
    await tester.tap(find.byTooltip('More actions'));
    await settle(tester);
    await tester.tap(find.widgetWithText(MenuItemButton, 'Archive'));
    await settle(tester);
    expect(
      find.textContaining('Used by 1 item elsewhere, which links its notes.'),
      findsOneWidget,
    );
    expect(
      find.textContaining('Its shortcut in 1 other place goes too.'),
      findsOneWidget,
    );
    await tester.tap(find.text('Cancel'));
    await settle(tester);
    await stopApp(tester);
  });

  // ------------------------------------------------------------------ M2

  testWidgets('values: create one, tie it, and see it inherited below', (
    tester,
  ) async {
    await startApp(
      tester,
      size: wide,
      seed: (env) async {
        final trip = await env.nodes.create(title: 'Trip');
        await env.nodes.create(title: 'Pack bags', parentId: trip);
      },
    );
    await tester.tap(find.widgetWithText(ListTile, 'Values'));
    await settle(tester);
    expect(find.text('No values yet.'), findsOneWidget);
    await tester.tap(find.widgetWithText(FilledButton, 'New value…'));
    await settle(tester);
    await tester.enterText(find.widgetWithText(TextField, 'Name'), 'Family');
    await tester.enterText(
      find.widgetWithText(TextField, 'Why it matters'),
      'Time together',
    );
    await tester.tap(find.widgetWithText(FilledButton, 'Save'));
    await settle(tester);
    expect(find.text('Time together'), findsOneWidget);

    // Tie it to Trip.
    await tester.tap(inTree('Trip'));
    await settle(tester);
    await tester.tap(find.widgetWithText(ActionChip, 'Value'));
    await settle(tester);
    await tester.tap(find.widgetWithText(CheckboxMenuButton, 'Family'));
    await settle(tester);
    expect(find.widgetWithText(InputChip, 'Family'), findsOneWidget);

    // Pack bags inherits it.
    await tester.tap(find.widgetWithText(Card, 'Pack bags'));
    await settle(tester);
    expect(find.text('Family · from Trip'), findsOneWidget);

    // The Values page lists what it is tied to.
    await tester.tap(find.widgetWithText(ListTile, 'Values'));
    await settle(tester);
    expect(find.widgetWithText(ActionChip, 'Trip'), findsOneWidget);
    await stopApp(tester);
  });

  testWidgets('tags: typed #tags become chips; clicking one searches', (
    tester,
  ) async {
    await startApp(
      tester,
      size: wide,
      seed: (env) async {
        await env.nodes.create(title: 'Buy #paint');
        await env.nodes.create(title: 'Brushes');
      },
    );
    await tester.tap(inTree('Buy #paint'));
    await settle(tester);
    expect(find.widgetWithText(InputChip, '#paint'), findsOneWidget);

    // A picker tag on Brushes.
    await tester.tap(inTree('Brushes'));
    await settle(tester);
    await tester.tap(find.widgetWithText(ActionChip, 'Tag'));
    await settle(tester);
    await tester.enterText(
      find.widgetWithText(TextField, 'Type a tag and press Enter'),
      'paint',
    );
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await settle(tester);
    await tester.tap(
      find.descendant(
        of: find.byType(AlertDialog),
        matching: find.widgetWithText(FilledButton, 'Done'),
      ),
    );
    await settle(tester);

    await tester.tap(find.widgetWithText(InputChip, '#paint'));
    await settle(tester);
    expect(find.text('2 results'), findsOneWidget);
    expect(find.widgetWithText(ListTile, 'Buy #paint'), findsOneWidget);
    expect(find.widgetWithText(ListTile, 'Brushes'), findsOneWidget);
    await stopApp(tester);
  });

  testWidgets('search: results replace the tree; filters; Esc clears', (
    tester,
  ) async {
    await startApp(
      tester,
      size: wide,
      seed: (env) async {
        final trip = await env.nodes.create(title: 'Trip');
        await env.nodes.create(
          title: 'Packing ideas',
          type: NodeType.note,
          parentId: trip,
          bodyMd: 'Sunscreen and hats',
        );
        await env.nodes.create(title: 'Buy sunscreen', parentId: trip);
      },
    );
    final box = find.widgetWithText(
      TextField,
      'Search  (#tag, value:, type:, in:)',
    );
    await tester.enterText(box, 'sunsc');
    await settle(tester);
    expect(find.text('2 results'), findsOneWidget);
    expect(find.text('New item'), findsNothing);
    expect(find.widgetWithText(ListTile, 'Packing ideas'), findsOneWidget);

    // A Type filter narrows it to notes.
    await tester.tap(find.byTooltip('Filters'));
    await settle(tester);
    await tester.tap(find.widgetWithText(FilterChip, 'Type'));
    await settle(tester);
    await tester.tap(find.widgetWithText(CheckboxMenuButton, 'Note'));
    await settle(tester);
    await tester.tapAt(const Offset(900, 700));
    await settle(tester);
    expect(find.text('1 result'), findsOneWidget);

    await tester.tap(find.widgetWithText(ListTile, 'Packing ideas'));
    await settle(tester);
    expect(find.text('Sunscreen and hats'), findsOneWidget);

    await tester.tap(box);
    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await settle(tester);
    expect(find.text('New item'), findsOneWidget);
    expect(inTree('Trip'), findsOneWidget);
    await stopApp(tester);
  });

  testWidgets('zoom: right-click a row, zoom in, step out', (tester) async {
    await startApp(
      tester,
      size: wide,
      seed: (env) async {
        final trip = await env.nodes.create(title: 'Trip');
        await env.nodes.create(title: 'Pack bags', parentId: trip);
        await env.nodes.create(title: 'Other');
      },
    );
    await tester.tap(inTree('Trip'), buttons: kSecondaryButton);
    await settle(tester);
    await tester.tap(find.widgetWithText(MenuItemButton, 'Zoom in'));
    await settle(tester);
    expect(inTree('Pack bags'), findsOneWidget);
    expect(inTree('Other'), findsNothing);
    expect(find.byTooltip('Show the whole tree'), findsOneWidget);

    await tester.tap(find.byTooltip('Zoom out one level'));
    await settle(tester);
    expect(inTree('Other'), findsOneWidget);
    expect(find.byTooltip('Show the whole tree'), findsNothing);
    await stopApp(tester);
  }, variant: TargetPlatformVariant.only(TargetPlatform.windows));

  testWidgets('phone: a long path collapses to first … last', (tester) async {
    late String leaf;
    await startApp(
      tester,
      size: phone,
      seed: (env) async {
        final a = await env.nodes.create(title: 'Alpha');
        final b = await env.nodes.create(title: 'Bravo', parentId: a);
        final c = await env.nodes.create(title: 'Charlie', parentId: b);
        leaf = await env.nodes.create(title: 'Delta', parentId: c);
      },
    );
    expect(leaf, isNotEmpty);
    await tester.tap(find.text('Alpha'));
    await settle(tester);
    await tester.tap(find.widgetWithText(Card, 'Bravo'));
    await settle(tester);
    await tester.tap(find.widgetWithText(Card, 'Charlie'));
    await settle(tester);
    await tester.tap(find.widgetWithText(Card, 'Delta'));
    await settle(tester);
    expect(find.text('…'), findsOneWidget);
    expect(find.text('Bravo'), findsNothing);
    await tester.tap(find.text('…'));
    await settle(tester);
    expect(find.text('Bravo'), findsOneWidget);
    await stopApp(tester);
  });

  testWidgets('peek: hover an Items card, then pin it beside', (tester) async {
    await startApp(
      tester,
      size: const Size(1600, 900),
      seed: (env) async {
        final trip = await env.nodes.create(title: 'Trip');
        await env.nodes.create(
          title: 'Pack bags',
          parentId: trip,
          bodyMd: 'Remember the charger',
        );
      },
    );
    await tester.tap(inTree('Trip'));
    await settle(tester);
    final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await mouse.addPointer(location: Offset.zero);
    addTearDown(mouse.removePointer);
    await mouse.moveTo(
      tester.getCenter(find.widgetWithText(Card, 'Pack bags')),
    );
    await tester.pump(const Duration(milliseconds: 800));
    await settle(tester);
    expect(find.widgetWithText(FilledButton, 'Open'), findsOneWidget);

    await tester.tap(find.byTooltip('Pin beside'));
    await settle(tester);
    // Pinned: the side panel stays after the mouse leaves.
    await mouse.moveTo(const Offset(5, 5));
    await settle(tester);
    expect(find.byTooltip('Close'), findsOneWidget);
    expect(find.text('Remember the charger'), findsWidgets);
    await tester.tap(find.byTooltip('Close'));
    await settle(tester);
    expect(find.byTooltip('Close'), findsNothing);
    await stopApp(tester);
  }, variant: TargetPlatformVariant.only(TargetPlatform.windows));

  testWidgets('tags page: create, star, rename; favourites are one tap', (
    tester,
  ) async {
    await startApp(
      tester,
      size: wide,
      seed: (env) async {
        await env.nodes.create(title: 'Fix #job');
        await env.nodes.create(title: 'Report');
      },
    );
    await tester.tap(find.widgetWithText(ListTile, 'Tags'));
    await settle(tester);
    await tester.enterText(
      find.widgetWithText(TextField, 'New tag, then Enter'),
      'work',
    );
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await settle(tester);
    expect(find.text('#work'), findsOneWidget);
    expect(find.text('Not used'), findsOneWidget);

    // Star #work.
    await tester.tap(
      find.descendant(
        of: find.widgetWithText(ListTile, '#work'),
        matching: find.byTooltip('Add to favorites'),
      ),
    );
    await settle(tester);
    expect(find.text('Favorites'), findsOneWidget);

    // Rename #job to #work: merge.
    await tester.tap(
      find.descendant(
        of: find.widgetWithText(ListTile, '#job'),
        matching: find.byTooltip('Rename'),
      ),
    );
    await settle(tester);
    await tester.enterText(
      find.descendant(
        of: find.byType(AlertDialog),
        matching: find.byType(TextField),
      ),
      'work',
    );
    await settle(tester);
    expect(find.textContaining('will be merged into #work'), findsOneWidget);
    await tester.tap(find.widgetWithText(FilledButton, 'Merge'));
    await settle(tester);
    expect(find.text('#job'), findsNothing);
    expect(inTree('Fix #work'), findsOneWidget);

    // On Report, the favourite is one tap in the picker.
    await tester.tap(inTree('Report'));
    await settle(tester);
    await tester.tap(find.widgetWithText(ActionChip, 'Tag'));
    await settle(tester);
    await tester.tap(find.widgetWithText(FilterChip, '#work'));
    await settle(tester);
    await tester.tap(
      find.descendant(
        of: find.byType(AlertDialog),
        matching: find.widgetWithText(FilledButton, 'Done'),
      ),
    );
    await settle(tester);
    expect(find.widgetWithText(InputChip, '#work'), findsOneWidget);
    await stopApp(tester);
  });

  testWidgets('peek: hovering and clicking Pin raises no errors', (
    tester,
  ) async {
    await startApp(
      tester,
      size: const Size(1600, 900),
      seed: (env) async {
        final trip = await env.nodes.create(title: 'Trip');
        await env.nodes.create(
          title: 'Pack bags',
          parentId: trip,
          bodyMd: 'Charger',
        );
      },
    );
    await tester.tap(inTree('Trip'));
    await settle(tester);
    final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await mouse.addPointer(location: Offset.zero);
    addTearDown(mouse.removePointer);
    await mouse.moveTo(
      tester.getCenter(find.widgetWithText(Card, 'Pack bags')),
    );
    await tester.pump(const Duration(milliseconds: 800));
    await settle(tester);
    final pin = find.byTooltip('Pin beside');
    await mouse.moveTo(tester.getCenter(pin));
    await tester.pump(const Duration(seconds: 2));
    await settle(tester);
    expect(tester.takeException(), isNull);
    await mouse.moveTo(const Offset(5, 5));
    await tester.pump(const Duration(seconds: 1));
    await settle(tester);
    expect(tester.takeException(), isNull);
    await mouse.moveTo(
      tester.getCenter(find.widgetWithText(Card, 'Pack bags')),
    );
    await tester.pump(const Duration(milliseconds: 800));
    await settle(tester);
    await mouse.moveTo(tester.getCenter(find.byTooltip('Pin beside')));
    await tester.pump(const Duration(seconds: 2));
    await mouse.down(tester.getCenter(find.byTooltip('Pin beside')));
    await tester.pump();
    await mouse.up();
    await tester.pump();
    expect(tester.takeException(), isNull);
    await settle(tester);
    expect(tester.takeException(), isNull);
    expect(find.byTooltip('Close'), findsOneWidget);
    await stopApp(tester);
  }, variant: TargetPlatformVariant.only(TargetPlatform.windows));

  // ------------------------------------------------------------------ M3

  const tinyPng =
      'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNk+M9QDwADhgGAWjR9awAAAABJRU5ErkJggg==';

  testWidgets(
    'files: listed in the notes column; a text file opens; remove and undo',
    (tester) async {
      late String trip;
      await startApp(
        tester,
        size: const Size(1600, 900),
        seed: (env) async {
          trip = await env.nodes.create(title: 'Trip');
          await env.nodes.files.add(
            trip,
            filename: 'packing.md',
            open: () => Stream.value(utf8.encode('# Packing\n\nSunscreen')),
          );
          await env.nodes.files.add(
            trip,
            filename: 'photo.png',
            open: () => Stream.value(base64.decode(tinyPng)),
            width: 1,
            height: 1,
          );
        },
      );
      await tester.tap(inTree('Trip'));
      await settle(tester);
      await tester.tap(find.text('Notes & files (2)'));
      await settle(tester);
      expect(find.text('Files (2)'), findsOneWidget);
      expect(find.byTooltip('photo.png'), findsOneWidget);

      await tester.tap(find.widgetWithText(ListTile, 'packing.md'));
      await settle(tester);
      await letFilesLoad(tester);
      expect(find.text('Sunscreen'), findsOneWidget);
      expect(find.text('Back to Trip'), findsOneWidget);

      // Open in… hands a copy to the default app.
      String? opened;
      final realOpen = openFileExternally;
      addTearDown(() => openFileExternally = realOpen);
      openFileExternally = (path, mime) async {
        opened = path;
        return true;
      };
      await tester.tap(find.byTooltip('More actions'));
      await settle(tester);
      await tester.tap(find.widgetWithText(MenuItemButton, 'Open in…'));
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 200)),
      );
      await settle(tester);
      expect(opened, endsWith('packing.md'));

      await tester.tap(find.byTooltip('More actions'));
      await settle(tester);
      await tester.tap(find.widgetWithText(MenuItemButton, 'Remove file'));
      await settle(tester);
      expect(find.text('Files (1)'), findsOneWidget);
      await tester.tap(find.text('Undo'));
      await settle(tester);
      expect(find.text('Files (2)'), findsOneWidget);
      await stopApp(tester);
    },
  );

  testWidgets('markup: drawing on an image saves a stroke; hide and erase', (
    tester,
  ) async {
    late String photo;
    await startApp(
      tester,
      size: const Size(1600, 900),
      seed: (env) async {
        final trip = await env.nodes.create(title: 'Trip');
        photo = await env.nodes.files.add(
          trip,
          filename: 'map.png',
          open: () => Stream.value(base64.decode(tinyPng)),
          width: 400,
          height: 300,
        );
      },
    );
    await tester.tap(inTree('Trip'));
    await settle(tester);
    await tester.tap(find.text('Notes & files (1)'));
    await settle(tester);
    await tester.tap(find.byTooltip('map.png'));
    await settle(tester);
    await tester.tap(find.widgetWithText(FilledButton, 'Mark up'));
    await settle(tester);

    final picture = find.byType(AspectRatio).last;
    final c = tester.getCenter(picture);
    await tester.dragFrom(c, const Offset(80, 40));
    await settle(tester);
    var marks = await tester.runAsync(() => env.nodes.files.annotations(photo));
    expect(marks, hasLength(1));
    expect(marks!.single.kind, AnnotationKind.stroke);

    // Undo removes it again.
    await tester.tap(find.byTooltip('Undo last mark'));
    await settle(tester);
    marks = await tester.runAsync(() => env.nodes.files.annotations(photo));
    expect(marks, isEmpty);

    // Draw again, then erase over it.
    await tester.dragFrom(c, const Offset(80, 0));
    await settle(tester);
    await tester.tap(find.byIcon(Icons.auto_fix_normal));
    await settle(tester);
    await tester.dragFrom(c + const Offset(40, -20), const Offset(0, 40));
    await settle(tester);
    marks = await tester.runAsync(() => env.nodes.files.annotations(photo));
    expect(marks, isEmpty);

    await tester.tap(find.widgetWithText(FilledButton, 'Done'));
    await settle(tester);
    expect(find.widgetWithText(FilledButton, 'Mark up'), findsOneWidget);
    await stopApp(tester);
  });

  testWidgets('files from above: link, open from the child, Back returns', (
    tester,
  ) async {
    await startApp(
      tester,
      size: const Size(1600, 900),
      seed: (env) async {
        final trip = await env.nodes.create(title: 'Trip');
        await env.nodes.create(title: 'Pack bags', parentId: trip);
        await env.nodes.files.add(
          trip,
          filename: 'list.txt',
          open: () => Stream.value(utf8.encode('socks')),
        );
      },
    );
    await tester.tap(inTree('Trip'));
    await settle(tester);
    await tester.tap(find.widgetWithText(Card, 'Pack bags'));
    await settle(tester);
    await tester.tap(find.text('Notes & files (0)'));
    await settle(tester);
    await tester.tap(find.text('Link from above…'));
    await settle(tester);
    await tester.tap(find.widgetWithText(CheckboxListTile, 'list.txt'));
    await settle(tester);
    await tester.tap(
      find.descendant(
        of: find.byType(AlertDialog),
        matching: find.widgetWithText(FilledButton, 'Done'),
      ),
    );
    await settle(tester);
    expect(find.text('from: Trip'), findsOneWidget);

    await tester.tap(find.widgetWithText(ListTile, 'list.txt'));
    await settle(tester);
    await letFilesLoad(tester);
    expect(find.textContaining('socks'), findsOneWidget);
    expect(find.text('Back to Pack bags'), findsOneWidget);
    expect(find.text('Linked into 1 item:'), findsOneWidget);
    await tester.tap(find.text('Back to Pack bags'));
    await settle(tester);
    expect(find.text('from: Trip'), findsOneWidget);
    await stopApp(tester);
  });

  testWidgets('search lists files and opens them', (tester) async {
    await startApp(
      tester,
      size: const Size(1600, 900),
      seed: (env) async {
        final trip = await env.nodes.create(title: 'Trip');
        await env.nodes.files.add(
          trip,
          filename: 'notes.txt',
          open: () => Stream.value(utf8.encode('passport renewal')),
        );
      },
    );
    await tester.enterText(
      find.widgetWithText(TextField, 'Search  (#tag, value:, type:, in:)'),
      'passport',
    );
    await settle(tester);
    expect(find.text('1 result'), findsOneWidget);
    await tester.tap(find.widgetWithText(ListTile, 'notes.txt'));
    await settle(tester);
    await letFilesLoad(tester);
    expect(find.textContaining('passport renewal'), findsOneWidget);
    await stopApp(tester);
  });

  // ------------------------------------------------------------------ M4

  DateTime todayAt(int hour) {
    final n = DateTime.now();
    return DateTime(n.year, n.month, n.day, hour);
  }

  testWidgets('calendar: week shows events, deadlines and repeats; open one', (
    tester,
  ) async {
    await startApp(
      tester,
      size: const Size(1600, 1000),
      seed: (env) async {
        final dentist = await env.nodes.create(title: 'Dentist');
        await env.nodes.setDates(
          dentist,
          NodeDates(start: todayAt(10), end: todayAt(11)),
        );
        final taxes = await env.nodes.create(title: 'Taxes');
        await env.nodes.setDates(taxes, NodeDates(dueDate: todayAt(0)));
        final plants = await env.nodes.create(title: 'Water plants');
        await env.nodes.setDates(
          plants,
          NodeDates(
            rrule: const RepeatRule.daily().toRrule(),
            repeatStart: todayAt(0),
          ),
        );
      },
    );
    await tester.tap(find.widgetWithText(ListTile, 'Calendar'));
    await settle(tester);
    Finder inCalendar(String text) => find.descendant(
      of: find.byType(CalendarPage),
      matching: find.textContaining(text),
    );
    expect(inCalendar('Dentist'), findsOneWidget);
    expect(inCalendar('Taxes'), findsOneWidget);
    // Daily from today to the end of this (Monday-first) week.
    expect(
      inCalendar('Water plants'),
      findsNWidgets(8 - DateTime.now().weekday),
    );

    await tester.tap(find.text('Month'));
    await settle(tester);
    expect(inCalendar('Taxes'), findsOneWidget);

    await tester.tap(inCalendar('Taxes'));
    await settle(tester);
    expect(titleField('Taxes'), findsOneWidget);
    await stopApp(tester);
  });

  testWidgets(
    'calendar: left click lists the day; right click asks, then adds',
    (tester) async {
      await startApp(
        tester,
        size: const Size(1600, 1000),
        seed: (env) async {
          for (var i = 0; i < 5; i++) {
            final r = await env.nodes.create(title: 'Routine $i');
            await env.nodes.setDates(
              r,
              NodeDates(
                rrule: const RepeatRule.daily().toRrule(),
                repeatStart: todayAt(0),
              ),
            );
          }
        },
      );
      await tester.tap(find.widgetWithText(ListTile, 'Calendar'));
      await settle(tester);
      Finder inCalendar(String text) => find.descendant(
        of: find.byType(CalendarPage),
        matching: find.textContaining(text),
      );
      // Five repeats on a day: two shown, then "+3 more".
      expect(inCalendar('+3 more'), findsWidgets);

      // Clicking "+3 more" lists all five beside the calendar.
      await tester.tap(inCalendar('+3 more').first);
      await settle(tester);
      expect(find.text('5 entries'), findsOneWidget);
      expect(find.widgetWithText(ListTile, 'Routine 4'), findsOneWidget);

      // Hide repeats with the filter.
      await tester.tap(find.widgetWithText(FilterChip, 'Repeats'));
      await settle(tester);
      expect(inCalendar('Routine'), findsNothing);
      await tester.tap(find.text('Clear filters'));
      await settle(tester);
      await tester.tap(find.byTooltip('Close'));
      await settle(tester);

      // Right-click empty time: a dialog first; Cancel adds nothing.
      await tester.tap(find.text('Day'));
      await settle(tester);
      final grid = find.byType(SingleChildScrollView).last;
      final spot = tester.getTopLeft(grid) + const Offset(300, 60);
      await tester.tapAt(spot, buttons: kSecondaryButton);
      await settle(tester);
      expect(find.textContaining('New event'), findsOneWidget);
      await tester.tap(find.text('Cancel'));
      await settle(tester);
      var rows = await tester.runAsync(() => env.db.select(env.db.nodes).get());
      expect(rows, hasLength(5));

      await tester.tapAt(spot, buttons: kSecondaryButton);
      await settle(tester);
      await tester.enterText(
        find.descendant(
          of: find.byType(AlertDialog),
          matching: find.byType(TextField),
        ),
        'Dentist',
      );
      await tester.tap(find.widgetWithText(FilledButton, 'Add'));
      await settle(tester);
      rows = await tester.runAsync(() => env.db.select(env.db.nodes).get());
      final added = rows!.singleWhere((n) => n.title == 'Dentist');
      expect(added.endAt!.difference(added.startAt!).inHours, 1);
      expect(inCalendar('Dentist'), findsOneWidget);
      await stopApp(tester);
    },
    variant: TargetPlatformVariant.only(TargetPlatform.windows),
  );

  testWidgets(
    'repeating checklist: ticks are for today; parent done when all are',
    (tester) async {
      late String dishes;
      await startApp(
        tester,
        size: wide,
        seed: (env) async {
          final chores = await env.nodes.create(title: 'Chores');
          await env.nodes.setDates(
            chores,
            NodeDates(
              rrule: const RepeatRule.daily().toRrule(),
              repeatStart: todayAt(0),
            ),
          );
          await env.nodes.setChildView(chores, ChildView.checklist);
          dishes = await env.nodes.create(title: 'Dishes', parentId: chores);
          await env.nodes.create(title: 'Floor', parentId: chores);
        },
      );
      await tester.tap(inTree('Chores'));
      await settle(tester);
      expect(find.text('Done for today'), findsOneWidget);
      final boxes = find.byType(Checkbox);
      expect(boxes, findsNWidgets(2));
      await tester.tap(boxes.first);
      await settle(tester);
      expect(
        (await tester.runAsync(() => env.nodes.get(dishes)))!.status,
        NodeStatus.open,
      );
      expect(find.text('Done for today'), findsOneWidget);
      await tester.tap(boxes.last);
      await settle(tester);
      expect(find.text('Completed for today'), findsOneWidget);
      await stopApp(tester);
    },
  );

  testWidgets('dates dialog: reminders and calendar export are saved', (
    tester,
  ) async {
    late String id;
    await startApp(
      tester,
      size: wide,
      seed: (env) async {
        id = await env.nodes.create(title: 'Taxes');
      },
    );
    await tester.tap(inTree('Taxes'));
    await settle(tester);
    await tester.tap(find.widgetWithText(ActionChip, 'Date & time'));
    await settle(tester);
    await tester.tap(find.widgetWithText(SwitchListTile, 'Deadline'));
    await settle(tester);
    expect(find.text('Remind me'), findsOneWidget);
    await tester.ensureVisible(
      find.widgetWithText(FilterChip, 'Day before, 09:00'),
    );
    await tester.tap(find.widgetWithText(FilterChip, 'Day before, 09:00'));
    await settle(tester);
    await tester.ensureVisible(
      find.widgetWithText(SwitchListTile, 'Include in calendar export'),
    );
    await tester.tap(
      find.widgetWithText(SwitchListTile, 'Include in calendar export'),
    );
    await settle(tester);
    await tester.tap(find.text('OK'));
    await settle(tester);
    expect(await tester.runAsync(() => env.nodes.reminders.of(id)), {900});
    expect(await tester.runAsync(() => env.nodes.prefs.icsExport(id)), isTrue);

    // ⋮ → Export to calendar saves this item's .ics.
    String? saved;
    final realSave = saveFileDialog;
    addTearDown(() => saveFileDialog = realSave);
    saveFileDialog = (name, bytes, mime) async {
      saved = '$name|${String.fromCharCodes(bytes)}';
      return name;
    };
    await tester.tap(find.byTooltip('More actions'));
    await settle(tester);
    await tester.tap(
      find.widgetWithText(MenuItemButton, 'Export to calendar (.ics)…'),
    );
    await settle(tester);
    expect(saved, startsWith('Taxes.ics|BEGIN:VCALENDAR'));
    expect(saved, contains('SUMMARY:Due: Taxes'));
    await stopApp(tester);
  });

  testWidgets('show in calendar: from an item, filtered to it and below', (
    tester,
  ) async {
    await startApp(
      tester,
      size: const Size(1600, 1000),
      seed: (env) async {
        final trip = await env.nodes.create(title: 'Trip');
        final flight = await env.nodes.create(title: 'Flight', parentId: trip);
        await env.nodes.setDates(flight, NodeDates(dueDate: todayAt(0)));
        final other = await env.nodes.create(title: 'Dentist');
        await env.nodes.setDates(other, NodeDates(dueDate: todayAt(0)));
      },
    );
    await tester.tap(inTree('Trip'));
    await settle(tester);
    await tester.tap(find.byTooltip('More actions'));
    await settle(tester);
    await tester.tap(find.widgetWithText(MenuItemButton, 'Show in calendar'));
    await settle(tester);
    Finder inCalendar(String text) => find.descendant(
      of: find.byType(CalendarPage),
      matching: find.textContaining(text),
    );
    expect(find.text('Only Trip'), findsOneWidget);
    expect(inCalendar('Flight'), findsOneWidget);
    expect(inCalendar('Dentist'), findsNothing);

    // ✕ on the chip shows everything again.
    await tester.tap(
      find.descendant(
        of: find.widgetWithText(InputChip, 'Only Trip'),
        matching: find.byTooltip('Delete'),
      ),
    );
    await settle(tester);
    expect(inCalendar('Dentist'), findsOneWidget);

    // The chip by an item's dates jumps too.
    await tester.tap(inTree('Dentist'));
    await settle(tester);
    await tester.tap(find.widgetWithText(ActionChip, 'Show in calendar'));
    await settle(tester);
    expect(find.text('Only Dentist'), findsOneWidget);
    expect(inCalendar('Flight'), findsNothing);
    await stopApp(tester);
  });
}
