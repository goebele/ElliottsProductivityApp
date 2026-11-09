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

  /// Toggle that shows an item's children as a checklist
  ///
  /// In en, this message translates to:
  /// **'Show as list'**
  String get showAsList;

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

  /// Button that shows or hides an item's notes column
  ///
  /// In en, this message translates to:
  /// **'Notes ({count})'**
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
