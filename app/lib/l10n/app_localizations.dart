import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('en')];

  /// The application title
  ///
  /// In en, this message translates to:
  /// **'Elliott\'s Productivity App'**
  String get appTitle;

  /// Shown if the database or identity key could not be loaded
  ///
  /// In en, this message translates to:
  /// **'Something went wrong while starting up: {error}'**
  String startupError(String error);

  /// Button that creates a new top-level node
  ///
  /// In en, this message translates to:
  /// **'New item'**
  String get newItem;

  /// Shown in place of an empty node title
  ///
  /// In en, this message translates to:
  /// **'Untitled'**
  String get untitled;

  /// Tree pane text when there are no nodes
  ///
  /// In en, this message translates to:
  /// **'Nothing here yet. Create your first goal, project or task.'**
  String get treeEmpty;

  /// Detail pane text when no node is selected
  ///
  /// In en, this message translates to:
  /// **'Select an item to see its details.'**
  String get noSelection;

  /// Detail pane text when the node was removed
  ///
  /// In en, this message translates to:
  /// **'This item no longer exists.'**
  String get itemNotFound;

  /// Hint in the node title field
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get titleHint;

  /// Label of the node type picker
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get fieldType;

  /// Label of the node status picker
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get fieldStatus;

  /// No description provided for @closeDescription.
  ///
  /// In en, this message translates to:
  /// **'Close description'**
  String get closeDescription;

  /// No description provided for @editDescription.
  ///
  /// In en, this message translates to:
  /// **'Edit description'**
  String get editDescription;

  /// Hint in an item's description field
  ///
  /// In en, this message translates to:
  /// **'Description (Markdown)'**
  String get descriptionHint;

  /// Heading above a node's children in the detail pane
  ///
  /// In en, this message translates to:
  /// **'Items'**
  String get childrenHeading;

  /// Hint in the quick-add field for child nodes
  ///
  /// In en, this message translates to:
  /// **'Add an item and press Enter'**
  String get addChildHint;

  /// Tooltip on the tree row arrow when collapsed
  ///
  /// In en, this message translates to:
  /// **'Expand'**
  String get expand;

  /// Tooltip on the tree row arrow when expanded
  ///
  /// In en, this message translates to:
  /// **'Collapse'**
  String get collapse;

  /// No description provided for @typeGoal.
  ///
  /// In en, this message translates to:
  /// **'Goal'**
  String get typeGoal;

  /// No description provided for @typeProject.
  ///
  /// In en, this message translates to:
  /// **'Project'**
  String get typeProject;

  /// No description provided for @typeTask.
  ///
  /// In en, this message translates to:
  /// **'Task'**
  String get typeTask;

  /// No description provided for @typeIdea.
  ///
  /// In en, this message translates to:
  /// **'Idea'**
  String get typeIdea;

  /// No description provided for @typeNote.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get typeNote;

  /// No description provided for @statusOpen.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get statusOpen;

  /// No description provided for @statusActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get statusActive;

  /// No description provided for @statusWaiting.
  ///
  /// In en, this message translates to:
  /// **'Waiting'**
  String get statusWaiting;

  /// No description provided for @statusDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get statusDone;

  /// No description provided for @statusDropped.
  ///
  /// In en, this message translates to:
  /// **'Dropped'**
  String get statusDropped;

  /// No description provided for @actionDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get actionDone;

  /// No description provided for @actionDoneToday.
  ///
  /// In en, this message translates to:
  /// **'Done for today'**
  String get actionDoneToday;

  /// No description provided for @actionDoneFor.
  ///
  /// In en, this message translates to:
  /// **'Done for {date}'**
  String actionDoneFor(String date);

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @completedOn.
  ///
  /// In en, this message translates to:
  /// **'Completed {date}'**
  String completedOn(String date);

  /// No description provided for @completedToday.
  ///
  /// In en, this message translates to:
  /// **'Completed for today'**
  String get completedToday;

  /// No description provided for @completedFor.
  ///
  /// In en, this message translates to:
  /// **'Completed for {date}'**
  String completedFor(String date);

  /// No description provided for @markedDone.
  ///
  /// In en, this message translates to:
  /// **'Done: {title}'**
  String markedDone(String title);

  /// No description provided for @reopen.
  ///
  /// In en, this message translates to:
  /// **'Reopen'**
  String get reopen;

  /// No description provided for @movedItem.
  ///
  /// In en, this message translates to:
  /// **'Moved {title}'**
  String movedItem(String title);

  /// No description provided for @reorderHandle.
  ///
  /// In en, this message translates to:
  /// **'Drag to reorder'**
  String get reorderHandle;

  /// No description provided for @repeatNotStarted.
  ///
  /// In en, this message translates to:
  /// **'Starts {date}'**
  String repeatNotStarted(String date);

  /// Chip that adds a description field to an item
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get addDescription;

  /// Chip that adds a deadline to an item
  ///
  /// In en, this message translates to:
  /// **'Deadline'**
  String get addDeadline;

  /// Chip that gives an item a time slot, making it an event
  ///
  /// In en, this message translates to:
  /// **'Date & time'**
  String get addDateTime;

  /// Chip that makes an item repeat (a routine); also the repeat dialog title
  ///
  /// In en, this message translates to:
  /// **'Repeat'**
  String get addRepeat;

  /// Deadline chip text
  ///
  /// In en, this message translates to:
  /// **'Due {date}'**
  String dueOn(String date);

  /// Time slot chip text
  ///
  /// In en, this message translates to:
  /// **'{date} · {start}–{end}'**
  String scheduleSummary(String date, String start, String end);

  /// Heading of the start time picker
  ///
  /// In en, this message translates to:
  /// **'Start time'**
  String get pickStartTime;

  /// Heading of the end time picker
  ///
  /// In en, this message translates to:
  /// **'End time'**
  String get pickEndTime;

  /// Repeat summary and option: Monday to Friday
  ///
  /// In en, this message translates to:
  /// **'Every weekday'**
  String get repeatWeekdays;

  /// Repeat option: on chosen days of the week, every N weeks
  ///
  /// In en, this message translates to:
  /// **'Weekly pattern'**
  String get repeatWeeklyOption;

  /// Repeat option: on a day of the month
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get repeatMonthlyOption;

  /// Label of the day-of-month picker in the repeat dialog
  ///
  /// In en, this message translates to:
  /// **'Day of the month'**
  String get repeatMonthDay;

  /// Repeat summary for a rule this version can't show
  ///
  /// In en, this message translates to:
  /// **'Custom repeat ({rule})'**
  String repeatCustom(String rule);

  /// Tooltip on the x of an item's deadline, time slot or repeat chip
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

  /// Date & time dialog section that gives an item a start and end time (an event)
  ///
  /// In en, this message translates to:
  /// **'Time slot'**
  String get sectionTimeSlot;

  /// Heading of the notes column / section of an item
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notesHeading;

  /// No description provided for @notesToggle.
  ///
  /// In en, this message translates to:
  /// **'Notes & files ({count})'**
  String notesToggle(int count);

  /// Button that adds a note to an item
  ///
  /// In en, this message translates to:
  /// **'New note'**
  String get newNote;

  /// Notes column text when an item has no notes
  ///
  /// In en, this message translates to:
  /// **'No notes yet.'**
  String get notesEmpty;

  /// Hint in a note's text field
  ///
  /// In en, this message translates to:
  /// **'Write your note (Markdown)'**
  String get noteBodyHint;

  /// Repeat option: every N days
  ///
  /// In en, this message translates to:
  /// **'Daily'**
  String get repeatDailyOption;

  /// Repeat summary
  ///
  /// In en, this message translates to:
  /// **'{n, plural, =1{Every day} other{Every {n} days}}'**
  String repeatEveryDays(int n);

  /// Repeat summary; days is a list like 'Mon, Thu'
  ///
  /// In en, this message translates to:
  /// **'{n, plural, =1{Every week on {days}} other{Every {n} weeks on {days}}}'**
  String repeatEveryWeeks(int n, String days);

  /// Repeat summary
  ///
  /// In en, this message translates to:
  /// **'{n, plural, =1{Every month on day {day}} other{Every {n} months on day {day}}}'**
  String repeatEveryMonths(int n, int day);

  /// Before the interval number in the repeat section: 'Every [2] weeks'
  ///
  /// In en, this message translates to:
  /// **'Every'**
  String get repeatEvery;

  /// After the interval number
  ///
  /// In en, this message translates to:
  /// **'{n, plural, =1{day} other{days}}'**
  String repeatUnitDays(int n);

  /// After the interval number
  ///
  /// In en, this message translates to:
  /// **'{n, plural, =1{week} other{weeks}}'**
  String repeatUnitWeeks(int n);

  /// After the interval number
  ///
  /// In en, this message translates to:
  /// **'{n, plural, =1{month} other{months}}'**
  String repeatUnitMonths(int n);

  /// Tooltip on the button that lowers the repeat interval
  ///
  /// In en, this message translates to:
  /// **'Fewer'**
  String get fewer;

  /// Tooltip on the button that raises the repeat interval
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get more;

  /// Button showing (and changing) the first day of a repeat
  ///
  /// In en, this message translates to:
  /// **'Starting {date}'**
  String repeatStarting(String date);

  /// Switch: the item's sub-items take turns, one per occurrence
  ///
  /// In en, this message translates to:
  /// **'One sub-item at a time'**
  String get exclusiveSwitch;

  /// Explains the one-at-a-time switch
  ///
  /// In en, this message translates to:
  /// **'Suggests only the most overdue sub-item, never two at once'**
  String get exclusiveSwitchHelp;

  /// Repeat chip text when sub-items take turns
  ///
  /// In en, this message translates to:
  /// **'{summary} · one at a time'**
  String exclusiveChip(String summary);

  /// Which sub-item is suggested now
  ///
  /// In en, this message translates to:
  /// **'Next up: {title}'**
  String exclusiveNext(String title);

  /// The sub-item already done for this occurrence
  ///
  /// In en, this message translates to:
  /// **'Done: {title}'**
  String exclusiveDone(String title);

  /// No sub-item of a one-at-a-time set is due
  ///
  /// In en, this message translates to:
  /// **'Nothing due right now'**
  String get exclusiveNothing;

  /// Button that completes the suggested sub-item
  ///
  /// In en, this message translates to:
  /// **'Mark done'**
  String get markDone;

  /// Button that undoes a completion
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get undo;

  /// Sub-item with no repeat of its own, in a one-at-a-time set
  ///
  /// In en, this message translates to:
  /// **'Parent\'s schedule'**
  String get cadenceParent;

  /// When a sub-item was last done
  ///
  /// In en, this message translates to:
  /// **'last done {date}'**
  String lastDoneOn(String date);

  /// A sub-item that has never been done
  ///
  /// In en, this message translates to:
  /// **'not done yet'**
  String get neverDone;

  /// How late the suggested sub-item is
  ///
  /// In en, this message translates to:
  /// **'{n, plural, =0{due today} =1{1 day overdue} other{{n} days overdue}}'**
  String overdueDays(int n);

  /// No description provided for @actionArchive.
  ///
  /// In en, this message translates to:
  /// **'Archive'**
  String get actionArchive;

  /// No description provided for @actionMoveToTrash.
  ///
  /// In en, this message translates to:
  /// **'Move to Trash'**
  String get actionMoveToTrash;

  /// No description provided for @actionDeleteForever.
  ///
  /// In en, this message translates to:
  /// **'Delete forever'**
  String get actionDeleteForever;

  /// No description provided for @actionEmptyTrash.
  ///
  /// In en, this message translates to:
  /// **'Empty Trash'**
  String get actionEmptyTrash;

  /// No description provided for @actionRestore.
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get actionRestore;

  /// No description provided for @moreActions.
  ///
  /// In en, this message translates to:
  /// **'More actions'**
  String get moreActions;

  /// No description provided for @archiveConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Archive {title}?'**
  String archiveConfirmTitle(String title);

  /// No description provided for @archiveConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{It will be hidden but kept. You can restore it from the Archive.} =1{It and 1 item inside it will be hidden but kept. You can restore them from the Archive.} other{It and {count} items inside it will be hidden but kept. You can restore them from the Archive.}}'**
  String archiveConfirmBody(int count);

  /// No description provided for @trashConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Move {title} to Trash?'**
  String trashConfirmTitle(String title);

  /// No description provided for @trashConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{Items in Trash are deleted after 30 days.} =1{It and 1 item inside it go to Trash. Items in Trash are deleted after 30 days.} other{It and {count} items inside it go to Trash. Items in Trash are deleted after 30 days.}}'**
  String trashConfirmBody(int count);

  /// No description provided for @deleteForeverTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete {title} forever?'**
  String deleteForeverTitle(String title);

  /// No description provided for @deleteForeverBody.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{This can\'t be undone.} =1{It and 1 item inside it will be deleted. This can\'t be undone.} other{It and {count} items inside it will be deleted. This can\'t be undone.}}'**
  String deleteForeverBody(int count);

  /// No description provided for @emptyTrashTitle.
  ///
  /// In en, this message translates to:
  /// **'Empty Trash?'**
  String get emptyTrashTitle;

  /// No description provided for @emptyTrashBody.
  ///
  /// In en, this message translates to:
  /// **'Everything in Trash will be deleted forever. This can\'t be undone.'**
  String get emptyTrashBody;

  /// No description provided for @archivedItem.
  ///
  /// In en, this message translates to:
  /// **'Archived {title}'**
  String archivedItem(String title);

  /// No description provided for @trashedItem.
  ///
  /// In en, this message translates to:
  /// **'Moved {title} to Trash'**
  String trashedItem(String title);

  /// No description provided for @restoredItem.
  ///
  /// In en, this message translates to:
  /// **'Restored {title}'**
  String restoredItem(String title);

  /// No description provided for @restoredToTop.
  ///
  /// In en, this message translates to:
  /// **'Restored {title} to the top level (its old place is gone)'**
  String restoredToTop(String title);

  /// No description provided for @inArchive.
  ///
  /// In en, this message translates to:
  /// **'In the Archive'**
  String get inArchive;

  /// No description provided for @inTrash.
  ///
  /// In en, this message translates to:
  /// **'In Trash'**
  String get inTrash;

  /// No description provided for @inArchiveWith.
  ///
  /// In en, this message translates to:
  /// **'Archived with {title}'**
  String inArchiveWith(String title);

  /// No description provided for @inTrashWith.
  ///
  /// In en, this message translates to:
  /// **'In Trash with {title}'**
  String inTrashWith(String title);

  /// No description provided for @archiveView.
  ///
  /// In en, this message translates to:
  /// **'Archive'**
  String get archiveView;

  /// No description provided for @trashView.
  ///
  /// In en, this message translates to:
  /// **'Trash'**
  String get trashView;

  /// No description provided for @archiveEmpty.
  ///
  /// In en, this message translates to:
  /// **'Nothing archived.'**
  String get archiveEmpty;

  /// No description provided for @trashEmpty.
  ///
  /// In en, this message translates to:
  /// **'Trash is empty.'**
  String get trashEmpty;

  /// No description provided for @trashHint.
  ///
  /// In en, this message translates to:
  /// **'Items in Trash are deleted after 30 days.'**
  String get trashHint;

  /// No description provided for @groupOthers.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{and 1 item} other{and {count} items}}'**
  String groupOthers(int count);

  /// No description provided for @wasIn.
  ///
  /// In en, this message translates to:
  /// **'was in {title}'**
  String wasIn(String title);

  /// No description provided for @archivedOn.
  ///
  /// In en, this message translates to:
  /// **'Archived {date}'**
  String archivedOn(String date);

  /// No description provided for @trashedOn.
  ///
  /// In en, this message translates to:
  /// **'Deleted {date}'**
  String trashedOn(String date);

  /// No description provided for @daysLeft.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{deleted today} =1{1 day left} other{{count} days left}}'**
  String daysLeft(int count);

  /// No description provided for @viewPanels.
  ///
  /// In en, this message translates to:
  /// **'Panels'**
  String get viewPanels;

  /// No description provided for @viewChecklist.
  ///
  /// In en, this message translates to:
  /// **'Checklist'**
  String get viewChecklist;

  /// No description provided for @viewSteps.
  ///
  /// In en, this message translates to:
  /// **'Steps'**
  String get viewSteps;

  /// No description provided for @markNotDone.
  ///
  /// In en, this message translates to:
  /// **'Mark not done'**
  String get markNotDone;

  /// No description provided for @progressCount.
  ///
  /// In en, this message translates to:
  /// **'{done}/{total}'**
  String progressCount(int done, int total);

  /// No description provided for @mdBold.
  ///
  /// In en, this message translates to:
  /// **'Bold'**
  String get mdBold;

  /// No description provided for @mdItalic.
  ///
  /// In en, this message translates to:
  /// **'Italic'**
  String get mdItalic;

  /// No description provided for @mdHeading.
  ///
  /// In en, this message translates to:
  /// **'Heading'**
  String get mdHeading;

  /// No description provided for @mdBullets.
  ///
  /// In en, this message translates to:
  /// **'Bulleted list'**
  String get mdBullets;

  /// No description provided for @mdNumbers.
  ///
  /// In en, this message translates to:
  /// **'Numbered list'**
  String get mdNumbers;

  /// No description provided for @mdLink.
  ///
  /// In en, this message translates to:
  /// **'Link'**
  String get mdLink;

  /// No description provided for @mdCode.
  ///
  /// In en, this message translates to:
  /// **'Code'**
  String get mdCode;

  /// No description provided for @mdPreview.
  ///
  /// In en, this message translates to:
  /// **'Preview'**
  String get mdPreview;

  /// No description provided for @mdEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get mdEdit;

  /// No description provided for @mdNothingToPreview.
  ///
  /// In en, this message translates to:
  /// **'Nothing to preview yet.'**
  String get mdNothingToPreview;

  /// No description provided for @noteEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get noteEdit;

  /// No description provided for @noteSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get noteSave;

  /// No description provided for @noteEmpty.
  ///
  /// In en, this message translates to:
  /// **'Empty note. Click to write.'**
  String get noteEmpty;

  /// No description provided for @backTo.
  ///
  /// In en, this message translates to:
  /// **'Back to {title}'**
  String backTo(String title);

  /// No description provided for @cantMoveThere.
  ///
  /// In en, this message translates to:
  /// **'Can\'t move it there: it would end up inside itself.'**
  String get cantMoveThere;

  /// No description provided for @removeShortcut.
  ///
  /// In en, this message translates to:
  /// **'Remove shortcut'**
  String get removeShortcut;

  /// No description provided for @shortcutTooltip.
  ///
  /// In en, this message translates to:
  /// **'Shortcut: this item really lives elsewhere'**
  String get shortcutTooltip;

  /// No description provided for @alsoShowIn.
  ///
  /// In en, this message translates to:
  /// **'Also show in…'**
  String get alsoShowIn;

  /// No description provided for @removeShortcutFrom.
  ///
  /// In en, this message translates to:
  /// **'Remove shortcut from {title}'**
  String removeShortcutFrom(String title);

  /// No description provided for @topLevel.
  ///
  /// In en, this message translates to:
  /// **'Top level'**
  String get topLevel;

  /// No description provided for @alsoShownIn.
  ///
  /// In en, this message translates to:
  /// **'Also shown in {title}'**
  String alsoShownIn(String title);

  /// No description provided for @pickerTitle.
  ///
  /// In en, this message translates to:
  /// **'Also show {title} in…'**
  String pickerTitle(String title);

  /// No description provided for @pickerSearch.
  ///
  /// In en, this message translates to:
  /// **'Search items'**
  String get pickerSearch;

  /// No description provided for @pickerNoMatches.
  ///
  /// In en, this message translates to:
  /// **'No matching items.'**
  String get pickerNoMatches;

  /// No description provided for @viaShortcut.
  ///
  /// In en, this message translates to:
  /// **'via {title}'**
  String viaShortcut(String title);

  /// No description provided for @linkedNotesHeading.
  ///
  /// In en, this message translates to:
  /// **'From above'**
  String get linkedNotesHeading;

  /// No description provided for @linkFromAbove.
  ///
  /// In en, this message translates to:
  /// **'Link from above…'**
  String get linkFromAbove;

  /// No description provided for @linkPickerTitle.
  ///
  /// In en, this message translates to:
  /// **'Link from above'**
  String get linkPickerTitle;

  /// No description provided for @linkPickerEmpty.
  ///
  /// In en, this message translates to:
  /// **'The items above this one have no notes or files yet.'**
  String get linkPickerEmpty;

  /// No description provided for @linkGroupParent.
  ///
  /// In en, this message translates to:
  /// **'{title} (parent)'**
  String linkGroupParent(String title);

  /// No description provided for @linkGroupElsewhere.
  ///
  /// In en, this message translates to:
  /// **'Linked earlier, no longer above'**
  String get linkGroupElsewhere;

  /// No description provided for @linkedFrom.
  ///
  /// In en, this message translates to:
  /// **'from: {title}'**
  String linkedFrom(String title);

  /// No description provided for @linkedInto.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Linked into 1 item:} other{Linked into {count} items:}}'**
  String linkedInto(int count);

  /// No description provided for @unlink.
  ///
  /// In en, this message translates to:
  /// **'Unlink'**
  String get unlink;

  /// No description provided for @sourceArchived.
  ///
  /// In en, this message translates to:
  /// **'Source archived'**
  String get sourceArchived;

  /// No description provided for @sourceTrashed.
  ///
  /// In en, this message translates to:
  /// **'Source in Trash'**
  String get sourceTrashed;

  /// No description provided for @sourceDeleted.
  ///
  /// In en, this message translates to:
  /// **'Source deleted'**
  String get sourceDeleted;

  /// No description provided for @restoreSource.
  ///
  /// In en, this message translates to:
  /// **'Restore source'**
  String get restoreSource;

  /// No description provided for @clearLink.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clearLink;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @sharedFrom.
  ///
  /// In en, this message translates to:
  /// **'pinned by: {title}'**
  String sharedFrom(String title);

  /// No description provided for @sharedWithAll.
  ///
  /// In en, this message translates to:
  /// **'Shared with all sub-items'**
  String get sharedWithAll;

  /// No description provided for @shareWithAll.
  ///
  /// In en, this message translates to:
  /// **'Share with all sub-items'**
  String get shareWithAll;

  /// No description provided for @stopSharing.
  ///
  /// In en, this message translates to:
  /// **'Stop sharing with sub-items'**
  String get stopSharing;

  /// No description provided for @usedByElsewhere.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Used by 1 item elsewhere, which links its notes.} other{Used by {count} items elsewhere, which link its notes.}}'**
  String usedByElsewhere(int count);

  /// No description provided for @shortcutsElsewhere.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Its shortcut in 1 other place goes too.} other{Its shortcuts in {count} other places go too.}}'**
  String shortcutsElsewhere(int count);

  /// No description provided for @valuesView.
  ///
  /// In en, this message translates to:
  /// **'Values'**
  String get valuesView;

  /// No description provided for @valuesIntro.
  ///
  /// In en, this message translates to:
  /// **'What matters to you, and why. Tie values to goals and projects; everything inside them inherits the value.'**
  String get valuesIntro;

  /// No description provided for @valuesEmpty.
  ///
  /// In en, this message translates to:
  /// **'No values yet.'**
  String get valuesEmpty;

  /// No description provided for @valueNew.
  ///
  /// In en, this message translates to:
  /// **'New value…'**
  String get valueNew;

  /// No description provided for @valueEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit value'**
  String get valueEdit;

  /// No description provided for @valueDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete value'**
  String get valueDelete;

  /// No description provided for @valueDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete “{name}”?'**
  String valueDeleteTitle(String name);

  /// No description provided for @valueDeleteBody.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{It isn\'t tied to anything.} =1{It will be untied from 1 item.} other{It will be untied from {count} items.}}'**
  String valueDeleteBody(int count);

  /// No description provided for @valueName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get valueName;

  /// No description provided for @valueStatement.
  ///
  /// In en, this message translates to:
  /// **'Why it matters'**
  String get valueStatement;

  /// No description provided for @valueStatementHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. I want the energy to keep up with my kids.'**
  String get valueStatementHint;

  /// No description provided for @valueIcon.
  ///
  /// In en, this message translates to:
  /// **'Icon'**
  String get valueIcon;

  /// No description provided for @valueColor.
  ///
  /// In en, this message translates to:
  /// **'Color'**
  String get valueColor;

  /// No description provided for @valueAdd.
  ///
  /// In en, this message translates to:
  /// **'Value'**
  String get valueAdd;

  /// No description provided for @valueRemove.
  ///
  /// In en, this message translates to:
  /// **'Untie this value'**
  String get valueRemove;

  /// No description provided for @valueFrom.
  ///
  /// In en, this message translates to:
  /// **'{name} · from {title}'**
  String valueFrom(String name, String title);

  /// No description provided for @valueInherited.
  ///
  /// In en, this message translates to:
  /// **'Inherited from an item above. Open it to change.'**
  String get valueInherited;

  /// No description provided for @valueNothingTied.
  ///
  /// In en, this message translates to:
  /// **'Not tied to anything yet. Add it from an item\'s “+ Value”.'**
  String get valueNothingTied;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @tagAdd.
  ///
  /// In en, this message translates to:
  /// **'Tag'**
  String get tagAdd;

  /// No description provided for @tagRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove tag'**
  String get tagRemove;

  /// No description provided for @tagFromText.
  ///
  /// In en, this message translates to:
  /// **'From the text. Edit the text to remove it.'**
  String get tagFromText;

  /// No description provided for @tagSearch.
  ///
  /// In en, this message translates to:
  /// **'Search for this tag'**
  String get tagSearch;

  /// No description provided for @tagPickerTitle.
  ///
  /// In en, this message translates to:
  /// **'Tags'**
  String get tagPickerTitle;

  /// No description provided for @tagPickerHint.
  ///
  /// In en, this message translates to:
  /// **'Type a tag and press Enter'**
  String get tagPickerHint;

  /// No description provided for @tagsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No tags yet.'**
  String get tagsEmpty;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search  (#tag, value:, type:, in:)'**
  String get searchHint;

  /// No description provided for @searchFilters.
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get searchFilters;

  /// No description provided for @searchClear.
  ///
  /// In en, this message translates to:
  /// **'Clear search'**
  String get searchClear;

  /// No description provided for @searchNoResults.
  ///
  /// In en, this message translates to:
  /// **'Nothing found.'**
  String get searchNoResults;

  /// No description provided for @searchCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 result} other{{count} results}}'**
  String searchCount(int count);

  /// No description provided for @searchLinkedIn.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{linked in 1 place} other{linked in {count} places}}'**
  String searchLinkedIn(int count);

  /// No description provided for @searchArchived.
  ///
  /// In en, this message translates to:
  /// **'archived'**
  String get searchArchived;

  /// No description provided for @filterValue.
  ///
  /// In en, this message translates to:
  /// **'Value'**
  String get filterValue;

  /// No description provided for @filterTag.
  ///
  /// In en, this message translates to:
  /// **'Tag'**
  String get filterTag;

  /// No description provided for @filterIncludeChildren.
  ///
  /// In en, this message translates to:
  /// **'Include items under tagged ones'**
  String get filterIncludeChildren;

  /// No description provided for @filterType.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get filterType;

  /// No description provided for @filterStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get filterStatus;

  /// No description provided for @filterProject.
  ///
  /// In en, this message translates to:
  /// **'Project'**
  String get filterProject;

  /// No description provided for @filterAnyProject.
  ///
  /// In en, this message translates to:
  /// **'Anywhere'**
  String get filterAnyProject;

  /// No description provided for @filterDue.
  ///
  /// In en, this message translates to:
  /// **'Due'**
  String get filterDue;

  /// No description provided for @filterDueRange.
  ///
  /// In en, this message translates to:
  /// **'{from} – {to}'**
  String filterDueRange(String from, String to);

  /// No description provided for @filterArchived.
  ///
  /// In en, this message translates to:
  /// **'Include archived'**
  String get filterArchived;

  /// No description provided for @zoomIn.
  ///
  /// In en, this message translates to:
  /// **'Zoom in'**
  String get zoomIn;

  /// No description provided for @zoomTreeHere.
  ///
  /// In en, this message translates to:
  /// **'Zoom tree here'**
  String get zoomTreeHere;

  /// No description provided for @zoomOut.
  ///
  /// In en, this message translates to:
  /// **'Zoom out one level'**
  String get zoomOut;

  /// No description provided for @zoomReset.
  ///
  /// In en, this message translates to:
  /// **'Show the whole tree'**
  String get zoomReset;

  /// No description provided for @breadcrumbsShowAll.
  ///
  /// In en, this message translates to:
  /// **'Show the full path'**
  String get breadcrumbsShowAll;

  /// No description provided for @peekOpen.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get peekOpen;

  /// No description provided for @peekPin.
  ///
  /// In en, this message translates to:
  /// **'Pin beside'**
  String get peekPin;

  /// No description provided for @peekUnpin.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get peekUnpin;

  /// No description provided for @peekItems.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 item} other{{count} items}}'**
  String peekItems(int count);

  /// No description provided for @tagsView.
  ///
  /// In en, this message translates to:
  /// **'Tags'**
  String get tagsView;

  /// No description provided for @tagsIntro.
  ///
  /// In en, this message translates to:
  /// **'Star the tags you use most, such as #work or #home: they become one-tap choices when tagging an item. Click a count to see those items.'**
  String get tagsIntro;

  /// No description provided for @tagsFavorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get tagsFavorites;

  /// No description provided for @tagsOthers.
  ///
  /// In en, this message translates to:
  /// **'Other tags'**
  String get tagsOthers;

  /// No description provided for @tagsAll.
  ///
  /// In en, this message translates to:
  /// **'All tags'**
  String get tagsAll;

  /// No description provided for @tagNew.
  ///
  /// In en, this message translates to:
  /// **'Create tag'**
  String get tagNew;

  /// No description provided for @tagNewHint.
  ///
  /// In en, this message translates to:
  /// **'New tag, then Enter'**
  String get tagNewHint;

  /// No description provided for @tagNameInvalid.
  ///
  /// In en, this message translates to:
  /// **'Start with a letter; use letters, numbers, - and _.'**
  String get tagNameInvalid;

  /// No description provided for @tagFavorite.
  ///
  /// In en, this message translates to:
  /// **'Add to favorites'**
  String get tagFavorite;

  /// No description provided for @tagUnfavorite.
  ///
  /// In en, this message translates to:
  /// **'Remove from favorites'**
  String get tagUnfavorite;

  /// No description provided for @tagColor.
  ///
  /// In en, this message translates to:
  /// **'Colour'**
  String get tagColor;

  /// No description provided for @tagNoColor.
  ///
  /// In en, this message translates to:
  /// **'No colour'**
  String get tagNoColor;

  /// No description provided for @tagUses.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{Not used} =1{1 item} other{{count} items}}'**
  String tagUses(int count);

  /// No description provided for @tagRename.
  ///
  /// In en, this message translates to:
  /// **'Rename'**
  String get tagRename;

  /// No description provided for @tagMerge.
  ///
  /// In en, this message translates to:
  /// **'Merge'**
  String get tagMerge;

  /// No description provided for @tagRenameTitle.
  ///
  /// In en, this message translates to:
  /// **'Rename #{name}'**
  String tagRenameTitle(String name);

  /// No description provided for @tagRenameNote.
  ///
  /// In en, this message translates to:
  /// **'Where it is written in a title or text, that is rewritten too.'**
  String get tagRenameNote;

  /// No description provided for @tagMergeNote.
  ///
  /// In en, this message translates to:
  /// **'#{from} will be merged into #{into}: every item with #{from} gets #{into}, and the text is rewritten.'**
  String tagMergeNote(String from, String into);

  /// No description provided for @tagDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete tag'**
  String get tagDelete;

  /// No description provided for @tagDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete #{name}?'**
  String tagDeleteTitle(String name);

  /// No description provided for @tagDeleteBody.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{It isn\'t on any item.} =1{It will be removed from 1 item.} other{It will be removed from {count} items.}} Where it is written in text, the # is removed so it stays plain text.'**
  String tagDeleteBody(int count);

  /// No description provided for @tagPickerOnItem.
  ///
  /// In en, this message translates to:
  /// **'On this item'**
  String get tagPickerOnItem;

  /// No description provided for @filesHeading.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{Files} other{Files ({count})}}'**
  String filesHeading(int count);

  /// No description provided for @fileAdd.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get fileAdd;

  /// No description provided for @fileChoose.
  ///
  /// In en, this message translates to:
  /// **'Choose files…'**
  String get fileChoose;

  /// No description provided for @fileTakePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take photo'**
  String get fileTakePhoto;

  /// No description provided for @filePasteImage.
  ///
  /// In en, this message translates to:
  /// **'Paste image'**
  String get filePasteImage;

  /// No description provided for @fileNoImageToPaste.
  ///
  /// In en, this message translates to:
  /// **'There\'s no image on the clipboard.'**
  String get fileNoImageToPaste;

  /// No description provided for @filesEmpty.
  ///
  /// In en, this message translates to:
  /// **'No files yet.'**
  String get filesEmpty;

  /// No description provided for @filesEmptyDesktop.
  ///
  /// In en, this message translates to:
  /// **'No files yet. Drop files on this item, or paste a screenshot with Ctrl+V.'**
  String get filesEmptyDesktop;

  /// No description provided for @fileDropHere.
  ///
  /// In en, this message translates to:
  /// **'Drop to attach'**
  String get fileDropHere;

  /// No description provided for @fileTooBigTitle.
  ///
  /// In en, this message translates to:
  /// **'Large file'**
  String get fileTooBigTitle;

  /// No description provided for @fileTooBigBody.
  ///
  /// In en, this message translates to:
  /// **'{name} is {size}. Files over 20 MB fill up your devices quickly. Attach it anyway?'**
  String fileTooBigBody(String name, String size);

  /// No description provided for @fileSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get fileSkip;

  /// No description provided for @fileAttachAnyway.
  ///
  /// In en, this message translates to:
  /// **'Attach anyway'**
  String get fileAttachAnyway;

  /// No description provided for @fileAttached.
  ///
  /// In en, this message translates to:
  /// **'Attached {name}'**
  String fileAttached(String name);

  /// No description provided for @filesAttached.
  ///
  /// In en, this message translates to:
  /// **'Attached {count} files'**
  String filesAttached(int count);

  /// No description provided for @fileNoApp.
  ///
  /// In en, this message translates to:
  /// **'No app on this device can open this file.'**
  String get fileNoApp;

  /// No description provided for @fileOpenIn.
  ///
  /// In en, this message translates to:
  /// **'Open in…'**
  String get fileOpenIn;

  /// No description provided for @fileOpenInNote.
  ///
  /// In en, this message translates to:
  /// **'Opens a copy in your default app. Changes made there aren\'t saved here; use Replace file to bring in a new version.'**
  String get fileOpenInNote;

  /// No description provided for @fileReplace.
  ///
  /// In en, this message translates to:
  /// **'Replace file…'**
  String get fileReplace;

  /// No description provided for @fileExportMarkup.
  ///
  /// In en, this message translates to:
  /// **'Export with markup…'**
  String get fileExportMarkup;

  /// No description provided for @fileRename.
  ///
  /// In en, this message translates to:
  /// **'Rename'**
  String get fileRename;

  /// No description provided for @fileRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove file'**
  String get fileRemove;

  /// No description provided for @fileRemoved.
  ///
  /// In en, this message translates to:
  /// **'Removed {name}'**
  String fileRemoved(String name);

  /// No description provided for @fileSaved.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get fileSaved;

  /// No description provided for @fileOwnedBy.
  ///
  /// In en, this message translates to:
  /// **'from {title}'**
  String fileOwnedBy(String title);

  /// No description provided for @markup.
  ///
  /// In en, this message translates to:
  /// **'Mark up'**
  String get markup;

  /// No description provided for @markupDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get markupDone;

  /// No description provided for @markupShow.
  ///
  /// In en, this message translates to:
  /// **'Show markup'**
  String get markupShow;

  /// No description provided for @markupHide.
  ///
  /// In en, this message translates to:
  /// **'Hide markup'**
  String get markupHide;

  /// No description provided for @markupPen.
  ///
  /// In en, this message translates to:
  /// **'Pen'**
  String get markupPen;

  /// No description provided for @markupHighlighter.
  ///
  /// In en, this message translates to:
  /// **'Highlighter'**
  String get markupHighlighter;

  /// No description provided for @markupText.
  ///
  /// In en, this message translates to:
  /// **'Text label'**
  String get markupText;

  /// No description provided for @markupEraser.
  ///
  /// In en, this message translates to:
  /// **'Eraser'**
  String get markupEraser;

  /// No description provided for @markupUndo.
  ///
  /// In en, this message translates to:
  /// **'Undo last mark'**
  String get markupUndo;

  /// No description provided for @markupLabelTitle.
  ///
  /// In en, this message translates to:
  /// **'Label'**
  String get markupLabelTitle;

  /// No description provided for @markupHighlight.
  ///
  /// In en, this message translates to:
  /// **'Highlight'**
  String get markupHighlight;

  /// No description provided for @markupClear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get markupClear;

  /// No description provided for @markupSelectHint.
  ///
  /// In en, this message translates to:
  /// **'Select text, then Highlight.'**
  String get markupSelectHint;

  /// No description provided for @linkedFilesHeading.
  ///
  /// In en, this message translates to:
  /// **'Files'**
  String get linkedFilesHeading;

  /// No description provided for @searchFile.
  ///
  /// In en, this message translates to:
  /// **'file'**
  String get searchFile;

  /// No description provided for @filterHasFiles.
  ///
  /// In en, this message translates to:
  /// **'Has files'**
  String get filterHasFiles;

  /// No description provided for @fileTooBigToShow.
  ///
  /// In en, this message translates to:
  /// **'This file is too big to show here. Use Open in… to read it.'**
  String get fileTooBigToShow;

  /// No description provided for @calendarView.
  ///
  /// In en, this message translates to:
  /// **'Calendar'**
  String get calendarView;

  /// No description provided for @calendarDay.
  ///
  /// In en, this message translates to:
  /// **'Day'**
  String get calendarDay;

  /// No description provided for @calendarWeek.
  ///
  /// In en, this message translates to:
  /// **'Week'**
  String get calendarWeek;

  /// No description provided for @calendarMonth.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get calendarMonth;

  /// No description provided for @calendarToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get calendarToday;

  /// No description provided for @calendarPrevious.
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get calendarPrevious;

  /// No description provided for @calendarNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get calendarNext;

  /// No description provided for @calendarMore.
  ///
  /// In en, this message translates to:
  /// **'+{count} more'**
  String calendarMore(int count);

  /// No description provided for @icsExport.
  ///
  /// In en, this message translates to:
  /// **'Export calendar (.ics)…'**
  String get icsExport;

  /// No description provided for @icsExportItem.
  ///
  /// In en, this message translates to:
  /// **'Export to calendar (.ics)…'**
  String get icsExportItem;

  /// No description provided for @icsNoneChosen.
  ///
  /// In en, this message translates to:
  /// **'No items are chosen for export yet. In an item\'s date & time, turn on \"Include in calendar export\".'**
  String get icsNoneChosen;

  /// No description provided for @icsInclude.
  ///
  /// In en, this message translates to:
  /// **'Include in calendar export'**
  String get icsInclude;

  /// No description provided for @icsIncludeHelp.
  ///
  /// In en, this message translates to:
  /// **'Adds it to the .ics file from Calendar → Export, for Google, Outlook or Apple calendars.'**
  String get icsIncludeHelp;

  /// No description provided for @remindMe.
  ///
  /// In en, this message translates to:
  /// **'Remind me'**
  String get remindMe;

  /// No description provided for @remindAtTime.
  ///
  /// In en, this message translates to:
  /// **'At the time'**
  String get remindAtTime;

  /// No description provided for @remindMinutesBefore.
  ///
  /// In en, this message translates to:
  /// **'{count} min before'**
  String remindMinutesBefore(int count);

  /// No description provided for @remindHoursBefore.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 hour before} other{{count} hours before}}'**
  String remindHoursBefore(int count);

  /// No description provided for @remindDaysBefore.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 day before} other{{count} days before}}'**
  String remindDaysBefore(int count);

  /// No description provided for @remindOnDay.
  ///
  /// In en, this message translates to:
  /// **'On the day, 09:00'**
  String get remindOnDay;

  /// No description provided for @remindDayBefore.
  ///
  /// In en, this message translates to:
  /// **'Day before, 09:00'**
  String get remindDayBefore;

  /// No description provided for @calendarEvents.
  ///
  /// In en, this message translates to:
  /// **'Events'**
  String get calendarEvents;

  /// No description provided for @calendarDeadlines.
  ///
  /// In en, this message translates to:
  /// **'Deadlines'**
  String get calendarDeadlines;

  /// No description provided for @calendarRepeats.
  ///
  /// In en, this message translates to:
  /// **'Repeats'**
  String get calendarRepeats;

  /// No description provided for @calendarHideDone.
  ///
  /// In en, this message translates to:
  /// **'Hide done'**
  String get calendarHideDone;

  /// No description provided for @calendarUnderItem.
  ///
  /// In en, this message translates to:
  /// **'Only {title}'**
  String calendarUnderItem(String title);

  /// No description provided for @calendarClearFilters.
  ///
  /// In en, this message translates to:
  /// **'Clear filters'**
  String get calendarClearFilters;

  /// No description provided for @calendarAdded.
  ///
  /// In en, this message translates to:
  /// **'Added {title}'**
  String calendarAdded(String title);

  /// No description provided for @calendarQuickAdd.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get calendarQuickAdd;

  /// No description provided for @calendarQuickAddDue.
  ///
  /// In en, this message translates to:
  /// **'New item · due {day}'**
  String calendarQuickAddDue(String day);

  /// No description provided for @calendarQuickAddAt.
  ///
  /// In en, this message translates to:
  /// **'New event · {day} · {start}–{end}'**
  String calendarQuickAddAt(String day, String start, String end);

  /// No description provided for @calendarCloseDay.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get calendarCloseDay;

  /// No description provided for @calendarDayCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{Nothing on this day.} =1{1 entry} other{{count} entries}}'**
  String calendarDayCount(int count);

  /// No description provided for @calendarAllDay.
  ///
  /// In en, this message translates to:
  /// **'All day'**
  String get calendarAllDay;

  /// No description provided for @calendarDeadline.
  ///
  /// In en, this message translates to:
  /// **'Deadline'**
  String get calendarDeadline;

  /// No description provided for @calendarRepeat.
  ///
  /// In en, this message translates to:
  /// **'Repeat'**
  String get calendarRepeat;

  /// No description provided for @calendarEvent.
  ///
  /// In en, this message translates to:
  /// **'Event'**
  String get calendarEvent;

  /// No description provided for @calendarAddOnDay.
  ///
  /// In en, this message translates to:
  /// **'Add on this day…'**
  String get calendarAddOnDay;

  /// No description provided for @calendarListDay.
  ///
  /// In en, this message translates to:
  /// **'Show everything on this day'**
  String get calendarListDay;

  /// No description provided for @showInCalendar.
  ///
  /// In en, this message translates to:
  /// **'Show in calendar'**
  String get showInCalendar;

  /// No description provided for @timerStart.
  ///
  /// In en, this message translates to:
  /// **'Start timer'**
  String get timerStart;

  /// No description provided for @timerStartMenu.
  ///
  /// In en, this message translates to:
  /// **'Timer or focus'**
  String get timerStartMenu;

  /// No description provided for @timerStop.
  ///
  /// In en, this message translates to:
  /// **'Stop timer'**
  String get timerStop;

  /// No description provided for @timerPause.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get timerPause;

  /// No description provided for @timerResume.
  ///
  /// In en, this message translates to:
  /// **'Resume'**
  String get timerResume;

  /// No description provided for @timerPaused.
  ///
  /// In en, this message translates to:
  /// **'Paused · {title}'**
  String timerPaused(String title);

  /// No description provided for @timerNow.
  ///
  /// In en, this message translates to:
  /// **'now'**
  String get timerNow;

  /// No description provided for @timerMiniWindow.
  ///
  /// In en, this message translates to:
  /// **'Mini window (stays on top)'**
  String get timerMiniWindow;

  /// No description provided for @timerExpand.
  ///
  /// In en, this message translates to:
  /// **'Back to the full window'**
  String get timerExpand;

  /// No description provided for @focusFor.
  ///
  /// In en, this message translates to:
  /// **'Focus for {length}'**
  String focusFor(String length);

  /// No description provided for @focusForEstimate.
  ///
  /// In en, this message translates to:
  /// **'Focus for the estimate ({length})'**
  String focusForEstimate(String length);

  /// No description provided for @focusLeft.
  ///
  /// In en, this message translates to:
  /// **'{title} · {left} left'**
  String focusLeft(String title, String left);

  /// No description provided for @focusOver.
  ///
  /// In en, this message translates to:
  /// **'{title} · {elapsed} (focus time is up)'**
  String focusOver(String title, String elapsed);

  /// No description provided for @focusEndedTitle.
  ///
  /// In en, this message translates to:
  /// **'Focus time is up'**
  String get focusEndedTitle;

  /// No description provided for @focusEndedBody.
  ///
  /// In en, this message translates to:
  /// **'How did {title} go?'**
  String focusEndedBody(String title);

  /// No description provided for @focusKeepGoing.
  ///
  /// In en, this message translates to:
  /// **'Keep going'**
  String get focusKeepGoing;

  /// No description provided for @focusDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get focusDone;

  /// No description provided for @focusBreak.
  ///
  /// In en, this message translates to:
  /// **'Take a break'**
  String get focusBreak;

  /// No description provided for @breakLeft.
  ///
  /// In en, this message translates to:
  /// **'Break · {left} left'**
  String breakLeft(String left);

  /// No description provided for @breakOver.
  ///
  /// In en, this message translates to:
  /// **'Break\'s over'**
  String get breakOver;

  /// No description provided for @breakEnd.
  ///
  /// In en, this message translates to:
  /// **'End break'**
  String get breakEnd;

  /// No description provided for @estimateAdd.
  ///
  /// In en, this message translates to:
  /// **'Estimate'**
  String get estimateAdd;

  /// No description provided for @estimateIs.
  ///
  /// In en, this message translates to:
  /// **'Est. {length}'**
  String estimateIs(String length);

  /// No description provided for @estimateTitle.
  ///
  /// In en, this message translates to:
  /// **'Estimate'**
  String get estimateTitle;

  /// No description provided for @estimateMinutes.
  ///
  /// In en, this message translates to:
  /// **'Or minutes'**
  String get estimateMinutes;

  /// No description provided for @trackedNone.
  ///
  /// In en, this message translates to:
  /// **'Track time'**
  String get trackedNone;

  /// No description provided for @trackedIs.
  ///
  /// In en, this message translates to:
  /// **'{tracked} tracked'**
  String trackedIs(String tracked);

  /// No description provided for @trackedOf.
  ///
  /// In en, this message translates to:
  /// **'{tracked} of {estimate}'**
  String trackedOf(String tracked, String estimate);

  /// No description provided for @trackedTooltip.
  ///
  /// In en, this message translates to:
  /// **'Time entries: add, edit or delete'**
  String get trackedTooltip;

  /// No description provided for @rollupItems.
  ///
  /// In en, this message translates to:
  /// **'Items: {tracked} of {estimate}'**
  String rollupItems(String tracked, String estimate);

  /// No description provided for @timeEntriesTitle.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get timeEntriesTitle;

  /// No description provided for @timeEntriesEmpty.
  ///
  /// In en, this message translates to:
  /// **'No time tracked yet. Start a timer with ▶, or add time.'**
  String get timeEntriesEmpty;

  /// No description provided for @timeAdd.
  ///
  /// In en, this message translates to:
  /// **'Add time…'**
  String get timeAdd;

  /// No description provided for @timeEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit time'**
  String get timeEdit;

  /// No description provided for @timeDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get timeDelete;

  /// No description provided for @timeLength.
  ///
  /// In en, this message translates to:
  /// **'Length'**
  String get timeLength;

  /// No description provided for @timeNote.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get timeNote;

  /// No description provided for @timePersonal.
  ///
  /// In en, this message translates to:
  /// **'Only you see your time.'**
  String get timePersonal;

  /// No description provided for @progressItems.
  ///
  /// In en, this message translates to:
  /// **'{done}/{total} · {percent}%'**
  String progressItems(int done, int total, int percent);

  /// No description provided for @progressManual.
  ///
  /// In en, this message translates to:
  /// **'{percent}% (set by hand)'**
  String progressManual(int percent);

  /// No description provided for @progressSet.
  ///
  /// In en, this message translates to:
  /// **'Set progress manually…'**
  String get progressSet;

  /// No description provided for @progressSetTitle.
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get progressSetTitle;

  /// No description provided for @progressUseItems.
  ///
  /// In en, this message translates to:
  /// **'Count items again'**
  String get progressUseItems;

  /// No description provided for @reviewView.
  ///
  /// In en, this message translates to:
  /// **'Review'**
  String get reviewView;

  /// No description provided for @reviewCustom.
  ///
  /// In en, this message translates to:
  /// **'Dates…'**
  String get reviewCustom;

  /// No description provided for @reviewThis.
  ///
  /// In en, this message translates to:
  /// **'This one'**
  String get reviewThis;

  /// No description provided for @reviewCopy.
  ///
  /// In en, this message translates to:
  /// **'Copy as Markdown'**
  String get reviewCopy;

  /// No description provided for @reviewCopied.
  ///
  /// In en, this message translates to:
  /// **'Copied'**
  String get reviewCopied;

  /// No description provided for @reviewExport.
  ///
  /// In en, this message translates to:
  /// **'Export (.md)…'**
  String get reviewExport;

  /// No description provided for @reviewTitleFor.
  ///
  /// In en, this message translates to:
  /// **'Review: {range}'**
  String reviewTitleFor(String range);

  /// No description provided for @reviewCompleted.
  ///
  /// In en, this message translates to:
  /// **'completed'**
  String get reviewCompleted;

  /// No description provided for @reviewCreated.
  ///
  /// In en, this message translates to:
  /// **'created'**
  String get reviewCreated;

  /// No description provided for @reviewTracked.
  ///
  /// In en, this message translates to:
  /// **'tracked'**
  String get reviewTracked;

  /// No description provided for @reviewOverdue.
  ///
  /// In en, this message translates to:
  /// **'overdue'**
  String get reviewOverdue;

  /// No description provided for @reviewEmpty.
  ///
  /// In en, this message translates to:
  /// **'Nothing done, tracked or created in these dates yet.'**
  String get reviewEmpty;

  /// No description provided for @reviewCompletedByProject.
  ///
  /// In en, this message translates to:
  /// **'Completed, by project'**
  String get reviewCompletedByProject;

  /// No description provided for @reviewCompletedByValue.
  ///
  /// In en, this message translates to:
  /// **'Completed, by value'**
  String get reviewCompletedByValue;

  /// No description provided for @reviewTimeByProject.
  ///
  /// In en, this message translates to:
  /// **'Time by project'**
  String get reviewTimeByProject;

  /// No description provided for @reviewTimeByValue.
  ///
  /// In en, this message translates to:
  /// **'Time by value'**
  String get reviewTimeByValue;

  /// No description provided for @reviewTimeByTag.
  ///
  /// In en, this message translates to:
  /// **'Time by tag'**
  String get reviewTimeByTag;

  /// No description provided for @reviewRoutines.
  ///
  /// In en, this message translates to:
  /// **'Routines'**
  String get reviewRoutines;

  /// No description provided for @reviewOverdueTitle.
  ///
  /// In en, this message translates to:
  /// **'Overdue'**
  String get reviewOverdueTitle;

  /// No description provided for @reviewDue.
  ///
  /// In en, this message translates to:
  /// **'Due {date}'**
  String reviewDue(String date);

  /// No description provided for @todayView.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get todayView;

  /// No description provided for @treeView.
  ///
  /// In en, this message translates to:
  /// **'Tree'**
  String get treeView;

  /// No description provided for @todayDoneCount.
  ///
  /// In en, this message translates to:
  /// **'{done} of {total} done'**
  String todayDoneCount(int done, int total);

  /// No description provided for @todayEmpty.
  ///
  /// In en, this message translates to:
  /// **'Nothing on today yet. Add an item with ⋮ → Add to Today, or try Pick one for me.'**
  String get todayEmpty;

  /// No description provided for @todayPickOne.
  ///
  /// In en, this message translates to:
  /// **'Pick one for me'**
  String get todayPickOne;

  /// No description provided for @todayPickAnother.
  ///
  /// In en, this message translates to:
  /// **'Another'**
  String get todayPickAnother;

  /// No description provided for @todayPickNone.
  ///
  /// In en, this message translates to:
  /// **'Nothing open matches. Try fewer filters.'**
  String get todayPickNone;

  /// No description provided for @todayAdd.
  ///
  /// In en, this message translates to:
  /// **'Add to Today'**
  String get todayAdd;

  /// No description provided for @todayAddItem.
  ///
  /// In en, this message translates to:
  /// **'Add to Today'**
  String get todayAddItem;

  /// No description provided for @todayRemoveItem.
  ///
  /// In en, this message translates to:
  /// **'Remove from Today'**
  String get todayRemoveItem;

  /// No description provided for @todayRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove from today'**
  String get todayRemove;

  /// No description provided for @todayRemoved.
  ///
  /// In en, this message translates to:
  /// **'Removed {title} from today'**
  String todayRemoved(String title);

  /// No description provided for @todayOverdue.
  ///
  /// In en, this message translates to:
  /// **'{days, plural, =1{Overdue · 1 day} other{Overdue · {days} days}}'**
  String todayOverdue(int days);

  /// No description provided for @todayDue.
  ///
  /// In en, this message translates to:
  /// **'Due today'**
  String get todayDue;

  /// No description provided for @todayAt.
  ///
  /// In en, this message translates to:
  /// **'At {time}'**
  String todayAt(String time);

  /// No description provided for @todayPicked.
  ///
  /// In en, this message translates to:
  /// **'Added by you'**
  String get todayPicked;

  /// No description provided for @todayLeftOver.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 item you added on an earlier day isn\'t done} other{{count} items you added on earlier days aren\'t done}}'**
  String todayLeftOver(int count);

  /// No description provided for @todayKeep.
  ///
  /// In en, this message translates to:
  /// **'Keep on today'**
  String get todayKeep;

  /// No description provided for @todayDrop.
  ///
  /// In en, this message translates to:
  /// **'Drop'**
  String get todayDrop;

  /// No description provided for @todaySettings.
  ///
  /// In en, this message translates to:
  /// **'What Today adds by itself'**
  String get todaySettings;

  /// No description provided for @todayAutoTitle.
  ///
  /// In en, this message translates to:
  /// **'Add by itself:'**
  String get todayAutoTitle;

  /// No description provided for @todayAutoRoutines.
  ///
  /// In en, this message translates to:
  /// **'Routines due today'**
  String get todayAutoRoutines;

  /// No description provided for @todayAutoDue.
  ///
  /// In en, this message translates to:
  /// **'Due today'**
  String get todayAutoDue;

  /// No description provided for @todayAutoOverdue.
  ///
  /// In en, this message translates to:
  /// **'Overdue'**
  String get todayAutoOverdue;

  /// No description provided for @todayAutoEvents.
  ///
  /// In en, this message translates to:
  /// **'Events today'**
  String get todayAutoEvents;

  /// No description provided for @todayAutoActive.
  ///
  /// In en, this message translates to:
  /// **'In progress (Active)'**
  String get todayAutoActive;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
