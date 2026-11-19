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
    return 'Notes & files ($count)';
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
  String get linkPickerTitle => 'Link from above';

  @override
  String get linkPickerEmpty =>
      'The items above this one have no notes or files yet.';

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

  @override
  String get valuesView => 'Values';

  @override
  String get valuesIntro =>
      'What matters to you, and why. Tie values to goals and projects; everything inside them inherits the value.';

  @override
  String get valuesEmpty => 'No values yet.';

  @override
  String get valueNew => 'New value…';

  @override
  String get valueEdit => 'Edit value';

  @override
  String get valueDelete => 'Delete value';

  @override
  String valueDeleteTitle(String name) {
    return 'Delete “$name”?';
  }

  @override
  String valueDeleteBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'It will be untied from $count items.',
      one: 'It will be untied from 1 item.',
      zero: 'It isn\'t tied to anything.',
    );
    return '$_temp0';
  }

  @override
  String get valueName => 'Name';

  @override
  String get valueStatement => 'Why it matters';

  @override
  String get valueStatementHint =>
      'e.g. I want the energy to keep up with my kids.';

  @override
  String get valueIcon => 'Icon';

  @override
  String get valueColor => 'Color';

  @override
  String get valueAdd => 'Value';

  @override
  String get valueRemove => 'Untie this value';

  @override
  String valueFrom(String name, String title) {
    return '$name · from $title';
  }

  @override
  String get valueInherited =>
      'Inherited from an item above. Open it to change.';

  @override
  String get valueNothingTied =>
      'Not tied to anything yet. Add it from an item\'s “+ Value”.';

  @override
  String get save => 'Save';

  @override
  String get tagAdd => 'Tag';

  @override
  String get tagRemove => 'Remove tag';

  @override
  String get tagFromText => 'From the text. Edit the text to remove it.';

  @override
  String get tagSearch => 'Search for this tag';

  @override
  String get tagPickerTitle => 'Tags';

  @override
  String get tagPickerHint => 'Type a tag and press Enter';

  @override
  String get tagsEmpty => 'No tags yet.';

  @override
  String get searchHint => 'Search  (#tag, value:, type:, in:)';

  @override
  String get searchFilters => 'Filters';

  @override
  String get searchClear => 'Clear search';

  @override
  String get searchNoResults => 'Nothing found.';

  @override
  String searchCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count results',
      one: '1 result',
    );
    return '$_temp0';
  }

  @override
  String searchLinkedIn(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'linked in $count places',
      one: 'linked in 1 place',
    );
    return '$_temp0';
  }

  @override
  String get searchArchived => 'archived';

  @override
  String get filterValue => 'Value';

  @override
  String get filterTag => 'Tag';

  @override
  String get filterIncludeChildren => 'Include items under tagged ones';

  @override
  String get filterType => 'Type';

  @override
  String get filterStatus => 'Status';

  @override
  String get filterProject => 'Project';

  @override
  String get filterAnyProject => 'Anywhere';

  @override
  String get filterDue => 'Due';

  @override
  String filterDueRange(String from, String to) {
    return '$from – $to';
  }

  @override
  String get filterArchived => 'Include archived';

  @override
  String get zoomIn => 'Zoom in';

  @override
  String get zoomTreeHere => 'Zoom tree here';

  @override
  String get zoomOut => 'Zoom out one level';

  @override
  String get zoomReset => 'Show the whole tree';

  @override
  String get breadcrumbsShowAll => 'Show the full path';

  @override
  String get peekOpen => 'Open';

  @override
  String get peekPin => 'Pin beside';

  @override
  String get peekUnpin => 'Close';

  @override
  String peekItems(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items',
      one: '1 item',
    );
    return '$_temp0';
  }

  @override
  String get tagsView => 'Tags';

  @override
  String get tagsIntro =>
      'Star the tags you use most, such as #work or #home: they become one-tap choices when tagging an item. Click a count to see those items.';

  @override
  String get tagsFavorites => 'Favorites';

  @override
  String get tagsOthers => 'Other tags';

  @override
  String get tagsAll => 'All tags';

  @override
  String get tagNew => 'Create tag';

  @override
  String get tagNewHint => 'New tag, then Enter';

  @override
  String get tagNameInvalid =>
      'Start with a letter; use letters, numbers, - and _.';

  @override
  String get tagFavorite => 'Add to favorites';

  @override
  String get tagUnfavorite => 'Remove from favorites';

  @override
  String get tagColor => 'Colour';

  @override
  String get tagNoColor => 'No colour';

  @override
  String tagUses(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items',
      one: '1 item',
      zero: 'Not used',
    );
    return '$_temp0';
  }

  @override
  String get tagRename => 'Rename';

  @override
  String get tagMerge => 'Merge';

  @override
  String tagRenameTitle(String name) {
    return 'Rename #$name';
  }

  @override
  String get tagRenameNote =>
      'Where it is written in a title or text, that is rewritten too.';

  @override
  String tagMergeNote(String from, String into) {
    return '#$from will be merged into #$into: every item with #$from gets #$into, and the text is rewritten.';
  }

  @override
  String get tagDelete => 'Delete tag';

  @override
  String tagDeleteTitle(String name) {
    return 'Delete #$name?';
  }

  @override
  String tagDeleteBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'It will be removed from $count items.',
      one: 'It will be removed from 1 item.',
      zero: 'It isn\'t on any item.',
    );
    return '$_temp0 Where it is written in text, the # is removed so it stays plain text.';
  }

  @override
  String get tagPickerOnItem => 'On this item';

  @override
  String filesHeading(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Files ($count)',
      zero: 'Files',
    );
    return '$_temp0';
  }

  @override
  String get fileAdd => 'Add';

  @override
  String get fileChoose => 'Choose files…';

  @override
  String get fileTakePhoto => 'Take photo';

  @override
  String get filePasteImage => 'Paste image';

  @override
  String get fileNoImageToPaste => 'There\'s no image on the clipboard.';

  @override
  String get filesEmpty => 'No files yet.';

  @override
  String get filesEmptyDesktop =>
      'No files yet. Drop files on this item, or paste a screenshot with Ctrl+V.';

  @override
  String get fileDropHere => 'Drop to attach';

  @override
  String get fileTooBigTitle => 'Large file';

  @override
  String fileTooBigBody(String name, String size) {
    return '$name is $size. Files over 20 MB fill up your devices quickly. Attach it anyway?';
  }

  @override
  String get fileSkip => 'Skip';

  @override
  String get fileAttachAnyway => 'Attach anyway';

  @override
  String fileAttached(String name) {
    return 'Attached $name';
  }

  @override
  String filesAttached(int count) {
    return 'Attached $count files';
  }

  @override
  String get fileNoApp => 'No app on this device can open this file.';

  @override
  String get fileOpenIn => 'Open in…';

  @override
  String get fileOpenInNote =>
      'Opens a copy in your default app. Changes made there aren\'t saved here; use Replace file to bring in a new version.';

  @override
  String get fileReplace => 'Replace file…';

  @override
  String get fileExportMarkup => 'Export with markup…';

  @override
  String get fileRename => 'Rename';

  @override
  String get fileRemove => 'Remove file';

  @override
  String fileRemoved(String name) {
    return 'Removed $name';
  }

  @override
  String get fileSaved => 'Saved';

  @override
  String fileOwnedBy(String title) {
    return 'from $title';
  }

  @override
  String get markup => 'Mark up';

  @override
  String get markupDone => 'Done';

  @override
  String get markupShow => 'Show markup';

  @override
  String get markupHide => 'Hide markup';

  @override
  String get markupPen => 'Pen';

  @override
  String get markupHighlighter => 'Highlighter';

  @override
  String get markupText => 'Text label';

  @override
  String get markupEraser => 'Eraser';

  @override
  String get markupUndo => 'Undo last mark';

  @override
  String get markupLabelTitle => 'Label';

  @override
  String get markupHighlight => 'Highlight';

  @override
  String get markupClear => 'Clear';

  @override
  String get markupSelectHint => 'Select text, then Highlight.';

  @override
  String get linkedFilesHeading => 'Files';

  @override
  String get searchFile => 'file';

  @override
  String get filterHasFiles => 'Has files';

  @override
  String get fileTooBigToShow =>
      'This file is too big to show here. Use Open in… to read it.';

  @override
  String get calendarView => 'Calendar';

  @override
  String get calendarDay => 'Day';

  @override
  String get calendarWeek => 'Week';

  @override
  String get calendarMonth => 'Month';

  @override
  String get calendarToday => 'Today';

  @override
  String get calendarPrevious => 'Previous';

  @override
  String get calendarNext => 'Next';

  @override
  String calendarMore(int count) {
    return '+$count more';
  }

  @override
  String get icsExport => 'Export calendar (.ics)…';

  @override
  String get icsExportItem => 'Export to calendar (.ics)…';

  @override
  String get icsNoneChosen =>
      'No items are chosen for export yet. In an item\'s date & time, turn on \"Include in calendar export\".';

  @override
  String get icsInclude => 'Include in calendar export';

  @override
  String get icsIncludeHelp =>
      'Adds it to the .ics file from Calendar → Export, for Google, Outlook or Apple calendars.';

  @override
  String get remindMe => 'Remind me';

  @override
  String get remindAtTime => 'At the time';

  @override
  String remindMinutesBefore(int count) {
    return '$count min before';
  }

  @override
  String remindHoursBefore(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count hours before',
      one: '1 hour before',
    );
    return '$_temp0';
  }

  @override
  String remindDaysBefore(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days before',
      one: '1 day before',
    );
    return '$_temp0';
  }

  @override
  String get remindOnDay => 'On the day, 09:00';

  @override
  String get remindDayBefore => 'Day before, 09:00';

  @override
  String get calendarEvents => 'Events';

  @override
  String get calendarDeadlines => 'Deadlines';

  @override
  String get calendarRepeats => 'Repeats';

  @override
  String get calendarHideDone => 'Hide done';

  @override
  String calendarUnderItem(String title) {
    return 'Only $title';
  }

  @override
  String get calendarClearFilters => 'Clear filters';

  @override
  String calendarAdded(String title) {
    return 'Added $title';
  }

  @override
  String get calendarQuickAdd => 'Add';

  @override
  String calendarQuickAddDue(String day) {
    return 'New item · due $day';
  }

  @override
  String calendarQuickAddAt(String day, String start, String end) {
    return 'New event · $day · $start–$end';
  }

  @override
  String get calendarCloseDay => 'Close';

  @override
  String calendarDayCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count entries',
      one: '1 entry',
      zero: 'Nothing on this day.',
    );
    return '$_temp0';
  }

  @override
  String get calendarAllDay => 'All day';

  @override
  String get calendarDeadline => 'Deadline';

  @override
  String get calendarRepeat => 'Repeat';

  @override
  String get calendarEvent => 'Event';

  @override
  String get calendarAddOnDay => 'Add on this day…';

  @override
  String get calendarListDay => 'Show everything on this day';

  @override
  String get showInCalendar => 'Show in calendar';

  @override
  String get timerStart => 'Start timer';

  @override
  String get timerStartMenu => 'Timer or focus';

  @override
  String get timerStop => 'Stop timer';

  @override
  String get timerPause => 'Pause';

  @override
  String get timerResume => 'Resume';

  @override
  String timerPaused(String title) {
    return 'Paused · $title';
  }

  @override
  String get timerNow => 'now';

  @override
  String get timerMiniWindow => 'Mini window (stays on top)';

  @override
  String get timerExpand => 'Back to the full window';

  @override
  String focusFor(String length) {
    return 'Focus for $length';
  }

  @override
  String focusForEstimate(String length) {
    return 'Focus for the estimate ($length)';
  }

  @override
  String focusLeft(String title, String left) {
    return '$title · $left left';
  }

  @override
  String focusOver(String title, String elapsed) {
    return '$title · $elapsed (focus time is up)';
  }

  @override
  String get focusEndedTitle => 'Focus time is up';

  @override
  String focusEndedBody(String title) {
    return 'How did $title go?';
  }

  @override
  String get focusKeepGoing => 'Keep going';

  @override
  String get focusDone => 'Done';

  @override
  String get focusBreak => 'Take a break';

  @override
  String breakLeft(String left) {
    return 'Break · $left left';
  }

  @override
  String get breakOver => 'Break\'s over';

  @override
  String get breakEnd => 'End break';

  @override
  String get estimateAdd => 'Estimate';

  @override
  String estimateIs(String length) {
    return 'Est. $length';
  }

  @override
  String get estimateTitle => 'Estimate';

  @override
  String get estimateMinutes => 'Or minutes';

  @override
  String get trackedNone => 'Track time';

  @override
  String trackedIs(String tracked) {
    return '$tracked tracked';
  }

  @override
  String trackedOf(String tracked, String estimate) {
    return '$tracked of $estimate';
  }

  @override
  String get trackedTooltip => 'Time entries: add, edit or delete';

  @override
  String rollupItems(String tracked, String estimate) {
    return 'Items: $tracked of $estimate';
  }

  @override
  String get timeEntriesTitle => 'Time';

  @override
  String get timeEntriesEmpty =>
      'No time tracked yet. Start a timer with ▶, or add time.';

  @override
  String get timeAdd => 'Add time…';

  @override
  String get timeEdit => 'Edit time';

  @override
  String get timeDelete => 'Delete';

  @override
  String get timeLength => 'Length';

  @override
  String get timeNote => 'Note';

  @override
  String get timePersonal => 'Only you see your time.';

  @override
  String progressItems(int done, int total, int percent) {
    return '$done/$total · $percent%';
  }

  @override
  String progressManual(int percent) {
    return '$percent% (set by hand)';
  }

  @override
  String get progressSet => 'Set progress manually…';

  @override
  String get progressSetTitle => 'Progress';

  @override
  String get progressUseItems => 'Count items again';

  @override
  String get reviewView => 'Review';

  @override
  String get reviewCustom => 'Dates…';

  @override
  String get reviewThis => 'This one';

  @override
  String get reviewCopy => 'Copy as Markdown';

  @override
  String get reviewCopied => 'Copied';

  @override
  String get reviewExport => 'Export (.md)…';

  @override
  String reviewTitleFor(String range) {
    return 'Review: $range';
  }

  @override
  String get reviewCompleted => 'completed';

  @override
  String get reviewCreated => 'created';

  @override
  String get reviewTracked => 'tracked';

  @override
  String get reviewOverdue => 'overdue';

  @override
  String get reviewEmpty =>
      'Nothing done, tracked or created in these dates yet.';

  @override
  String get reviewCompletedByProject => 'Completed, by project';

  @override
  String get reviewCompletedByValue => 'Completed, by value';

  @override
  String get reviewTimeByProject => 'Time by project';

  @override
  String get reviewTimeByValue => 'Time by value';

  @override
  String get reviewTimeByTag => 'Time by tag';

  @override
  String get reviewRoutines => 'Routines';

  @override
  String get reviewOverdueTitle => 'Overdue';

  @override
  String reviewDue(String date) {
    return 'Due $date';
  }

  @override
  String get todayView => 'Today';

  @override
  String get treeView => 'Tree';

  @override
  String todayDoneCount(int done, int total) {
    return '$done of $total done';
  }

  @override
  String get todayEmpty =>
      'Nothing on today yet. Add an item with ⋮ → Add to Today, or try Pick one for me.';

  @override
  String get todayPickOne => 'Pick one for me';

  @override
  String get todayPickAnother => 'Another';

  @override
  String get todayPickNone => 'Nothing open matches. Try fewer filters.';

  @override
  String get todayAdd => 'Add to Today';

  @override
  String get todayAddItem => 'Add to Today';

  @override
  String get todayRemoveItem => 'Remove from Today';

  @override
  String get todayRemove => 'Remove from today';

  @override
  String todayRemoved(String title) {
    return 'Removed $title from today';
  }

  @override
  String todayOverdue(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'Overdue · $days days',
      one: 'Overdue · 1 day',
    );
    return '$_temp0';
  }

  @override
  String get todayDue => 'Due today';

  @override
  String todayAt(String time) {
    return 'At $time';
  }

  @override
  String get todayPicked => 'Added by you';

  @override
  String todayLeftOver(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items you added on earlier days aren\'t done',
      one: '1 item you added on an earlier day isn\'t done',
    );
    return '$_temp0';
  }

  @override
  String get todayKeep => 'Keep on today';

  @override
  String get todayDrop => 'Drop';

  @override
  String get todaySettings => 'What Today adds by itself';

  @override
  String get todayAutoTitle => 'Add by itself:';

  @override
  String get todayAutoRoutines => 'Routines due today';

  @override
  String get todayAutoDue => 'Due today';

  @override
  String get todayAutoOverdue => 'Overdue';

  @override
  String get todayAutoEvents => 'Events today';

  @override
  String get todayAutoActive => 'In progress (Active)';

  @override
  String get mdLinkItem => 'Link to a note or item ([[)';

  @override
  String get linkToItemTitle => 'Link to a note or item';

  @override
  String get linkToItemHint => 'Search titles and text';

  @override
  String get linkToItemRecent => 'Recently changed';

  @override
  String linkedFrom2(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Linked from $count:',
      one: 'Linked from 1:',
    );
    return '$_temp0';
  }

  @override
  String get todayDefineIt =>
      'Define it: add subtasks or a completion condition';

  @override
  String todayGroupDone(int done, int total) {
    return '$done/$total done';
  }

  @override
  String conditionChecklistProgress(int done, int total) {
    return 'Checklist $done/$total';
  }

  @override
  String conditionCounterProgress(int count, int target) {
    return '$count/$target';
  }

  @override
  String conditionTimerProgress(int minutes, int target) {
    return '$minutes/$target min';
  }

  @override
  String get completionCounter => 'Counter';

  @override
  String get completionTimer => 'Timer';

  @override
  String completionCounterState(int count, int target) {
    return '$count / $target';
  }

  @override
  String completionTimerState(int minutes, int target) {
    return '$minutes of $target min';
  }

  @override
  String get completionCountUp => '1';

  @override
  String get completionCountDown => 'Undo one';

  @override
  String get completionCounterAsk => 'Count to';

  @override
  String get completionTimerAsk => 'Time to spend';

  @override
  String get requirementAdd => 'Completion condition';

  @override
  String get requirementCheckbox => 'Checkbox';

  @override
  String get requirementCheckboxAsk => 'Checkbox';

  @override
  String get requirementRemove => 'Remove requirement';

  @override
  String get addTaskAndOpen => 'New task under this, and open it';

  @override
  String get titleFirst => 'Give it a title to continue';

  @override
  String get tagPickerNew => 'New tag';

  @override
  String tagPickerNewNamed(String name) {
    return 'New tag #$name';
  }

  @override
  String tagPickerAddNamed(String name) {
    return 'Add #$name';
  }

  @override
  String get rowTags => 'Tags';

  @override
  String get rowValue => 'Value';

  @override
  String get rowWhen => 'When';

  @override
  String get rowTime => 'Time';

  @override
  String get rowDescription => 'Description';

  @override
  String get descriptionPlaceholder => 'Add a description…';

  @override
  String get tagAddTooltip => 'Add a tag';

  @override
  String get valueAddTooltip => 'Add a value';

  @override
  String get addDateTimeTooltip => 'Set date & time';

  @override
  String get estimateAddTooltip => 'Set an estimate';

  @override
  String get notesShow => 'Show notes & files';

  @override
  String get notesHide => 'Hide notes & files';

  @override
  String get emptyItemRemoved => 'Removed an empty item';

  @override
  String get addCheckbox => 'Add a checkbox';

  @override
  String get checkboxDelete => 'Delete';

  @override
  String get checkboxRename => 'Rename checkbox';

  @override
  String checkboxDeleted(String title) {
    return 'Deleted “$title”';
  }

  @override
  String get checkboxRenameMenu => 'Rename';

  @override
  String get todayNewTask => 'New task for today';

  @override
  String get devicesView => 'Devices';

  @override
  String get devicesThisDevice => 'This device';

  @override
  String get devicesYours => 'Your devices';

  @override
  String get devicesNoneYet => 'No other devices yet. Pair one below.';

  @override
  String get devicesPair => 'Pair a device';

  @override
  String get devicesPairHelp =>
      'Pairing makes another device one of yours. The joining device keeps its items: both end up with everything.';

  @override
  String get devicesLetJoin => 'Let a device join this one';

  @override
  String get devicesNearby => 'Found nearby';

  @override
  String get devicesNearbyNone =>
      'No other devices found. Open Devices on the other device, on the same Wi-Fi, or join by address.';

  @override
  String get devicesJoin => 'Join';

  @override
  String get devicesJoinByAddress => 'Join by address…';

  @override
  String get devicesAddressPrompt =>
      'The other device\'s address (shown on its Devices page)';

  @override
  String get devicesAddressInvalid =>
      'That isn\'t an address like 192.168.1.20:47913.';

  @override
  String get devicesRename => 'Rename this device';

  @override
  String get devicesSyncNow => 'Sync now';

  @override
  String devicesReachableAt(String address) {
    return 'Reachable at $address';
  }

  @override
  String devicesLastSync(String when) {
    return 'Synced $when';
  }

  @override
  String get devicesNeverSynced => 'Not synced yet';

  @override
  String get devicesNearbyNow => 'Nearby';

  @override
  String devicesUnnamed(String code) {
    return 'Device $code';
  }

  @override
  String devicesPlatformCode(String platform, String code) {
    return '$platform · $code';
  }

  @override
  String get devicesPin => 'Pairing PIN';

  @override
  String get devicesPinHelp => 'Optional. A joining device must enter it too.';

  @override
  String get devicesPinSet => 'Set PIN';

  @override
  String get devicesPinChange => 'Change';

  @override
  String get devicesPinRemove => 'Remove';

  @override
  String get devicesPinOn => 'A PIN is set';

  @override
  String get devicesPinPrompt => 'Pairing PIN (4 or more digits)';

  @override
  String get devicesPinAsk => 'Enter the other device\'s pairing PIN';

  @override
  String get devicesSyncOff => 'Sync is off on this device.';

  @override
  String get pairWaitingTitle => 'Waiting for a device to join';

  @override
  String pairWaitingBody(String name) {
    return 'On the new device, open Devices and tap Join next to $name, on the same Wi-Fi.';
  }

  @override
  String get pairCompareTitle => 'Check the code';

  @override
  String get pairCompareBody => 'Does the other device show this code?';

  @override
  String get pairCodesMatch => 'Yes, it matches';

  @override
  String get pairCodesDiffer => 'No';

  @override
  String get pairWorking => 'Pairing and syncing…';

  @override
  String get pairJoined => 'Paired. Everything is syncing.';

  @override
  String pairFailed(String reason) {
    return 'Pairing stopped: $reason';
  }

  @override
  String get pairJoinConfirmTitle => 'Join this device?';

  @override
  String get pairJoinConfirmBody =>
      'This device becomes one of the other\'s devices. Its items are kept and added to the other\'s, so both have everything.';

  @override
  String get syncStatusSyncing => 'Syncing…';

  @override
  String syncStatusSynced(String when) {
    return 'Synced $when';
  }

  @override
  String get syncStatusNever => 'Not synced yet: pair a device';

  @override
  String syncStatusProblem(String message) {
    return 'Sync problem: $message';
  }

  @override
  String get syncJustNow => 'just now';

  @override
  String syncMinutesAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count minutes ago',
      one: '1 minute ago',
    );
    return '$_temp0';
  }

  @override
  String syncHoursAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count hours ago',
      one: '1 hour ago',
    );
    return '$_temp0';
  }

  @override
  String get cancel => 'Cancel';

  @override
  String get settingsView => 'Settings';

  @override
  String get settingsAppearance => 'Appearance';

  @override
  String get settingsTheme => 'Theme';

  @override
  String get settingsThemeSystem => 'System';

  @override
  String get settingsThemeLight => 'Light';

  @override
  String get settingsThemeDark => 'Dark';

  @override
  String get settingsThisDeviceOnly =>
      'Just for this device: your other devices keep their own.';

  @override
  String get settingsSync => 'Sync';

  @override
  String get settingsDevicesHelp =>
      'Pair devices and see when they last synced';

  @override
  String get settingsTroubleshooting => 'Troubleshooting';

  @override
  String get settingsLog => 'App log';

  @override
  String get settingsLogHelpDesktop =>
      'Startup, errors and sync problems on this device. Opens the file.';

  @override
  String get settingsLogHelpPhone =>
      'Startup, errors and sync problems on this device. Copies the latest lines.';

  @override
  String get settingsLogCopied => 'Log copied';

  @override
  String get mdStrike => 'Strikethrough';
}
