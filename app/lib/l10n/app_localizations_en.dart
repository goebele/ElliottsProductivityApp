// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Elliott\'s Productivity App';

  @override
  String startupError(String error) {
    return 'Something went wrong while starting up: $error';
  }

  @override
  String get newItem => 'New item';

  @override
  String get untitled => 'Untitled';

  @override
  String get treeEmpty =>
      'Nothing here yet. Create your first goal, project or task.';

  @override
  String get noSelection => 'Select an item to see its details.';

  @override
  String get itemNotFound => 'This item no longer exists.';

  @override
  String get titleHint => 'Title';

  @override
  String get fieldType => 'Type';

  @override
  String get fieldStatus => 'Status';

  @override
  String get closeDescription => 'Close description';

  @override
  String get editDescription => 'Edit description';

  @override
  String get descriptionHint => 'Description (Markdown)';

  @override
  String get childrenHeading => 'Items';

  @override
  String get addChildHint => 'Add an item and press Enter';

  @override
  String get expand => 'Expand';

  @override
  String get collapse => 'Collapse';

  @override
  String get typeGoal => 'Goal';

  @override
  String get typeProject => 'Project';

  @override
  String get typeTask => 'Task';

  @override
  String get typeIdea => 'Idea';

  @override
  String get typeNote => 'Note';

  @override
  String get statusOpen => 'Open';

  @override
  String get statusActive => 'Active';

  @override
  String get statusWaiting => 'Waiting';

  @override
  String get statusDone => 'Done';

  @override
  String get statusDropped => 'Dropped';

  @override
  String get actionDone => 'Done';

  @override
  String get actionDoneToday => 'Done for today';

  @override
  String actionDoneFor(String date) {
    return 'Done for $date';
  }

  @override
  String get completed => 'Completed';

  @override
  String completedOn(String date) {
    return 'Completed $date';
  }

  @override
  String get completedToday => 'Completed for today';

  @override
  String completedFor(String date) {
    return 'Completed for $date';
  }

  @override
  String markedDone(String title) {
    return 'Done: $title';
  }

  @override
  String get reopen => 'Reopen';

  @override
  String movedItem(String title) {
    return 'Moved $title';
  }

  @override
  String get reorderHandle => 'Drag to reorder';

  @override
  String repeatNotStarted(String date) {
    return 'Starts $date';
  }

  @override
  String get addDescription => 'Description';

  @override
  String get addDeadline => 'Deadline';

  @override
  String get addDateTime => 'Date & time';

  @override
  String get addRepeat => 'Repeat';

  @override
  String dueOn(String date) {
    return 'Due $date';
  }

  @override
  String scheduleSummary(String date, String start, String end) {
    return '$date · $start–$end';
  }

  @override
  String get pickStartTime => 'Start time';

  @override
  String get pickEndTime => 'End time';

  @override
  String get repeatWeekdays => 'Every weekday';

  @override
  String get repeatWeeklyOption => 'Weekly pattern';

  @override
  String get repeatMonthlyOption => 'Monthly';

  @override
  String get repeatMonthDay => 'Day of the month';

  @override
  String repeatCustom(String rule) {
    return 'Custom repeat ($rule)';
  }

  @override
  String get remove => 'Remove';

  @override
  String get sectionTimeSlot => 'Time slot';

  @override
  String get notesHeading => 'Notes';

  @override
  String notesToggle(int count) {
    return 'Notes ($count)';
  }

  @override
  String get newNote => 'New note';

  @override
  String get notesEmpty => 'No notes yet.';

  @override
  String get noteBodyHint => 'Write your note (Markdown)';

  @override
  String get repeatDailyOption => 'Daily';

  @override
  String repeatEveryDays(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'Every $n days',
      one: 'Every day',
    );
    return '$_temp0';
  }

  @override
  String repeatEveryWeeks(int n, String days) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'Every $n weeks on $days',
      one: 'Every week on $days',
    );
    return '$_temp0';
  }

  @override
  String repeatEveryMonths(int n, int day) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'Every $n months on day $day',
      one: 'Every month on day $day',
    );
    return '$_temp0';
  }

  @override
  String get repeatEvery => 'Every';

  @override
  String repeatUnitDays(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'days',
      one: 'day',
    );
    return '$_temp0';
  }

  @override
  String repeatUnitWeeks(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'weeks',
      one: 'week',
    );
    return '$_temp0';
  }

  @override
  String repeatUnitMonths(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'months',
      one: 'month',
    );
    return '$_temp0';
  }

  @override
  String get fewer => 'Fewer';

  @override
  String get more => 'More';

  @override
  String repeatStarting(String date) {
    return 'Starting $date';
  }

  @override
  String get exclusiveSwitch => 'One sub-item at a time';

  @override
  String get exclusiveSwitchHelp =>
      'Suggests only the most overdue sub-item, never two at once';

  @override
  String exclusiveChip(String summary) {
    return '$summary · one at a time';
  }

  @override
  String exclusiveNext(String title) {
    return 'Next up: $title';
  }

  @override
  String exclusiveDone(String title) {
    return 'Done: $title';
  }

  @override
  String get exclusiveNothing => 'Nothing due right now';

  @override
  String get markDone => 'Mark done';

  @override
  String get undo => 'Undo';

  @override
  String get cadenceParent => 'Parent\'s schedule';

  @override
  String lastDoneOn(String date) {
    return 'last done $date';
  }

  @override
  String get neverDone => 'not done yet';

  @override
  String overdueDays(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n days overdue',
      one: '1 day overdue',
      zero: 'due today',
    );
    return '$_temp0';
  }

  @override
  String get actionArchive => 'Archive';

  @override
  String get actionMoveToTrash => 'Move to Trash';

  @override
  String get actionDeleteForever => 'Delete forever';

  @override
  String get actionEmptyTrash => 'Empty Trash';

  @override
  String get actionRestore => 'Restore';

  @override
  String get moreActions => 'More actions';

  @override
  String archiveConfirmTitle(String title) {
    return 'Archive $title?';
  }

  @override
  String archiveConfirmBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'It and $count items inside it will be hidden but kept. You can restore them from the Archive.',
      one: 'It and 1 item inside it will be hidden but kept. You can restore them from the Archive.',
      zero: 'It will be hidden but kept. You can restore it from the Archive.',
    );
    return '$_temp0';
  }

  @override
  String trashConfirmTitle(String title) {
    return 'Move $title to Trash?';
  }

  @override
  String trashConfirmBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'It and $count items inside it go to Trash. Items in Trash are deleted after 30 days.',
      one: 'It and 1 item inside it go to Trash. Items in Trash are deleted after 30 days.',
      zero: 'Items in Trash are deleted after 30 days.',
    );
    return '$_temp0';
  }

  @override
  String deleteForeverTitle(String title) {
    return 'Delete $title forever?';
  }

  @override
  String deleteForeverBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'It and $count items inside it will be deleted. This can\'t be undone.',
      one: 'It and 1 item inside it will be deleted. This can\'t be undone.',
      zero: 'This can\'t be undone.',
    );
    return '$_temp0';
  }

  @override
  String get emptyTrashTitle => 'Empty Trash?';

  @override
  String get emptyTrashBody =>
      'Everything in Trash will be deleted forever. This can\'t be undone.';

  @override
  String archivedItem(String title) {
    return 'Archived $title';
  }

  @override
  String trashedItem(String title) {
    return 'Moved $title to Trash';
  }

  @override
  String restoredItem(String title) {
    return 'Restored $title';
  }

  @override
  String restoredToTop(String title) {
    return 'Restored $title to the top level (its old place is gone)';
  }

  @override
  String get inArchive => 'In the Archive';

  @override
  String get inTrash => 'In Trash';

  @override
  String inArchiveWith(String title) {
    return 'Archived with $title';
  }

  @override
  String inTrashWith(String title) {
    return 'In Trash with $title';
  }

  @override
  String get archiveView => 'Archive';

  @override
  String get trashView => 'Trash';

  @override
  String get archiveEmpty => 'Nothing archived.';

  @override
  String get trashEmpty => 'Trash is empty.';

  @override
  String get trashHint => 'Items in Trash are deleted after 30 days.';

  @override
  String groupOthers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'and $count items',
      one: 'and 1 item',
    );
    return '$_temp0';
  }

  @override
  String wasIn(String title) {
    return 'was in $title';
  }

  @override
  String archivedOn(String date) {
    return 'Archived $date';
  }

  @override
  String trashedOn(String date) {
    return 'Deleted $date';
  }

  @override
  String daysLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days left',
      one: '1 day left',
      zero: 'deleted today',
    );
    return '$_temp0';
  }

  @override
  String get viewPanels => 'Panels';

  @override
  String get viewChecklist => 'Checklist';

  @override
  String get viewSteps => 'Steps';

  @override
  String get markNotDone => 'Mark not done';

  @override
  String progressCount(int done, int total) {
    return '$done/$total';
  }

  @override
  String get mdBold => 'Bold';

  @override
  String get mdItalic => 'Italic';

  @override
  String get mdHeading => 'Heading';

  @override
  String get mdBullets => 'Bulleted list';

  @override
  String get mdNumbers => 'Numbered list';

  @override
  String get mdLink => 'Link';

  @override
  String get mdCode => 'Code';

  @override
  String get mdPreview => 'Preview';

  @override
  String get mdEdit => 'Edit';

  @override
  String get mdNothingToPreview => 'Nothing to preview yet.';

  @override
  String get noteEdit => 'Edit';

  @override
  String get noteSave => 'Save';

  @override
  String get noteEmpty => 'Empty note. Click to write.';

  @override
  String backTo(String title) {
    return 'Back to $title';
  }

  @override
  String get cantMoveThere =>
      'Can\'t move it there: it would end up inside itself.';

  @override
  String get removeShortcut => 'Remove shortcut';

  @override
  String get shortcutTooltip => 'Shortcut: this item really lives elsewhere';

  @override
  String get alsoShowIn => 'Also show in…';

  @override
  String removeShortcutFrom(String title) {
    return 'Remove shortcut from $title';
  }

  @override
  String get topLevel => 'Top level';

  @override
  String alsoShownIn(String title) {
    return 'Also shown in $title';
  }

  @override
  String pickerTitle(String title) {
    return 'Also show $title in…';
  }

  @override
  String get pickerSearch => 'Search items';

  @override
  String get pickerNoMatches => 'No matching items.';

  @override
  String viaShortcut(String title) {
    return 'via $title';
  }

  @override
  String get linkedNotesHeading => 'From above';

  @override
  String get linkFromAbove => 'Link from above…';

  @override
  String get linkPickerTitle => 'Link notes from above';

  @override
  String get linkPickerEmpty => 'The items above this one have no notes yet.';

  @override
  String linkGroupParent(String title) {
    return '$title (parent)';
  }

  @override
  String get linkGroupElsewhere => 'Linked earlier, no longer above';

  @override
  String linkedFrom(String title) {
    return 'from: $title';
  }

  @override
  String linkedInto(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Linked into $count items:',
      one: 'Linked into 1 item:',
    );
    return '$_temp0';
  }

  @override
  String get unlink => 'Unlink';

  @override
  String get sourceArchived => 'Source archived';

  @override
  String get sourceTrashed => 'Source in Trash';

  @override
  String get sourceDeleted => 'Source deleted';

  @override
  String get restoreSource => 'Restore source';

  @override
  String get clearLink => 'Clear';

  @override
  String get done => 'Done';

  @override
  String sharedFrom(String title) {
    return 'pinned by: $title';
  }

  @override
  String get sharedWithAll => 'Shared with all sub-items';

  @override
  String get shareWithAll => 'Share with all sub-items';

  @override
  String get stopSharing => 'Stop sharing with sub-items';

  @override
  String usedByElsewhere(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Used by $count items elsewhere, which link its notes.',
      one: 'Used by 1 item elsewhere, which links its notes.',
    );
    return '$_temp0';
  }

  @override
  String shortcutsElsewhere(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Its shortcuts in $count other places go too.',
      one: 'Its shortcut in 1 other place goes too.',
    );
    return '$_temp0';
  }
}
