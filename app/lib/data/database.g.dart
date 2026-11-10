// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $NodesTable extends Nodes with TableInfo<$NodesTable, Node> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NodesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _spaceIdMeta = const VerificationMeta(
    'spaceId',
  );
  @override
  late final GeneratedColumn<String> spaceId = GeneratedColumn<String>(
    'space_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdByMeta = const VerificationMeta(
    'createdBy',
  );
  @override
  late final GeneratedColumn<String> createdBy = GeneratedColumn<String>(
    'created_by',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedByMeta = const VerificationMeta(
    'updatedBy',
  );
  @override
  late final GeneratedColumn<String> updatedBy = GeneratedColumn<String>(
    'updated_by',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _hlcMeta = const VerificationMeta('hlc');
  @override
  late final GeneratedColumn<String> hlc = GeneratedColumn<String>(
    'hlc',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedMeta = const VerificationMeta(
    'deleted',
  );
  @override
  late final GeneratedColumn<bool> deleted = GeneratedColumn<bool>(
    'deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _parentIdMeta = const VerificationMeta(
    'parentId',
  );
  @override
  late final GeneratedColumn<String> parentId = GeneratedColumn<String>(
    'parent_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sortKeyMeta = const VerificationMeta(
    'sortKey',
  );
  @override
  late final GeneratedColumn<String> sortKey = GeneratedColumn<String>(
    'sort_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<NodeType, String> type =
      GeneratedColumn<String>(
        'type',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<NodeType>($NodesTable.$convertertype);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bodyMdMeta = const VerificationMeta('bodyMd');
  @override
  late final GeneratedColumn<String> bodyMd = GeneratedColumn<String>(
    'body_md',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _bodyFormatMeta = const VerificationMeta(
    'bodyFormat',
  );
  @override
  late final GeneratedColumn<String> bodyFormat = GeneratedColumn<String>(
    'body_format',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('md_lww'),
  );
  @override
  late final GeneratedColumnWithTypeConverter<ChildView?, String> childView =
      GeneratedColumn<String>(
        'child_view',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<ChildView?>($NodesTable.$converterchildViewn);
  @override
  late final GeneratedColumnWithTypeConverter<NodeStatus, String> status =
      GeneratedColumn<String>(
        'status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: Constant(NodeStatus.open.name),
      ).withConverter<NodeStatus>($NodesTable.$converterstatus);
  static const VerificationMeta _completedByMeta = const VerificationMeta(
    'completedBy',
  );
  @override
  late final GeneratedColumn<String> completedBy = GeneratedColumn<String>(
    'completed_by',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _completedAtMeta = const VerificationMeta(
    'completedAt',
  );
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
    'completed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _priorityMeta = const VerificationMeta(
    'priority',
  );
  @override
  late final GeneratedColumn<int> priority = GeneratedColumn<int>(
    'priority',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _estimateMinutesMeta = const VerificationMeta(
    'estimateMinutes',
  );
  @override
  late final GeneratedColumn<int> estimateMinutes = GeneratedColumn<int>(
    'estimate_minutes',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _startAtMeta = const VerificationMeta(
    'startAt',
  );
  @override
  late final GeneratedColumn<DateTime> startAt = GeneratedColumn<DateTime>(
    'start_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _endAtMeta = const VerificationMeta('endAt');
  @override
  late final GeneratedColumn<DateTime> endAt = GeneratedColumn<DateTime>(
    'end_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _timeZoneMeta = const VerificationMeta(
    'timeZone',
  );
  @override
  late final GeneratedColumn<String> timeZone = GeneratedColumn<String>(
    'time_zone',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dueAtMeta = const VerificationMeta('dueAt');
  @override
  late final GeneratedColumn<DateTime> dueAt = GeneratedColumn<DateTime>(
    'due_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dueDateMeta = const VerificationMeta(
    'dueDate',
  );
  @override
  late final GeneratedColumn<String> dueDate = GeneratedColumn<String>(
    'due_date',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _rruleMeta = const VerificationMeta('rrule');
  @override
  late final GeneratedColumn<String> rrule = GeneratedColumn<String>(
    'rrule',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _repeatStartMeta = const VerificationMeta(
    'repeatStart',
  );
  @override
  late final GeneratedColumn<String> repeatStart = GeneratedColumn<String>(
    'repeat_start',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _exclusiveChildrenMeta = const VerificationMeta(
    'exclusiveChildren',
  );
  @override
  late final GeneratedColumn<bool> exclusiveChildren = GeneratedColumn<bool>(
    'exclusive_children',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("exclusive_children" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _sharedWithChildrenMeta =
      const VerificationMeta('sharedWithChildren');
  @override
  late final GeneratedColumn<bool> sharedWithChildren = GeneratedColumn<bool>(
    'shared_with_children',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("shared_with_children" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  late final GeneratedColumnWithTypeConverter<Lifecycle, String> lifecycle =
      GeneratedColumn<String>(
        'lifecycle',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: Constant(Lifecycle.live.name),
      ).withConverter<Lifecycle>($NodesTable.$converterlifecycle);
  static const VerificationMeta _lifecycleAtMeta = const VerificationMeta(
    'lifecycleAt',
  );
  @override
  late final GeneratedColumn<DateTime> lifecycleAt = GeneratedColumn<DateTime>(
    'lifecycle_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lifecycleRootIdMeta = const VerificationMeta(
    'lifecycleRootId',
  );
  @override
  late final GeneratedColumn<String> lifecycleRootId = GeneratedColumn<String>(
    'lifecycle_root_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    spaceId,
    createdAt,
    createdBy,
    updatedBy,
    hlc,
    deleted,
    parentId,
    sortKey,
    type,
    title,
    bodyMd,
    bodyFormat,
    childView,
    status,
    completedBy,
    completedAt,
    priority,
    estimateMinutes,
    startAt,
    endAt,
    timeZone,
    dueAt,
    dueDate,
    rrule,
    repeatStart,
    exclusiveChildren,
    sharedWithChildren,
    lifecycle,
    lifecycleAt,
    lifecycleRootId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'nodes';
  @override
  VerificationContext validateIntegrity(
    Insertable<Node> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('space_id')) {
      context.handle(
        _spaceIdMeta,
        spaceId.isAcceptableOrUnknown(data['space_id']!, _spaceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_spaceIdMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('created_by')) {
      context.handle(
        _createdByMeta,
        createdBy.isAcceptableOrUnknown(data['created_by']!, _createdByMeta),
      );
    } else if (isInserting) {
      context.missing(_createdByMeta);
    }
    if (data.containsKey('updated_by')) {
      context.handle(
        _updatedByMeta,
        updatedBy.isAcceptableOrUnknown(data['updated_by']!, _updatedByMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedByMeta);
    }
    if (data.containsKey('hlc')) {
      context.handle(
        _hlcMeta,
        hlc.isAcceptableOrUnknown(data['hlc']!, _hlcMeta),
      );
    } else if (isInserting) {
      context.missing(_hlcMeta);
    }
    if (data.containsKey('deleted')) {
      context.handle(
        _deletedMeta,
        deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta),
      );
    }
    if (data.containsKey('parent_id')) {
      context.handle(
        _parentIdMeta,
        parentId.isAcceptableOrUnknown(data['parent_id']!, _parentIdMeta),
      );
    }
    if (data.containsKey('sort_key')) {
      context.handle(
        _sortKeyMeta,
        sortKey.isAcceptableOrUnknown(data['sort_key']!, _sortKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_sortKeyMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('body_md')) {
      context.handle(
        _bodyMdMeta,
        bodyMd.isAcceptableOrUnknown(data['body_md']!, _bodyMdMeta),
      );
    }
    if (data.containsKey('body_format')) {
      context.handle(
        _bodyFormatMeta,
        bodyFormat.isAcceptableOrUnknown(data['body_format']!, _bodyFormatMeta),
      );
    }
    if (data.containsKey('completed_by')) {
      context.handle(
        _completedByMeta,
        completedBy.isAcceptableOrUnknown(
          data['completed_by']!,
          _completedByMeta,
        ),
      );
    }
    if (data.containsKey('completed_at')) {
      context.handle(
        _completedAtMeta,
        completedAt.isAcceptableOrUnknown(
          data['completed_at']!,
          _completedAtMeta,
        ),
      );
    }
    if (data.containsKey('priority')) {
      context.handle(
        _priorityMeta,
        priority.isAcceptableOrUnknown(data['priority']!, _priorityMeta),
      );
    }
    if (data.containsKey('estimate_minutes')) {
      context.handle(
        _estimateMinutesMeta,
        estimateMinutes.isAcceptableOrUnknown(
          data['estimate_minutes']!,
          _estimateMinutesMeta,
        ),
      );
    }
    if (data.containsKey('start_at')) {
      context.handle(
        _startAtMeta,
        startAt.isAcceptableOrUnknown(data['start_at']!, _startAtMeta),
      );
    }
    if (data.containsKey('end_at')) {
      context.handle(
        _endAtMeta,
        endAt.isAcceptableOrUnknown(data['end_at']!, _endAtMeta),
      );
    }
    if (data.containsKey('time_zone')) {
      context.handle(
        _timeZoneMeta,
        timeZone.isAcceptableOrUnknown(data['time_zone']!, _timeZoneMeta),
      );
    }
    if (data.containsKey('due_at')) {
      context.handle(
        _dueAtMeta,
        dueAt.isAcceptableOrUnknown(data['due_at']!, _dueAtMeta),
      );
    }
    if (data.containsKey('due_date')) {
      context.handle(
        _dueDateMeta,
        dueDate.isAcceptableOrUnknown(data['due_date']!, _dueDateMeta),
      );
    }
    if (data.containsKey('rrule')) {
      context.handle(
        _rruleMeta,
        rrule.isAcceptableOrUnknown(data['rrule']!, _rruleMeta),
      );
    }
    if (data.containsKey('repeat_start')) {
      context.handle(
        _repeatStartMeta,
        repeatStart.isAcceptableOrUnknown(
          data['repeat_start']!,
          _repeatStartMeta,
        ),
      );
    }
    if (data.containsKey('exclusive_children')) {
      context.handle(
        _exclusiveChildrenMeta,
        exclusiveChildren.isAcceptableOrUnknown(
          data['exclusive_children']!,
          _exclusiveChildrenMeta,
        ),
      );
    }
    if (data.containsKey('shared_with_children')) {
      context.handle(
        _sharedWithChildrenMeta,
        sharedWithChildren.isAcceptableOrUnknown(
          data['shared_with_children']!,
          _sharedWithChildrenMeta,
        ),
      );
    }
    if (data.containsKey('lifecycle_at')) {
      context.handle(
        _lifecycleAtMeta,
        lifecycleAt.isAcceptableOrUnknown(
          data['lifecycle_at']!,
          _lifecycleAtMeta,
        ),
      );
    }
    if (data.containsKey('lifecycle_root_id')) {
      context.handle(
        _lifecycleRootIdMeta,
        lifecycleRootId.isAcceptableOrUnknown(
          data['lifecycle_root_id']!,
          _lifecycleRootIdMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Node map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Node(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      spaceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}space_id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      createdBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_by'],
      )!,
      updatedBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}updated_by'],
      )!,
      hlc: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}hlc'],
      )!,
      deleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}deleted'],
      )!,
      parentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}parent_id'],
      ),
      sortKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sort_key'],
      )!,
      type: $NodesTable.$convertertype.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}type'],
        )!,
      ),
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      bodyMd: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}body_md'],
      )!,
      bodyFormat: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}body_format'],
      )!,
      childView: $NodesTable.$converterchildViewn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}child_view'],
        ),
      ),
      status: $NodesTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}status'],
        )!,
      ),
      completedBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}completed_by'],
      ),
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}completed_at'],
      ),
      priority: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}priority'],
      ),
      estimateMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}estimate_minutes'],
      ),
      startAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start_at'],
      ),
      endAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}end_at'],
      ),
      timeZone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}time_zone'],
      ),
      dueAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}due_at'],
      ),
      dueDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}due_date'],
      ),
      rrule: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}rrule'],
      ),
      repeatStart: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}repeat_start'],
      ),
      exclusiveChildren: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}exclusive_children'],
      )!,
      sharedWithChildren: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}shared_with_children'],
      )!,
      lifecycle: $NodesTable.$converterlifecycle.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}lifecycle'],
        )!,
      ),
      lifecycleAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}lifecycle_at'],
      ),
      lifecycleRootId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}lifecycle_root_id'],
      ),
    );
  }

  @override
  $NodesTable createAlias(String alias) {
    return $NodesTable(attachedDatabase, alias);
  }

  static TypeConverter<NodeType, String> $convertertype =
      const TolerantEnumConverter(NodeType.values, NodeType.task);
  static TypeConverter<ChildView, String> $converterchildView =
      const TolerantEnumConverter(ChildView.values, ChildView.panels);
  static TypeConverter<ChildView?, String?> $converterchildViewn =
      NullAwareTypeConverter.wrap($converterchildView);
  static TypeConverter<NodeStatus, String> $converterstatus =
      const TolerantEnumConverter(NodeStatus.values, NodeStatus.open);
  static JsonTypeConverter2<Lifecycle, String, String> $converterlifecycle =
      const EnumNameConverter<Lifecycle>(Lifecycle.values);
}

class Node extends DataClass implements Insertable<Node> {
  /// UUIDv7.
  final String id;

  /// The space this row belongs to (§5.0, D13).
  final String spaceId;
  final DateTime createdAt;

  /// User ID of the creator.
  final String createdBy;

  /// User ID of whoever made the latest change.
  final String updatedBy;

  /// Hybrid logical clock stamp of the latest change (see `sync/hlc.dart`).
  final String hlc;

  /// Tombstone flag. Rows are never hard-deleted until compaction.
  final bool deleted;

  /// The single real parent. Null means top-level.
  final String? parentId;

  /// Fractional index among siblings (see `domain/sort_keys.dart`).
  /// Ties (two devices picking the same key) are broken by [id].
  final String sortKey;
  final NodeType type;
  final String title;
  final String bodyMd;

  /// `md_lww` in v1; leaves room for a CRDT note format later (Q-A).
  final String bodyFormat;

  /// How children are shown. Null means panels; checklist is "show as list".
  final ChildView? childView;
  final NodeStatus status;
  final String? completedBy;
  final DateTime? completedAt;

  /// 1–4.
  final int? priority;
  final int? estimateMinutes;

  /// Events and time blocks, in UTC, plus the IANA zone they were set in.
  final DateTime? startAt;
  final DateTime? endAt;
  final String? timeZone;

  /// A deadline with a time of day.
  final DateTime? dueAt;

  /// An all-day deadline, as `YYYY-MM-DD` with no time zone (§6.5).
  final String? dueDate;

  /// RFC 5545 RRULE. All descendants repeat with it (D24), unless
  /// [exclusiveChildren] makes them take turns (D36).
  final String? rrule;

  /// First day of the repeat series, `YYYY-MM-DD`. Intervals count from it
  /// (which weeks "every 2 weeks" means).
  final String? repeatStart;

  /// Children are an exclusive set (D36): each occurrence suggests at most
  /// one of them, the one furthest past its own due date.
  final bool exclusiveChildren;

  /// Notes only (§6.10): shared with every item under the note's owner, as
  /// if each had linked it. "Pinned" for all sub-items.
  final bool sharedWithChildren;

  /// Archive / Trash state, separate from [status] (§6.11).
  final Lifecycle lifecycle;
  final DateTime? lifecycleAt;

  /// The node the user actually archived or trashed; its whole subtree points
  /// here so restoring it brings back exactly that group.
  final String? lifecycleRootId;
  const Node({
    required this.id,
    required this.spaceId,
    required this.createdAt,
    required this.createdBy,
    required this.updatedBy,
    required this.hlc,
    required this.deleted,
    this.parentId,
    required this.sortKey,
    required this.type,
    required this.title,
    required this.bodyMd,
    required this.bodyFormat,
    this.childView,
    required this.status,
    this.completedBy,
    this.completedAt,
    this.priority,
    this.estimateMinutes,
    this.startAt,
    this.endAt,
    this.timeZone,
    this.dueAt,
    this.dueDate,
    this.rrule,
    this.repeatStart,
    required this.exclusiveChildren,
    required this.sharedWithChildren,
    required this.lifecycle,
    this.lifecycleAt,
    this.lifecycleRootId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['space_id'] = Variable<String>(spaceId);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['created_by'] = Variable<String>(createdBy);
    map['updated_by'] = Variable<String>(updatedBy);
    map['hlc'] = Variable<String>(hlc);
    map['deleted'] = Variable<bool>(deleted);
    if (!nullToAbsent || parentId != null) {
      map['parent_id'] = Variable<String>(parentId);
    }
    map['sort_key'] = Variable<String>(sortKey);
    {
      map['type'] = Variable<String>($NodesTable.$convertertype.toSql(type));
    }
    map['title'] = Variable<String>(title);
    map['body_md'] = Variable<String>(bodyMd);
    map['body_format'] = Variable<String>(bodyFormat);
    if (!nullToAbsent || childView != null) {
      map['child_view'] = Variable<String>(
        $NodesTable.$converterchildViewn.toSql(childView),
      );
    }
    {
      map['status'] = Variable<String>(
        $NodesTable.$converterstatus.toSql(status),
      );
    }
    if (!nullToAbsent || completedBy != null) {
      map['completed_by'] = Variable<String>(completedBy);
    }
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    if (!nullToAbsent || priority != null) {
      map['priority'] = Variable<int>(priority);
    }
    if (!nullToAbsent || estimateMinutes != null) {
      map['estimate_minutes'] = Variable<int>(estimateMinutes);
    }
    if (!nullToAbsent || startAt != null) {
      map['start_at'] = Variable<DateTime>(startAt);
    }
    if (!nullToAbsent || endAt != null) {
      map['end_at'] = Variable<DateTime>(endAt);
    }
    if (!nullToAbsent || timeZone != null) {
      map['time_zone'] = Variable<String>(timeZone);
    }
    if (!nullToAbsent || dueAt != null) {
      map['due_at'] = Variable<DateTime>(dueAt);
    }
    if (!nullToAbsent || dueDate != null) {
      map['due_date'] = Variable<String>(dueDate);
    }
    if (!nullToAbsent || rrule != null) {
      map['rrule'] = Variable<String>(rrule);
    }
    if (!nullToAbsent || repeatStart != null) {
      map['repeat_start'] = Variable<String>(repeatStart);
    }
    map['exclusive_children'] = Variable<bool>(exclusiveChildren);
    map['shared_with_children'] = Variable<bool>(sharedWithChildren);
    {
      map['lifecycle'] = Variable<String>(
        $NodesTable.$converterlifecycle.toSql(lifecycle),
      );
    }
    if (!nullToAbsent || lifecycleAt != null) {
      map['lifecycle_at'] = Variable<DateTime>(lifecycleAt);
    }
    if (!nullToAbsent || lifecycleRootId != null) {
      map['lifecycle_root_id'] = Variable<String>(lifecycleRootId);
    }
    return map;
  }

  NodesCompanion toCompanion(bool nullToAbsent) {
    return NodesCompanion(
      id: Value(id),
      spaceId: Value(spaceId),
      createdAt: Value(createdAt),
      createdBy: Value(createdBy),
      updatedBy: Value(updatedBy),
      hlc: Value(hlc),
      deleted: Value(deleted),
      parentId: parentId == null && nullToAbsent
          ? const Value.absent()
          : Value(parentId),
      sortKey: Value(sortKey),
      type: Value(type),
      title: Value(title),
      bodyMd: Value(bodyMd),
      bodyFormat: Value(bodyFormat),
      childView: childView == null && nullToAbsent
          ? const Value.absent()
          : Value(childView),
      status: Value(status),
      completedBy: completedBy == null && nullToAbsent
          ? const Value.absent()
          : Value(completedBy),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
      priority: priority == null && nullToAbsent
          ? const Value.absent()
          : Value(priority),
      estimateMinutes: estimateMinutes == null && nullToAbsent
          ? const Value.absent()
          : Value(estimateMinutes),
      startAt: startAt == null && nullToAbsent
          ? const Value.absent()
          : Value(startAt),
      endAt: endAt == null && nullToAbsent
          ? const Value.absent()
          : Value(endAt),
      timeZone: timeZone == null && nullToAbsent
          ? const Value.absent()
          : Value(timeZone),
      dueAt: dueAt == null && nullToAbsent
          ? const Value.absent()
          : Value(dueAt),
      dueDate: dueDate == null && nullToAbsent
          ? const Value.absent()
          : Value(dueDate),
      rrule: rrule == null && nullToAbsent
          ? const Value.absent()
          : Value(rrule),
      repeatStart: repeatStart == null && nullToAbsent
          ? const Value.absent()
          : Value(repeatStart),
      exclusiveChildren: Value(exclusiveChildren),
      sharedWithChildren: Value(sharedWithChildren),
      lifecycle: Value(lifecycle),
      lifecycleAt: lifecycleAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lifecycleAt),
      lifecycleRootId: lifecycleRootId == null && nullToAbsent
          ? const Value.absent()
          : Value(lifecycleRootId),
    );
  }

  factory Node.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Node(
      id: serializer.fromJson<String>(json['id']),
      spaceId: serializer.fromJson<String>(json['spaceId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      createdBy: serializer.fromJson<String>(json['createdBy']),
      updatedBy: serializer.fromJson<String>(json['updatedBy']),
      hlc: serializer.fromJson<String>(json['hlc']),
      deleted: serializer.fromJson<bool>(json['deleted']),
      parentId: serializer.fromJson<String?>(json['parentId']),
      sortKey: serializer.fromJson<String>(json['sortKey']),
      type: serializer.fromJson<NodeType>(json['type']),
      title: serializer.fromJson<String>(json['title']),
      bodyMd: serializer.fromJson<String>(json['bodyMd']),
      bodyFormat: serializer.fromJson<String>(json['bodyFormat']),
      childView: serializer.fromJson<ChildView?>(json['childView']),
      status: serializer.fromJson<NodeStatus>(json['status']),
      completedBy: serializer.fromJson<String?>(json['completedBy']),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
      priority: serializer.fromJson<int?>(json['priority']),
      estimateMinutes: serializer.fromJson<int?>(json['estimateMinutes']),
      startAt: serializer.fromJson<DateTime?>(json['startAt']),
      endAt: serializer.fromJson<DateTime?>(json['endAt']),
      timeZone: serializer.fromJson<String?>(json['timeZone']),
      dueAt: serializer.fromJson<DateTime?>(json['dueAt']),
      dueDate: serializer.fromJson<String?>(json['dueDate']),
      rrule: serializer.fromJson<String?>(json['rrule']),
      repeatStart: serializer.fromJson<String?>(json['repeatStart']),
      exclusiveChildren: serializer.fromJson<bool>(json['exclusiveChildren']),
      sharedWithChildren: serializer.fromJson<bool>(json['sharedWithChildren']),
      lifecycle: $NodesTable.$converterlifecycle.fromJson(
        serializer.fromJson<String>(json['lifecycle']),
      ),
      lifecycleAt: serializer.fromJson<DateTime?>(json['lifecycleAt']),
      lifecycleRootId: serializer.fromJson<String?>(json['lifecycleRootId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'spaceId': serializer.toJson<String>(spaceId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'createdBy': serializer.toJson<String>(createdBy),
      'updatedBy': serializer.toJson<String>(updatedBy),
      'hlc': serializer.toJson<String>(hlc),
      'deleted': serializer.toJson<bool>(deleted),
      'parentId': serializer.toJson<String?>(parentId),
      'sortKey': serializer.toJson<String>(sortKey),
      'type': serializer.toJson<NodeType>(type),
      'title': serializer.toJson<String>(title),
      'bodyMd': serializer.toJson<String>(bodyMd),
      'bodyFormat': serializer.toJson<String>(bodyFormat),
      'childView': serializer.toJson<ChildView?>(childView),
      'status': serializer.toJson<NodeStatus>(status),
      'completedBy': serializer.toJson<String?>(completedBy),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
      'priority': serializer.toJson<int?>(priority),
      'estimateMinutes': serializer.toJson<int?>(estimateMinutes),
      'startAt': serializer.toJson<DateTime?>(startAt),
      'endAt': serializer.toJson<DateTime?>(endAt),
      'timeZone': serializer.toJson<String?>(timeZone),
      'dueAt': serializer.toJson<DateTime?>(dueAt),
      'dueDate': serializer.toJson<String?>(dueDate),
      'rrule': serializer.toJson<String?>(rrule),
      'repeatStart': serializer.toJson<String?>(repeatStart),
      'exclusiveChildren': serializer.toJson<bool>(exclusiveChildren),
      'sharedWithChildren': serializer.toJson<bool>(sharedWithChildren),
      'lifecycle': serializer.toJson<String>(
        $NodesTable.$converterlifecycle.toJson(lifecycle),
      ),
      'lifecycleAt': serializer.toJson<DateTime?>(lifecycleAt),
      'lifecycleRootId': serializer.toJson<String?>(lifecycleRootId),
    };
  }

  Node copyWith({
    String? id,
    String? spaceId,
    DateTime? createdAt,
    String? createdBy,
    String? updatedBy,
    String? hlc,
    bool? deleted,
    Value<String?> parentId = const Value.absent(),
    String? sortKey,
    NodeType? type,
    String? title,
    String? bodyMd,
    String? bodyFormat,
    Value<ChildView?> childView = const Value.absent(),
    NodeStatus? status,
    Value<String?> completedBy = const Value.absent(),
    Value<DateTime?> completedAt = const Value.absent(),
    Value<int?> priority = const Value.absent(),
    Value<int?> estimateMinutes = const Value.absent(),
    Value<DateTime?> startAt = const Value.absent(),
    Value<DateTime?> endAt = const Value.absent(),
    Value<String?> timeZone = const Value.absent(),
    Value<DateTime?> dueAt = const Value.absent(),
    Value<String?> dueDate = const Value.absent(),
    Value<String?> rrule = const Value.absent(),
    Value<String?> repeatStart = const Value.absent(),
    bool? exclusiveChildren,
    bool? sharedWithChildren,
    Lifecycle? lifecycle,
    Value<DateTime?> lifecycleAt = const Value.absent(),
    Value<String?> lifecycleRootId = const Value.absent(),
  }) => Node(
    id: id ?? this.id,
    spaceId: spaceId ?? this.spaceId,
    createdAt: createdAt ?? this.createdAt,
    createdBy: createdBy ?? this.createdBy,
    updatedBy: updatedBy ?? this.updatedBy,
    hlc: hlc ?? this.hlc,
    deleted: deleted ?? this.deleted,
    parentId: parentId.present ? parentId.value : this.parentId,
    sortKey: sortKey ?? this.sortKey,
    type: type ?? this.type,
    title: title ?? this.title,
    bodyMd: bodyMd ?? this.bodyMd,
    bodyFormat: bodyFormat ?? this.bodyFormat,
    childView: childView.present ? childView.value : this.childView,
    status: status ?? this.status,
    completedBy: completedBy.present ? completedBy.value : this.completedBy,
    completedAt: completedAt.present ? completedAt.value : this.completedAt,
    priority: priority.present ? priority.value : this.priority,
    estimateMinutes: estimateMinutes.present
        ? estimateMinutes.value
        : this.estimateMinutes,
    startAt: startAt.present ? startAt.value : this.startAt,
    endAt: endAt.present ? endAt.value : this.endAt,
    timeZone: timeZone.present ? timeZone.value : this.timeZone,
    dueAt: dueAt.present ? dueAt.value : this.dueAt,
    dueDate: dueDate.present ? dueDate.value : this.dueDate,
    rrule: rrule.present ? rrule.value : this.rrule,
    repeatStart: repeatStart.present ? repeatStart.value : this.repeatStart,
    exclusiveChildren: exclusiveChildren ?? this.exclusiveChildren,
    sharedWithChildren: sharedWithChildren ?? this.sharedWithChildren,
    lifecycle: lifecycle ?? this.lifecycle,
    lifecycleAt: lifecycleAt.present ? lifecycleAt.value : this.lifecycleAt,
    lifecycleRootId: lifecycleRootId.present
        ? lifecycleRootId.value
        : this.lifecycleRootId,
  );
  Node copyWithCompanion(NodesCompanion data) {
    return Node(
      id: data.id.present ? data.id.value : this.id,
      spaceId: data.spaceId.present ? data.spaceId.value : this.spaceId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      createdBy: data.createdBy.present ? data.createdBy.value : this.createdBy,
      updatedBy: data.updatedBy.present ? data.updatedBy.value : this.updatedBy,
      hlc: data.hlc.present ? data.hlc.value : this.hlc,
      deleted: data.deleted.present ? data.deleted.value : this.deleted,
      parentId: data.parentId.present ? data.parentId.value : this.parentId,
      sortKey: data.sortKey.present ? data.sortKey.value : this.sortKey,
      type: data.type.present ? data.type.value : this.type,
      title: data.title.present ? data.title.value : this.title,
      bodyMd: data.bodyMd.present ? data.bodyMd.value : this.bodyMd,
      bodyFormat: data.bodyFormat.present
          ? data.bodyFormat.value
          : this.bodyFormat,
      childView: data.childView.present ? data.childView.value : this.childView,
      status: data.status.present ? data.status.value : this.status,
      completedBy: data.completedBy.present
          ? data.completedBy.value
          : this.completedBy,
      completedAt: data.completedAt.present
          ? data.completedAt.value
          : this.completedAt,
      priority: data.priority.present ? data.priority.value : this.priority,
      estimateMinutes: data.estimateMinutes.present
          ? data.estimateMinutes.value
          : this.estimateMinutes,
      startAt: data.startAt.present ? data.startAt.value : this.startAt,
      endAt: data.endAt.present ? data.endAt.value : this.endAt,
      timeZone: data.timeZone.present ? data.timeZone.value : this.timeZone,
      dueAt: data.dueAt.present ? data.dueAt.value : this.dueAt,
      dueDate: data.dueDate.present ? data.dueDate.value : this.dueDate,
      rrule: data.rrule.present ? data.rrule.value : this.rrule,
      repeatStart: data.repeatStart.present
          ? data.repeatStart.value
          : this.repeatStart,
      exclusiveChildren: data.exclusiveChildren.present
          ? data.exclusiveChildren.value
          : this.exclusiveChildren,
      sharedWithChildren: data.sharedWithChildren.present
          ? data.sharedWithChildren.value
          : this.sharedWithChildren,
      lifecycle: data.lifecycle.present ? data.lifecycle.value : this.lifecycle,
      lifecycleAt: data.lifecycleAt.present
          ? data.lifecycleAt.value
          : this.lifecycleAt,
      lifecycleRootId: data.lifecycleRootId.present
          ? data.lifecycleRootId.value
          : this.lifecycleRootId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Node(')
          ..write('id: $id, ')
          ..write('spaceId: $spaceId, ')
          ..write('createdAt: $createdAt, ')
          ..write('createdBy: $createdBy, ')
          ..write('updatedBy: $updatedBy, ')
          ..write('hlc: $hlc, ')
          ..write('deleted: $deleted, ')
          ..write('parentId: $parentId, ')
          ..write('sortKey: $sortKey, ')
          ..write('type: $type, ')
          ..write('title: $title, ')
          ..write('bodyMd: $bodyMd, ')
          ..write('bodyFormat: $bodyFormat, ')
          ..write('childView: $childView, ')
          ..write('status: $status, ')
          ..write('completedBy: $completedBy, ')
          ..write('completedAt: $completedAt, ')
          ..write('priority: $priority, ')
          ..write('estimateMinutes: $estimateMinutes, ')
          ..write('startAt: $startAt, ')
          ..write('endAt: $endAt, ')
          ..write('timeZone: $timeZone, ')
          ..write('dueAt: $dueAt, ')
          ..write('dueDate: $dueDate, ')
          ..write('rrule: $rrule, ')
          ..write('repeatStart: $repeatStart, ')
          ..write('exclusiveChildren: $exclusiveChildren, ')
          ..write('sharedWithChildren: $sharedWithChildren, ')
          ..write('lifecycle: $lifecycle, ')
          ..write('lifecycleAt: $lifecycleAt, ')
          ..write('lifecycleRootId: $lifecycleRootId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    spaceId,
    createdAt,
    createdBy,
    updatedBy,
    hlc,
    deleted,
    parentId,
    sortKey,
    type,
    title,
    bodyMd,
    bodyFormat,
    childView,
    status,
    completedBy,
    completedAt,
    priority,
    estimateMinutes,
    startAt,
    endAt,
    timeZone,
    dueAt,
    dueDate,
    rrule,
    repeatStart,
    exclusiveChildren,
    sharedWithChildren,
    lifecycle,
    lifecycleAt,
    lifecycleRootId,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Node &&
          other.id == this.id &&
          other.spaceId == this.spaceId &&
          other.createdAt == this.createdAt &&
          other.createdBy == this.createdBy &&
          other.updatedBy == this.updatedBy &&
          other.hlc == this.hlc &&
          other.deleted == this.deleted &&
          other.parentId == this.parentId &&
          other.sortKey == this.sortKey &&
          other.type == this.type &&
          other.title == this.title &&
          other.bodyMd == this.bodyMd &&
          other.bodyFormat == this.bodyFormat &&
          other.childView == this.childView &&
          other.status == this.status &&
          other.completedBy == this.completedBy &&
          other.completedAt == this.completedAt &&
          other.priority == this.priority &&
          other.estimateMinutes == this.estimateMinutes &&
          other.startAt == this.startAt &&
          other.endAt == this.endAt &&
          other.timeZone == this.timeZone &&
          other.dueAt == this.dueAt &&
          other.dueDate == this.dueDate &&
          other.rrule == this.rrule &&
          other.repeatStart == this.repeatStart &&
          other.exclusiveChildren == this.exclusiveChildren &&
          other.sharedWithChildren == this.sharedWithChildren &&
          other.lifecycle == this.lifecycle &&
          other.lifecycleAt == this.lifecycleAt &&
          other.lifecycleRootId == this.lifecycleRootId);
}

class NodesCompanion extends UpdateCompanion<Node> {
  final Value<String> id;
  final Value<String> spaceId;
  final Value<DateTime> createdAt;
  final Value<String> createdBy;
  final Value<String> updatedBy;
  final Value<String> hlc;
  final Value<bool> deleted;
  final Value<String?> parentId;
  final Value<String> sortKey;
  final Value<NodeType> type;
  final Value<String> title;
  final Value<String> bodyMd;
  final Value<String> bodyFormat;
  final Value<ChildView?> childView;
  final Value<NodeStatus> status;
  final Value<String?> completedBy;
  final Value<DateTime?> completedAt;
  final Value<int?> priority;
  final Value<int?> estimateMinutes;
  final Value<DateTime?> startAt;
  final Value<DateTime?> endAt;
  final Value<String?> timeZone;
  final Value<DateTime?> dueAt;
  final Value<String?> dueDate;
  final Value<String?> rrule;
  final Value<String?> repeatStart;
  final Value<bool> exclusiveChildren;
  final Value<bool> sharedWithChildren;
  final Value<Lifecycle> lifecycle;
  final Value<DateTime?> lifecycleAt;
  final Value<String?> lifecycleRootId;
  final Value<int> rowid;
  const NodesCompanion({
    this.id = const Value.absent(),
    this.spaceId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.createdBy = const Value.absent(),
    this.updatedBy = const Value.absent(),
    this.hlc = const Value.absent(),
    this.deleted = const Value.absent(),
    this.parentId = const Value.absent(),
    this.sortKey = const Value.absent(),
    this.type = const Value.absent(),
    this.title = const Value.absent(),
    this.bodyMd = const Value.absent(),
    this.bodyFormat = const Value.absent(),
    this.childView = const Value.absent(),
    this.status = const Value.absent(),
    this.completedBy = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.priority = const Value.absent(),
    this.estimateMinutes = const Value.absent(),
    this.startAt = const Value.absent(),
    this.endAt = const Value.absent(),
    this.timeZone = const Value.absent(),
    this.dueAt = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.rrule = const Value.absent(),
    this.repeatStart = const Value.absent(),
    this.exclusiveChildren = const Value.absent(),
    this.sharedWithChildren = const Value.absent(),
    this.lifecycle = const Value.absent(),
    this.lifecycleAt = const Value.absent(),
    this.lifecycleRootId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  NodesCompanion.insert({
    required String id,
    required String spaceId,
    required DateTime createdAt,
    required String createdBy,
    required String updatedBy,
    required String hlc,
    this.deleted = const Value.absent(),
    this.parentId = const Value.absent(),
    required String sortKey,
    required NodeType type,
    required String title,
    this.bodyMd = const Value.absent(),
    this.bodyFormat = const Value.absent(),
    this.childView = const Value.absent(),
    this.status = const Value.absent(),
    this.completedBy = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.priority = const Value.absent(),
    this.estimateMinutes = const Value.absent(),
    this.startAt = const Value.absent(),
    this.endAt = const Value.absent(),
    this.timeZone = const Value.absent(),
    this.dueAt = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.rrule = const Value.absent(),
    this.repeatStart = const Value.absent(),
    this.exclusiveChildren = const Value.absent(),
    this.sharedWithChildren = const Value.absent(),
    this.lifecycle = const Value.absent(),
    this.lifecycleAt = const Value.absent(),
    this.lifecycleRootId = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       spaceId = Value(spaceId),
       createdAt = Value(createdAt),
       createdBy = Value(createdBy),
       updatedBy = Value(updatedBy),
       hlc = Value(hlc),
       sortKey = Value(sortKey),
       type = Value(type),
       title = Value(title);
  static Insertable<Node> custom({
    Expression<String>? id,
    Expression<String>? spaceId,
    Expression<DateTime>? createdAt,
    Expression<String>? createdBy,
    Expression<String>? updatedBy,
    Expression<String>? hlc,
    Expression<bool>? deleted,
    Expression<String>? parentId,
    Expression<String>? sortKey,
    Expression<String>? type,
    Expression<String>? title,
    Expression<String>? bodyMd,
    Expression<String>? bodyFormat,
    Expression<String>? childView,
    Expression<String>? status,
    Expression<String>? completedBy,
    Expression<DateTime>? completedAt,
    Expression<int>? priority,
    Expression<int>? estimateMinutes,
    Expression<DateTime>? startAt,
    Expression<DateTime>? endAt,
    Expression<String>? timeZone,
    Expression<DateTime>? dueAt,
    Expression<String>? dueDate,
    Expression<String>? rrule,
    Expression<String>? repeatStart,
    Expression<bool>? exclusiveChildren,
    Expression<bool>? sharedWithChildren,
    Expression<String>? lifecycle,
    Expression<DateTime>? lifecycleAt,
    Expression<String>? lifecycleRootId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (spaceId != null) 'space_id': spaceId,
      if (createdAt != null) 'created_at': createdAt,
      if (createdBy != null) 'created_by': createdBy,
      if (updatedBy != null) 'updated_by': updatedBy,
      if (hlc != null) 'hlc': hlc,
      if (deleted != null) 'deleted': deleted,
      if (parentId != null) 'parent_id': parentId,
      if (sortKey != null) 'sort_key': sortKey,
      if (type != null) 'type': type,
      if (title != null) 'title': title,
      if (bodyMd != null) 'body_md': bodyMd,
      if (bodyFormat != null) 'body_format': bodyFormat,
      if (childView != null) 'child_view': childView,
      if (status != null) 'status': status,
      if (completedBy != null) 'completed_by': completedBy,
      if (completedAt != null) 'completed_at': completedAt,
      if (priority != null) 'priority': priority,
      if (estimateMinutes != null) 'estimate_minutes': estimateMinutes,
      if (startAt != null) 'start_at': startAt,
      if (endAt != null) 'end_at': endAt,
      if (timeZone != null) 'time_zone': timeZone,
      if (dueAt != null) 'due_at': dueAt,
      if (dueDate != null) 'due_date': dueDate,
      if (rrule != null) 'rrule': rrule,
      if (repeatStart != null) 'repeat_start': repeatStart,
      if (exclusiveChildren != null) 'exclusive_children': exclusiveChildren,
      if (sharedWithChildren != null)
        'shared_with_children': sharedWithChildren,
      if (lifecycle != null) 'lifecycle': lifecycle,
      if (lifecycleAt != null) 'lifecycle_at': lifecycleAt,
      if (lifecycleRootId != null) 'lifecycle_root_id': lifecycleRootId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  NodesCompanion copyWith({
    Value<String>? id,
    Value<String>? spaceId,
    Value<DateTime>? createdAt,
    Value<String>? createdBy,
    Value<String>? updatedBy,
    Value<String>? hlc,
    Value<bool>? deleted,
    Value<String?>? parentId,
    Value<String>? sortKey,
    Value<NodeType>? type,
    Value<String>? title,
    Value<String>? bodyMd,
    Value<String>? bodyFormat,
    Value<ChildView?>? childView,
    Value<NodeStatus>? status,
    Value<String?>? completedBy,
    Value<DateTime?>? completedAt,
    Value<int?>? priority,
    Value<int?>? estimateMinutes,
    Value<DateTime?>? startAt,
    Value<DateTime?>? endAt,
    Value<String?>? timeZone,
    Value<DateTime?>? dueAt,
    Value<String?>? dueDate,
    Value<String?>? rrule,
    Value<String?>? repeatStart,
    Value<bool>? exclusiveChildren,
    Value<bool>? sharedWithChildren,
    Value<Lifecycle>? lifecycle,
    Value<DateTime?>? lifecycleAt,
    Value<String?>? lifecycleRootId,
    Value<int>? rowid,
  }) {
    return NodesCompanion(
      id: id ?? this.id,
      spaceId: spaceId ?? this.spaceId,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      updatedBy: updatedBy ?? this.updatedBy,
      hlc: hlc ?? this.hlc,
      deleted: deleted ?? this.deleted,
      parentId: parentId ?? this.parentId,
      sortKey: sortKey ?? this.sortKey,
      type: type ?? this.type,
      title: title ?? this.title,
      bodyMd: bodyMd ?? this.bodyMd,
      bodyFormat: bodyFormat ?? this.bodyFormat,
      childView: childView ?? this.childView,
      status: status ?? this.status,
      completedBy: completedBy ?? this.completedBy,
      completedAt: completedAt ?? this.completedAt,
      priority: priority ?? this.priority,
      estimateMinutes: estimateMinutes ?? this.estimateMinutes,
      startAt: startAt ?? this.startAt,
      endAt: endAt ?? this.endAt,
      timeZone: timeZone ?? this.timeZone,
      dueAt: dueAt ?? this.dueAt,
      dueDate: dueDate ?? this.dueDate,
      rrule: rrule ?? this.rrule,
      repeatStart: repeatStart ?? this.repeatStart,
      exclusiveChildren: exclusiveChildren ?? this.exclusiveChildren,
      sharedWithChildren: sharedWithChildren ?? this.sharedWithChildren,
      lifecycle: lifecycle ?? this.lifecycle,
      lifecycleAt: lifecycleAt ?? this.lifecycleAt,
      lifecycleRootId: lifecycleRootId ?? this.lifecycleRootId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (spaceId.present) {
      map['space_id'] = Variable<String>(spaceId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (createdBy.present) {
      map['created_by'] = Variable<String>(createdBy.value);
    }
    if (updatedBy.present) {
      map['updated_by'] = Variable<String>(updatedBy.value);
    }
    if (hlc.present) {
      map['hlc'] = Variable<String>(hlc.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<bool>(deleted.value);
    }
    if (parentId.present) {
      map['parent_id'] = Variable<String>(parentId.value);
    }
    if (sortKey.present) {
      map['sort_key'] = Variable<String>(sortKey.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(
        $NodesTable.$convertertype.toSql(type.value),
      );
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (bodyMd.present) {
      map['body_md'] = Variable<String>(bodyMd.value);
    }
    if (bodyFormat.present) {
      map['body_format'] = Variable<String>(bodyFormat.value);
    }
    if (childView.present) {
      map['child_view'] = Variable<String>(
        $NodesTable.$converterchildViewn.toSql(childView.value),
      );
    }
    if (status.present) {
      map['status'] = Variable<String>(
        $NodesTable.$converterstatus.toSql(status.value),
      );
    }
    if (completedBy.present) {
      map['completed_by'] = Variable<String>(completedBy.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (priority.present) {
      map['priority'] = Variable<int>(priority.value);
    }
    if (estimateMinutes.present) {
      map['estimate_minutes'] = Variable<int>(estimateMinutes.value);
    }
    if (startAt.present) {
      map['start_at'] = Variable<DateTime>(startAt.value);
    }
    if (endAt.present) {
      map['end_at'] = Variable<DateTime>(endAt.value);
    }
    if (timeZone.present) {
      map['time_zone'] = Variable<String>(timeZone.value);
    }
    if (dueAt.present) {
      map['due_at'] = Variable<DateTime>(dueAt.value);
    }
    if (dueDate.present) {
      map['due_date'] = Variable<String>(dueDate.value);
    }
    if (rrule.present) {
      map['rrule'] = Variable<String>(rrule.value);
    }
    if (repeatStart.present) {
      map['repeat_start'] = Variable<String>(repeatStart.value);
    }
    if (exclusiveChildren.present) {
      map['exclusive_children'] = Variable<bool>(exclusiveChildren.value);
    }
    if (sharedWithChildren.present) {
      map['shared_with_children'] = Variable<bool>(sharedWithChildren.value);
    }
    if (lifecycle.present) {
      map['lifecycle'] = Variable<String>(
        $NodesTable.$converterlifecycle.toSql(lifecycle.value),
      );
    }
    if (lifecycleAt.present) {
      map['lifecycle_at'] = Variable<DateTime>(lifecycleAt.value);
    }
    if (lifecycleRootId.present) {
      map['lifecycle_root_id'] = Variable<String>(lifecycleRootId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NodesCompanion(')
          ..write('id: $id, ')
          ..write('spaceId: $spaceId, ')
          ..write('createdAt: $createdAt, ')
          ..write('createdBy: $createdBy, ')
          ..write('updatedBy: $updatedBy, ')
          ..write('hlc: $hlc, ')
          ..write('deleted: $deleted, ')
          ..write('parentId: $parentId, ')
          ..write('sortKey: $sortKey, ')
          ..write('type: $type, ')
          ..write('title: $title, ')
          ..write('bodyMd: $bodyMd, ')
          ..write('bodyFormat: $bodyFormat, ')
          ..write('childView: $childView, ')
          ..write('status: $status, ')
          ..write('completedBy: $completedBy, ')
          ..write('completedAt: $completedAt, ')
          ..write('priority: $priority, ')
          ..write('estimateMinutes: $estimateMinutes, ')
          ..write('startAt: $startAt, ')
          ..write('endAt: $endAt, ')
          ..write('timeZone: $timeZone, ')
          ..write('dueAt: $dueAt, ')
          ..write('dueDate: $dueDate, ')
          ..write('rrule: $rrule, ')
          ..write('repeatStart: $repeatStart, ')
          ..write('exclusiveChildren: $exclusiveChildren, ')
          ..write('sharedWithChildren: $sharedWithChildren, ')
          ..write('lifecycle: $lifecycle, ')
          ..write('lifecycleAt: $lifecycleAt, ')
          ..write('lifecycleRootId: $lifecycleRootId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class NodeSearch extends Table
    with
        TableInfo<NodeSearch, NodeSearchData>,
        VirtualTableInfo<NodeSearch, NodeSearchData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  NodeSearch(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: '',
  );
  static const VerificationMeta _bodyMdMeta = const VerificationMeta('bodyMd');
  late final GeneratedColumn<String> bodyMd = GeneratedColumn<String>(
    'body_md',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: '',
  );
  @override
  List<GeneratedColumn> get $columns => [title, bodyMd];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'node_search';
  @override
  VerificationContext validateIntegrity(
    Insertable<NodeSearchData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('body_md')) {
      context.handle(
        _bodyMdMeta,
        bodyMd.isAcceptableOrUnknown(data['body_md']!, _bodyMdMeta),
      );
    } else if (isInserting) {
      context.missing(_bodyMdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  NodeSearchData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return NodeSearchData(
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      bodyMd: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}body_md'],
      )!,
    );
  }

  @override
  NodeSearch createAlias(String alias) {
    return NodeSearch(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
  @override
  String get moduleAndArgs =>
      'fts5(title, body_md, content=nodes, content_rowid=rowid, tokenize=\'unicode61 remove_diacritics 2\')';
}

class NodeSearchData extends DataClass implements Insertable<NodeSearchData> {
  final String title;
  final String bodyMd;
  const NodeSearchData({required this.title, required this.bodyMd});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['title'] = Variable<String>(title);
    map['body_md'] = Variable<String>(bodyMd);
    return map;
  }

  NodeSearchCompanion toCompanion(bool nullToAbsent) {
    return NodeSearchCompanion(title: Value(title), bodyMd: Value(bodyMd));
  }

  factory NodeSearchData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return NodeSearchData(
      title: serializer.fromJson<String>(json['title']),
      bodyMd: serializer.fromJson<String>(json['body_md']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'title': serializer.toJson<String>(title),
      'body_md': serializer.toJson<String>(bodyMd),
    };
  }

  NodeSearchData copyWith({String? title, String? bodyMd}) =>
      NodeSearchData(title: title ?? this.title, bodyMd: bodyMd ?? this.bodyMd);
  NodeSearchData copyWithCompanion(NodeSearchCompanion data) {
    return NodeSearchData(
      title: data.title.present ? data.title.value : this.title,
      bodyMd: data.bodyMd.present ? data.bodyMd.value : this.bodyMd,
    );
  }

  @override
  String toString() {
    return (StringBuffer('NodeSearchData(')
          ..write('title: $title, ')
          ..write('bodyMd: $bodyMd')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(title, bodyMd);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NodeSearchData &&
          other.title == this.title &&
          other.bodyMd == this.bodyMd);
}

class NodeSearchCompanion extends UpdateCompanion<NodeSearchData> {
  final Value<String> title;
  final Value<String> bodyMd;
  final Value<int> rowid;
  const NodeSearchCompanion({
    this.title = const Value.absent(),
    this.bodyMd = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  NodeSearchCompanion.insert({
    required String title,
    required String bodyMd,
    this.rowid = const Value.absent(),
  }) : title = Value(title),
       bodyMd = Value(bodyMd);
  static Insertable<NodeSearchData> custom({
    Expression<String>? title,
    Expression<String>? bodyMd,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (title != null) 'title': title,
      if (bodyMd != null) 'body_md': bodyMd,
      if (rowid != null) 'rowid': rowid,
    });
  }

  NodeSearchCompanion copyWith({
    Value<String>? title,
    Value<String>? bodyMd,
    Value<int>? rowid,
  }) {
    return NodeSearchCompanion(
      title: title ?? this.title,
      bodyMd: bodyMd ?? this.bodyMd,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (bodyMd.present) {
      map['body_md'] = Variable<String>(bodyMd.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NodeSearchCompanion(')
          ..write('title: $title, ')
          ..write('bodyMd: $bodyMd, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class AttachmentSearch extends Table
    with
        TableInfo<AttachmentSearch, AttachmentSearchData>,
        VirtualTableInfo<AttachmentSearch, AttachmentSearchData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  AttachmentSearch(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _attachmentIdMeta = const VerificationMeta(
    'attachmentId',
  );
  late final GeneratedColumn<String> attachmentId = GeneratedColumn<String>(
    'attachment_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: '',
  );
  static const VerificationMeta _filenameMeta = const VerificationMeta(
    'filename',
  );
  late final GeneratedColumn<String> filename = GeneratedColumn<String>(
    'filename',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: '',
  );
  static const VerificationMeta _contentMeta = const VerificationMeta(
    'content',
  );
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
    'content',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: '',
  );
  @override
  List<GeneratedColumn> get $columns => [attachmentId, filename, content];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'attachment_search';
  @override
  VerificationContext validateIntegrity(
    Insertable<AttachmentSearchData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('attachment_id')) {
      context.handle(
        _attachmentIdMeta,
        attachmentId.isAcceptableOrUnknown(
          data['attachment_id']!,
          _attachmentIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_attachmentIdMeta);
    }
    if (data.containsKey('filename')) {
      context.handle(
        _filenameMeta,
        filename.isAcceptableOrUnknown(data['filename']!, _filenameMeta),
      );
    } else if (isInserting) {
      context.missing(_filenameMeta);
    }
    if (data.containsKey('content')) {
      context.handle(
        _contentMeta,
        content.isAcceptableOrUnknown(data['content']!, _contentMeta),
      );
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  AttachmentSearchData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AttachmentSearchData(
      attachmentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}attachment_id'],
      )!,
      filename: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}filename'],
      )!,
      content: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content'],
      )!,
    );
  }

  @override
  AttachmentSearch createAlias(String alias) {
    return AttachmentSearch(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
  @override
  String get moduleAndArgs =>
      'fts5(attachment_id UNINDEXED, filename, content, tokenize=\'unicode61 remove_diacritics 2\')';
}

class AttachmentSearchData extends DataClass
    implements Insertable<AttachmentSearchData> {
  final String attachmentId;
  final String filename;
  final String content;
  const AttachmentSearchData({
    required this.attachmentId,
    required this.filename,
    required this.content,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['attachment_id'] = Variable<String>(attachmentId);
    map['filename'] = Variable<String>(filename);
    map['content'] = Variable<String>(content);
    return map;
  }

  AttachmentSearchCompanion toCompanion(bool nullToAbsent) {
    return AttachmentSearchCompanion(
      attachmentId: Value(attachmentId),
      filename: Value(filename),
      content: Value(content),
    );
  }

  factory AttachmentSearchData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AttachmentSearchData(
      attachmentId: serializer.fromJson<String>(json['attachment_id']),
      filename: serializer.fromJson<String>(json['filename']),
      content: serializer.fromJson<String>(json['content']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'attachment_id': serializer.toJson<String>(attachmentId),
      'filename': serializer.toJson<String>(filename),
      'content': serializer.toJson<String>(content),
    };
  }

  AttachmentSearchData copyWith({
    String? attachmentId,
    String? filename,
    String? content,
  }) => AttachmentSearchData(
    attachmentId: attachmentId ?? this.attachmentId,
    filename: filename ?? this.filename,
    content: content ?? this.content,
  );
  AttachmentSearchData copyWithCompanion(AttachmentSearchCompanion data) {
    return AttachmentSearchData(
      attachmentId: data.attachmentId.present
          ? data.attachmentId.value
          : this.attachmentId,
      filename: data.filename.present ? data.filename.value : this.filename,
      content: data.content.present ? data.content.value : this.content,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AttachmentSearchData(')
          ..write('attachmentId: $attachmentId, ')
          ..write('filename: $filename, ')
          ..write('content: $content')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(attachmentId, filename, content);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AttachmentSearchData &&
          other.attachmentId == this.attachmentId &&
          other.filename == this.filename &&
          other.content == this.content);
}

class AttachmentSearchCompanion extends UpdateCompanion<AttachmentSearchData> {
  final Value<String> attachmentId;
  final Value<String> filename;
  final Value<String> content;
  final Value<int> rowid;
  const AttachmentSearchCompanion({
    this.attachmentId = const Value.absent(),
    this.filename = const Value.absent(),
    this.content = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AttachmentSearchCompanion.insert({
    required String attachmentId,
    required String filename,
    required String content,
    this.rowid = const Value.absent(),
  }) : attachmentId = Value(attachmentId),
       filename = Value(filename),
       content = Value(content);
  static Insertable<AttachmentSearchData> custom({
    Expression<String>? attachmentId,
    Expression<String>? filename,
    Expression<String>? content,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (attachmentId != null) 'attachment_id': attachmentId,
      if (filename != null) 'filename': filename,
      if (content != null) 'content': content,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AttachmentSearchCompanion copyWith({
    Value<String>? attachmentId,
    Value<String>? filename,
    Value<String>? content,
    Value<int>? rowid,
  }) {
    return AttachmentSearchCompanion(
      attachmentId: attachmentId ?? this.attachmentId,
      filename: filename ?? this.filename,
      content: content ?? this.content,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (attachmentId.present) {
      map['attachment_id'] = Variable<String>(attachmentId.value);
    }
    if (filename.present) {
      map['filename'] = Variable<String>(filename.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AttachmentSearchCompanion(')
          ..write('attachmentId: $attachmentId, ')
          ..write('filename: $filename, ')
          ..write('content: $content, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $UsersTable extends Users with TableInfo<$UsersTable, User> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _spaceIdMeta = const VerificationMeta(
    'spaceId',
  );
  @override
  late final GeneratedColumn<String> spaceId = GeneratedColumn<String>(
    'space_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdByMeta = const VerificationMeta(
    'createdBy',
  );
  @override
  late final GeneratedColumn<String> createdBy = GeneratedColumn<String>(
    'created_by',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedByMeta = const VerificationMeta(
    'updatedBy',
  );
  @override
  late final GeneratedColumn<String> updatedBy = GeneratedColumn<String>(
    'updated_by',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _hlcMeta = const VerificationMeta('hlc');
  @override
  late final GeneratedColumn<String> hlc = GeneratedColumn<String>(
    'hlc',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedMeta = const VerificationMeta(
    'deleted',
  );
  @override
  late final GeneratedColumn<bool> deleted = GeneratedColumn<bool>(
    'deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _identityPublicKeyMeta = const VerificationMeta(
    'identityPublicKey',
  );
  @override
  late final GeneratedColumn<String> identityPublicKey =
      GeneratedColumn<String>(
        'identity_public_key',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    spaceId,
    createdAt,
    createdBy,
    updatedBy,
    hlc,
    deleted,
    identityPublicKey,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'users';
  @override
  VerificationContext validateIntegrity(
    Insertable<User> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('space_id')) {
      context.handle(
        _spaceIdMeta,
        spaceId.isAcceptableOrUnknown(data['space_id']!, _spaceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_spaceIdMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('created_by')) {
      context.handle(
        _createdByMeta,
        createdBy.isAcceptableOrUnknown(data['created_by']!, _createdByMeta),
      );
    } else if (isInserting) {
      context.missing(_createdByMeta);
    }
    if (data.containsKey('updated_by')) {
      context.handle(
        _updatedByMeta,
        updatedBy.isAcceptableOrUnknown(data['updated_by']!, _updatedByMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedByMeta);
    }
    if (data.containsKey('hlc')) {
      context.handle(
        _hlcMeta,
        hlc.isAcceptableOrUnknown(data['hlc']!, _hlcMeta),
      );
    } else if (isInserting) {
      context.missing(_hlcMeta);
    }
    if (data.containsKey('deleted')) {
      context.handle(
        _deletedMeta,
        deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta),
      );
    }
    if (data.containsKey('identity_public_key')) {
      context.handle(
        _identityPublicKeyMeta,
        identityPublicKey.isAcceptableOrUnknown(
          data['identity_public_key']!,
          _identityPublicKeyMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_identityPublicKeyMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  User map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return User(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      spaceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}space_id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      createdBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_by'],
      )!,
      updatedBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}updated_by'],
      )!,
      hlc: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}hlc'],
      )!,
      deleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}deleted'],
      )!,
      identityPublicKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}identity_public_key'],
      )!,
    );
  }

  @override
  $UsersTable createAlias(String alias) {
    return $UsersTable(attachedDatabase, alias);
  }
}

class User extends DataClass implements Insertable<User> {
  /// UUIDv7.
  final String id;

  /// The space this row belongs to (§5.0, D13).
  final String spaceId;
  final DateTime createdAt;

  /// User ID of the creator.
  final String createdBy;

  /// User ID of whoever made the latest change.
  final String updatedBy;

  /// Hybrid logical clock stamp of the latest change (see `sync/hlc.dart`).
  final String hlc;

  /// Tombstone flag. Rows are never hard-deleted until compaction.
  final bool deleted;

  /// Base64 Ed25519 public key.
  final String identityPublicKey;
  const User({
    required this.id,
    required this.spaceId,
    required this.createdAt,
    required this.createdBy,
    required this.updatedBy,
    required this.hlc,
    required this.deleted,
    required this.identityPublicKey,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['space_id'] = Variable<String>(spaceId);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['created_by'] = Variable<String>(createdBy);
    map['updated_by'] = Variable<String>(updatedBy);
    map['hlc'] = Variable<String>(hlc);
    map['deleted'] = Variable<bool>(deleted);
    map['identity_public_key'] = Variable<String>(identityPublicKey);
    return map;
  }

  UsersCompanion toCompanion(bool nullToAbsent) {
    return UsersCompanion(
      id: Value(id),
      spaceId: Value(spaceId),
      createdAt: Value(createdAt),
      createdBy: Value(createdBy),
      updatedBy: Value(updatedBy),
      hlc: Value(hlc),
      deleted: Value(deleted),
      identityPublicKey: Value(identityPublicKey),
    );
  }

  factory User.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return User(
      id: serializer.fromJson<String>(json['id']),
      spaceId: serializer.fromJson<String>(json['spaceId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      createdBy: serializer.fromJson<String>(json['createdBy']),
      updatedBy: serializer.fromJson<String>(json['updatedBy']),
      hlc: serializer.fromJson<String>(json['hlc']),
      deleted: serializer.fromJson<bool>(json['deleted']),
      identityPublicKey: serializer.fromJson<String>(json['identityPublicKey']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'spaceId': serializer.toJson<String>(spaceId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'createdBy': serializer.toJson<String>(createdBy),
      'updatedBy': serializer.toJson<String>(updatedBy),
      'hlc': serializer.toJson<String>(hlc),
      'deleted': serializer.toJson<bool>(deleted),
      'identityPublicKey': serializer.toJson<String>(identityPublicKey),
    };
  }

  User copyWith({
    String? id,
    String? spaceId,
    DateTime? createdAt,
    String? createdBy,
    String? updatedBy,
    String? hlc,
    bool? deleted,
    String? identityPublicKey,
  }) => User(
    id: id ?? this.id,
    spaceId: spaceId ?? this.spaceId,
    createdAt: createdAt ?? this.createdAt,
    createdBy: createdBy ?? this.createdBy,
    updatedBy: updatedBy ?? this.updatedBy,
    hlc: hlc ?? this.hlc,
    deleted: deleted ?? this.deleted,
    identityPublicKey: identityPublicKey ?? this.identityPublicKey,
  );
  User copyWithCompanion(UsersCompanion data) {
    return User(
      id: data.id.present ? data.id.value : this.id,
      spaceId: data.spaceId.present ? data.spaceId.value : this.spaceId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      createdBy: data.createdBy.present ? data.createdBy.value : this.createdBy,
      updatedBy: data.updatedBy.present ? data.updatedBy.value : this.updatedBy,
      hlc: data.hlc.present ? data.hlc.value : this.hlc,
      deleted: data.deleted.present ? data.deleted.value : this.deleted,
      identityPublicKey: data.identityPublicKey.present
          ? data.identityPublicKey.value
          : this.identityPublicKey,
    );
  }

  @override
  String toString() {
    return (StringBuffer('User(')
          ..write('id: $id, ')
          ..write('spaceId: $spaceId, ')
          ..write('createdAt: $createdAt, ')
          ..write('createdBy: $createdBy, ')
          ..write('updatedBy: $updatedBy, ')
          ..write('hlc: $hlc, ')
          ..write('deleted: $deleted, ')
          ..write('identityPublicKey: $identityPublicKey')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    spaceId,
    createdAt,
    createdBy,
    updatedBy,
    hlc,
    deleted,
    identityPublicKey,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is User &&
          other.id == this.id &&
          other.spaceId == this.spaceId &&
          other.createdAt == this.createdAt &&
          other.createdBy == this.createdBy &&
          other.updatedBy == this.updatedBy &&
          other.hlc == this.hlc &&
          other.deleted == this.deleted &&
          other.identityPublicKey == this.identityPublicKey);
}

class UsersCompanion extends UpdateCompanion<User> {
  final Value<String> id;
  final Value<String> spaceId;
  final Value<DateTime> createdAt;
  final Value<String> createdBy;
  final Value<String> updatedBy;
  final Value<String> hlc;
  final Value<bool> deleted;
  final Value<String> identityPublicKey;
  final Value<int> rowid;
  const UsersCompanion({
    this.id = const Value.absent(),
    this.spaceId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.createdBy = const Value.absent(),
    this.updatedBy = const Value.absent(),
    this.hlc = const Value.absent(),
    this.deleted = const Value.absent(),
    this.identityPublicKey = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UsersCompanion.insert({
    required String id,
    required String spaceId,
    required DateTime createdAt,
    required String createdBy,
    required String updatedBy,
    required String hlc,
    this.deleted = const Value.absent(),
    required String identityPublicKey,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       spaceId = Value(spaceId),
       createdAt = Value(createdAt),
       createdBy = Value(createdBy),
       updatedBy = Value(updatedBy),
       hlc = Value(hlc),
       identityPublicKey = Value(identityPublicKey);
  static Insertable<User> custom({
    Expression<String>? id,
    Expression<String>? spaceId,
    Expression<DateTime>? createdAt,
    Expression<String>? createdBy,
    Expression<String>? updatedBy,
    Expression<String>? hlc,
    Expression<bool>? deleted,
    Expression<String>? identityPublicKey,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (spaceId != null) 'space_id': spaceId,
      if (createdAt != null) 'created_at': createdAt,
      if (createdBy != null) 'created_by': createdBy,
      if (updatedBy != null) 'updated_by': updatedBy,
      if (hlc != null) 'hlc': hlc,
      if (deleted != null) 'deleted': deleted,
      if (identityPublicKey != null) 'identity_public_key': identityPublicKey,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UsersCompanion copyWith({
    Value<String>? id,
    Value<String>? spaceId,
    Value<DateTime>? createdAt,
    Value<String>? createdBy,
    Value<String>? updatedBy,
    Value<String>? hlc,
    Value<bool>? deleted,
    Value<String>? identityPublicKey,
    Value<int>? rowid,
  }) {
    return UsersCompanion(
      id: id ?? this.id,
      spaceId: spaceId ?? this.spaceId,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      updatedBy: updatedBy ?? this.updatedBy,
      hlc: hlc ?? this.hlc,
      deleted: deleted ?? this.deleted,
      identityPublicKey: identityPublicKey ?? this.identityPublicKey,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (spaceId.present) {
      map['space_id'] = Variable<String>(spaceId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (createdBy.present) {
      map['created_by'] = Variable<String>(createdBy.value);
    }
    if (updatedBy.present) {
      map['updated_by'] = Variable<String>(updatedBy.value);
    }
    if (hlc.present) {
      map['hlc'] = Variable<String>(hlc.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<bool>(deleted.value);
    }
    if (identityPublicKey.present) {
      map['identity_public_key'] = Variable<String>(identityPublicKey.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsersCompanion(')
          ..write('id: $id, ')
          ..write('spaceId: $spaceId, ')
          ..write('createdAt: $createdAt, ')
          ..write('createdBy: $createdBy, ')
          ..write('updatedBy: $updatedBy, ')
          ..write('hlc: $hlc, ')
          ..write('deleted: $deleted, ')
          ..write('identityPublicKey: $identityPublicKey, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SpacesTable extends Spaces with TableInfo<$SpacesTable, Space> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SpacesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _spaceIdMeta = const VerificationMeta(
    'spaceId',
  );
  @override
  late final GeneratedColumn<String> spaceId = GeneratedColumn<String>(
    'space_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdByMeta = const VerificationMeta(
    'createdBy',
  );
  @override
  late final GeneratedColumn<String> createdBy = GeneratedColumn<String>(
    'created_by',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedByMeta = const VerificationMeta(
    'updatedBy',
  );
  @override
  late final GeneratedColumn<String> updatedBy = GeneratedColumn<String>(
    'updated_by',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _hlcMeta = const VerificationMeta('hlc');
  @override
  late final GeneratedColumn<String> hlc = GeneratedColumn<String>(
    'hlc',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedMeta = const VerificationMeta(
    'deleted',
  );
  @override
  late final GeneratedColumn<bool> deleted = GeneratedColumn<bool>(
    'deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  late final GeneratedColumnWithTypeConverter<SpaceKind, String> kind =
      GeneratedColumn<String>(
        'kind',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<SpaceKind>($SpacesTable.$converterkind);
  static const VerificationMeta _rootNodeIdMeta = const VerificationMeta(
    'rootNodeId',
  );
  @override
  late final GeneratedColumn<String> rootNodeId = GeneratedColumn<String>(
    'root_node_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _mergedIntoSpaceIdMeta = const VerificationMeta(
    'mergedIntoSpaceId',
  );
  @override
  late final GeneratedColumn<String> mergedIntoSpaceId =
      GeneratedColumn<String>(
        'merged_into_space_id',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    spaceId,
    createdAt,
    createdBy,
    updatedBy,
    hlc,
    deleted,
    kind,
    rootNodeId,
    mergedIntoSpaceId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'spaces';
  @override
  VerificationContext validateIntegrity(
    Insertable<Space> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('space_id')) {
      context.handle(
        _spaceIdMeta,
        spaceId.isAcceptableOrUnknown(data['space_id']!, _spaceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_spaceIdMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('created_by')) {
      context.handle(
        _createdByMeta,
        createdBy.isAcceptableOrUnknown(data['created_by']!, _createdByMeta),
      );
    } else if (isInserting) {
      context.missing(_createdByMeta);
    }
    if (data.containsKey('updated_by')) {
      context.handle(
        _updatedByMeta,
        updatedBy.isAcceptableOrUnknown(data['updated_by']!, _updatedByMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedByMeta);
    }
    if (data.containsKey('hlc')) {
      context.handle(
        _hlcMeta,
        hlc.isAcceptableOrUnknown(data['hlc']!, _hlcMeta),
      );
    } else if (isInserting) {
      context.missing(_hlcMeta);
    }
    if (data.containsKey('deleted')) {
      context.handle(
        _deletedMeta,
        deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta),
      );
    }
    if (data.containsKey('root_node_id')) {
      context.handle(
        _rootNodeIdMeta,
        rootNodeId.isAcceptableOrUnknown(
          data['root_node_id']!,
          _rootNodeIdMeta,
        ),
      );
    }
    if (data.containsKey('merged_into_space_id')) {
      context.handle(
        _mergedIntoSpaceIdMeta,
        mergedIntoSpaceId.isAcceptableOrUnknown(
          data['merged_into_space_id']!,
          _mergedIntoSpaceIdMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Space map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Space(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      spaceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}space_id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      createdBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_by'],
      )!,
      updatedBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}updated_by'],
      )!,
      hlc: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}hlc'],
      )!,
      deleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}deleted'],
      )!,
      kind: $SpacesTable.$converterkind.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}kind'],
        )!,
      ),
      rootNodeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}root_node_id'],
      ),
      mergedIntoSpaceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}merged_into_space_id'],
      ),
    );
  }

  @override
  $SpacesTable createAlias(String alias) {
    return $SpacesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<SpaceKind, String, String> $converterkind =
      const EnumNameConverter<SpaceKind>(SpaceKind.values);
}

class Space extends DataClass implements Insertable<Space> {
  /// UUIDv7.
  final String id;

  /// The space this row belongs to (§5.0, D13).
  final String spaceId;
  final DateTime createdAt;

  /// User ID of the creator.
  final String createdBy;

  /// User ID of whoever made the latest change.
  final String updatedBy;

  /// Hybrid logical clock stamp of the latest change (see `sync/hlc.dart`).
  final String hlc;

  /// Tombstone flag. Rows are never hard-deleted until compaction.
  final bool deleted;
  final SpaceKind kind;

  /// Null until the space has a root node (the personal space has none).
  final String? rootNodeId;

  /// Set when a smaller share is absorbed into a larger one (§11.3).
  final String? mergedIntoSpaceId;
  const Space({
    required this.id,
    required this.spaceId,
    required this.createdAt,
    required this.createdBy,
    required this.updatedBy,
    required this.hlc,
    required this.deleted,
    required this.kind,
    this.rootNodeId,
    this.mergedIntoSpaceId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['space_id'] = Variable<String>(spaceId);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['created_by'] = Variable<String>(createdBy);
    map['updated_by'] = Variable<String>(updatedBy);
    map['hlc'] = Variable<String>(hlc);
    map['deleted'] = Variable<bool>(deleted);
    {
      map['kind'] = Variable<String>($SpacesTable.$converterkind.toSql(kind));
    }
    if (!nullToAbsent || rootNodeId != null) {
      map['root_node_id'] = Variable<String>(rootNodeId);
    }
    if (!nullToAbsent || mergedIntoSpaceId != null) {
      map['merged_into_space_id'] = Variable<String>(mergedIntoSpaceId);
    }
    return map;
  }

  SpacesCompanion toCompanion(bool nullToAbsent) {
    return SpacesCompanion(
      id: Value(id),
      spaceId: Value(spaceId),
      createdAt: Value(createdAt),
      createdBy: Value(createdBy),
      updatedBy: Value(updatedBy),
      hlc: Value(hlc),
      deleted: Value(deleted),
      kind: Value(kind),
      rootNodeId: rootNodeId == null && nullToAbsent
          ? const Value.absent()
          : Value(rootNodeId),
      mergedIntoSpaceId: mergedIntoSpaceId == null && nullToAbsent
          ? const Value.absent()
          : Value(mergedIntoSpaceId),
    );
  }

  factory Space.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Space(
      id: serializer.fromJson<String>(json['id']),
      spaceId: serializer.fromJson<String>(json['spaceId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      createdBy: serializer.fromJson<String>(json['createdBy']),
      updatedBy: serializer.fromJson<String>(json['updatedBy']),
      hlc: serializer.fromJson<String>(json['hlc']),
      deleted: serializer.fromJson<bool>(json['deleted']),
      kind: $SpacesTable.$converterkind.fromJson(
        serializer.fromJson<String>(json['kind']),
      ),
      rootNodeId: serializer.fromJson<String?>(json['rootNodeId']),
      mergedIntoSpaceId: serializer.fromJson<String?>(
        json['mergedIntoSpaceId'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'spaceId': serializer.toJson<String>(spaceId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'createdBy': serializer.toJson<String>(createdBy),
      'updatedBy': serializer.toJson<String>(updatedBy),
      'hlc': serializer.toJson<String>(hlc),
      'deleted': serializer.toJson<bool>(deleted),
      'kind': serializer.toJson<String>(
        $SpacesTable.$converterkind.toJson(kind),
      ),
      'rootNodeId': serializer.toJson<String?>(rootNodeId),
      'mergedIntoSpaceId': serializer.toJson<String?>(mergedIntoSpaceId),
    };
  }

  Space copyWith({
    String? id,
    String? spaceId,
    DateTime? createdAt,
    String? createdBy,
    String? updatedBy,
    String? hlc,
    bool? deleted,
    SpaceKind? kind,
    Value<String?> rootNodeId = const Value.absent(),
    Value<String?> mergedIntoSpaceId = const Value.absent(),
  }) => Space(
    id: id ?? this.id,
    spaceId: spaceId ?? this.spaceId,
    createdAt: createdAt ?? this.createdAt,
    createdBy: createdBy ?? this.createdBy,
    updatedBy: updatedBy ?? this.updatedBy,
    hlc: hlc ?? this.hlc,
    deleted: deleted ?? this.deleted,
    kind: kind ?? this.kind,
    rootNodeId: rootNodeId.present ? rootNodeId.value : this.rootNodeId,
    mergedIntoSpaceId: mergedIntoSpaceId.present
        ? mergedIntoSpaceId.value
        : this.mergedIntoSpaceId,
  );
  Space copyWithCompanion(SpacesCompanion data) {
    return Space(
      id: data.id.present ? data.id.value : this.id,
      spaceId: data.spaceId.present ? data.spaceId.value : this.spaceId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      createdBy: data.createdBy.present ? data.createdBy.value : this.createdBy,
      updatedBy: data.updatedBy.present ? data.updatedBy.value : this.updatedBy,
      hlc: data.hlc.present ? data.hlc.value : this.hlc,
      deleted: data.deleted.present ? data.deleted.value : this.deleted,
      kind: data.kind.present ? data.kind.value : this.kind,
      rootNodeId: data.rootNodeId.present
          ? data.rootNodeId.value
          : this.rootNodeId,
      mergedIntoSpaceId: data.mergedIntoSpaceId.present
          ? data.mergedIntoSpaceId.value
          : this.mergedIntoSpaceId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Space(')
          ..write('id: $id, ')
          ..write('spaceId: $spaceId, ')
          ..write('createdAt: $createdAt, ')
          ..write('createdBy: $createdBy, ')
          ..write('updatedBy: $updatedBy, ')
          ..write('hlc: $hlc, ')
          ..write('deleted: $deleted, ')
          ..write('kind: $kind, ')
          ..write('rootNodeId: $rootNodeId, ')
          ..write('mergedIntoSpaceId: $mergedIntoSpaceId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    spaceId,
    createdAt,
    createdBy,
    updatedBy,
    hlc,
    deleted,
    kind,
    rootNodeId,
    mergedIntoSpaceId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Space &&
          other.id == this.id &&
          other.spaceId == this.spaceId &&
          other.createdAt == this.createdAt &&
          other.createdBy == this.createdBy &&
          other.updatedBy == this.updatedBy &&
          other.hlc == this.hlc &&
          other.deleted == this.deleted &&
          other.kind == this.kind &&
          other.rootNodeId == this.rootNodeId &&
          other.mergedIntoSpaceId == this.mergedIntoSpaceId);
}

class SpacesCompanion extends UpdateCompanion<Space> {
  final Value<String> id;
  final Value<String> spaceId;
  final Value<DateTime> createdAt;
  final Value<String> createdBy;
  final Value<String> updatedBy;
  final Value<String> hlc;
  final Value<bool> deleted;
  final Value<SpaceKind> kind;
  final Value<String?> rootNodeId;
  final Value<String?> mergedIntoSpaceId;
  final Value<int> rowid;
  const SpacesCompanion({
    this.id = const Value.absent(),
    this.spaceId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.createdBy = const Value.absent(),
    this.updatedBy = const Value.absent(),
    this.hlc = const Value.absent(),
    this.deleted = const Value.absent(),
    this.kind = const Value.absent(),
    this.rootNodeId = const Value.absent(),
    this.mergedIntoSpaceId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SpacesCompanion.insert({
    required String id,
    required String spaceId,
    required DateTime createdAt,
    required String createdBy,
    required String updatedBy,
    required String hlc,
    this.deleted = const Value.absent(),
    required SpaceKind kind,
    this.rootNodeId = const Value.absent(),
    this.mergedIntoSpaceId = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       spaceId = Value(spaceId),
       createdAt = Value(createdAt),
       createdBy = Value(createdBy),
       updatedBy = Value(updatedBy),
       hlc = Value(hlc),
       kind = Value(kind);
  static Insertable<Space> custom({
    Expression<String>? id,
    Expression<String>? spaceId,
    Expression<DateTime>? createdAt,
    Expression<String>? createdBy,
    Expression<String>? updatedBy,
    Expression<String>? hlc,
    Expression<bool>? deleted,
    Expression<String>? kind,
    Expression<String>? rootNodeId,
    Expression<String>? mergedIntoSpaceId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (spaceId != null) 'space_id': spaceId,
      if (createdAt != null) 'created_at': createdAt,
      if (createdBy != null) 'created_by': createdBy,
      if (updatedBy != null) 'updated_by': updatedBy,
      if (hlc != null) 'hlc': hlc,
      if (deleted != null) 'deleted': deleted,
      if (kind != null) 'kind': kind,
      if (rootNodeId != null) 'root_node_id': rootNodeId,
      if (mergedIntoSpaceId != null) 'merged_into_space_id': mergedIntoSpaceId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SpacesCompanion copyWith({
    Value<String>? id,
    Value<String>? spaceId,
    Value<DateTime>? createdAt,
    Value<String>? createdBy,
    Value<String>? updatedBy,
    Value<String>? hlc,
    Value<bool>? deleted,
    Value<SpaceKind>? kind,
    Value<String?>? rootNodeId,
    Value<String?>? mergedIntoSpaceId,
    Value<int>? rowid,
  }) {
    return SpacesCompanion(
      id: id ?? this.id,
      spaceId: spaceId ?? this.spaceId,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      updatedBy: updatedBy ?? this.updatedBy,
      hlc: hlc ?? this.hlc,
      deleted: deleted ?? this.deleted,
      kind: kind ?? this.kind,
      rootNodeId: rootNodeId ?? this.rootNodeId,
      mergedIntoSpaceId: mergedIntoSpaceId ?? this.mergedIntoSpaceId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (spaceId.present) {
      map['space_id'] = Variable<String>(spaceId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (createdBy.present) {
      map['created_by'] = Variable<String>(createdBy.value);
    }
    if (updatedBy.present) {
      map['updated_by'] = Variable<String>(updatedBy.value);
    }
    if (hlc.present) {
      map['hlc'] = Variable<String>(hlc.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<bool>(deleted.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(
        $SpacesTable.$converterkind.toSql(kind.value),
      );
    }
    if (rootNodeId.present) {
      map['root_node_id'] = Variable<String>(rootNodeId.value);
    }
    if (mergedIntoSpaceId.present) {
      map['merged_into_space_id'] = Variable<String>(mergedIntoSpaceId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SpacesCompanion(')
          ..write('id: $id, ')
          ..write('spaceId: $spaceId, ')
          ..write('createdAt: $createdAt, ')
          ..write('createdBy: $createdBy, ')
          ..write('updatedBy: $updatedBy, ')
          ..write('hlc: $hlc, ')
          ..write('deleted: $deleted, ')
          ..write('kind: $kind, ')
          ..write('rootNodeId: $rootNodeId, ')
          ..write('mergedIntoSpaceId: $mergedIntoSpaceId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SpaceMembersTable extends SpaceMembers
    with TableInfo<$SpaceMembersTable, SpaceMember> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SpaceMembersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _spaceIdMeta = const VerificationMeta(
    'spaceId',
  );
  @override
  late final GeneratedColumn<String> spaceId = GeneratedColumn<String>(
    'space_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdByMeta = const VerificationMeta(
    'createdBy',
  );
  @override
  late final GeneratedColumn<String> createdBy = GeneratedColumn<String>(
    'created_by',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedByMeta = const VerificationMeta(
    'updatedBy',
  );
  @override
  late final GeneratedColumn<String> updatedBy = GeneratedColumn<String>(
    'updated_by',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _hlcMeta = const VerificationMeta('hlc');
  @override
  late final GeneratedColumn<String> hlc = GeneratedColumn<String>(
    'hlc',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedMeta = const VerificationMeta(
    'deleted',
  );
  @override
  late final GeneratedColumn<bool> deleted = GeneratedColumn<bool>(
    'deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<MemberRole, String> role =
      GeneratedColumn<String>(
        'role',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<MemberRole>($SpaceMembersTable.$converterrole);
  static const VerificationMeta _joinedAtMeta = const VerificationMeta(
    'joinedAt',
  );
  @override
  late final GeneratedColumn<DateTime> joinedAt = GeneratedColumn<DateTime>(
    'joined_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    spaceId,
    createdAt,
    createdBy,
    updatedBy,
    hlc,
    deleted,
    userId,
    role,
    joinedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'space_members';
  @override
  VerificationContext validateIntegrity(
    Insertable<SpaceMember> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('space_id')) {
      context.handle(
        _spaceIdMeta,
        spaceId.isAcceptableOrUnknown(data['space_id']!, _spaceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_spaceIdMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('created_by')) {
      context.handle(
        _createdByMeta,
        createdBy.isAcceptableOrUnknown(data['created_by']!, _createdByMeta),
      );
    } else if (isInserting) {
      context.missing(_createdByMeta);
    }
    if (data.containsKey('updated_by')) {
      context.handle(
        _updatedByMeta,
        updatedBy.isAcceptableOrUnknown(data['updated_by']!, _updatedByMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedByMeta);
    }
    if (data.containsKey('hlc')) {
      context.handle(
        _hlcMeta,
        hlc.isAcceptableOrUnknown(data['hlc']!, _hlcMeta),
      );
    } else if (isInserting) {
      context.missing(_hlcMeta);
    }
    if (data.containsKey('deleted')) {
      context.handle(
        _deletedMeta,
        deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta),
      );
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('joined_at')) {
      context.handle(
        _joinedAtMeta,
        joinedAt.isAcceptableOrUnknown(data['joined_at']!, _joinedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_joinedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {spaceId, userId},
  ];
  @override
  SpaceMember map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SpaceMember(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      spaceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}space_id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      createdBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_by'],
      )!,
      updatedBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}updated_by'],
      )!,
      hlc: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}hlc'],
      )!,
      deleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}deleted'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      role: $SpaceMembersTable.$converterrole.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}role'],
        )!,
      ),
      joinedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}joined_at'],
      )!,
    );
  }

  @override
  $SpaceMembersTable createAlias(String alias) {
    return $SpaceMembersTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<MemberRole, String, String> $converterrole =
      const EnumNameConverter<MemberRole>(MemberRole.values);
}

class SpaceMember extends DataClass implements Insertable<SpaceMember> {
  /// UUIDv7.
  final String id;

  /// The space this row belongs to (§5.0, D13).
  final String spaceId;
  final DateTime createdAt;

  /// User ID of the creator.
  final String createdBy;

  /// User ID of whoever made the latest change.
  final String updatedBy;

  /// Hybrid logical clock stamp of the latest change (see `sync/hlc.dart`).
  final String hlc;

  /// Tombstone flag. Rows are never hard-deleted until compaction.
  final bool deleted;
  final String userId;
  final MemberRole role;
  final DateTime joinedAt;
  const SpaceMember({
    required this.id,
    required this.spaceId,
    required this.createdAt,
    required this.createdBy,
    required this.updatedBy,
    required this.hlc,
    required this.deleted,
    required this.userId,
    required this.role,
    required this.joinedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['space_id'] = Variable<String>(spaceId);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['created_by'] = Variable<String>(createdBy);
    map['updated_by'] = Variable<String>(updatedBy);
    map['hlc'] = Variable<String>(hlc);
    map['deleted'] = Variable<bool>(deleted);
    map['user_id'] = Variable<String>(userId);
    {
      map['role'] = Variable<String>(
        $SpaceMembersTable.$converterrole.toSql(role),
      );
    }
    map['joined_at'] = Variable<DateTime>(joinedAt);
    return map;
  }

  SpaceMembersCompanion toCompanion(bool nullToAbsent) {
    return SpaceMembersCompanion(
      id: Value(id),
      spaceId: Value(spaceId),
      createdAt: Value(createdAt),
      createdBy: Value(createdBy),
      updatedBy: Value(updatedBy),
      hlc: Value(hlc),
      deleted: Value(deleted),
      userId: Value(userId),
      role: Value(role),
      joinedAt: Value(joinedAt),
    );
  }

  factory SpaceMember.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SpaceMember(
      id: serializer.fromJson<String>(json['id']),
      spaceId: serializer.fromJson<String>(json['spaceId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      createdBy: serializer.fromJson<String>(json['createdBy']),
      updatedBy: serializer.fromJson<String>(json['updatedBy']),
      hlc: serializer.fromJson<String>(json['hlc']),
      deleted: serializer.fromJson<bool>(json['deleted']),
      userId: serializer.fromJson<String>(json['userId']),
      role: $SpaceMembersTable.$converterrole.fromJson(
        serializer.fromJson<String>(json['role']),
      ),
      joinedAt: serializer.fromJson<DateTime>(json['joinedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'spaceId': serializer.toJson<String>(spaceId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'createdBy': serializer.toJson<String>(createdBy),
      'updatedBy': serializer.toJson<String>(updatedBy),
      'hlc': serializer.toJson<String>(hlc),
      'deleted': serializer.toJson<bool>(deleted),
      'userId': serializer.toJson<String>(userId),
      'role': serializer.toJson<String>(
        $SpaceMembersTable.$converterrole.toJson(role),
      ),
      'joinedAt': serializer.toJson<DateTime>(joinedAt),
    };
  }

  SpaceMember copyWith({
    String? id,
    String? spaceId,
    DateTime? createdAt,
    String? createdBy,
    String? updatedBy,
    String? hlc,
    bool? deleted,
    String? userId,
    MemberRole? role,
    DateTime? joinedAt,
  }) => SpaceMember(
    id: id ?? this.id,
    spaceId: spaceId ?? this.spaceId,
    createdAt: createdAt ?? this.createdAt,
    createdBy: createdBy ?? this.createdBy,
    updatedBy: updatedBy ?? this.updatedBy,
    hlc: hlc ?? this.hlc,
    deleted: deleted ?? this.deleted,
    userId: userId ?? this.userId,
    role: role ?? this.role,
    joinedAt: joinedAt ?? this.joinedAt,
  );
  SpaceMember copyWithCompanion(SpaceMembersCompanion data) {
    return SpaceMember(
      id: data.id.present ? data.id.value : this.id,
      spaceId: data.spaceId.present ? data.spaceId.value : this.spaceId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      createdBy: data.createdBy.present ? data.createdBy.value : this.createdBy,
      updatedBy: data.updatedBy.present ? data.updatedBy.value : this.updatedBy,
      hlc: data.hlc.present ? data.hlc.value : this.hlc,
      deleted: data.deleted.present ? data.deleted.value : this.deleted,
      userId: data.userId.present ? data.userId.value : this.userId,
      role: data.role.present ? data.role.value : this.role,
      joinedAt: data.joinedAt.present ? data.joinedAt.value : this.joinedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SpaceMember(')
          ..write('id: $id, ')
          ..write('spaceId: $spaceId, ')
          ..write('createdAt: $createdAt, ')
          ..write('createdBy: $createdBy, ')
          ..write('updatedBy: $updatedBy, ')
          ..write('hlc: $hlc, ')
          ..write('deleted: $deleted, ')
          ..write('userId: $userId, ')
          ..write('role: $role, ')
          ..write('joinedAt: $joinedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    spaceId,
    createdAt,
    createdBy,
    updatedBy,
    hlc,
    deleted,
    userId,
    role,
    joinedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SpaceMember &&
          other.id == this.id &&
          other.spaceId == this.spaceId &&
          other.createdAt == this.createdAt &&
          other.createdBy == this.createdBy &&
          other.updatedBy == this.updatedBy &&
          other.hlc == this.hlc &&
          other.deleted == this.deleted &&
          other.userId == this.userId &&
          other.role == this.role &&
          other.joinedAt == this.joinedAt);
}

class SpaceMembersCompanion extends UpdateCompanion<SpaceMember> {
  final Value<String> id;
  final Value<String> spaceId;
  final Value<DateTime> createdAt;
  final Value<String> createdBy;
  final Value<String> updatedBy;
  final Value<String> hlc;
  final Value<bool> deleted;
  final Value<String> userId;
  final Value<MemberRole> role;
  final Value<DateTime> joinedAt;
  final Value<int> rowid;
  const SpaceMembersCompanion({
    this.id = const Value.absent(),
    this.spaceId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.createdBy = const Value.absent(),
    this.updatedBy = const Value.absent(),
    this.hlc = const Value.absent(),
    this.deleted = const Value.absent(),
    this.userId = const Value.absent(),
    this.role = const Value.absent(),
    this.joinedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SpaceMembersCompanion.insert({
    required String id,
    required String spaceId,
    required DateTime createdAt,
    required String createdBy,
    required String updatedBy,
    required String hlc,
    this.deleted = const Value.absent(),
    required String userId,
    required MemberRole role,
    required DateTime joinedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       spaceId = Value(spaceId),
       createdAt = Value(createdAt),
       createdBy = Value(createdBy),
       updatedBy = Value(updatedBy),
       hlc = Value(hlc),
       userId = Value(userId),
       role = Value(role),
       joinedAt = Value(joinedAt);
  static Insertable<SpaceMember> custom({
    Expression<String>? id,
    Expression<String>? spaceId,
    Expression<DateTime>? createdAt,
    Expression<String>? createdBy,
    Expression<String>? updatedBy,
    Expression<String>? hlc,
    Expression<bool>? deleted,
    Expression<String>? userId,
    Expression<String>? role,
    Expression<DateTime>? joinedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (spaceId != null) 'space_id': spaceId,
      if (createdAt != null) 'created_at': createdAt,
      if (createdBy != null) 'created_by': createdBy,
      if (updatedBy != null) 'updated_by': updatedBy,
      if (hlc != null) 'hlc': hlc,
      if (deleted != null) 'deleted': deleted,
      if (userId != null) 'user_id': userId,
      if (role != null) 'role': role,
      if (joinedAt != null) 'joined_at': joinedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SpaceMembersCompanion copyWith({
    Value<String>? id,
    Value<String>? spaceId,
    Value<DateTime>? createdAt,
    Value<String>? createdBy,
    Value<String>? updatedBy,
    Value<String>? hlc,
    Value<bool>? deleted,
    Value<String>? userId,
    Value<MemberRole>? role,
    Value<DateTime>? joinedAt,
    Value<int>? rowid,
  }) {
    return SpaceMembersCompanion(
      id: id ?? this.id,
      spaceId: spaceId ?? this.spaceId,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      updatedBy: updatedBy ?? this.updatedBy,
      hlc: hlc ?? this.hlc,
      deleted: deleted ?? this.deleted,
      userId: userId ?? this.userId,
      role: role ?? this.role,
      joinedAt: joinedAt ?? this.joinedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (spaceId.present) {
      map['space_id'] = Variable<String>(spaceId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (createdBy.present) {
      map['created_by'] = Variable<String>(createdBy.value);
    }
    if (updatedBy.present) {
      map['updated_by'] = Variable<String>(updatedBy.value);
    }
    if (hlc.present) {
      map['hlc'] = Variable<String>(hlc.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<bool>(deleted.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(
        $SpaceMembersTable.$converterrole.toSql(role.value),
      );
    }
    if (joinedAt.present) {
      map['joined_at'] = Variable<DateTime>(joinedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SpaceMembersCompanion(')
          ..write('id: $id, ')
          ..write('spaceId: $spaceId, ')
          ..write('createdAt: $createdAt, ')
          ..write('createdBy: $createdBy, ')
          ..write('updatedBy: $updatedBy, ')
          ..write('hlc: $hlc, ')
          ..write('deleted: $deleted, ')
          ..write('userId: $userId, ')
          ..write('role: $role, ')
          ..write('joinedAt: $joinedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $OccurrenceCompletionsTable extends OccurrenceCompletions
    with TableInfo<$OccurrenceCompletionsTable, OccurrenceCompletion> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OccurrenceCompletionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _spaceIdMeta = const VerificationMeta(
    'spaceId',
  );
  @override
  late final GeneratedColumn<String> spaceId = GeneratedColumn<String>(
    'space_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdByMeta = const VerificationMeta(
    'createdBy',
  );
  @override
  late final GeneratedColumn<String> createdBy = GeneratedColumn<String>(
    'created_by',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedByMeta = const VerificationMeta(
    'updatedBy',
  );
  @override
  late final GeneratedColumn<String> updatedBy = GeneratedColumn<String>(
    'updated_by',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _hlcMeta = const VerificationMeta('hlc');
  @override
  late final GeneratedColumn<String> hlc = GeneratedColumn<String>(
    'hlc',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedMeta = const VerificationMeta(
    'deleted',
  );
  @override
  late final GeneratedColumn<bool> deleted = GeneratedColumn<bool>(
    'deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _nodeIdMeta = const VerificationMeta('nodeId');
  @override
  late final GeneratedColumn<String> nodeId = GeneratedColumn<String>(
    'node_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _occurrenceDateMeta = const VerificationMeta(
    'occurrenceDate',
  );
  @override
  late final GeneratedColumn<String> occurrenceDate = GeneratedColumn<String>(
    'occurrence_date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _completedByMeta = const VerificationMeta(
    'completedBy',
  );
  @override
  late final GeneratedColumn<String> completedBy = GeneratedColumn<String>(
    'completed_by',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _completedAtMeta = const VerificationMeta(
    'completedAt',
  );
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
    'completed_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    spaceId,
    createdAt,
    createdBy,
    updatedBy,
    hlc,
    deleted,
    nodeId,
    occurrenceDate,
    completedBy,
    completedAt,
    note,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'occurrence_completions';
  @override
  VerificationContext validateIntegrity(
    Insertable<OccurrenceCompletion> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('space_id')) {
      context.handle(
        _spaceIdMeta,
        spaceId.isAcceptableOrUnknown(data['space_id']!, _spaceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_spaceIdMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('created_by')) {
      context.handle(
        _createdByMeta,
        createdBy.isAcceptableOrUnknown(data['created_by']!, _createdByMeta),
      );
    } else if (isInserting) {
      context.missing(_createdByMeta);
    }
    if (data.containsKey('updated_by')) {
      context.handle(
        _updatedByMeta,
        updatedBy.isAcceptableOrUnknown(data['updated_by']!, _updatedByMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedByMeta);
    }
    if (data.containsKey('hlc')) {
      context.handle(
        _hlcMeta,
        hlc.isAcceptableOrUnknown(data['hlc']!, _hlcMeta),
      );
    } else if (isInserting) {
      context.missing(_hlcMeta);
    }
    if (data.containsKey('deleted')) {
      context.handle(
        _deletedMeta,
        deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta),
      );
    }
    if (data.containsKey('node_id')) {
      context.handle(
        _nodeIdMeta,
        nodeId.isAcceptableOrUnknown(data['node_id']!, _nodeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_nodeIdMeta);
    }
    if (data.containsKey('occurrence_date')) {
      context.handle(
        _occurrenceDateMeta,
        occurrenceDate.isAcceptableOrUnknown(
          data['occurrence_date']!,
          _occurrenceDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_occurrenceDateMeta);
    }
    if (data.containsKey('completed_by')) {
      context.handle(
        _completedByMeta,
        completedBy.isAcceptableOrUnknown(
          data['completed_by']!,
          _completedByMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_completedByMeta);
    }
    if (data.containsKey('completed_at')) {
      context.handle(
        _completedAtMeta,
        completedAt.isAcceptableOrUnknown(
          data['completed_at']!,
          _completedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_completedAtMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  OccurrenceCompletion map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OccurrenceCompletion(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      spaceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}space_id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      createdBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_by'],
      )!,
      updatedBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}updated_by'],
      )!,
      hlc: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}hlc'],
      )!,
      deleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}deleted'],
      )!,
      nodeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}node_id'],
      )!,
      occurrenceDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}occurrence_date'],
      )!,
      completedBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}completed_by'],
      )!,
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}completed_at'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
    );
  }

  @override
  $OccurrenceCompletionsTable createAlias(String alias) {
    return $OccurrenceCompletionsTable(attachedDatabase, alias);
  }
}

class OccurrenceCompletion extends DataClass
    implements Insertable<OccurrenceCompletion> {
  /// UUIDv7.
  final String id;

  /// The space this row belongs to (§5.0, D13).
  final String spaceId;
  final DateTime createdAt;

  /// User ID of the creator.
  final String createdBy;

  /// User ID of whoever made the latest change.
  final String updatedBy;

  /// Hybrid logical clock stamp of the latest change (see `sync/hlc.dart`).
  final String hlc;

  /// Tombstone flag. Rows are never hard-deleted until compaction.
  final bool deleted;
  final String nodeId;

  /// `YYYY-MM-DD`: the occurrence of the nearest repeating ancestor (or of
  /// the node itself) that this completion counts for.
  final String occurrenceDate;
  final String completedBy;
  final DateTime completedAt;
  final String? note;
  const OccurrenceCompletion({
    required this.id,
    required this.spaceId,
    required this.createdAt,
    required this.createdBy,
    required this.updatedBy,
    required this.hlc,
    required this.deleted,
    required this.nodeId,
    required this.occurrenceDate,
    required this.completedBy,
    required this.completedAt,
    this.note,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['space_id'] = Variable<String>(spaceId);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['created_by'] = Variable<String>(createdBy);
    map['updated_by'] = Variable<String>(updatedBy);
    map['hlc'] = Variable<String>(hlc);
    map['deleted'] = Variable<bool>(deleted);
    map['node_id'] = Variable<String>(nodeId);
    map['occurrence_date'] = Variable<String>(occurrenceDate);
    map['completed_by'] = Variable<String>(completedBy);
    map['completed_at'] = Variable<DateTime>(completedAt);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    return map;
  }

  OccurrenceCompletionsCompanion toCompanion(bool nullToAbsent) {
    return OccurrenceCompletionsCompanion(
      id: Value(id),
      spaceId: Value(spaceId),
      createdAt: Value(createdAt),
      createdBy: Value(createdBy),
      updatedBy: Value(updatedBy),
      hlc: Value(hlc),
      deleted: Value(deleted),
      nodeId: Value(nodeId),
      occurrenceDate: Value(occurrenceDate),
      completedBy: Value(completedBy),
      completedAt: Value(completedAt),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
    );
  }

  factory OccurrenceCompletion.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OccurrenceCompletion(
      id: serializer.fromJson<String>(json['id']),
      spaceId: serializer.fromJson<String>(json['spaceId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      createdBy: serializer.fromJson<String>(json['createdBy']),
      updatedBy: serializer.fromJson<String>(json['updatedBy']),
      hlc: serializer.fromJson<String>(json['hlc']),
      deleted: serializer.fromJson<bool>(json['deleted']),
      nodeId: serializer.fromJson<String>(json['nodeId']),
      occurrenceDate: serializer.fromJson<String>(json['occurrenceDate']),
      completedBy: serializer.fromJson<String>(json['completedBy']),
      completedAt: serializer.fromJson<DateTime>(json['completedAt']),
      note: serializer.fromJson<String?>(json['note']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'spaceId': serializer.toJson<String>(spaceId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'createdBy': serializer.toJson<String>(createdBy),
      'updatedBy': serializer.toJson<String>(updatedBy),
      'hlc': serializer.toJson<String>(hlc),
      'deleted': serializer.toJson<bool>(deleted),
      'nodeId': serializer.toJson<String>(nodeId),
      'occurrenceDate': serializer.toJson<String>(occurrenceDate),
      'completedBy': serializer.toJson<String>(completedBy),
      'completedAt': serializer.toJson<DateTime>(completedAt),
      'note': serializer.toJson<String?>(note),
    };
  }

  OccurrenceCompletion copyWith({
    String? id,
    String? spaceId,
    DateTime? createdAt,
    String? createdBy,
    String? updatedBy,
    String? hlc,
    bool? deleted,
    String? nodeId,
    String? occurrenceDate,
    String? completedBy,
    DateTime? completedAt,
    Value<String?> note = const Value.absent(),
  }) => OccurrenceCompletion(
    id: id ?? this.id,
    spaceId: spaceId ?? this.spaceId,
    createdAt: createdAt ?? this.createdAt,
    createdBy: createdBy ?? this.createdBy,
    updatedBy: updatedBy ?? this.updatedBy,
    hlc: hlc ?? this.hlc,
    deleted: deleted ?? this.deleted,
    nodeId: nodeId ?? this.nodeId,
    occurrenceDate: occurrenceDate ?? this.occurrenceDate,
    completedBy: completedBy ?? this.completedBy,
    completedAt: completedAt ?? this.completedAt,
    note: note.present ? note.value : this.note,
  );
  OccurrenceCompletion copyWithCompanion(OccurrenceCompletionsCompanion data) {
    return OccurrenceCompletion(
      id: data.id.present ? data.id.value : this.id,
      spaceId: data.spaceId.present ? data.spaceId.value : this.spaceId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      createdBy: data.createdBy.present ? data.createdBy.value : this.createdBy,
      updatedBy: data.updatedBy.present ? data.updatedBy.value : this.updatedBy,
      hlc: data.hlc.present ? data.hlc.value : this.hlc,
      deleted: data.deleted.present ? data.deleted.value : this.deleted,
      nodeId: data.nodeId.present ? data.nodeId.value : this.nodeId,
      occurrenceDate: data.occurrenceDate.present
          ? data.occurrenceDate.value
          : this.occurrenceDate,
      completedBy: data.completedBy.present
          ? data.completedBy.value
          : this.completedBy,
      completedAt: data.completedAt.present
          ? data.completedAt.value
          : this.completedAt,
      note: data.note.present ? data.note.value : this.note,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OccurrenceCompletion(')
          ..write('id: $id, ')
          ..write('spaceId: $spaceId, ')
          ..write('createdAt: $createdAt, ')
          ..write('createdBy: $createdBy, ')
          ..write('updatedBy: $updatedBy, ')
          ..write('hlc: $hlc, ')
          ..write('deleted: $deleted, ')
          ..write('nodeId: $nodeId, ')
          ..write('occurrenceDate: $occurrenceDate, ')
          ..write('completedBy: $completedBy, ')
          ..write('completedAt: $completedAt, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    spaceId,
    createdAt,
    createdBy,
    updatedBy,
    hlc,
    deleted,
    nodeId,
    occurrenceDate,
    completedBy,
    completedAt,
    note,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OccurrenceCompletion &&
          other.id == this.id &&
          other.spaceId == this.spaceId &&
          other.createdAt == this.createdAt &&
          other.createdBy == this.createdBy &&
          other.updatedBy == this.updatedBy &&
          other.hlc == this.hlc &&
          other.deleted == this.deleted &&
          other.nodeId == this.nodeId &&
          other.occurrenceDate == this.occurrenceDate &&
          other.completedBy == this.completedBy &&
          other.completedAt == this.completedAt &&
          other.note == this.note);
}

class OccurrenceCompletionsCompanion
    extends UpdateCompanion<OccurrenceCompletion> {
  final Value<String> id;
  final Value<String> spaceId;
  final Value<DateTime> createdAt;
  final Value<String> createdBy;
  final Value<String> updatedBy;
  final Value<String> hlc;
  final Value<bool> deleted;
  final Value<String> nodeId;
  final Value<String> occurrenceDate;
  final Value<String> completedBy;
  final Value<DateTime> completedAt;
  final Value<String?> note;
  final Value<int> rowid;
  const OccurrenceCompletionsCompanion({
    this.id = const Value.absent(),
    this.spaceId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.createdBy = const Value.absent(),
    this.updatedBy = const Value.absent(),
    this.hlc = const Value.absent(),
    this.deleted = const Value.absent(),
    this.nodeId = const Value.absent(),
    this.occurrenceDate = const Value.absent(),
    this.completedBy = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.note = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  OccurrenceCompletionsCompanion.insert({
    required String id,
    required String spaceId,
    required DateTime createdAt,
    required String createdBy,
    required String updatedBy,
    required String hlc,
    this.deleted = const Value.absent(),
    required String nodeId,
    required String occurrenceDate,
    required String completedBy,
    required DateTime completedAt,
    this.note = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       spaceId = Value(spaceId),
       createdAt = Value(createdAt),
       createdBy = Value(createdBy),
       updatedBy = Value(updatedBy),
       hlc = Value(hlc),
       nodeId = Value(nodeId),
       occurrenceDate = Value(occurrenceDate),
       completedBy = Value(completedBy),
       completedAt = Value(completedAt);
  static Insertable<OccurrenceCompletion> custom({
    Expression<String>? id,
    Expression<String>? spaceId,
    Expression<DateTime>? createdAt,
    Expression<String>? createdBy,
    Expression<String>? updatedBy,
    Expression<String>? hlc,
    Expression<bool>? deleted,
    Expression<String>? nodeId,
    Expression<String>? occurrenceDate,
    Expression<String>? completedBy,
    Expression<DateTime>? completedAt,
    Expression<String>? note,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (spaceId != null) 'space_id': spaceId,
      if (createdAt != null) 'created_at': createdAt,
      if (createdBy != null) 'created_by': createdBy,
      if (updatedBy != null) 'updated_by': updatedBy,
      if (hlc != null) 'hlc': hlc,
      if (deleted != null) 'deleted': deleted,
      if (nodeId != null) 'node_id': nodeId,
      if (occurrenceDate != null) 'occurrence_date': occurrenceDate,
      if (completedBy != null) 'completed_by': completedBy,
      if (completedAt != null) 'completed_at': completedAt,
      if (note != null) 'note': note,
      if (rowid != null) 'rowid': rowid,
    });
  }

  OccurrenceCompletionsCompanion copyWith({
    Value<String>? id,
    Value<String>? spaceId,
    Value<DateTime>? createdAt,
    Value<String>? createdBy,
    Value<String>? updatedBy,
    Value<String>? hlc,
    Value<bool>? deleted,
    Value<String>? nodeId,
    Value<String>? occurrenceDate,
    Value<String>? completedBy,
    Value<DateTime>? completedAt,
    Value<String?>? note,
    Value<int>? rowid,
  }) {
    return OccurrenceCompletionsCompanion(
      id: id ?? this.id,
      spaceId: spaceId ?? this.spaceId,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      updatedBy: updatedBy ?? this.updatedBy,
      hlc: hlc ?? this.hlc,
      deleted: deleted ?? this.deleted,
      nodeId: nodeId ?? this.nodeId,
      occurrenceDate: occurrenceDate ?? this.occurrenceDate,
      completedBy: completedBy ?? this.completedBy,
      completedAt: completedAt ?? this.completedAt,
      note: note ?? this.note,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (spaceId.present) {
      map['space_id'] = Variable<String>(spaceId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (createdBy.present) {
      map['created_by'] = Variable<String>(createdBy.value);
    }
    if (updatedBy.present) {
      map['updated_by'] = Variable<String>(updatedBy.value);
    }
    if (hlc.present) {
      map['hlc'] = Variable<String>(hlc.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<bool>(deleted.value);
    }
    if (nodeId.present) {
      map['node_id'] = Variable<String>(nodeId.value);
    }
    if (occurrenceDate.present) {
      map['occurrence_date'] = Variable<String>(occurrenceDate.value);
    }
    if (completedBy.present) {
      map['completed_by'] = Variable<String>(completedBy.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OccurrenceCompletionsCompanion(')
          ..write('id: $id, ')
          ..write('spaceId: $spaceId, ')
          ..write('createdAt: $createdAt, ')
          ..write('createdBy: $createdBy, ')
          ..write('updatedBy: $updatedBy, ')
          ..write('hlc: $hlc, ')
          ..write('deleted: $deleted, ')
          ..write('nodeId: $nodeId, ')
          ..write('occurrenceDate: $occurrenceDate, ')
          ..write('completedBy: $completedBy, ')
          ..write('completedAt: $completedAt, ')
          ..write('note: $note, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PlacementsTable extends Placements
    with TableInfo<$PlacementsTable, Placement> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlacementsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _spaceIdMeta = const VerificationMeta(
    'spaceId',
  );
  @override
  late final GeneratedColumn<String> spaceId = GeneratedColumn<String>(
    'space_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdByMeta = const VerificationMeta(
    'createdBy',
  );
  @override
  late final GeneratedColumn<String> createdBy = GeneratedColumn<String>(
    'created_by',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedByMeta = const VerificationMeta(
    'updatedBy',
  );
  @override
  late final GeneratedColumn<String> updatedBy = GeneratedColumn<String>(
    'updated_by',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _hlcMeta = const VerificationMeta('hlc');
  @override
  late final GeneratedColumn<String> hlc = GeneratedColumn<String>(
    'hlc',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedMeta = const VerificationMeta(
    'deleted',
  );
  @override
  late final GeneratedColumn<bool> deleted = GeneratedColumn<bool>(
    'deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _nodeIdMeta = const VerificationMeta('nodeId');
  @override
  late final GeneratedColumn<String> nodeId = GeneratedColumn<String>(
    'node_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _parentNodeIdMeta = const VerificationMeta(
    'parentNodeId',
  );
  @override
  late final GeneratedColumn<String> parentNodeId = GeneratedColumn<String>(
    'parent_node_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sortKeyMeta = const VerificationMeta(
    'sortKey',
  );
  @override
  late final GeneratedColumn<String> sortKey = GeneratedColumn<String>(
    'sort_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    spaceId,
    createdAt,
    createdBy,
    updatedBy,
    hlc,
    deleted,
    nodeId,
    parentNodeId,
    sortKey,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'placements';
  @override
  VerificationContext validateIntegrity(
    Insertable<Placement> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('space_id')) {
      context.handle(
        _spaceIdMeta,
        spaceId.isAcceptableOrUnknown(data['space_id']!, _spaceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_spaceIdMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('created_by')) {
      context.handle(
        _createdByMeta,
        createdBy.isAcceptableOrUnknown(data['created_by']!, _createdByMeta),
      );
    } else if (isInserting) {
      context.missing(_createdByMeta);
    }
    if (data.containsKey('updated_by')) {
      context.handle(
        _updatedByMeta,
        updatedBy.isAcceptableOrUnknown(data['updated_by']!, _updatedByMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedByMeta);
    }
    if (data.containsKey('hlc')) {
      context.handle(
        _hlcMeta,
        hlc.isAcceptableOrUnknown(data['hlc']!, _hlcMeta),
      );
    } else if (isInserting) {
      context.missing(_hlcMeta);
    }
    if (data.containsKey('deleted')) {
      context.handle(
        _deletedMeta,
        deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta),
      );
    }
    if (data.containsKey('node_id')) {
      context.handle(
        _nodeIdMeta,
        nodeId.isAcceptableOrUnknown(data['node_id']!, _nodeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_nodeIdMeta);
    }
    if (data.containsKey('parent_node_id')) {
      context.handle(
        _parentNodeIdMeta,
        parentNodeId.isAcceptableOrUnknown(
          data['parent_node_id']!,
          _parentNodeIdMeta,
        ),
      );
    }
    if (data.containsKey('sort_key')) {
      context.handle(
        _sortKeyMeta,
        sortKey.isAcceptableOrUnknown(data['sort_key']!, _sortKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_sortKeyMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Placement map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Placement(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      spaceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}space_id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      createdBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_by'],
      )!,
      updatedBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}updated_by'],
      )!,
      hlc: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}hlc'],
      )!,
      deleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}deleted'],
      )!,
      nodeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}node_id'],
      )!,
      parentNodeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}parent_node_id'],
      ),
      sortKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sort_key'],
      )!,
    );
  }

  @override
  $PlacementsTable createAlias(String alias) {
    return $PlacementsTable(attachedDatabase, alias);
  }
}

class Placement extends DataClass implements Insertable<Placement> {
  /// UUIDv7.
  final String id;

  /// The space this row belongs to (§5.0, D13).
  final String spaceId;
  final DateTime createdAt;

  /// User ID of the creator.
  final String createdBy;

  /// User ID of whoever made the latest change.
  final String updatedBy;

  /// Hybrid logical clock stamp of the latest change (see `sync/hlc.dart`).
  final String hlc;

  /// Tombstone flag. Rows are never hard-deleted until compaction.
  final bool deleted;
  final String nodeId;

  /// Where the shortcut shows; null = the top level.
  final String? parentNodeId;

  /// Order among the parent's children (real ones and shortcuts share one
  /// key space).
  final String sortKey;
  const Placement({
    required this.id,
    required this.spaceId,
    required this.createdAt,
    required this.createdBy,
    required this.updatedBy,
    required this.hlc,
    required this.deleted,
    required this.nodeId,
    this.parentNodeId,
    required this.sortKey,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['space_id'] = Variable<String>(spaceId);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['created_by'] = Variable<String>(createdBy);
    map['updated_by'] = Variable<String>(updatedBy);
    map['hlc'] = Variable<String>(hlc);
    map['deleted'] = Variable<bool>(deleted);
    map['node_id'] = Variable<String>(nodeId);
    if (!nullToAbsent || parentNodeId != null) {
      map['parent_node_id'] = Variable<String>(parentNodeId);
    }
    map['sort_key'] = Variable<String>(sortKey);
    return map;
  }

  PlacementsCompanion toCompanion(bool nullToAbsent) {
    return PlacementsCompanion(
      id: Value(id),
      spaceId: Value(spaceId),
      createdAt: Value(createdAt),
      createdBy: Value(createdBy),
      updatedBy: Value(updatedBy),
      hlc: Value(hlc),
      deleted: Value(deleted),
      nodeId: Value(nodeId),
      parentNodeId: parentNodeId == null && nullToAbsent
          ? const Value.absent()
          : Value(parentNodeId),
      sortKey: Value(sortKey),
    );
  }

  factory Placement.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Placement(
      id: serializer.fromJson<String>(json['id']),
      spaceId: serializer.fromJson<String>(json['spaceId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      createdBy: serializer.fromJson<String>(json['createdBy']),
      updatedBy: serializer.fromJson<String>(json['updatedBy']),
      hlc: serializer.fromJson<String>(json['hlc']),
      deleted: serializer.fromJson<bool>(json['deleted']),
      nodeId: serializer.fromJson<String>(json['nodeId']),
      parentNodeId: serializer.fromJson<String?>(json['parentNodeId']),
      sortKey: serializer.fromJson<String>(json['sortKey']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'spaceId': serializer.toJson<String>(spaceId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'createdBy': serializer.toJson<String>(createdBy),
      'updatedBy': serializer.toJson<String>(updatedBy),
      'hlc': serializer.toJson<String>(hlc),
      'deleted': serializer.toJson<bool>(deleted),
      'nodeId': serializer.toJson<String>(nodeId),
      'parentNodeId': serializer.toJson<String?>(parentNodeId),
      'sortKey': serializer.toJson<String>(sortKey),
    };
  }

  Placement copyWith({
    String? id,
    String? spaceId,
    DateTime? createdAt,
    String? createdBy,
    String? updatedBy,
    String? hlc,
    bool? deleted,
    String? nodeId,
    Value<String?> parentNodeId = const Value.absent(),
    String? sortKey,
  }) => Placement(
    id: id ?? this.id,
    spaceId: spaceId ?? this.spaceId,
    createdAt: createdAt ?? this.createdAt,
    createdBy: createdBy ?? this.createdBy,
    updatedBy: updatedBy ?? this.updatedBy,
    hlc: hlc ?? this.hlc,
    deleted: deleted ?? this.deleted,
    nodeId: nodeId ?? this.nodeId,
    parentNodeId: parentNodeId.present ? parentNodeId.value : this.parentNodeId,
    sortKey: sortKey ?? this.sortKey,
  );
  Placement copyWithCompanion(PlacementsCompanion data) {
    return Placement(
      id: data.id.present ? data.id.value : this.id,
      spaceId: data.spaceId.present ? data.spaceId.value : this.spaceId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      createdBy: data.createdBy.present ? data.createdBy.value : this.createdBy,
      updatedBy: data.updatedBy.present ? data.updatedBy.value : this.updatedBy,
      hlc: data.hlc.present ? data.hlc.value : this.hlc,
      deleted: data.deleted.present ? data.deleted.value : this.deleted,
      nodeId: data.nodeId.present ? data.nodeId.value : this.nodeId,
      parentNodeId: data.parentNodeId.present
          ? data.parentNodeId.value
          : this.parentNodeId,
      sortKey: data.sortKey.present ? data.sortKey.value : this.sortKey,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Placement(')
          ..write('id: $id, ')
          ..write('spaceId: $spaceId, ')
          ..write('createdAt: $createdAt, ')
          ..write('createdBy: $createdBy, ')
          ..write('updatedBy: $updatedBy, ')
          ..write('hlc: $hlc, ')
          ..write('deleted: $deleted, ')
          ..write('nodeId: $nodeId, ')
          ..write('parentNodeId: $parentNodeId, ')
          ..write('sortKey: $sortKey')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    spaceId,
    createdAt,
    createdBy,
    updatedBy,
    hlc,
    deleted,
    nodeId,
    parentNodeId,
    sortKey,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Placement &&
          other.id == this.id &&
          other.spaceId == this.spaceId &&
          other.createdAt == this.createdAt &&
          other.createdBy == this.createdBy &&
          other.updatedBy == this.updatedBy &&
          other.hlc == this.hlc &&
          other.deleted == this.deleted &&
          other.nodeId == this.nodeId &&
          other.parentNodeId == this.parentNodeId &&
          other.sortKey == this.sortKey);
}

class PlacementsCompanion extends UpdateCompanion<Placement> {
  final Value<String> id;
  final Value<String> spaceId;
  final Value<DateTime> createdAt;
  final Value<String> createdBy;
  final Value<String> updatedBy;
  final Value<String> hlc;
  final Value<bool> deleted;
  final Value<String> nodeId;
  final Value<String?> parentNodeId;
  final Value<String> sortKey;
  final Value<int> rowid;
  const PlacementsCompanion({
    this.id = const Value.absent(),
    this.spaceId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.createdBy = const Value.absent(),
    this.updatedBy = const Value.absent(),
    this.hlc = const Value.absent(),
    this.deleted = const Value.absent(),
    this.nodeId = const Value.absent(),
    this.parentNodeId = const Value.absent(),
    this.sortKey = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PlacementsCompanion.insert({
    required String id,
    required String spaceId,
    required DateTime createdAt,
    required String createdBy,
    required String updatedBy,
    required String hlc,
    this.deleted = const Value.absent(),
    required String nodeId,
    this.parentNodeId = const Value.absent(),
    required String sortKey,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       spaceId = Value(spaceId),
       createdAt = Value(createdAt),
       createdBy = Value(createdBy),
       updatedBy = Value(updatedBy),
       hlc = Value(hlc),
       nodeId = Value(nodeId),
       sortKey = Value(sortKey);
  static Insertable<Placement> custom({
    Expression<String>? id,
    Expression<String>? spaceId,
    Expression<DateTime>? createdAt,
    Expression<String>? createdBy,
    Expression<String>? updatedBy,
    Expression<String>? hlc,
    Expression<bool>? deleted,
    Expression<String>? nodeId,
    Expression<String>? parentNodeId,
    Expression<String>? sortKey,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (spaceId != null) 'space_id': spaceId,
      if (createdAt != null) 'created_at': createdAt,
      if (createdBy != null) 'created_by': createdBy,
      if (updatedBy != null) 'updated_by': updatedBy,
      if (hlc != null) 'hlc': hlc,
      if (deleted != null) 'deleted': deleted,
      if (nodeId != null) 'node_id': nodeId,
      if (parentNodeId != null) 'parent_node_id': parentNodeId,
      if (sortKey != null) 'sort_key': sortKey,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PlacementsCompanion copyWith({
    Value<String>? id,
    Value<String>? spaceId,
    Value<DateTime>? createdAt,
    Value<String>? createdBy,
    Value<String>? updatedBy,
    Value<String>? hlc,
    Value<bool>? deleted,
    Value<String>? nodeId,
    Value<String?>? parentNodeId,
    Value<String>? sortKey,
    Value<int>? rowid,
  }) {
    return PlacementsCompanion(
      id: id ?? this.id,
      spaceId: spaceId ?? this.spaceId,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      updatedBy: updatedBy ?? this.updatedBy,
      hlc: hlc ?? this.hlc,
      deleted: deleted ?? this.deleted,
      nodeId: nodeId ?? this.nodeId,
      parentNodeId: parentNodeId ?? this.parentNodeId,
      sortKey: sortKey ?? this.sortKey,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (spaceId.present) {
      map['space_id'] = Variable<String>(spaceId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (createdBy.present) {
      map['created_by'] = Variable<String>(createdBy.value);
    }
    if (updatedBy.present) {
      map['updated_by'] = Variable<String>(updatedBy.value);
    }
    if (hlc.present) {
      map['hlc'] = Variable<String>(hlc.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<bool>(deleted.value);
    }
    if (nodeId.present) {
      map['node_id'] = Variable<String>(nodeId.value);
    }
    if (parentNodeId.present) {
      map['parent_node_id'] = Variable<String>(parentNodeId.value);
    }
    if (sortKey.present) {
      map['sort_key'] = Variable<String>(sortKey.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlacementsCompanion(')
          ..write('id: $id, ')
          ..write('spaceId: $spaceId, ')
          ..write('createdAt: $createdAt, ')
          ..write('createdBy: $createdBy, ')
          ..write('updatedBy: $updatedBy, ')
          ..write('hlc: $hlc, ')
          ..write('deleted: $deleted, ')
          ..write('nodeId: $nodeId, ')
          ..write('parentNodeId: $parentNodeId, ')
          ..write('sortKey: $sortKey, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LinksTable extends Links with TableInfo<$LinksTable, Link> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LinksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _spaceIdMeta = const VerificationMeta(
    'spaceId',
  );
  @override
  late final GeneratedColumn<String> spaceId = GeneratedColumn<String>(
    'space_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdByMeta = const VerificationMeta(
    'createdBy',
  );
  @override
  late final GeneratedColumn<String> createdBy = GeneratedColumn<String>(
    'created_by',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedByMeta = const VerificationMeta(
    'updatedBy',
  );
  @override
  late final GeneratedColumn<String> updatedBy = GeneratedColumn<String>(
    'updated_by',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _hlcMeta = const VerificationMeta('hlc');
  @override
  late final GeneratedColumn<String> hlc = GeneratedColumn<String>(
    'hlc',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedMeta = const VerificationMeta(
    'deleted',
  );
  @override
  late final GeneratedColumn<bool> deleted = GeneratedColumn<bool>(
    'deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _fromNodeIdMeta = const VerificationMeta(
    'fromNodeId',
  );
  @override
  late final GeneratedColumn<String> fromNodeId = GeneratedColumn<String>(
    'from_node_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<LinkKind, String> targetKind =
      GeneratedColumn<String>(
        'target_kind',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<LinkKind>($LinksTable.$convertertargetKind);
  static const VerificationMeta _targetIdMeta = const VerificationMeta(
    'targetId',
  );
  @override
  late final GeneratedColumn<String> targetId = GeneratedColumn<String>(
    'target_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _urlMeta = const VerificationMeta('url');
  @override
  late final GeneratedColumn<String> url = GeneratedColumn<String>(
    'url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
    'label',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<LinkOrigin, String> origin =
      GeneratedColumn<String>(
        'origin',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<LinkOrigin>($LinksTable.$converterorigin);
  @override
  List<GeneratedColumn> get $columns => [
    id,
    spaceId,
    createdAt,
    createdBy,
    updatedBy,
    hlc,
    deleted,
    fromNodeId,
    targetKind,
    targetId,
    url,
    label,
    origin,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'links';
  @override
  VerificationContext validateIntegrity(
    Insertable<Link> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('space_id')) {
      context.handle(
        _spaceIdMeta,
        spaceId.isAcceptableOrUnknown(data['space_id']!, _spaceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_spaceIdMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('created_by')) {
      context.handle(
        _createdByMeta,
        createdBy.isAcceptableOrUnknown(data['created_by']!, _createdByMeta),
      );
    } else if (isInserting) {
      context.missing(_createdByMeta);
    }
    if (data.containsKey('updated_by')) {
      context.handle(
        _updatedByMeta,
        updatedBy.isAcceptableOrUnknown(data['updated_by']!, _updatedByMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedByMeta);
    }
    if (data.containsKey('hlc')) {
      context.handle(
        _hlcMeta,
        hlc.isAcceptableOrUnknown(data['hlc']!, _hlcMeta),
      );
    } else if (isInserting) {
      context.missing(_hlcMeta);
    }
    if (data.containsKey('deleted')) {
      context.handle(
        _deletedMeta,
        deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta),
      );
    }
    if (data.containsKey('from_node_id')) {
      context.handle(
        _fromNodeIdMeta,
        fromNodeId.isAcceptableOrUnknown(
          data['from_node_id']!,
          _fromNodeIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_fromNodeIdMeta);
    }
    if (data.containsKey('target_id')) {
      context.handle(
        _targetIdMeta,
        targetId.isAcceptableOrUnknown(data['target_id']!, _targetIdMeta),
      );
    }
    if (data.containsKey('url')) {
      context.handle(
        _urlMeta,
        url.isAcceptableOrUnknown(data['url']!, _urlMeta),
      );
    }
    if (data.containsKey('label')) {
      context.handle(
        _labelMeta,
        label.isAcceptableOrUnknown(data['label']!, _labelMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Link map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Link(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      spaceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}space_id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      createdBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_by'],
      )!,
      updatedBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}updated_by'],
      )!,
      hlc: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}hlc'],
      )!,
      deleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}deleted'],
      )!,
      fromNodeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}from_node_id'],
      )!,
      targetKind: $LinksTable.$convertertargetKind.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}target_kind'],
        )!,
      ),
      targetId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}target_id'],
      ),
      url: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}url'],
      ),
      label: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}label'],
      ),
      origin: $LinksTable.$converterorigin.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}origin'],
        )!,
      ),
    );
  }

  @override
  $LinksTable createAlias(String alias) {
    return $LinksTable(attachedDatabase, alias);
  }

  static TypeConverter<LinkKind, String> $convertertargetKind =
      const TolerantEnumConverter(LinkKind.values, LinkKind.node);
  static TypeConverter<LinkOrigin, String> $converterorigin =
      const TolerantEnumConverter(LinkOrigin.values, LinkOrigin.attached);
}

class Link extends DataClass implements Insertable<Link> {
  /// UUIDv7.
  final String id;

  /// The space this row belongs to (§5.0, D13).
  final String spaceId;
  final DateTime createdAt;

  /// User ID of the creator.
  final String createdBy;

  /// User ID of whoever made the latest change.
  final String updatedBy;

  /// Hybrid logical clock stamp of the latest change (see `sync/hlc.dart`).
  final String hlc;

  /// Tombstone flag. Rows are never hard-deleted until compaction.
  final bool deleted;
  final String fromNodeId;
  final LinkKind targetKind;

  /// The linked node (for `note`, the note node). Null for `url`.
  final String? targetId;
  final String? url;
  final String? label;
  final LinkOrigin origin;
  const Link({
    required this.id,
    required this.spaceId,
    required this.createdAt,
    required this.createdBy,
    required this.updatedBy,
    required this.hlc,
    required this.deleted,
    required this.fromNodeId,
    required this.targetKind,
    this.targetId,
    this.url,
    this.label,
    required this.origin,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['space_id'] = Variable<String>(spaceId);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['created_by'] = Variable<String>(createdBy);
    map['updated_by'] = Variable<String>(updatedBy);
    map['hlc'] = Variable<String>(hlc);
    map['deleted'] = Variable<bool>(deleted);
    map['from_node_id'] = Variable<String>(fromNodeId);
    {
      map['target_kind'] = Variable<String>(
        $LinksTable.$convertertargetKind.toSql(targetKind),
      );
    }
    if (!nullToAbsent || targetId != null) {
      map['target_id'] = Variable<String>(targetId);
    }
    if (!nullToAbsent || url != null) {
      map['url'] = Variable<String>(url);
    }
    if (!nullToAbsent || label != null) {
      map['label'] = Variable<String>(label);
    }
    {
      map['origin'] = Variable<String>(
        $LinksTable.$converterorigin.toSql(origin),
      );
    }
    return map;
  }

  LinksCompanion toCompanion(bool nullToAbsent) {
    return LinksCompanion(
      id: Value(id),
      spaceId: Value(spaceId),
      createdAt: Value(createdAt),
      createdBy: Value(createdBy),
      updatedBy: Value(updatedBy),
      hlc: Value(hlc),
      deleted: Value(deleted),
      fromNodeId: Value(fromNodeId),
      targetKind: Value(targetKind),
      targetId: targetId == null && nullToAbsent
          ? const Value.absent()
          : Value(targetId),
      url: url == null && nullToAbsent ? const Value.absent() : Value(url),
      label: label == null && nullToAbsent
          ? const Value.absent()
          : Value(label),
      origin: Value(origin),
    );
  }

  factory Link.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Link(
      id: serializer.fromJson<String>(json['id']),
      spaceId: serializer.fromJson<String>(json['spaceId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      createdBy: serializer.fromJson<String>(json['createdBy']),
      updatedBy: serializer.fromJson<String>(json['updatedBy']),
      hlc: serializer.fromJson<String>(json['hlc']),
      deleted: serializer.fromJson<bool>(json['deleted']),
      fromNodeId: serializer.fromJson<String>(json['fromNodeId']),
      targetKind: serializer.fromJson<LinkKind>(json['targetKind']),
      targetId: serializer.fromJson<String?>(json['targetId']),
      url: serializer.fromJson<String?>(json['url']),
      label: serializer.fromJson<String?>(json['label']),
      origin: serializer.fromJson<LinkOrigin>(json['origin']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'spaceId': serializer.toJson<String>(spaceId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'createdBy': serializer.toJson<String>(createdBy),
      'updatedBy': serializer.toJson<String>(updatedBy),
      'hlc': serializer.toJson<String>(hlc),
      'deleted': serializer.toJson<bool>(deleted),
      'fromNodeId': serializer.toJson<String>(fromNodeId),
      'targetKind': serializer.toJson<LinkKind>(targetKind),
      'targetId': serializer.toJson<String?>(targetId),
      'url': serializer.toJson<String?>(url),
      'label': serializer.toJson<String?>(label),
      'origin': serializer.toJson<LinkOrigin>(origin),
    };
  }

  Link copyWith({
    String? id,
    String? spaceId,
    DateTime? createdAt,
    String? createdBy,
    String? updatedBy,
    String? hlc,
    bool? deleted,
    String? fromNodeId,
    LinkKind? targetKind,
    Value<String?> targetId = const Value.absent(),
    Value<String?> url = const Value.absent(),
    Value<String?> label = const Value.absent(),
    LinkOrigin? origin,
  }) => Link(
    id: id ?? this.id,
    spaceId: spaceId ?? this.spaceId,
    createdAt: createdAt ?? this.createdAt,
    createdBy: createdBy ?? this.createdBy,
    updatedBy: updatedBy ?? this.updatedBy,
    hlc: hlc ?? this.hlc,
    deleted: deleted ?? this.deleted,
    fromNodeId: fromNodeId ?? this.fromNodeId,
    targetKind: targetKind ?? this.targetKind,
    targetId: targetId.present ? targetId.value : this.targetId,
    url: url.present ? url.value : this.url,
    label: label.present ? label.value : this.label,
    origin: origin ?? this.origin,
  );
  Link copyWithCompanion(LinksCompanion data) {
    return Link(
      id: data.id.present ? data.id.value : this.id,
      spaceId: data.spaceId.present ? data.spaceId.value : this.spaceId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      createdBy: data.createdBy.present ? data.createdBy.value : this.createdBy,
      updatedBy: data.updatedBy.present ? data.updatedBy.value : this.updatedBy,
      hlc: data.hlc.present ? data.hlc.value : this.hlc,
      deleted: data.deleted.present ? data.deleted.value : this.deleted,
      fromNodeId: data.fromNodeId.present
          ? data.fromNodeId.value
          : this.fromNodeId,
      targetKind: data.targetKind.present
          ? data.targetKind.value
          : this.targetKind,
      targetId: data.targetId.present ? data.targetId.value : this.targetId,
      url: data.url.present ? data.url.value : this.url,
      label: data.label.present ? data.label.value : this.label,
      origin: data.origin.present ? data.origin.value : this.origin,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Link(')
          ..write('id: $id, ')
          ..write('spaceId: $spaceId, ')
          ..write('createdAt: $createdAt, ')
          ..write('createdBy: $createdBy, ')
          ..write('updatedBy: $updatedBy, ')
          ..write('hlc: $hlc, ')
          ..write('deleted: $deleted, ')
          ..write('fromNodeId: $fromNodeId, ')
          ..write('targetKind: $targetKind, ')
          ..write('targetId: $targetId, ')
          ..write('url: $url, ')
          ..write('label: $label, ')
          ..write('origin: $origin')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    spaceId,
    createdAt,
    createdBy,
    updatedBy,
    hlc,
    deleted,
    fromNodeId,
    targetKind,
    targetId,
    url,
    label,
    origin,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Link &&
          other.id == this.id &&
          other.spaceId == this.spaceId &&
          other.createdAt == this.createdAt &&
          other.createdBy == this.createdBy &&
          other.updatedBy == this.updatedBy &&
          other.hlc == this.hlc &&
          other.deleted == this.deleted &&
          other.fromNodeId == this.fromNodeId &&
          other.targetKind == this.targetKind &&
          other.targetId == this.targetId &&
          other.url == this.url &&
          other.label == this.label &&
          other.origin == this.origin);
}

class LinksCompanion extends UpdateCompanion<Link> {
  final Value<String> id;
  final Value<String> spaceId;
  final Value<DateTime> createdAt;
  final Value<String> createdBy;
  final Value<String> updatedBy;
  final Value<String> hlc;
  final Value<bool> deleted;
  final Value<String> fromNodeId;
  final Value<LinkKind> targetKind;
  final Value<String?> targetId;
  final Value<String?> url;
  final Value<String?> label;
  final Value<LinkOrigin> origin;
  final Value<int> rowid;
  const LinksCompanion({
    this.id = const Value.absent(),
    this.spaceId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.createdBy = const Value.absent(),
    this.updatedBy = const Value.absent(),
    this.hlc = const Value.absent(),
    this.deleted = const Value.absent(),
    this.fromNodeId = const Value.absent(),
    this.targetKind = const Value.absent(),
    this.targetId = const Value.absent(),
    this.url = const Value.absent(),
    this.label = const Value.absent(),
    this.origin = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LinksCompanion.insert({
    required String id,
    required String spaceId,
    required DateTime createdAt,
    required String createdBy,
    required String updatedBy,
    required String hlc,
    this.deleted = const Value.absent(),
    required String fromNodeId,
    required LinkKind targetKind,
    this.targetId = const Value.absent(),
    this.url = const Value.absent(),
    this.label = const Value.absent(),
    required LinkOrigin origin,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       spaceId = Value(spaceId),
       createdAt = Value(createdAt),
       createdBy = Value(createdBy),
       updatedBy = Value(updatedBy),
       hlc = Value(hlc),
       fromNodeId = Value(fromNodeId),
       targetKind = Value(targetKind),
       origin = Value(origin);
  static Insertable<Link> custom({
    Expression<String>? id,
    Expression<String>? spaceId,
    Expression<DateTime>? createdAt,
    Expression<String>? createdBy,
    Expression<String>? updatedBy,
    Expression<String>? hlc,
    Expression<bool>? deleted,
    Expression<String>? fromNodeId,
    Expression<String>? targetKind,
    Expression<String>? targetId,
    Expression<String>? url,
    Expression<String>? label,
    Expression<String>? origin,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (spaceId != null) 'space_id': spaceId,
      if (createdAt != null) 'created_at': createdAt,
      if (createdBy != null) 'created_by': createdBy,
      if (updatedBy != null) 'updated_by': updatedBy,
      if (hlc != null) 'hlc': hlc,
      if (deleted != null) 'deleted': deleted,
      if (fromNodeId != null) 'from_node_id': fromNodeId,
      if (targetKind != null) 'target_kind': targetKind,
      if (targetId != null) 'target_id': targetId,
      if (url != null) 'url': url,
      if (label != null) 'label': label,
      if (origin != null) 'origin': origin,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LinksCompanion copyWith({
    Value<String>? id,
    Value<String>? spaceId,
    Value<DateTime>? createdAt,
    Value<String>? createdBy,
    Value<String>? updatedBy,
    Value<String>? hlc,
    Value<bool>? deleted,
    Value<String>? fromNodeId,
    Value<LinkKind>? targetKind,
    Value<String?>? targetId,
    Value<String?>? url,
    Value<String?>? label,
    Value<LinkOrigin>? origin,
    Value<int>? rowid,
  }) {
    return LinksCompanion(
      id: id ?? this.id,
      spaceId: spaceId ?? this.spaceId,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      updatedBy: updatedBy ?? this.updatedBy,
      hlc: hlc ?? this.hlc,
      deleted: deleted ?? this.deleted,
      fromNodeId: fromNodeId ?? this.fromNodeId,
      targetKind: targetKind ?? this.targetKind,
      targetId: targetId ?? this.targetId,
      url: url ?? this.url,
      label: label ?? this.label,
      origin: origin ?? this.origin,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (spaceId.present) {
      map['space_id'] = Variable<String>(spaceId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (createdBy.present) {
      map['created_by'] = Variable<String>(createdBy.value);
    }
    if (updatedBy.present) {
      map['updated_by'] = Variable<String>(updatedBy.value);
    }
    if (hlc.present) {
      map['hlc'] = Variable<String>(hlc.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<bool>(deleted.value);
    }
    if (fromNodeId.present) {
      map['from_node_id'] = Variable<String>(fromNodeId.value);
    }
    if (targetKind.present) {
      map['target_kind'] = Variable<String>(
        $LinksTable.$convertertargetKind.toSql(targetKind.value),
      );
    }
    if (targetId.present) {
      map['target_id'] = Variable<String>(targetId.value);
    }
    if (url.present) {
      map['url'] = Variable<String>(url.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (origin.present) {
      map['origin'] = Variable<String>(
        $LinksTable.$converterorigin.toSql(origin.value),
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LinksCompanion(')
          ..write('id: $id, ')
          ..write('spaceId: $spaceId, ')
          ..write('createdAt: $createdAt, ')
          ..write('createdBy: $createdBy, ')
          ..write('updatedBy: $updatedBy, ')
          ..write('hlc: $hlc, ')
          ..write('deleted: $deleted, ')
          ..write('fromNodeId: $fromNodeId, ')
          ..write('targetKind: $targetKind, ')
          ..write('targetId: $targetId, ')
          ..write('url: $url, ')
          ..write('label: $label, ')
          ..write('origin: $origin, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CoreValuesTable extends CoreValues
    with TableInfo<$CoreValuesTable, CoreValue> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CoreValuesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _spaceIdMeta = const VerificationMeta(
    'spaceId',
  );
  @override
  late final GeneratedColumn<String> spaceId = GeneratedColumn<String>(
    'space_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdByMeta = const VerificationMeta(
    'createdBy',
  );
  @override
  late final GeneratedColumn<String> createdBy = GeneratedColumn<String>(
    'created_by',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedByMeta = const VerificationMeta(
    'updatedBy',
  );
  @override
  late final GeneratedColumn<String> updatedBy = GeneratedColumn<String>(
    'updated_by',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _hlcMeta = const VerificationMeta('hlc');
  @override
  late final GeneratedColumn<String> hlc = GeneratedColumn<String>(
    'hlc',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedMeta = const VerificationMeta(
    'deleted',
  );
  @override
  late final GeneratedColumn<bool> deleted = GeneratedColumn<bool>(
    'deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statementMeta = const VerificationMeta(
    'statement',
  );
  @override
  late final GeneratedColumn<String> statement = GeneratedColumn<String>(
    'statement',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<int> color = GeneratedColumn<int>(
    'color',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _iconMeta = const VerificationMeta('icon');
  @override
  late final GeneratedColumn<String> icon = GeneratedColumn<String>(
    'icon',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sortKeyMeta = const VerificationMeta(
    'sortKey',
  );
  @override
  late final GeneratedColumn<String> sortKey = GeneratedColumn<String>(
    'sort_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    spaceId,
    createdAt,
    createdBy,
    updatedBy,
    hlc,
    deleted,
    name,
    statement,
    color,
    icon,
    sortKey,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'core_values';
  @override
  VerificationContext validateIntegrity(
    Insertable<CoreValue> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('space_id')) {
      context.handle(
        _spaceIdMeta,
        spaceId.isAcceptableOrUnknown(data['space_id']!, _spaceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_spaceIdMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('created_by')) {
      context.handle(
        _createdByMeta,
        createdBy.isAcceptableOrUnknown(data['created_by']!, _createdByMeta),
      );
    } else if (isInserting) {
      context.missing(_createdByMeta);
    }
    if (data.containsKey('updated_by')) {
      context.handle(
        _updatedByMeta,
        updatedBy.isAcceptableOrUnknown(data['updated_by']!, _updatedByMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedByMeta);
    }
    if (data.containsKey('hlc')) {
      context.handle(
        _hlcMeta,
        hlc.isAcceptableOrUnknown(data['hlc']!, _hlcMeta),
      );
    } else if (isInserting) {
      context.missing(_hlcMeta);
    }
    if (data.containsKey('deleted')) {
      context.handle(
        _deletedMeta,
        deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('statement')) {
      context.handle(
        _statementMeta,
        statement.isAcceptableOrUnknown(data['statement']!, _statementMeta),
      );
    }
    if (data.containsKey('color')) {
      context.handle(
        _colorMeta,
        color.isAcceptableOrUnknown(data['color']!, _colorMeta),
      );
    }
    if (data.containsKey('icon')) {
      context.handle(
        _iconMeta,
        icon.isAcceptableOrUnknown(data['icon']!, _iconMeta),
      );
    }
    if (data.containsKey('sort_key')) {
      context.handle(
        _sortKeyMeta,
        sortKey.isAcceptableOrUnknown(data['sort_key']!, _sortKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_sortKeyMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CoreValue map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CoreValue(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      spaceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}space_id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      createdBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_by'],
      )!,
      updatedBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}updated_by'],
      )!,
      hlc: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}hlc'],
      )!,
      deleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}deleted'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      statement: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}statement'],
      )!,
      color: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}color'],
      ),
      icon: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon'],
      ),
      sortKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sort_key'],
      )!,
    );
  }

  @override
  $CoreValuesTable createAlias(String alias) {
    return $CoreValuesTable(attachedDatabase, alias);
  }
}

class CoreValue extends DataClass implements Insertable<CoreValue> {
  /// UUIDv7.
  final String id;

  /// The space this row belongs to (§5.0, D13).
  final String spaceId;
  final DateTime createdAt;

  /// User ID of the creator.
  final String createdBy;

  /// User ID of whoever made the latest change.
  final String updatedBy;

  /// Hybrid logical clock stamp of the latest change (see `sync/hlc.dart`).
  final String hlc;

  /// Tombstone flag. Rows are never hard-deleted until compaction.
  final bool deleted;
  final String name;

  /// Markdown.
  final String statement;

  /// ARGB; null = the theme's default.
  final int? color;

  /// A short icon name (see `ui/values.dart`); null = the default.
  final String? icon;
  final String sortKey;
  const CoreValue({
    required this.id,
    required this.spaceId,
    required this.createdAt,
    required this.createdBy,
    required this.updatedBy,
    required this.hlc,
    required this.deleted,
    required this.name,
    required this.statement,
    this.color,
    this.icon,
    required this.sortKey,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['space_id'] = Variable<String>(spaceId);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['created_by'] = Variable<String>(createdBy);
    map['updated_by'] = Variable<String>(updatedBy);
    map['hlc'] = Variable<String>(hlc);
    map['deleted'] = Variable<bool>(deleted);
    map['name'] = Variable<String>(name);
    map['statement'] = Variable<String>(statement);
    if (!nullToAbsent || color != null) {
      map['color'] = Variable<int>(color);
    }
    if (!nullToAbsent || icon != null) {
      map['icon'] = Variable<String>(icon);
    }
    map['sort_key'] = Variable<String>(sortKey);
    return map;
  }

  CoreValuesCompanion toCompanion(bool nullToAbsent) {
    return CoreValuesCompanion(
      id: Value(id),
      spaceId: Value(spaceId),
      createdAt: Value(createdAt),
      createdBy: Value(createdBy),
      updatedBy: Value(updatedBy),
      hlc: Value(hlc),
      deleted: Value(deleted),
      name: Value(name),
      statement: Value(statement),
      color: color == null && nullToAbsent
          ? const Value.absent()
          : Value(color),
      icon: icon == null && nullToAbsent ? const Value.absent() : Value(icon),
      sortKey: Value(sortKey),
    );
  }

  factory CoreValue.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CoreValue(
      id: serializer.fromJson<String>(json['id']),
      spaceId: serializer.fromJson<String>(json['spaceId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      createdBy: serializer.fromJson<String>(json['createdBy']),
      updatedBy: serializer.fromJson<String>(json['updatedBy']),
      hlc: serializer.fromJson<String>(json['hlc']),
      deleted: serializer.fromJson<bool>(json['deleted']),
      name: serializer.fromJson<String>(json['name']),
      statement: serializer.fromJson<String>(json['statement']),
      color: serializer.fromJson<int?>(json['color']),
      icon: serializer.fromJson<String?>(json['icon']),
      sortKey: serializer.fromJson<String>(json['sortKey']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'spaceId': serializer.toJson<String>(spaceId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'createdBy': serializer.toJson<String>(createdBy),
      'updatedBy': serializer.toJson<String>(updatedBy),
      'hlc': serializer.toJson<String>(hlc),
      'deleted': serializer.toJson<bool>(deleted),
      'name': serializer.toJson<String>(name),
      'statement': serializer.toJson<String>(statement),
      'color': serializer.toJson<int?>(color),
      'icon': serializer.toJson<String?>(icon),
      'sortKey': serializer.toJson<String>(sortKey),
    };
  }

  CoreValue copyWith({
    String? id,
    String? spaceId,
    DateTime? createdAt,
    String? createdBy,
    String? updatedBy,
    String? hlc,
    bool? deleted,
    String? name,
    String? statement,
    Value<int?> color = const Value.absent(),
    Value<String?> icon = const Value.absent(),
    String? sortKey,
  }) => CoreValue(
    id: id ?? this.id,
    spaceId: spaceId ?? this.spaceId,
    createdAt: createdAt ?? this.createdAt,
    createdBy: createdBy ?? this.createdBy,
    updatedBy: updatedBy ?? this.updatedBy,
    hlc: hlc ?? this.hlc,
    deleted: deleted ?? this.deleted,
    name: name ?? this.name,
    statement: statement ?? this.statement,
    color: color.present ? color.value : this.color,
    icon: icon.present ? icon.value : this.icon,
    sortKey: sortKey ?? this.sortKey,
  );
  CoreValue copyWithCompanion(CoreValuesCompanion data) {
    return CoreValue(
      id: data.id.present ? data.id.value : this.id,
      spaceId: data.spaceId.present ? data.spaceId.value : this.spaceId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      createdBy: data.createdBy.present ? data.createdBy.value : this.createdBy,
      updatedBy: data.updatedBy.present ? data.updatedBy.value : this.updatedBy,
      hlc: data.hlc.present ? data.hlc.value : this.hlc,
      deleted: data.deleted.present ? data.deleted.value : this.deleted,
      name: data.name.present ? data.name.value : this.name,
      statement: data.statement.present ? data.statement.value : this.statement,
      color: data.color.present ? data.color.value : this.color,
      icon: data.icon.present ? data.icon.value : this.icon,
      sortKey: data.sortKey.present ? data.sortKey.value : this.sortKey,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CoreValue(')
          ..write('id: $id, ')
          ..write('spaceId: $spaceId, ')
          ..write('createdAt: $createdAt, ')
          ..write('createdBy: $createdBy, ')
          ..write('updatedBy: $updatedBy, ')
          ..write('hlc: $hlc, ')
          ..write('deleted: $deleted, ')
          ..write('name: $name, ')
          ..write('statement: $statement, ')
          ..write('color: $color, ')
          ..write('icon: $icon, ')
          ..write('sortKey: $sortKey')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    spaceId,
    createdAt,
    createdBy,
    updatedBy,
    hlc,
    deleted,
    name,
    statement,
    color,
    icon,
    sortKey,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CoreValue &&
          other.id == this.id &&
          other.spaceId == this.spaceId &&
          other.createdAt == this.createdAt &&
          other.createdBy == this.createdBy &&
          other.updatedBy == this.updatedBy &&
          other.hlc == this.hlc &&
          other.deleted == this.deleted &&
          other.name == this.name &&
          other.statement == this.statement &&
          other.color == this.color &&
          other.icon == this.icon &&
          other.sortKey == this.sortKey);
}

class CoreValuesCompanion extends UpdateCompanion<CoreValue> {
  final Value<String> id;
  final Value<String> spaceId;
  final Value<DateTime> createdAt;
  final Value<String> createdBy;
  final Value<String> updatedBy;
  final Value<String> hlc;
  final Value<bool> deleted;
  final Value<String> name;
  final Value<String> statement;
  final Value<int?> color;
  final Value<String?> icon;
  final Value<String> sortKey;
  final Value<int> rowid;
  const CoreValuesCompanion({
    this.id = const Value.absent(),
    this.spaceId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.createdBy = const Value.absent(),
    this.updatedBy = const Value.absent(),
    this.hlc = const Value.absent(),
    this.deleted = const Value.absent(),
    this.name = const Value.absent(),
    this.statement = const Value.absent(),
    this.color = const Value.absent(),
    this.icon = const Value.absent(),
    this.sortKey = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CoreValuesCompanion.insert({
    required String id,
    required String spaceId,
    required DateTime createdAt,
    required String createdBy,
    required String updatedBy,
    required String hlc,
    this.deleted = const Value.absent(),
    required String name,
    this.statement = const Value.absent(),
    this.color = const Value.absent(),
    this.icon = const Value.absent(),
    required String sortKey,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       spaceId = Value(spaceId),
       createdAt = Value(createdAt),
       createdBy = Value(createdBy),
       updatedBy = Value(updatedBy),
       hlc = Value(hlc),
       name = Value(name),
       sortKey = Value(sortKey);
  static Insertable<CoreValue> custom({
    Expression<String>? id,
    Expression<String>? spaceId,
    Expression<DateTime>? createdAt,
    Expression<String>? createdBy,
    Expression<String>? updatedBy,
    Expression<String>? hlc,
    Expression<bool>? deleted,
    Expression<String>? name,
    Expression<String>? statement,
    Expression<int>? color,
    Expression<String>? icon,
    Expression<String>? sortKey,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (spaceId != null) 'space_id': spaceId,
      if (createdAt != null) 'created_at': createdAt,
      if (createdBy != null) 'created_by': createdBy,
      if (updatedBy != null) 'updated_by': updatedBy,
      if (hlc != null) 'hlc': hlc,
      if (deleted != null) 'deleted': deleted,
      if (name != null) 'name': name,
      if (statement != null) 'statement': statement,
      if (color != null) 'color': color,
      if (icon != null) 'icon': icon,
      if (sortKey != null) 'sort_key': sortKey,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CoreValuesCompanion copyWith({
    Value<String>? id,
    Value<String>? spaceId,
    Value<DateTime>? createdAt,
    Value<String>? createdBy,
    Value<String>? updatedBy,
    Value<String>? hlc,
    Value<bool>? deleted,
    Value<String>? name,
    Value<String>? statement,
    Value<int?>? color,
    Value<String?>? icon,
    Value<String>? sortKey,
    Value<int>? rowid,
  }) {
    return CoreValuesCompanion(
      id: id ?? this.id,
      spaceId: spaceId ?? this.spaceId,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      updatedBy: updatedBy ?? this.updatedBy,
      hlc: hlc ?? this.hlc,
      deleted: deleted ?? this.deleted,
      name: name ?? this.name,
      statement: statement ?? this.statement,
      color: color ?? this.color,
      icon: icon ?? this.icon,
      sortKey: sortKey ?? this.sortKey,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (spaceId.present) {
      map['space_id'] = Variable<String>(spaceId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (createdBy.present) {
      map['created_by'] = Variable<String>(createdBy.value);
    }
    if (updatedBy.present) {
      map['updated_by'] = Variable<String>(updatedBy.value);
    }
    if (hlc.present) {
      map['hlc'] = Variable<String>(hlc.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<bool>(deleted.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (statement.present) {
      map['statement'] = Variable<String>(statement.value);
    }
    if (color.present) {
      map['color'] = Variable<int>(color.value);
    }
    if (icon.present) {
      map['icon'] = Variable<String>(icon.value);
    }
    if (sortKey.present) {
      map['sort_key'] = Variable<String>(sortKey.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CoreValuesCompanion(')
          ..write('id: $id, ')
          ..write('spaceId: $spaceId, ')
          ..write('createdAt: $createdAt, ')
          ..write('createdBy: $createdBy, ')
          ..write('updatedBy: $updatedBy, ')
          ..write('hlc: $hlc, ')
          ..write('deleted: $deleted, ')
          ..write('name: $name, ')
          ..write('statement: $statement, ')
          ..write('color: $color, ')
          ..write('icon: $icon, ')
          ..write('sortKey: $sortKey, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $NodeValuesTable extends NodeValues
    with TableInfo<$NodeValuesTable, NodeValue> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NodeValuesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _spaceIdMeta = const VerificationMeta(
    'spaceId',
  );
  @override
  late final GeneratedColumn<String> spaceId = GeneratedColumn<String>(
    'space_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdByMeta = const VerificationMeta(
    'createdBy',
  );
  @override
  late final GeneratedColumn<String> createdBy = GeneratedColumn<String>(
    'created_by',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedByMeta = const VerificationMeta(
    'updatedBy',
  );
  @override
  late final GeneratedColumn<String> updatedBy = GeneratedColumn<String>(
    'updated_by',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _hlcMeta = const VerificationMeta('hlc');
  @override
  late final GeneratedColumn<String> hlc = GeneratedColumn<String>(
    'hlc',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedMeta = const VerificationMeta(
    'deleted',
  );
  @override
  late final GeneratedColumn<bool> deleted = GeneratedColumn<bool>(
    'deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _nodeIdMeta = const VerificationMeta('nodeId');
  @override
  late final GeneratedColumn<String> nodeId = GeneratedColumn<String>(
    'node_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueIdMeta = const VerificationMeta(
    'valueId',
  );
  @override
  late final GeneratedColumn<String> valueId = GeneratedColumn<String>(
    'value_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    spaceId,
    createdAt,
    createdBy,
    updatedBy,
    hlc,
    deleted,
    nodeId,
    valueId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'node_values';
  @override
  VerificationContext validateIntegrity(
    Insertable<NodeValue> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('space_id')) {
      context.handle(
        _spaceIdMeta,
        spaceId.isAcceptableOrUnknown(data['space_id']!, _spaceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_spaceIdMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('created_by')) {
      context.handle(
        _createdByMeta,
        createdBy.isAcceptableOrUnknown(data['created_by']!, _createdByMeta),
      );
    } else if (isInserting) {
      context.missing(_createdByMeta);
    }
    if (data.containsKey('updated_by')) {
      context.handle(
        _updatedByMeta,
        updatedBy.isAcceptableOrUnknown(data['updated_by']!, _updatedByMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedByMeta);
    }
    if (data.containsKey('hlc')) {
      context.handle(
        _hlcMeta,
        hlc.isAcceptableOrUnknown(data['hlc']!, _hlcMeta),
      );
    } else if (isInserting) {
      context.missing(_hlcMeta);
    }
    if (data.containsKey('deleted')) {
      context.handle(
        _deletedMeta,
        deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta),
      );
    }
    if (data.containsKey('node_id')) {
      context.handle(
        _nodeIdMeta,
        nodeId.isAcceptableOrUnknown(data['node_id']!, _nodeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_nodeIdMeta);
    }
    if (data.containsKey('value_id')) {
      context.handle(
        _valueIdMeta,
        valueId.isAcceptableOrUnknown(data['value_id']!, _valueIdMeta),
      );
    } else if (isInserting) {
      context.missing(_valueIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  NodeValue map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return NodeValue(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      spaceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}space_id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      createdBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_by'],
      )!,
      updatedBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}updated_by'],
      )!,
      hlc: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}hlc'],
      )!,
      deleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}deleted'],
      )!,
      nodeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}node_id'],
      )!,
      valueId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value_id'],
      )!,
    );
  }

  @override
  $NodeValuesTable createAlias(String alias) {
    return $NodeValuesTable(attachedDatabase, alias);
  }
}

class NodeValue extends DataClass implements Insertable<NodeValue> {
  /// UUIDv7.
  final String id;

  /// The space this row belongs to (§5.0, D13).
  final String spaceId;
  final DateTime createdAt;

  /// User ID of the creator.
  final String createdBy;

  /// User ID of whoever made the latest change.
  final String updatedBy;

  /// Hybrid logical clock stamp of the latest change (see `sync/hlc.dart`).
  final String hlc;

  /// Tombstone flag. Rows are never hard-deleted until compaction.
  final bool deleted;
  final String nodeId;
  final String valueId;
  const NodeValue({
    required this.id,
    required this.spaceId,
    required this.createdAt,
    required this.createdBy,
    required this.updatedBy,
    required this.hlc,
    required this.deleted,
    required this.nodeId,
    required this.valueId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['space_id'] = Variable<String>(spaceId);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['created_by'] = Variable<String>(createdBy);
    map['updated_by'] = Variable<String>(updatedBy);
    map['hlc'] = Variable<String>(hlc);
    map['deleted'] = Variable<bool>(deleted);
    map['node_id'] = Variable<String>(nodeId);
    map['value_id'] = Variable<String>(valueId);
    return map;
  }

  NodeValuesCompanion toCompanion(bool nullToAbsent) {
    return NodeValuesCompanion(
      id: Value(id),
      spaceId: Value(spaceId),
      createdAt: Value(createdAt),
      createdBy: Value(createdBy),
      updatedBy: Value(updatedBy),
      hlc: Value(hlc),
      deleted: Value(deleted),
      nodeId: Value(nodeId),
      valueId: Value(valueId),
    );
  }

  factory NodeValue.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return NodeValue(
      id: serializer.fromJson<String>(json['id']),
      spaceId: serializer.fromJson<String>(json['spaceId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      createdBy: serializer.fromJson<String>(json['createdBy']),
      updatedBy: serializer.fromJson<String>(json['updatedBy']),
      hlc: serializer.fromJson<String>(json['hlc']),
      deleted: serializer.fromJson<bool>(json['deleted']),
      nodeId: serializer.fromJson<String>(json['nodeId']),
      valueId: serializer.fromJson<String>(json['valueId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'spaceId': serializer.toJson<String>(spaceId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'createdBy': serializer.toJson<String>(createdBy),
      'updatedBy': serializer.toJson<String>(updatedBy),
      'hlc': serializer.toJson<String>(hlc),
      'deleted': serializer.toJson<bool>(deleted),
      'nodeId': serializer.toJson<String>(nodeId),
      'valueId': serializer.toJson<String>(valueId),
    };
  }

  NodeValue copyWith({
    String? id,
    String? spaceId,
    DateTime? createdAt,
    String? createdBy,
    String? updatedBy,
    String? hlc,
    bool? deleted,
    String? nodeId,
    String? valueId,
  }) => NodeValue(
    id: id ?? this.id,
    spaceId: spaceId ?? this.spaceId,
    createdAt: createdAt ?? this.createdAt,
    createdBy: createdBy ?? this.createdBy,
    updatedBy: updatedBy ?? this.updatedBy,
    hlc: hlc ?? this.hlc,
    deleted: deleted ?? this.deleted,
    nodeId: nodeId ?? this.nodeId,
    valueId: valueId ?? this.valueId,
  );
  NodeValue copyWithCompanion(NodeValuesCompanion data) {
    return NodeValue(
      id: data.id.present ? data.id.value : this.id,
      spaceId: data.spaceId.present ? data.spaceId.value : this.spaceId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      createdBy: data.createdBy.present ? data.createdBy.value : this.createdBy,
      updatedBy: data.updatedBy.present ? data.updatedBy.value : this.updatedBy,
      hlc: data.hlc.present ? data.hlc.value : this.hlc,
      deleted: data.deleted.present ? data.deleted.value : this.deleted,
      nodeId: data.nodeId.present ? data.nodeId.value : this.nodeId,
      valueId: data.valueId.present ? data.valueId.value : this.valueId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('NodeValue(')
          ..write('id: $id, ')
          ..write('spaceId: $spaceId, ')
          ..write('createdAt: $createdAt, ')
          ..write('createdBy: $createdBy, ')
          ..write('updatedBy: $updatedBy, ')
          ..write('hlc: $hlc, ')
          ..write('deleted: $deleted, ')
          ..write('nodeId: $nodeId, ')
          ..write('valueId: $valueId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    spaceId,
    createdAt,
    createdBy,
    updatedBy,
    hlc,
    deleted,
    nodeId,
    valueId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NodeValue &&
          other.id == this.id &&
          other.spaceId == this.spaceId &&
          other.createdAt == this.createdAt &&
          other.createdBy == this.createdBy &&
          other.updatedBy == this.updatedBy &&
          other.hlc == this.hlc &&
          other.deleted == this.deleted &&
          other.nodeId == this.nodeId &&
          other.valueId == this.valueId);
}

class NodeValuesCompanion extends UpdateCompanion<NodeValue> {
  final Value<String> id;
  final Value<String> spaceId;
  final Value<DateTime> createdAt;
  final Value<String> createdBy;
  final Value<String> updatedBy;
  final Value<String> hlc;
  final Value<bool> deleted;
  final Value<String> nodeId;
  final Value<String> valueId;
  final Value<int> rowid;
  const NodeValuesCompanion({
    this.id = const Value.absent(),
    this.spaceId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.createdBy = const Value.absent(),
    this.updatedBy = const Value.absent(),
    this.hlc = const Value.absent(),
    this.deleted = const Value.absent(),
    this.nodeId = const Value.absent(),
    this.valueId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  NodeValuesCompanion.insert({
    required String id,
    required String spaceId,
    required DateTime createdAt,
    required String createdBy,
    required String updatedBy,
    required String hlc,
    this.deleted = const Value.absent(),
    required String nodeId,
    required String valueId,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       spaceId = Value(spaceId),
       createdAt = Value(createdAt),
       createdBy = Value(createdBy),
       updatedBy = Value(updatedBy),
       hlc = Value(hlc),
       nodeId = Value(nodeId),
       valueId = Value(valueId);
  static Insertable<NodeValue> custom({
    Expression<String>? id,
    Expression<String>? spaceId,
    Expression<DateTime>? createdAt,
    Expression<String>? createdBy,
    Expression<String>? updatedBy,
    Expression<String>? hlc,
    Expression<bool>? deleted,
    Expression<String>? nodeId,
    Expression<String>? valueId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (spaceId != null) 'space_id': spaceId,
      if (createdAt != null) 'created_at': createdAt,
      if (createdBy != null) 'created_by': createdBy,
      if (updatedBy != null) 'updated_by': updatedBy,
      if (hlc != null) 'hlc': hlc,
      if (deleted != null) 'deleted': deleted,
      if (nodeId != null) 'node_id': nodeId,
      if (valueId != null) 'value_id': valueId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  NodeValuesCompanion copyWith({
    Value<String>? id,
    Value<String>? spaceId,
    Value<DateTime>? createdAt,
    Value<String>? createdBy,
    Value<String>? updatedBy,
    Value<String>? hlc,
    Value<bool>? deleted,
    Value<String>? nodeId,
    Value<String>? valueId,
    Value<int>? rowid,
  }) {
    return NodeValuesCompanion(
      id: id ?? this.id,
      spaceId: spaceId ?? this.spaceId,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      updatedBy: updatedBy ?? this.updatedBy,
      hlc: hlc ?? this.hlc,
      deleted: deleted ?? this.deleted,
      nodeId: nodeId ?? this.nodeId,
      valueId: valueId ?? this.valueId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (spaceId.present) {
      map['space_id'] = Variable<String>(spaceId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (createdBy.present) {
      map['created_by'] = Variable<String>(createdBy.value);
    }
    if (updatedBy.present) {
      map['updated_by'] = Variable<String>(updatedBy.value);
    }
    if (hlc.present) {
      map['hlc'] = Variable<String>(hlc.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<bool>(deleted.value);
    }
    if (nodeId.present) {
      map['node_id'] = Variable<String>(nodeId.value);
    }
    if (valueId.present) {
      map['value_id'] = Variable<String>(valueId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NodeValuesCompanion(')
          ..write('id: $id, ')
          ..write('spaceId: $spaceId, ')
          ..write('createdAt: $createdAt, ')
          ..write('createdBy: $createdBy, ')
          ..write('updatedBy: $updatedBy, ')
          ..write('hlc: $hlc, ')
          ..write('deleted: $deleted, ')
          ..write('nodeId: $nodeId, ')
          ..write('valueId: $valueId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TagsTable extends Tags with TableInfo<$TagsTable, Tag> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TagsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _spaceIdMeta = const VerificationMeta(
    'spaceId',
  );
  @override
  late final GeneratedColumn<String> spaceId = GeneratedColumn<String>(
    'space_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdByMeta = const VerificationMeta(
    'createdBy',
  );
  @override
  late final GeneratedColumn<String> createdBy = GeneratedColumn<String>(
    'created_by',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedByMeta = const VerificationMeta(
    'updatedBy',
  );
  @override
  late final GeneratedColumn<String> updatedBy = GeneratedColumn<String>(
    'updated_by',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _hlcMeta = const VerificationMeta('hlc');
  @override
  late final GeneratedColumn<String> hlc = GeneratedColumn<String>(
    'hlc',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedMeta = const VerificationMeta(
    'deleted',
  );
  @override
  late final GeneratedColumn<bool> deleted = GeneratedColumn<bool>(
    'deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<int> color = GeneratedColumn<int>(
    'color',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<TagKind, String> kind =
      GeneratedColumn<String>(
        'kind',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<TagKind>($TagsTable.$converterkind);
  static const VerificationMeta _favoriteMeta = const VerificationMeta(
    'favorite',
  );
  @override
  late final GeneratedColumn<bool> favorite = GeneratedColumn<bool>(
    'favorite',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("favorite" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _keptMeta = const VerificationMeta('kept');
  @override
  late final GeneratedColumn<bool> kept = GeneratedColumn<bool>(
    'kept',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("kept" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    spaceId,
    createdAt,
    createdBy,
    updatedBy,
    hlc,
    deleted,
    name,
    color,
    kind,
    favorite,
    kept,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tags';
  @override
  VerificationContext validateIntegrity(
    Insertable<Tag> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('space_id')) {
      context.handle(
        _spaceIdMeta,
        spaceId.isAcceptableOrUnknown(data['space_id']!, _spaceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_spaceIdMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('created_by')) {
      context.handle(
        _createdByMeta,
        createdBy.isAcceptableOrUnknown(data['created_by']!, _createdByMeta),
      );
    } else if (isInserting) {
      context.missing(_createdByMeta);
    }
    if (data.containsKey('updated_by')) {
      context.handle(
        _updatedByMeta,
        updatedBy.isAcceptableOrUnknown(data['updated_by']!, _updatedByMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedByMeta);
    }
    if (data.containsKey('hlc')) {
      context.handle(
        _hlcMeta,
        hlc.isAcceptableOrUnknown(data['hlc']!, _hlcMeta),
      );
    } else if (isInserting) {
      context.missing(_hlcMeta);
    }
    if (data.containsKey('deleted')) {
      context.handle(
        _deletedMeta,
        deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('color')) {
      context.handle(
        _colorMeta,
        color.isAcceptableOrUnknown(data['color']!, _colorMeta),
      );
    }
    if (data.containsKey('favorite')) {
      context.handle(
        _favoriteMeta,
        favorite.isAcceptableOrUnknown(data['favorite']!, _favoriteMeta),
      );
    }
    if (data.containsKey('kept')) {
      context.handle(
        _keptMeta,
        kept.isAcceptableOrUnknown(data['kept']!, _keptMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Tag map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Tag(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      spaceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}space_id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      createdBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_by'],
      )!,
      updatedBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}updated_by'],
      )!,
      hlc: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}hlc'],
      )!,
      deleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}deleted'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      color: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}color'],
      ),
      kind: $TagsTable.$converterkind.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}kind'],
        )!,
      ),
      favorite: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}favorite'],
      )!,
      kept: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}kept'],
      )!,
    );
  }

  @override
  $TagsTable createAlias(String alias) {
    return $TagsTable(attachedDatabase, alias);
  }

  static TypeConverter<TagKind, String> $converterkind =
      const TolerantEnumConverter(TagKind.values, TagKind.normal);
}

class Tag extends DataClass implements Insertable<Tag> {
  /// UUIDv7.
  final String id;

  /// The space this row belongs to (§5.0, D13).
  final String spaceId;
  final DateTime createdAt;

  /// User ID of the creator.
  final String createdBy;

  /// User ID of whoever made the latest change.
  final String updatedBy;

  /// Hybrid logical clock stamp of the latest change (see `sync/hlc.dart`).
  final String hlc;

  /// Tombstone flag. Rows are never hard-deleted until compaction.
  final bool deleted;

  /// Without the `#`. Matched case-insensitively; shown as first written.
  final String name;

  /// ARGB; null = no colour.
  final int? color;
  final TagKind kind;

  /// One tap in the tag picker: a common category such as #work. In v1
  /// tags are personal; with sharing, favourites move to a personal table
  /// so members can have their own.
  final bool favorite;

  /// Made or edited on the Tags page: stays when nothing uses it.
  final bool kept;
  const Tag({
    required this.id,
    required this.spaceId,
    required this.createdAt,
    required this.createdBy,
    required this.updatedBy,
    required this.hlc,
    required this.deleted,
    required this.name,
    this.color,
    required this.kind,
    required this.favorite,
    required this.kept,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['space_id'] = Variable<String>(spaceId);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['created_by'] = Variable<String>(createdBy);
    map['updated_by'] = Variable<String>(updatedBy);
    map['hlc'] = Variable<String>(hlc);
    map['deleted'] = Variable<bool>(deleted);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || color != null) {
      map['color'] = Variable<int>(color);
    }
    {
      map['kind'] = Variable<String>($TagsTable.$converterkind.toSql(kind));
    }
    map['favorite'] = Variable<bool>(favorite);
    map['kept'] = Variable<bool>(kept);
    return map;
  }

  TagsCompanion toCompanion(bool nullToAbsent) {
    return TagsCompanion(
      id: Value(id),
      spaceId: Value(spaceId),
      createdAt: Value(createdAt),
      createdBy: Value(createdBy),
      updatedBy: Value(updatedBy),
      hlc: Value(hlc),
      deleted: Value(deleted),
      name: Value(name),
      color: color == null && nullToAbsent
          ? const Value.absent()
          : Value(color),
      kind: Value(kind),
      favorite: Value(favorite),
      kept: Value(kept),
    );
  }

  factory Tag.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Tag(
      id: serializer.fromJson<String>(json['id']),
      spaceId: serializer.fromJson<String>(json['spaceId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      createdBy: serializer.fromJson<String>(json['createdBy']),
      updatedBy: serializer.fromJson<String>(json['updatedBy']),
      hlc: serializer.fromJson<String>(json['hlc']),
      deleted: serializer.fromJson<bool>(json['deleted']),
      name: serializer.fromJson<String>(json['name']),
      color: serializer.fromJson<int?>(json['color']),
      kind: serializer.fromJson<TagKind>(json['kind']),
      favorite: serializer.fromJson<bool>(json['favorite']),
      kept: serializer.fromJson<bool>(json['kept']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'spaceId': serializer.toJson<String>(spaceId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'createdBy': serializer.toJson<String>(createdBy),
      'updatedBy': serializer.toJson<String>(updatedBy),
      'hlc': serializer.toJson<String>(hlc),
      'deleted': serializer.toJson<bool>(deleted),
      'name': serializer.toJson<String>(name),
      'color': serializer.toJson<int?>(color),
      'kind': serializer.toJson<TagKind>(kind),
      'favorite': serializer.toJson<bool>(favorite),
      'kept': serializer.toJson<bool>(kept),
    };
  }

  Tag copyWith({
    String? id,
    String? spaceId,
    DateTime? createdAt,
    String? createdBy,
    String? updatedBy,
    String? hlc,
    bool? deleted,
    String? name,
    Value<int?> color = const Value.absent(),
    TagKind? kind,
    bool? favorite,
    bool? kept,
  }) => Tag(
    id: id ?? this.id,
    spaceId: spaceId ?? this.spaceId,
    createdAt: createdAt ?? this.createdAt,
    createdBy: createdBy ?? this.createdBy,
    updatedBy: updatedBy ?? this.updatedBy,
    hlc: hlc ?? this.hlc,
    deleted: deleted ?? this.deleted,
    name: name ?? this.name,
    color: color.present ? color.value : this.color,
    kind: kind ?? this.kind,
    favorite: favorite ?? this.favorite,
    kept: kept ?? this.kept,
  );
  Tag copyWithCompanion(TagsCompanion data) {
    return Tag(
      id: data.id.present ? data.id.value : this.id,
      spaceId: data.spaceId.present ? data.spaceId.value : this.spaceId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      createdBy: data.createdBy.present ? data.createdBy.value : this.createdBy,
      updatedBy: data.updatedBy.present ? data.updatedBy.value : this.updatedBy,
      hlc: data.hlc.present ? data.hlc.value : this.hlc,
      deleted: data.deleted.present ? data.deleted.value : this.deleted,
      name: data.name.present ? data.name.value : this.name,
      color: data.color.present ? data.color.value : this.color,
      kind: data.kind.present ? data.kind.value : this.kind,
      favorite: data.favorite.present ? data.favorite.value : this.favorite,
      kept: data.kept.present ? data.kept.value : this.kept,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Tag(')
          ..write('id: $id, ')
          ..write('spaceId: $spaceId, ')
          ..write('createdAt: $createdAt, ')
          ..write('createdBy: $createdBy, ')
          ..write('updatedBy: $updatedBy, ')
          ..write('hlc: $hlc, ')
          ..write('deleted: $deleted, ')
          ..write('name: $name, ')
          ..write('color: $color, ')
          ..write('kind: $kind, ')
          ..write('favorite: $favorite, ')
          ..write('kept: $kept')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    spaceId,
    createdAt,
    createdBy,
    updatedBy,
    hlc,
    deleted,
    name,
    color,
    kind,
    favorite,
    kept,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Tag &&
          other.id == this.id &&
          other.spaceId == this.spaceId &&
          other.createdAt == this.createdAt &&
          other.createdBy == this.createdBy &&
          other.updatedBy == this.updatedBy &&
          other.hlc == this.hlc &&
          other.deleted == this.deleted &&
          other.name == this.name &&
          other.color == this.color &&
          other.kind == this.kind &&
          other.favorite == this.favorite &&
          other.kept == this.kept);
}

class TagsCompanion extends UpdateCompanion<Tag> {
  final Value<String> id;
  final Value<String> spaceId;
  final Value<DateTime> createdAt;
  final Value<String> createdBy;
  final Value<String> updatedBy;
  final Value<String> hlc;
  final Value<bool> deleted;
  final Value<String> name;
  final Value<int?> color;
  final Value<TagKind> kind;
  final Value<bool> favorite;
  final Value<bool> kept;
  final Value<int> rowid;
  const TagsCompanion({
    this.id = const Value.absent(),
    this.spaceId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.createdBy = const Value.absent(),
    this.updatedBy = const Value.absent(),
    this.hlc = const Value.absent(),
    this.deleted = const Value.absent(),
    this.name = const Value.absent(),
    this.color = const Value.absent(),
    this.kind = const Value.absent(),
    this.favorite = const Value.absent(),
    this.kept = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TagsCompanion.insert({
    required String id,
    required String spaceId,
    required DateTime createdAt,
    required String createdBy,
    required String updatedBy,
    required String hlc,
    this.deleted = const Value.absent(),
    required String name,
    this.color = const Value.absent(),
    required TagKind kind,
    this.favorite = const Value.absent(),
    this.kept = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       spaceId = Value(spaceId),
       createdAt = Value(createdAt),
       createdBy = Value(createdBy),
       updatedBy = Value(updatedBy),
       hlc = Value(hlc),
       name = Value(name),
       kind = Value(kind);
  static Insertable<Tag> custom({
    Expression<String>? id,
    Expression<String>? spaceId,
    Expression<DateTime>? createdAt,
    Expression<String>? createdBy,
    Expression<String>? updatedBy,
    Expression<String>? hlc,
    Expression<bool>? deleted,
    Expression<String>? name,
    Expression<int>? color,
    Expression<String>? kind,
    Expression<bool>? favorite,
    Expression<bool>? kept,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (spaceId != null) 'space_id': spaceId,
      if (createdAt != null) 'created_at': createdAt,
      if (createdBy != null) 'created_by': createdBy,
      if (updatedBy != null) 'updated_by': updatedBy,
      if (hlc != null) 'hlc': hlc,
      if (deleted != null) 'deleted': deleted,
      if (name != null) 'name': name,
      if (color != null) 'color': color,
      if (kind != null) 'kind': kind,
      if (favorite != null) 'favorite': favorite,
      if (kept != null) 'kept': kept,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TagsCompanion copyWith({
    Value<String>? id,
    Value<String>? spaceId,
    Value<DateTime>? createdAt,
    Value<String>? createdBy,
    Value<String>? updatedBy,
    Value<String>? hlc,
    Value<bool>? deleted,
    Value<String>? name,
    Value<int?>? color,
    Value<TagKind>? kind,
    Value<bool>? favorite,
    Value<bool>? kept,
    Value<int>? rowid,
  }) {
    return TagsCompanion(
      id: id ?? this.id,
      spaceId: spaceId ?? this.spaceId,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      updatedBy: updatedBy ?? this.updatedBy,
      hlc: hlc ?? this.hlc,
      deleted: deleted ?? this.deleted,
      name: name ?? this.name,
      color: color ?? this.color,
      kind: kind ?? this.kind,
      favorite: favorite ?? this.favorite,
      kept: kept ?? this.kept,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (spaceId.present) {
      map['space_id'] = Variable<String>(spaceId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (createdBy.present) {
      map['created_by'] = Variable<String>(createdBy.value);
    }
    if (updatedBy.present) {
      map['updated_by'] = Variable<String>(updatedBy.value);
    }
    if (hlc.present) {
      map['hlc'] = Variable<String>(hlc.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<bool>(deleted.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (color.present) {
      map['color'] = Variable<int>(color.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(
        $TagsTable.$converterkind.toSql(kind.value),
      );
    }
    if (favorite.present) {
      map['favorite'] = Variable<bool>(favorite.value);
    }
    if (kept.present) {
      map['kept'] = Variable<bool>(kept.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TagsCompanion(')
          ..write('id: $id, ')
          ..write('spaceId: $spaceId, ')
          ..write('createdAt: $createdAt, ')
          ..write('createdBy: $createdBy, ')
          ..write('updatedBy: $updatedBy, ')
          ..write('hlc: $hlc, ')
          ..write('deleted: $deleted, ')
          ..write('name: $name, ')
          ..write('color: $color, ')
          ..write('kind: $kind, ')
          ..write('favorite: $favorite, ')
          ..write('kept: $kept, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $NodeTagsTable extends NodeTags with TableInfo<$NodeTagsTable, NodeTag> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NodeTagsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _spaceIdMeta = const VerificationMeta(
    'spaceId',
  );
  @override
  late final GeneratedColumn<String> spaceId = GeneratedColumn<String>(
    'space_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdByMeta = const VerificationMeta(
    'createdBy',
  );
  @override
  late final GeneratedColumn<String> createdBy = GeneratedColumn<String>(
    'created_by',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedByMeta = const VerificationMeta(
    'updatedBy',
  );
  @override
  late final GeneratedColumn<String> updatedBy = GeneratedColumn<String>(
    'updated_by',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _hlcMeta = const VerificationMeta('hlc');
  @override
  late final GeneratedColumn<String> hlc = GeneratedColumn<String>(
    'hlc',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedMeta = const VerificationMeta(
    'deleted',
  );
  @override
  late final GeneratedColumn<bool> deleted = GeneratedColumn<bool>(
    'deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _nodeIdMeta = const VerificationMeta('nodeId');
  @override
  late final GeneratedColumn<String> nodeId = GeneratedColumn<String>(
    'node_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tagIdMeta = const VerificationMeta('tagId');
  @override
  late final GeneratedColumn<String> tagId = GeneratedColumn<String>(
    'tag_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<LinkOrigin, String> origin =
      GeneratedColumn<String>(
        'origin',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<LinkOrigin>($NodeTagsTable.$converterorigin);
  @override
  List<GeneratedColumn> get $columns => [
    id,
    spaceId,
    createdAt,
    createdBy,
    updatedBy,
    hlc,
    deleted,
    nodeId,
    tagId,
    origin,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'node_tags';
  @override
  VerificationContext validateIntegrity(
    Insertable<NodeTag> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('space_id')) {
      context.handle(
        _spaceIdMeta,
        spaceId.isAcceptableOrUnknown(data['space_id']!, _spaceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_spaceIdMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('created_by')) {
      context.handle(
        _createdByMeta,
        createdBy.isAcceptableOrUnknown(data['created_by']!, _createdByMeta),
      );
    } else if (isInserting) {
      context.missing(_createdByMeta);
    }
    if (data.containsKey('updated_by')) {
      context.handle(
        _updatedByMeta,
        updatedBy.isAcceptableOrUnknown(data['updated_by']!, _updatedByMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedByMeta);
    }
    if (data.containsKey('hlc')) {
      context.handle(
        _hlcMeta,
        hlc.isAcceptableOrUnknown(data['hlc']!, _hlcMeta),
      );
    } else if (isInserting) {
      context.missing(_hlcMeta);
    }
    if (data.containsKey('deleted')) {
      context.handle(
        _deletedMeta,
        deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta),
      );
    }
    if (data.containsKey('node_id')) {
      context.handle(
        _nodeIdMeta,
        nodeId.isAcceptableOrUnknown(data['node_id']!, _nodeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_nodeIdMeta);
    }
    if (data.containsKey('tag_id')) {
      context.handle(
        _tagIdMeta,
        tagId.isAcceptableOrUnknown(data['tag_id']!, _tagIdMeta),
      );
    } else if (isInserting) {
      context.missing(_tagIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  NodeTag map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return NodeTag(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      spaceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}space_id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      createdBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_by'],
      )!,
      updatedBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}updated_by'],
      )!,
      hlc: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}hlc'],
      )!,
      deleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}deleted'],
      )!,
      nodeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}node_id'],
      )!,
      tagId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tag_id'],
      )!,
      origin: $NodeTagsTable.$converterorigin.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}origin'],
        )!,
      ),
    );
  }

  @override
  $NodeTagsTable createAlias(String alias) {
    return $NodeTagsTable(attachedDatabase, alias);
  }

  static TypeConverter<LinkOrigin, String> $converterorigin =
      const TolerantEnumConverter(LinkOrigin.values, LinkOrigin.attached);
}

class NodeTag extends DataClass implements Insertable<NodeTag> {
  /// UUIDv7.
  final String id;

  /// The space this row belongs to (§5.0, D13).
  final String spaceId;
  final DateTime createdAt;

  /// User ID of the creator.
  final String createdBy;

  /// User ID of whoever made the latest change.
  final String updatedBy;

  /// Hybrid logical clock stamp of the latest change (see `sync/hlc.dart`).
  final String hlc;

  /// Tombstone flag. Rows are never hard-deleted until compaction.
  final bool deleted;
  final String nodeId;
  final String tagId;
  final LinkOrigin origin;
  const NodeTag({
    required this.id,
    required this.spaceId,
    required this.createdAt,
    required this.createdBy,
    required this.updatedBy,
    required this.hlc,
    required this.deleted,
    required this.nodeId,
    required this.tagId,
    required this.origin,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['space_id'] = Variable<String>(spaceId);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['created_by'] = Variable<String>(createdBy);
    map['updated_by'] = Variable<String>(updatedBy);
    map['hlc'] = Variable<String>(hlc);
    map['deleted'] = Variable<bool>(deleted);
    map['node_id'] = Variable<String>(nodeId);
    map['tag_id'] = Variable<String>(tagId);
    {
      map['origin'] = Variable<String>(
        $NodeTagsTable.$converterorigin.toSql(origin),
      );
    }
    return map;
  }

  NodeTagsCompanion toCompanion(bool nullToAbsent) {
    return NodeTagsCompanion(
      id: Value(id),
      spaceId: Value(spaceId),
      createdAt: Value(createdAt),
      createdBy: Value(createdBy),
      updatedBy: Value(updatedBy),
      hlc: Value(hlc),
      deleted: Value(deleted),
      nodeId: Value(nodeId),
      tagId: Value(tagId),
      origin: Value(origin),
    );
  }

  factory NodeTag.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return NodeTag(
      id: serializer.fromJson<String>(json['id']),
      spaceId: serializer.fromJson<String>(json['spaceId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      createdBy: serializer.fromJson<String>(json['createdBy']),
      updatedBy: serializer.fromJson<String>(json['updatedBy']),
      hlc: serializer.fromJson<String>(json['hlc']),
      deleted: serializer.fromJson<bool>(json['deleted']),
      nodeId: serializer.fromJson<String>(json['nodeId']),
      tagId: serializer.fromJson<String>(json['tagId']),
      origin: serializer.fromJson<LinkOrigin>(json['origin']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'spaceId': serializer.toJson<String>(spaceId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'createdBy': serializer.toJson<String>(createdBy),
      'updatedBy': serializer.toJson<String>(updatedBy),
      'hlc': serializer.toJson<String>(hlc),
      'deleted': serializer.toJson<bool>(deleted),
      'nodeId': serializer.toJson<String>(nodeId),
      'tagId': serializer.toJson<String>(tagId),
      'origin': serializer.toJson<LinkOrigin>(origin),
    };
  }

  NodeTag copyWith({
    String? id,
    String? spaceId,
    DateTime? createdAt,
    String? createdBy,
    String? updatedBy,
    String? hlc,
    bool? deleted,
    String? nodeId,
    String? tagId,
    LinkOrigin? origin,
  }) => NodeTag(
    id: id ?? this.id,
    spaceId: spaceId ?? this.spaceId,
    createdAt: createdAt ?? this.createdAt,
    createdBy: createdBy ?? this.createdBy,
    updatedBy: updatedBy ?? this.updatedBy,
    hlc: hlc ?? this.hlc,
    deleted: deleted ?? this.deleted,
    nodeId: nodeId ?? this.nodeId,
    tagId: tagId ?? this.tagId,
    origin: origin ?? this.origin,
  );
  NodeTag copyWithCompanion(NodeTagsCompanion data) {
    return NodeTag(
      id: data.id.present ? data.id.value : this.id,
      spaceId: data.spaceId.present ? data.spaceId.value : this.spaceId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      createdBy: data.createdBy.present ? data.createdBy.value : this.createdBy,
      updatedBy: data.updatedBy.present ? data.updatedBy.value : this.updatedBy,
      hlc: data.hlc.present ? data.hlc.value : this.hlc,
      deleted: data.deleted.present ? data.deleted.value : this.deleted,
      nodeId: data.nodeId.present ? data.nodeId.value : this.nodeId,
      tagId: data.tagId.present ? data.tagId.value : this.tagId,
      origin: data.origin.present ? data.origin.value : this.origin,
    );
  }

  @override
  String toString() {
    return (StringBuffer('NodeTag(')
          ..write('id: $id, ')
          ..write('spaceId: $spaceId, ')
          ..write('createdAt: $createdAt, ')
          ..write('createdBy: $createdBy, ')
          ..write('updatedBy: $updatedBy, ')
          ..write('hlc: $hlc, ')
          ..write('deleted: $deleted, ')
          ..write('nodeId: $nodeId, ')
          ..write('tagId: $tagId, ')
          ..write('origin: $origin')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    spaceId,
    createdAt,
    createdBy,
    updatedBy,
    hlc,
    deleted,
    nodeId,
    tagId,
    origin,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NodeTag &&
          other.id == this.id &&
          other.spaceId == this.spaceId &&
          other.createdAt == this.createdAt &&
          other.createdBy == this.createdBy &&
          other.updatedBy == this.updatedBy &&
          other.hlc == this.hlc &&
          other.deleted == this.deleted &&
          other.nodeId == this.nodeId &&
          other.tagId == this.tagId &&
          other.origin == this.origin);
}

class NodeTagsCompanion extends UpdateCompanion<NodeTag> {
  final Value<String> id;
  final Value<String> spaceId;
  final Value<DateTime> createdAt;
  final Value<String> createdBy;
  final Value<String> updatedBy;
  final Value<String> hlc;
  final Value<bool> deleted;
  final Value<String> nodeId;
  final Value<String> tagId;
  final Value<LinkOrigin> origin;
  final Value<int> rowid;
  const NodeTagsCompanion({
    this.id = const Value.absent(),
    this.spaceId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.createdBy = const Value.absent(),
    this.updatedBy = const Value.absent(),
    this.hlc = const Value.absent(),
    this.deleted = const Value.absent(),
    this.nodeId = const Value.absent(),
    this.tagId = const Value.absent(),
    this.origin = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  NodeTagsCompanion.insert({
    required String id,
    required String spaceId,
    required DateTime createdAt,
    required String createdBy,
    required String updatedBy,
    required String hlc,
    this.deleted = const Value.absent(),
    required String nodeId,
    required String tagId,
    required LinkOrigin origin,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       spaceId = Value(spaceId),
       createdAt = Value(createdAt),
       createdBy = Value(createdBy),
       updatedBy = Value(updatedBy),
       hlc = Value(hlc),
       nodeId = Value(nodeId),
       tagId = Value(tagId),
       origin = Value(origin);
  static Insertable<NodeTag> custom({
    Expression<String>? id,
    Expression<String>? spaceId,
    Expression<DateTime>? createdAt,
    Expression<String>? createdBy,
    Expression<String>? updatedBy,
    Expression<String>? hlc,
    Expression<bool>? deleted,
    Expression<String>? nodeId,
    Expression<String>? tagId,
    Expression<String>? origin,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (spaceId != null) 'space_id': spaceId,
      if (createdAt != null) 'created_at': createdAt,
      if (createdBy != null) 'created_by': createdBy,
      if (updatedBy != null) 'updated_by': updatedBy,
      if (hlc != null) 'hlc': hlc,
      if (deleted != null) 'deleted': deleted,
      if (nodeId != null) 'node_id': nodeId,
      if (tagId != null) 'tag_id': tagId,
      if (origin != null) 'origin': origin,
      if (rowid != null) 'rowid': rowid,
    });
  }

  NodeTagsCompanion copyWith({
    Value<String>? id,
    Value<String>? spaceId,
    Value<DateTime>? createdAt,
    Value<String>? createdBy,
    Value<String>? updatedBy,
    Value<String>? hlc,
    Value<bool>? deleted,
    Value<String>? nodeId,
    Value<String>? tagId,
    Value<LinkOrigin>? origin,
    Value<int>? rowid,
  }) {
    return NodeTagsCompanion(
      id: id ?? this.id,
      spaceId: spaceId ?? this.spaceId,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      updatedBy: updatedBy ?? this.updatedBy,
      hlc: hlc ?? this.hlc,
      deleted: deleted ?? this.deleted,
      nodeId: nodeId ?? this.nodeId,
      tagId: tagId ?? this.tagId,
      origin: origin ?? this.origin,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (spaceId.present) {
      map['space_id'] = Variable<String>(spaceId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (createdBy.present) {
      map['created_by'] = Variable<String>(createdBy.value);
    }
    if (updatedBy.present) {
      map['updated_by'] = Variable<String>(updatedBy.value);
    }
    if (hlc.present) {
      map['hlc'] = Variable<String>(hlc.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<bool>(deleted.value);
    }
    if (nodeId.present) {
      map['node_id'] = Variable<String>(nodeId.value);
    }
    if (tagId.present) {
      map['tag_id'] = Variable<String>(tagId.value);
    }
    if (origin.present) {
      map['origin'] = Variable<String>(
        $NodeTagsTable.$converterorigin.toSql(origin.value),
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NodeTagsCompanion(')
          ..write('id: $id, ')
          ..write('spaceId: $spaceId, ')
          ..write('createdAt: $createdAt, ')
          ..write('createdBy: $createdBy, ')
          ..write('updatedBy: $updatedBy, ')
          ..write('hlc: $hlc, ')
          ..write('deleted: $deleted, ')
          ..write('nodeId: $nodeId, ')
          ..write('tagId: $tagId, ')
          ..write('origin: $origin, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AttachmentsTable extends Attachments
    with TableInfo<$AttachmentsTable, Attachment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AttachmentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _spaceIdMeta = const VerificationMeta(
    'spaceId',
  );
  @override
  late final GeneratedColumn<String> spaceId = GeneratedColumn<String>(
    'space_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdByMeta = const VerificationMeta(
    'createdBy',
  );
  @override
  late final GeneratedColumn<String> createdBy = GeneratedColumn<String>(
    'created_by',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedByMeta = const VerificationMeta(
    'updatedBy',
  );
  @override
  late final GeneratedColumn<String> updatedBy = GeneratedColumn<String>(
    'updated_by',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _hlcMeta = const VerificationMeta('hlc');
  @override
  late final GeneratedColumn<String> hlc = GeneratedColumn<String>(
    'hlc',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedMeta = const VerificationMeta(
    'deleted',
  );
  @override
  late final GeneratedColumn<bool> deleted = GeneratedColumn<bool>(
    'deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _nodeIdMeta = const VerificationMeta('nodeId');
  @override
  late final GeneratedColumn<String> nodeId = GeneratedColumn<String>(
    'node_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contentHashMeta = const VerificationMeta(
    'contentHash',
  );
  @override
  late final GeneratedColumn<String> contentHash = GeneratedColumn<String>(
    'content_hash',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _filenameMeta = const VerificationMeta(
    'filename',
  );
  @override
  late final GeneratedColumn<String> filename = GeneratedColumn<String>(
    'filename',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _mimeMeta = const VerificationMeta('mime');
  @override
  late final GeneratedColumn<String> mime = GeneratedColumn<String>(
    'mime',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sizeBytesMeta = const VerificationMeta(
    'sizeBytes',
  );
  @override
  late final GeneratedColumn<int> sizeBytes = GeneratedColumn<int>(
    'size_bytes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<AttachmentKind, String> kind =
      GeneratedColumn<String>(
        'kind',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<AttachmentKind>($AttachmentsTable.$converterkind);
  static const VerificationMeta _widthMeta = const VerificationMeta('width');
  @override
  late final GeneratedColumn<int> width = GeneratedColumn<int>(
    'width',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _heightMeta = const VerificationMeta('height');
  @override
  late final GeneratedColumn<int> height = GeneratedColumn<int>(
    'height',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    spaceId,
    createdAt,
    createdBy,
    updatedBy,
    hlc,
    deleted,
    nodeId,
    contentHash,
    filename,
    mime,
    sizeBytes,
    kind,
    width,
    height,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'attachments';
  @override
  VerificationContext validateIntegrity(
    Insertable<Attachment> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('space_id')) {
      context.handle(
        _spaceIdMeta,
        spaceId.isAcceptableOrUnknown(data['space_id']!, _spaceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_spaceIdMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('created_by')) {
      context.handle(
        _createdByMeta,
        createdBy.isAcceptableOrUnknown(data['created_by']!, _createdByMeta),
      );
    } else if (isInserting) {
      context.missing(_createdByMeta);
    }
    if (data.containsKey('updated_by')) {
      context.handle(
        _updatedByMeta,
        updatedBy.isAcceptableOrUnknown(data['updated_by']!, _updatedByMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedByMeta);
    }
    if (data.containsKey('hlc')) {
      context.handle(
        _hlcMeta,
        hlc.isAcceptableOrUnknown(data['hlc']!, _hlcMeta),
      );
    } else if (isInserting) {
      context.missing(_hlcMeta);
    }
    if (data.containsKey('deleted')) {
      context.handle(
        _deletedMeta,
        deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta),
      );
    }
    if (data.containsKey('node_id')) {
      context.handle(
        _nodeIdMeta,
        nodeId.isAcceptableOrUnknown(data['node_id']!, _nodeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_nodeIdMeta);
    }
    if (data.containsKey('content_hash')) {
      context.handle(
        _contentHashMeta,
        contentHash.isAcceptableOrUnknown(
          data['content_hash']!,
          _contentHashMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_contentHashMeta);
    }
    if (data.containsKey('filename')) {
      context.handle(
        _filenameMeta,
        filename.isAcceptableOrUnknown(data['filename']!, _filenameMeta),
      );
    } else if (isInserting) {
      context.missing(_filenameMeta);
    }
    if (data.containsKey('mime')) {
      context.handle(
        _mimeMeta,
        mime.isAcceptableOrUnknown(data['mime']!, _mimeMeta),
      );
    } else if (isInserting) {
      context.missing(_mimeMeta);
    }
    if (data.containsKey('size_bytes')) {
      context.handle(
        _sizeBytesMeta,
        sizeBytes.isAcceptableOrUnknown(data['size_bytes']!, _sizeBytesMeta),
      );
    } else if (isInserting) {
      context.missing(_sizeBytesMeta);
    }
    if (data.containsKey('width')) {
      context.handle(
        _widthMeta,
        width.isAcceptableOrUnknown(data['width']!, _widthMeta),
      );
    }
    if (data.containsKey('height')) {
      context.handle(
        _heightMeta,
        height.isAcceptableOrUnknown(data['height']!, _heightMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Attachment map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Attachment(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      spaceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}space_id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      createdBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_by'],
      )!,
      updatedBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}updated_by'],
      )!,
      hlc: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}hlc'],
      )!,
      deleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}deleted'],
      )!,
      nodeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}node_id'],
      )!,
      contentHash: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content_hash'],
      )!,
      filename: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}filename'],
      )!,
      mime: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mime'],
      )!,
      sizeBytes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}size_bytes'],
      )!,
      kind: $AttachmentsTable.$converterkind.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}kind'],
        )!,
      ),
      width: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}width'],
      ),
      height: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}height'],
      ),
    );
  }

  @override
  $AttachmentsTable createAlias(String alias) {
    return $AttachmentsTable(attachedDatabase, alias);
  }

  static TypeConverter<AttachmentKind, String> $converterkind =
      const TolerantEnumConverter(AttachmentKind.values, AttachmentKind.other);
}

class Attachment extends DataClass implements Insertable<Attachment> {
  /// UUIDv7.
  final String id;

  /// The space this row belongs to (§5.0, D13).
  final String spaceId;
  final DateTime createdAt;

  /// User ID of the creator.
  final String createdBy;

  /// User ID of whoever made the latest change.
  final String updatedBy;

  /// Hybrid logical clock stamp of the latest change (see `sync/hlc.dart`).
  final String hlc;

  /// Tombstone flag. Rows are never hard-deleted until compaction.
  final bool deleted;
  final String nodeId;

  /// SHA-256, hex.
  final String contentHash;
  final String filename;
  final String mime;
  final int sizeBytes;
  final AttachmentKind kind;

  /// Images only, in pixels.
  final int? width;
  final int? height;
  const Attachment({
    required this.id,
    required this.spaceId,
    required this.createdAt,
    required this.createdBy,
    required this.updatedBy,
    required this.hlc,
    required this.deleted,
    required this.nodeId,
    required this.contentHash,
    required this.filename,
    required this.mime,
    required this.sizeBytes,
    required this.kind,
    this.width,
    this.height,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['space_id'] = Variable<String>(spaceId);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['created_by'] = Variable<String>(createdBy);
    map['updated_by'] = Variable<String>(updatedBy);
    map['hlc'] = Variable<String>(hlc);
    map['deleted'] = Variable<bool>(deleted);
    map['node_id'] = Variable<String>(nodeId);
    map['content_hash'] = Variable<String>(contentHash);
    map['filename'] = Variable<String>(filename);
    map['mime'] = Variable<String>(mime);
    map['size_bytes'] = Variable<int>(sizeBytes);
    {
      map['kind'] = Variable<String>(
        $AttachmentsTable.$converterkind.toSql(kind),
      );
    }
    if (!nullToAbsent || width != null) {
      map['width'] = Variable<int>(width);
    }
    if (!nullToAbsent || height != null) {
      map['height'] = Variable<int>(height);
    }
    return map;
  }

  AttachmentsCompanion toCompanion(bool nullToAbsent) {
    return AttachmentsCompanion(
      id: Value(id),
      spaceId: Value(spaceId),
      createdAt: Value(createdAt),
      createdBy: Value(createdBy),
      updatedBy: Value(updatedBy),
      hlc: Value(hlc),
      deleted: Value(deleted),
      nodeId: Value(nodeId),
      contentHash: Value(contentHash),
      filename: Value(filename),
      mime: Value(mime),
      sizeBytes: Value(sizeBytes),
      kind: Value(kind),
      width: width == null && nullToAbsent
          ? const Value.absent()
          : Value(width),
      height: height == null && nullToAbsent
          ? const Value.absent()
          : Value(height),
    );
  }

  factory Attachment.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Attachment(
      id: serializer.fromJson<String>(json['id']),
      spaceId: serializer.fromJson<String>(json['spaceId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      createdBy: serializer.fromJson<String>(json['createdBy']),
      updatedBy: serializer.fromJson<String>(json['updatedBy']),
      hlc: serializer.fromJson<String>(json['hlc']),
      deleted: serializer.fromJson<bool>(json['deleted']),
      nodeId: serializer.fromJson<String>(json['nodeId']),
      contentHash: serializer.fromJson<String>(json['contentHash']),
      filename: serializer.fromJson<String>(json['filename']),
      mime: serializer.fromJson<String>(json['mime']),
      sizeBytes: serializer.fromJson<int>(json['sizeBytes']),
      kind: serializer.fromJson<AttachmentKind>(json['kind']),
      width: serializer.fromJson<int?>(json['width']),
      height: serializer.fromJson<int?>(json['height']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'spaceId': serializer.toJson<String>(spaceId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'createdBy': serializer.toJson<String>(createdBy),
      'updatedBy': serializer.toJson<String>(updatedBy),
      'hlc': serializer.toJson<String>(hlc),
      'deleted': serializer.toJson<bool>(deleted),
      'nodeId': serializer.toJson<String>(nodeId),
      'contentHash': serializer.toJson<String>(contentHash),
      'filename': serializer.toJson<String>(filename),
      'mime': serializer.toJson<String>(mime),
      'sizeBytes': serializer.toJson<int>(sizeBytes),
      'kind': serializer.toJson<AttachmentKind>(kind),
      'width': serializer.toJson<int?>(width),
      'height': serializer.toJson<int?>(height),
    };
  }

  Attachment copyWith({
    String? id,
    String? spaceId,
    DateTime? createdAt,
    String? createdBy,
    String? updatedBy,
    String? hlc,
    bool? deleted,
    String? nodeId,
    String? contentHash,
    String? filename,
    String? mime,
    int? sizeBytes,
    AttachmentKind? kind,
    Value<int?> width = const Value.absent(),
    Value<int?> height = const Value.absent(),
  }) => Attachment(
    id: id ?? this.id,
    spaceId: spaceId ?? this.spaceId,
    createdAt: createdAt ?? this.createdAt,
    createdBy: createdBy ?? this.createdBy,
    updatedBy: updatedBy ?? this.updatedBy,
    hlc: hlc ?? this.hlc,
    deleted: deleted ?? this.deleted,
    nodeId: nodeId ?? this.nodeId,
    contentHash: contentHash ?? this.contentHash,
    filename: filename ?? this.filename,
    mime: mime ?? this.mime,
    sizeBytes: sizeBytes ?? this.sizeBytes,
    kind: kind ?? this.kind,
    width: width.present ? width.value : this.width,
    height: height.present ? height.value : this.height,
  );
  Attachment copyWithCompanion(AttachmentsCompanion data) {
    return Attachment(
      id: data.id.present ? data.id.value : this.id,
      spaceId: data.spaceId.present ? data.spaceId.value : this.spaceId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      createdBy: data.createdBy.present ? data.createdBy.value : this.createdBy,
      updatedBy: data.updatedBy.present ? data.updatedBy.value : this.updatedBy,
      hlc: data.hlc.present ? data.hlc.value : this.hlc,
      deleted: data.deleted.present ? data.deleted.value : this.deleted,
      nodeId: data.nodeId.present ? data.nodeId.value : this.nodeId,
      contentHash: data.contentHash.present
          ? data.contentHash.value
          : this.contentHash,
      filename: data.filename.present ? data.filename.value : this.filename,
      mime: data.mime.present ? data.mime.value : this.mime,
      sizeBytes: data.sizeBytes.present ? data.sizeBytes.value : this.sizeBytes,
      kind: data.kind.present ? data.kind.value : this.kind,
      width: data.width.present ? data.width.value : this.width,
      height: data.height.present ? data.height.value : this.height,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Attachment(')
          ..write('id: $id, ')
          ..write('spaceId: $spaceId, ')
          ..write('createdAt: $createdAt, ')
          ..write('createdBy: $createdBy, ')
          ..write('updatedBy: $updatedBy, ')
          ..write('hlc: $hlc, ')
          ..write('deleted: $deleted, ')
          ..write('nodeId: $nodeId, ')
          ..write('contentHash: $contentHash, ')
          ..write('filename: $filename, ')
          ..write('mime: $mime, ')
          ..write('sizeBytes: $sizeBytes, ')
          ..write('kind: $kind, ')
          ..write('width: $width, ')
          ..write('height: $height')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    spaceId,
    createdAt,
    createdBy,
    updatedBy,
    hlc,
    deleted,
    nodeId,
    contentHash,
    filename,
    mime,
    sizeBytes,
    kind,
    width,
    height,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Attachment &&
          other.id == this.id &&
          other.spaceId == this.spaceId &&
          other.createdAt == this.createdAt &&
          other.createdBy == this.createdBy &&
          other.updatedBy == this.updatedBy &&
          other.hlc == this.hlc &&
          other.deleted == this.deleted &&
          other.nodeId == this.nodeId &&
          other.contentHash == this.contentHash &&
          other.filename == this.filename &&
          other.mime == this.mime &&
          other.sizeBytes == this.sizeBytes &&
          other.kind == this.kind &&
          other.width == this.width &&
          other.height == this.height);
}

class AttachmentsCompanion extends UpdateCompanion<Attachment> {
  final Value<String> id;
  final Value<String> spaceId;
  final Value<DateTime> createdAt;
  final Value<String> createdBy;
  final Value<String> updatedBy;
  final Value<String> hlc;
  final Value<bool> deleted;
  final Value<String> nodeId;
  final Value<String> contentHash;
  final Value<String> filename;
  final Value<String> mime;
  final Value<int> sizeBytes;
  final Value<AttachmentKind> kind;
  final Value<int?> width;
  final Value<int?> height;
  final Value<int> rowid;
  const AttachmentsCompanion({
    this.id = const Value.absent(),
    this.spaceId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.createdBy = const Value.absent(),
    this.updatedBy = const Value.absent(),
    this.hlc = const Value.absent(),
    this.deleted = const Value.absent(),
    this.nodeId = const Value.absent(),
    this.contentHash = const Value.absent(),
    this.filename = const Value.absent(),
    this.mime = const Value.absent(),
    this.sizeBytes = const Value.absent(),
    this.kind = const Value.absent(),
    this.width = const Value.absent(),
    this.height = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AttachmentsCompanion.insert({
    required String id,
    required String spaceId,
    required DateTime createdAt,
    required String createdBy,
    required String updatedBy,
    required String hlc,
    this.deleted = const Value.absent(),
    required String nodeId,
    required String contentHash,
    required String filename,
    required String mime,
    required int sizeBytes,
    required AttachmentKind kind,
    this.width = const Value.absent(),
    this.height = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       spaceId = Value(spaceId),
       createdAt = Value(createdAt),
       createdBy = Value(createdBy),
       updatedBy = Value(updatedBy),
       hlc = Value(hlc),
       nodeId = Value(nodeId),
       contentHash = Value(contentHash),
       filename = Value(filename),
       mime = Value(mime),
       sizeBytes = Value(sizeBytes),
       kind = Value(kind);
  static Insertable<Attachment> custom({
    Expression<String>? id,
    Expression<String>? spaceId,
    Expression<DateTime>? createdAt,
    Expression<String>? createdBy,
    Expression<String>? updatedBy,
    Expression<String>? hlc,
    Expression<bool>? deleted,
    Expression<String>? nodeId,
    Expression<String>? contentHash,
    Expression<String>? filename,
    Expression<String>? mime,
    Expression<int>? sizeBytes,
    Expression<String>? kind,
    Expression<int>? width,
    Expression<int>? height,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (spaceId != null) 'space_id': spaceId,
      if (createdAt != null) 'created_at': createdAt,
      if (createdBy != null) 'created_by': createdBy,
      if (updatedBy != null) 'updated_by': updatedBy,
      if (hlc != null) 'hlc': hlc,
      if (deleted != null) 'deleted': deleted,
      if (nodeId != null) 'node_id': nodeId,
      if (contentHash != null) 'content_hash': contentHash,
      if (filename != null) 'filename': filename,
      if (mime != null) 'mime': mime,
      if (sizeBytes != null) 'size_bytes': sizeBytes,
      if (kind != null) 'kind': kind,
      if (width != null) 'width': width,
      if (height != null) 'height': height,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AttachmentsCompanion copyWith({
    Value<String>? id,
    Value<String>? spaceId,
    Value<DateTime>? createdAt,
    Value<String>? createdBy,
    Value<String>? updatedBy,
    Value<String>? hlc,
    Value<bool>? deleted,
    Value<String>? nodeId,
    Value<String>? contentHash,
    Value<String>? filename,
    Value<String>? mime,
    Value<int>? sizeBytes,
    Value<AttachmentKind>? kind,
    Value<int?>? width,
    Value<int?>? height,
    Value<int>? rowid,
  }) {
    return AttachmentsCompanion(
      id: id ?? this.id,
      spaceId: spaceId ?? this.spaceId,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      updatedBy: updatedBy ?? this.updatedBy,
      hlc: hlc ?? this.hlc,
      deleted: deleted ?? this.deleted,
      nodeId: nodeId ?? this.nodeId,
      contentHash: contentHash ?? this.contentHash,
      filename: filename ?? this.filename,
      mime: mime ?? this.mime,
      sizeBytes: sizeBytes ?? this.sizeBytes,
      kind: kind ?? this.kind,
      width: width ?? this.width,
      height: height ?? this.height,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (spaceId.present) {
      map['space_id'] = Variable<String>(spaceId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (createdBy.present) {
      map['created_by'] = Variable<String>(createdBy.value);
    }
    if (updatedBy.present) {
      map['updated_by'] = Variable<String>(updatedBy.value);
    }
    if (hlc.present) {
      map['hlc'] = Variable<String>(hlc.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<bool>(deleted.value);
    }
    if (nodeId.present) {
      map['node_id'] = Variable<String>(nodeId.value);
    }
    if (contentHash.present) {
      map['content_hash'] = Variable<String>(contentHash.value);
    }
    if (filename.present) {
      map['filename'] = Variable<String>(filename.value);
    }
    if (mime.present) {
      map['mime'] = Variable<String>(mime.value);
    }
    if (sizeBytes.present) {
      map['size_bytes'] = Variable<int>(sizeBytes.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(
        $AttachmentsTable.$converterkind.toSql(kind.value),
      );
    }
    if (width.present) {
      map['width'] = Variable<int>(width.value);
    }
    if (height.present) {
      map['height'] = Variable<int>(height.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AttachmentsCompanion(')
          ..write('id: $id, ')
          ..write('spaceId: $spaceId, ')
          ..write('createdAt: $createdAt, ')
          ..write('createdBy: $createdBy, ')
          ..write('updatedBy: $updatedBy, ')
          ..write('hlc: $hlc, ')
          ..write('deleted: $deleted, ')
          ..write('nodeId: $nodeId, ')
          ..write('contentHash: $contentHash, ')
          ..write('filename: $filename, ')
          ..write('mime: $mime, ')
          ..write('sizeBytes: $sizeBytes, ')
          ..write('kind: $kind, ')
          ..write('width: $width, ')
          ..write('height: $height, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AnnotationsTable extends Annotations
    with TableInfo<$AnnotationsTable, Annotation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AnnotationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _spaceIdMeta = const VerificationMeta(
    'spaceId',
  );
  @override
  late final GeneratedColumn<String> spaceId = GeneratedColumn<String>(
    'space_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdByMeta = const VerificationMeta(
    'createdBy',
  );
  @override
  late final GeneratedColumn<String> createdBy = GeneratedColumn<String>(
    'created_by',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedByMeta = const VerificationMeta(
    'updatedBy',
  );
  @override
  late final GeneratedColumn<String> updatedBy = GeneratedColumn<String>(
    'updated_by',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _hlcMeta = const VerificationMeta('hlc');
  @override
  late final GeneratedColumn<String> hlc = GeneratedColumn<String>(
    'hlc',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedMeta = const VerificationMeta(
    'deleted',
  );
  @override
  late final GeneratedColumn<bool> deleted = GeneratedColumn<bool>(
    'deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _attachmentIdMeta = const VerificationMeta(
    'attachmentId',
  );
  @override
  late final GeneratedColumn<String> attachmentId = GeneratedColumn<String>(
    'attachment_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<AnnotationKind, String> kind =
      GeneratedColumn<String>(
        'kind',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<AnnotationKind>($AnnotationsTable.$converterkind);
  static const VerificationMeta _dataJsonMeta = const VerificationMeta(
    'dataJson',
  );
  @override
  late final GeneratedColumn<String> dataJson = GeneratedColumn<String>(
    'data_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<int> color = GeneratedColumn<int>(
    'color',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _zMeta = const VerificationMeta('z');
  @override
  late final GeneratedColumn<int> z = GeneratedColumn<int>(
    'z',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    spaceId,
    createdAt,
    createdBy,
    updatedBy,
    hlc,
    deleted,
    attachmentId,
    kind,
    dataJson,
    color,
    z,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'annotations';
  @override
  VerificationContext validateIntegrity(
    Insertable<Annotation> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('space_id')) {
      context.handle(
        _spaceIdMeta,
        spaceId.isAcceptableOrUnknown(data['space_id']!, _spaceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_spaceIdMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('created_by')) {
      context.handle(
        _createdByMeta,
        createdBy.isAcceptableOrUnknown(data['created_by']!, _createdByMeta),
      );
    } else if (isInserting) {
      context.missing(_createdByMeta);
    }
    if (data.containsKey('updated_by')) {
      context.handle(
        _updatedByMeta,
        updatedBy.isAcceptableOrUnknown(data['updated_by']!, _updatedByMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedByMeta);
    }
    if (data.containsKey('hlc')) {
      context.handle(
        _hlcMeta,
        hlc.isAcceptableOrUnknown(data['hlc']!, _hlcMeta),
      );
    } else if (isInserting) {
      context.missing(_hlcMeta);
    }
    if (data.containsKey('deleted')) {
      context.handle(
        _deletedMeta,
        deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta),
      );
    }
    if (data.containsKey('attachment_id')) {
      context.handle(
        _attachmentIdMeta,
        attachmentId.isAcceptableOrUnknown(
          data['attachment_id']!,
          _attachmentIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_attachmentIdMeta);
    }
    if (data.containsKey('data_json')) {
      context.handle(
        _dataJsonMeta,
        dataJson.isAcceptableOrUnknown(data['data_json']!, _dataJsonMeta),
      );
    } else if (isInserting) {
      context.missing(_dataJsonMeta);
    }
    if (data.containsKey('color')) {
      context.handle(
        _colorMeta,
        color.isAcceptableOrUnknown(data['color']!, _colorMeta),
      );
    } else if (isInserting) {
      context.missing(_colorMeta);
    }
    if (data.containsKey('z')) {
      context.handle(_zMeta, z.isAcceptableOrUnknown(data['z']!, _zMeta));
    } else if (isInserting) {
      context.missing(_zMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Annotation map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Annotation(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      spaceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}space_id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      createdBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_by'],
      )!,
      updatedBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}updated_by'],
      )!,
      hlc: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}hlc'],
      )!,
      deleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}deleted'],
      )!,
      attachmentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}attachment_id'],
      )!,
      kind: $AnnotationsTable.$converterkind.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}kind'],
        )!,
      ),
      dataJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}data_json'],
      )!,
      color: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}color'],
      )!,
      z: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}z'],
      )!,
    );
  }

  @override
  $AnnotationsTable createAlias(String alias) {
    return $AnnotationsTable(attachedDatabase, alias);
  }

  static TypeConverter<AnnotationKind, String> $converterkind =
      const TolerantEnumConverter(AnnotationKind.values, AnnotationKind.stroke);
}

class Annotation extends DataClass implements Insertable<Annotation> {
  /// UUIDv7.
  final String id;

  /// The space this row belongs to (§5.0, D13).
  final String spaceId;
  final DateTime createdAt;

  /// User ID of the creator.
  final String createdBy;

  /// User ID of whoever made the latest change.
  final String updatedBy;

  /// Hybrid logical clock stamp of the latest change (see `sync/hlc.dart`).
  final String hlc;

  /// Tombstone flag. Rows are never hard-deleted until compaction.
  final bool deleted;
  final String attachmentId;
  final AnnotationKind kind;

  /// stroke: `{"points": [x0, y0, x1, y1, …], "width": w, "pen": "pen" |
  /// "highlighter"}`, coordinates 0–1 of the image; textLabel: `{"x", "y",
  /// "text"}`; highlight: `{"start", "end"}` character offsets.
  final String dataJson;

  /// ARGB.
  final int color;

  /// Drawing order.
  final int z;
  const Annotation({
    required this.id,
    required this.spaceId,
    required this.createdAt,
    required this.createdBy,
    required this.updatedBy,
    required this.hlc,
    required this.deleted,
    required this.attachmentId,
    required this.kind,
    required this.dataJson,
    required this.color,
    required this.z,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['space_id'] = Variable<String>(spaceId);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['created_by'] = Variable<String>(createdBy);
    map['updated_by'] = Variable<String>(updatedBy);
    map['hlc'] = Variable<String>(hlc);
    map['deleted'] = Variable<bool>(deleted);
    map['attachment_id'] = Variable<String>(attachmentId);
    {
      map['kind'] = Variable<String>(
        $AnnotationsTable.$converterkind.toSql(kind),
      );
    }
    map['data_json'] = Variable<String>(dataJson);
    map['color'] = Variable<int>(color);
    map['z'] = Variable<int>(z);
    return map;
  }

  AnnotationsCompanion toCompanion(bool nullToAbsent) {
    return AnnotationsCompanion(
      id: Value(id),
      spaceId: Value(spaceId),
      createdAt: Value(createdAt),
      createdBy: Value(createdBy),
      updatedBy: Value(updatedBy),
      hlc: Value(hlc),
      deleted: Value(deleted),
      attachmentId: Value(attachmentId),
      kind: Value(kind),
      dataJson: Value(dataJson),
      color: Value(color),
      z: Value(z),
    );
  }

  factory Annotation.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Annotation(
      id: serializer.fromJson<String>(json['id']),
      spaceId: serializer.fromJson<String>(json['spaceId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      createdBy: serializer.fromJson<String>(json['createdBy']),
      updatedBy: serializer.fromJson<String>(json['updatedBy']),
      hlc: serializer.fromJson<String>(json['hlc']),
      deleted: serializer.fromJson<bool>(json['deleted']),
      attachmentId: serializer.fromJson<String>(json['attachmentId']),
      kind: serializer.fromJson<AnnotationKind>(json['kind']),
      dataJson: serializer.fromJson<String>(json['dataJson']),
      color: serializer.fromJson<int>(json['color']),
      z: serializer.fromJson<int>(json['z']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'spaceId': serializer.toJson<String>(spaceId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'createdBy': serializer.toJson<String>(createdBy),
      'updatedBy': serializer.toJson<String>(updatedBy),
      'hlc': serializer.toJson<String>(hlc),
      'deleted': serializer.toJson<bool>(deleted),
      'attachmentId': serializer.toJson<String>(attachmentId),
      'kind': serializer.toJson<AnnotationKind>(kind),
      'dataJson': serializer.toJson<String>(dataJson),
      'color': serializer.toJson<int>(color),
      'z': serializer.toJson<int>(z),
    };
  }

  Annotation copyWith({
    String? id,
    String? spaceId,
    DateTime? createdAt,
    String? createdBy,
    String? updatedBy,
    String? hlc,
    bool? deleted,
    String? attachmentId,
    AnnotationKind? kind,
    String? dataJson,
    int? color,
    int? z,
  }) => Annotation(
    id: id ?? this.id,
    spaceId: spaceId ?? this.spaceId,
    createdAt: createdAt ?? this.createdAt,
    createdBy: createdBy ?? this.createdBy,
    updatedBy: updatedBy ?? this.updatedBy,
    hlc: hlc ?? this.hlc,
    deleted: deleted ?? this.deleted,
    attachmentId: attachmentId ?? this.attachmentId,
    kind: kind ?? this.kind,
    dataJson: dataJson ?? this.dataJson,
    color: color ?? this.color,
    z: z ?? this.z,
  );
  Annotation copyWithCompanion(AnnotationsCompanion data) {
    return Annotation(
      id: data.id.present ? data.id.value : this.id,
      spaceId: data.spaceId.present ? data.spaceId.value : this.spaceId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      createdBy: data.createdBy.present ? data.createdBy.value : this.createdBy,
      updatedBy: data.updatedBy.present ? data.updatedBy.value : this.updatedBy,
      hlc: data.hlc.present ? data.hlc.value : this.hlc,
      deleted: data.deleted.present ? data.deleted.value : this.deleted,
      attachmentId: data.attachmentId.present
          ? data.attachmentId.value
          : this.attachmentId,
      kind: data.kind.present ? data.kind.value : this.kind,
      dataJson: data.dataJson.present ? data.dataJson.value : this.dataJson,
      color: data.color.present ? data.color.value : this.color,
      z: data.z.present ? data.z.value : this.z,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Annotation(')
          ..write('id: $id, ')
          ..write('spaceId: $spaceId, ')
          ..write('createdAt: $createdAt, ')
          ..write('createdBy: $createdBy, ')
          ..write('updatedBy: $updatedBy, ')
          ..write('hlc: $hlc, ')
          ..write('deleted: $deleted, ')
          ..write('attachmentId: $attachmentId, ')
          ..write('kind: $kind, ')
          ..write('dataJson: $dataJson, ')
          ..write('color: $color, ')
          ..write('z: $z')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    spaceId,
    createdAt,
    createdBy,
    updatedBy,
    hlc,
    deleted,
    attachmentId,
    kind,
    dataJson,
    color,
    z,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Annotation &&
          other.id == this.id &&
          other.spaceId == this.spaceId &&
          other.createdAt == this.createdAt &&
          other.createdBy == this.createdBy &&
          other.updatedBy == this.updatedBy &&
          other.hlc == this.hlc &&
          other.deleted == this.deleted &&
          other.attachmentId == this.attachmentId &&
          other.kind == this.kind &&
          other.dataJson == this.dataJson &&
          other.color == this.color &&
          other.z == this.z);
}

class AnnotationsCompanion extends UpdateCompanion<Annotation> {
  final Value<String> id;
  final Value<String> spaceId;
  final Value<DateTime> createdAt;
  final Value<String> createdBy;
  final Value<String> updatedBy;
  final Value<String> hlc;
  final Value<bool> deleted;
  final Value<String> attachmentId;
  final Value<AnnotationKind> kind;
  final Value<String> dataJson;
  final Value<int> color;
  final Value<int> z;
  final Value<int> rowid;
  const AnnotationsCompanion({
    this.id = const Value.absent(),
    this.spaceId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.createdBy = const Value.absent(),
    this.updatedBy = const Value.absent(),
    this.hlc = const Value.absent(),
    this.deleted = const Value.absent(),
    this.attachmentId = const Value.absent(),
    this.kind = const Value.absent(),
    this.dataJson = const Value.absent(),
    this.color = const Value.absent(),
    this.z = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AnnotationsCompanion.insert({
    required String id,
    required String spaceId,
    required DateTime createdAt,
    required String createdBy,
    required String updatedBy,
    required String hlc,
    this.deleted = const Value.absent(),
    required String attachmentId,
    required AnnotationKind kind,
    required String dataJson,
    required int color,
    required int z,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       spaceId = Value(spaceId),
       createdAt = Value(createdAt),
       createdBy = Value(createdBy),
       updatedBy = Value(updatedBy),
       hlc = Value(hlc),
       attachmentId = Value(attachmentId),
       kind = Value(kind),
       dataJson = Value(dataJson),
       color = Value(color),
       z = Value(z);
  static Insertable<Annotation> custom({
    Expression<String>? id,
    Expression<String>? spaceId,
    Expression<DateTime>? createdAt,
    Expression<String>? createdBy,
    Expression<String>? updatedBy,
    Expression<String>? hlc,
    Expression<bool>? deleted,
    Expression<String>? attachmentId,
    Expression<String>? kind,
    Expression<String>? dataJson,
    Expression<int>? color,
    Expression<int>? z,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (spaceId != null) 'space_id': spaceId,
      if (createdAt != null) 'created_at': createdAt,
      if (createdBy != null) 'created_by': createdBy,
      if (updatedBy != null) 'updated_by': updatedBy,
      if (hlc != null) 'hlc': hlc,
      if (deleted != null) 'deleted': deleted,
      if (attachmentId != null) 'attachment_id': attachmentId,
      if (kind != null) 'kind': kind,
      if (dataJson != null) 'data_json': dataJson,
      if (color != null) 'color': color,
      if (z != null) 'z': z,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AnnotationsCompanion copyWith({
    Value<String>? id,
    Value<String>? spaceId,
    Value<DateTime>? createdAt,
    Value<String>? createdBy,
    Value<String>? updatedBy,
    Value<String>? hlc,
    Value<bool>? deleted,
    Value<String>? attachmentId,
    Value<AnnotationKind>? kind,
    Value<String>? dataJson,
    Value<int>? color,
    Value<int>? z,
    Value<int>? rowid,
  }) {
    return AnnotationsCompanion(
      id: id ?? this.id,
      spaceId: spaceId ?? this.spaceId,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      updatedBy: updatedBy ?? this.updatedBy,
      hlc: hlc ?? this.hlc,
      deleted: deleted ?? this.deleted,
      attachmentId: attachmentId ?? this.attachmentId,
      kind: kind ?? this.kind,
      dataJson: dataJson ?? this.dataJson,
      color: color ?? this.color,
      z: z ?? this.z,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (spaceId.present) {
      map['space_id'] = Variable<String>(spaceId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (createdBy.present) {
      map['created_by'] = Variable<String>(createdBy.value);
    }
    if (updatedBy.present) {
      map['updated_by'] = Variable<String>(updatedBy.value);
    }
    if (hlc.present) {
      map['hlc'] = Variable<String>(hlc.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<bool>(deleted.value);
    }
    if (attachmentId.present) {
      map['attachment_id'] = Variable<String>(attachmentId.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(
        $AnnotationsTable.$converterkind.toSql(kind.value),
      );
    }
    if (dataJson.present) {
      map['data_json'] = Variable<String>(dataJson.value);
    }
    if (color.present) {
      map['color'] = Variable<int>(color.value);
    }
    if (z.present) {
      map['z'] = Variable<int>(z.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AnnotationsCompanion(')
          ..write('id: $id, ')
          ..write('spaceId: $spaceId, ')
          ..write('createdAt: $createdAt, ')
          ..write('createdBy: $createdBy, ')
          ..write('updatedBy: $updatedBy, ')
          ..write('hlc: $hlc, ')
          ..write('deleted: $deleted, ')
          ..write('attachmentId: $attachmentId, ')
          ..write('kind: $kind, ')
          ..write('dataJson: $dataJson, ')
          ..write('color: $color, ')
          ..write('z: $z, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RemindersTable extends Reminders
    with TableInfo<$RemindersTable, Reminder> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RemindersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _spaceIdMeta = const VerificationMeta(
    'spaceId',
  );
  @override
  late final GeneratedColumn<String> spaceId = GeneratedColumn<String>(
    'space_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdByMeta = const VerificationMeta(
    'createdBy',
  );
  @override
  late final GeneratedColumn<String> createdBy = GeneratedColumn<String>(
    'created_by',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedByMeta = const VerificationMeta(
    'updatedBy',
  );
  @override
  late final GeneratedColumn<String> updatedBy = GeneratedColumn<String>(
    'updated_by',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _hlcMeta = const VerificationMeta('hlc');
  @override
  late final GeneratedColumn<String> hlc = GeneratedColumn<String>(
    'hlc',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedMeta = const VerificationMeta(
    'deleted',
  );
  @override
  late final GeneratedColumn<bool> deleted = GeneratedColumn<bool>(
    'deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _nodeIdMeta = const VerificationMeta('nodeId');
  @override
  late final GeneratedColumn<String> nodeId = GeneratedColumn<String>(
    'node_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _minutesBeforeMeta = const VerificationMeta(
    'minutesBefore',
  );
  @override
  late final GeneratedColumn<int> minutesBefore = GeneratedColumn<int>(
    'minutes_before',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    spaceId,
    createdAt,
    createdBy,
    updatedBy,
    hlc,
    deleted,
    nodeId,
    minutesBefore,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'reminders';
  @override
  VerificationContext validateIntegrity(
    Insertable<Reminder> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('space_id')) {
      context.handle(
        _spaceIdMeta,
        spaceId.isAcceptableOrUnknown(data['space_id']!, _spaceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_spaceIdMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('created_by')) {
      context.handle(
        _createdByMeta,
        createdBy.isAcceptableOrUnknown(data['created_by']!, _createdByMeta),
      );
    } else if (isInserting) {
      context.missing(_createdByMeta);
    }
    if (data.containsKey('updated_by')) {
      context.handle(
        _updatedByMeta,
        updatedBy.isAcceptableOrUnknown(data['updated_by']!, _updatedByMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedByMeta);
    }
    if (data.containsKey('hlc')) {
      context.handle(
        _hlcMeta,
        hlc.isAcceptableOrUnknown(data['hlc']!, _hlcMeta),
      );
    } else if (isInserting) {
      context.missing(_hlcMeta);
    }
    if (data.containsKey('deleted')) {
      context.handle(
        _deletedMeta,
        deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta),
      );
    }
    if (data.containsKey('node_id')) {
      context.handle(
        _nodeIdMeta,
        nodeId.isAcceptableOrUnknown(data['node_id']!, _nodeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_nodeIdMeta);
    }
    if (data.containsKey('minutes_before')) {
      context.handle(
        _minutesBeforeMeta,
        minutesBefore.isAcceptableOrUnknown(
          data['minutes_before']!,
          _minutesBeforeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_minutesBeforeMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Reminder map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Reminder(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      spaceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}space_id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      createdBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_by'],
      )!,
      updatedBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}updated_by'],
      )!,
      hlc: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}hlc'],
      )!,
      deleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}deleted'],
      )!,
      nodeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}node_id'],
      )!,
      minutesBefore: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}minutes_before'],
      )!,
    );
  }

  @override
  $RemindersTable createAlias(String alias) {
    return $RemindersTable(attachedDatabase, alias);
  }
}

class Reminder extends DataClass implements Insertable<Reminder> {
  /// UUIDv7.
  final String id;

  /// The space this row belongs to (§5.0, D13).
  final String spaceId;
  final DateTime createdAt;

  /// User ID of the creator.
  final String createdBy;

  /// User ID of whoever made the latest change.
  final String updatedBy;

  /// Hybrid logical clock stamp of the latest change (see `sync/hlc.dart`).
  final String hlc;

  /// Tombstone flag. Rows are never hard-deleted until compaction.
  final bool deleted;
  final String nodeId;
  final int minutesBefore;
  const Reminder({
    required this.id,
    required this.spaceId,
    required this.createdAt,
    required this.createdBy,
    required this.updatedBy,
    required this.hlc,
    required this.deleted,
    required this.nodeId,
    required this.minutesBefore,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['space_id'] = Variable<String>(spaceId);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['created_by'] = Variable<String>(createdBy);
    map['updated_by'] = Variable<String>(updatedBy);
    map['hlc'] = Variable<String>(hlc);
    map['deleted'] = Variable<bool>(deleted);
    map['node_id'] = Variable<String>(nodeId);
    map['minutes_before'] = Variable<int>(minutesBefore);
    return map;
  }

  RemindersCompanion toCompanion(bool nullToAbsent) {
    return RemindersCompanion(
      id: Value(id),
      spaceId: Value(spaceId),
      createdAt: Value(createdAt),
      createdBy: Value(createdBy),
      updatedBy: Value(updatedBy),
      hlc: Value(hlc),
      deleted: Value(deleted),
      nodeId: Value(nodeId),
      minutesBefore: Value(minutesBefore),
    );
  }

  factory Reminder.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Reminder(
      id: serializer.fromJson<String>(json['id']),
      spaceId: serializer.fromJson<String>(json['spaceId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      createdBy: serializer.fromJson<String>(json['createdBy']),
      updatedBy: serializer.fromJson<String>(json['updatedBy']),
      hlc: serializer.fromJson<String>(json['hlc']),
      deleted: serializer.fromJson<bool>(json['deleted']),
      nodeId: serializer.fromJson<String>(json['nodeId']),
      minutesBefore: serializer.fromJson<int>(json['minutesBefore']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'spaceId': serializer.toJson<String>(spaceId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'createdBy': serializer.toJson<String>(createdBy),
      'updatedBy': serializer.toJson<String>(updatedBy),
      'hlc': serializer.toJson<String>(hlc),
      'deleted': serializer.toJson<bool>(deleted),
      'nodeId': serializer.toJson<String>(nodeId),
      'minutesBefore': serializer.toJson<int>(minutesBefore),
    };
  }

  Reminder copyWith({
    String? id,
    String? spaceId,
    DateTime? createdAt,
    String? createdBy,
    String? updatedBy,
    String? hlc,
    bool? deleted,
    String? nodeId,
    int? minutesBefore,
  }) => Reminder(
    id: id ?? this.id,
    spaceId: spaceId ?? this.spaceId,
    createdAt: createdAt ?? this.createdAt,
    createdBy: createdBy ?? this.createdBy,
    updatedBy: updatedBy ?? this.updatedBy,
    hlc: hlc ?? this.hlc,
    deleted: deleted ?? this.deleted,
    nodeId: nodeId ?? this.nodeId,
    minutesBefore: minutesBefore ?? this.minutesBefore,
  );
  Reminder copyWithCompanion(RemindersCompanion data) {
    return Reminder(
      id: data.id.present ? data.id.value : this.id,
      spaceId: data.spaceId.present ? data.spaceId.value : this.spaceId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      createdBy: data.createdBy.present ? data.createdBy.value : this.createdBy,
      updatedBy: data.updatedBy.present ? data.updatedBy.value : this.updatedBy,
      hlc: data.hlc.present ? data.hlc.value : this.hlc,
      deleted: data.deleted.present ? data.deleted.value : this.deleted,
      nodeId: data.nodeId.present ? data.nodeId.value : this.nodeId,
      minutesBefore: data.minutesBefore.present
          ? data.minutesBefore.value
          : this.minutesBefore,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Reminder(')
          ..write('id: $id, ')
          ..write('spaceId: $spaceId, ')
          ..write('createdAt: $createdAt, ')
          ..write('createdBy: $createdBy, ')
          ..write('updatedBy: $updatedBy, ')
          ..write('hlc: $hlc, ')
          ..write('deleted: $deleted, ')
          ..write('nodeId: $nodeId, ')
          ..write('minutesBefore: $minutesBefore')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    spaceId,
    createdAt,
    createdBy,
    updatedBy,
    hlc,
    deleted,
    nodeId,
    minutesBefore,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Reminder &&
          other.id == this.id &&
          other.spaceId == this.spaceId &&
          other.createdAt == this.createdAt &&
          other.createdBy == this.createdBy &&
          other.updatedBy == this.updatedBy &&
          other.hlc == this.hlc &&
          other.deleted == this.deleted &&
          other.nodeId == this.nodeId &&
          other.minutesBefore == this.minutesBefore);
}

class RemindersCompanion extends UpdateCompanion<Reminder> {
  final Value<String> id;
  final Value<String> spaceId;
  final Value<DateTime> createdAt;
  final Value<String> createdBy;
  final Value<String> updatedBy;
  final Value<String> hlc;
  final Value<bool> deleted;
  final Value<String> nodeId;
  final Value<int> minutesBefore;
  final Value<int> rowid;
  const RemindersCompanion({
    this.id = const Value.absent(),
    this.spaceId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.createdBy = const Value.absent(),
    this.updatedBy = const Value.absent(),
    this.hlc = const Value.absent(),
    this.deleted = const Value.absent(),
    this.nodeId = const Value.absent(),
    this.minutesBefore = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RemindersCompanion.insert({
    required String id,
    required String spaceId,
    required DateTime createdAt,
    required String createdBy,
    required String updatedBy,
    required String hlc,
    this.deleted = const Value.absent(),
    required String nodeId,
    required int minutesBefore,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       spaceId = Value(spaceId),
       createdAt = Value(createdAt),
       createdBy = Value(createdBy),
       updatedBy = Value(updatedBy),
       hlc = Value(hlc),
       nodeId = Value(nodeId),
       minutesBefore = Value(minutesBefore);
  static Insertable<Reminder> custom({
    Expression<String>? id,
    Expression<String>? spaceId,
    Expression<DateTime>? createdAt,
    Expression<String>? createdBy,
    Expression<String>? updatedBy,
    Expression<String>? hlc,
    Expression<bool>? deleted,
    Expression<String>? nodeId,
    Expression<int>? minutesBefore,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (spaceId != null) 'space_id': spaceId,
      if (createdAt != null) 'created_at': createdAt,
      if (createdBy != null) 'created_by': createdBy,
      if (updatedBy != null) 'updated_by': updatedBy,
      if (hlc != null) 'hlc': hlc,
      if (deleted != null) 'deleted': deleted,
      if (nodeId != null) 'node_id': nodeId,
      if (minutesBefore != null) 'minutes_before': minutesBefore,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RemindersCompanion copyWith({
    Value<String>? id,
    Value<String>? spaceId,
    Value<DateTime>? createdAt,
    Value<String>? createdBy,
    Value<String>? updatedBy,
    Value<String>? hlc,
    Value<bool>? deleted,
    Value<String>? nodeId,
    Value<int>? minutesBefore,
    Value<int>? rowid,
  }) {
    return RemindersCompanion(
      id: id ?? this.id,
      spaceId: spaceId ?? this.spaceId,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      updatedBy: updatedBy ?? this.updatedBy,
      hlc: hlc ?? this.hlc,
      deleted: deleted ?? this.deleted,
      nodeId: nodeId ?? this.nodeId,
      minutesBefore: minutesBefore ?? this.minutesBefore,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (spaceId.present) {
      map['space_id'] = Variable<String>(spaceId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (createdBy.present) {
      map['created_by'] = Variable<String>(createdBy.value);
    }
    if (updatedBy.present) {
      map['updated_by'] = Variable<String>(updatedBy.value);
    }
    if (hlc.present) {
      map['hlc'] = Variable<String>(hlc.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<bool>(deleted.value);
    }
    if (nodeId.present) {
      map['node_id'] = Variable<String>(nodeId.value);
    }
    if (minutesBefore.present) {
      map['minutes_before'] = Variable<int>(minutesBefore.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RemindersCompanion(')
          ..write('id: $id, ')
          ..write('spaceId: $spaceId, ')
          ..write('createdAt: $createdAt, ')
          ..write('createdBy: $createdBy, ')
          ..write('updatedBy: $updatedBy, ')
          ..write('hlc: $hlc, ')
          ..write('deleted: $deleted, ')
          ..write('nodeId: $nodeId, ')
          ..write('minutesBefore: $minutesBefore, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $NodeUserPrefsTable extends NodeUserPrefs
    with TableInfo<$NodeUserPrefsTable, NodeUserPref> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NodeUserPrefsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _spaceIdMeta = const VerificationMeta(
    'spaceId',
  );
  @override
  late final GeneratedColumn<String> spaceId = GeneratedColumn<String>(
    'space_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdByMeta = const VerificationMeta(
    'createdBy',
  );
  @override
  late final GeneratedColumn<String> createdBy = GeneratedColumn<String>(
    'created_by',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedByMeta = const VerificationMeta(
    'updatedBy',
  );
  @override
  late final GeneratedColumn<String> updatedBy = GeneratedColumn<String>(
    'updated_by',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _hlcMeta = const VerificationMeta('hlc');
  @override
  late final GeneratedColumn<String> hlc = GeneratedColumn<String>(
    'hlc',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedMeta = const VerificationMeta(
    'deleted',
  );
  @override
  late final GeneratedColumn<bool> deleted = GeneratedColumn<bool>(
    'deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _nodeIdMeta = const VerificationMeta('nodeId');
  @override
  late final GeneratedColumn<String> nodeId = GeneratedColumn<String>(
    'node_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _icsExportMeta = const VerificationMeta(
    'icsExport',
  );
  @override
  late final GeneratedColumn<bool> icsExport = GeneratedColumn<bool>(
    'ics_export',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("ics_export" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    spaceId,
    createdAt,
    createdBy,
    updatedBy,
    hlc,
    deleted,
    nodeId,
    icsExport,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'node_user_prefs';
  @override
  VerificationContext validateIntegrity(
    Insertable<NodeUserPref> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('space_id')) {
      context.handle(
        _spaceIdMeta,
        spaceId.isAcceptableOrUnknown(data['space_id']!, _spaceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_spaceIdMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('created_by')) {
      context.handle(
        _createdByMeta,
        createdBy.isAcceptableOrUnknown(data['created_by']!, _createdByMeta),
      );
    } else if (isInserting) {
      context.missing(_createdByMeta);
    }
    if (data.containsKey('updated_by')) {
      context.handle(
        _updatedByMeta,
        updatedBy.isAcceptableOrUnknown(data['updated_by']!, _updatedByMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedByMeta);
    }
    if (data.containsKey('hlc')) {
      context.handle(
        _hlcMeta,
        hlc.isAcceptableOrUnknown(data['hlc']!, _hlcMeta),
      );
    } else if (isInserting) {
      context.missing(_hlcMeta);
    }
    if (data.containsKey('deleted')) {
      context.handle(
        _deletedMeta,
        deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta),
      );
    }
    if (data.containsKey('node_id')) {
      context.handle(
        _nodeIdMeta,
        nodeId.isAcceptableOrUnknown(data['node_id']!, _nodeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_nodeIdMeta);
    }
    if (data.containsKey('ics_export')) {
      context.handle(
        _icsExportMeta,
        icsExport.isAcceptableOrUnknown(data['ics_export']!, _icsExportMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  NodeUserPref map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return NodeUserPref(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      spaceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}space_id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      createdBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_by'],
      )!,
      updatedBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}updated_by'],
      )!,
      hlc: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}hlc'],
      )!,
      deleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}deleted'],
      )!,
      nodeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}node_id'],
      )!,
      icsExport: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}ics_export'],
      )!,
    );
  }

  @override
  $NodeUserPrefsTable createAlias(String alias) {
    return $NodeUserPrefsTable(attachedDatabase, alias);
  }
}

class NodeUserPref extends DataClass implements Insertable<NodeUserPref> {
  /// UUIDv7.
  final String id;

  /// The space this row belongs to (§5.0, D13).
  final String spaceId;
  final DateTime createdAt;

  /// User ID of the creator.
  final String createdBy;

  /// User ID of whoever made the latest change.
  final String updatedBy;

  /// Hybrid logical clock stamp of the latest change (see `sync/hlc.dart`).
  final String hlc;

  /// Tombstone flag. Rows are never hard-deleted until compaction.
  final bool deleted;
  final String nodeId;

  /// Included in "Export calendar" (.ics). Off by default (v0.13).
  final bool icsExport;
  const NodeUserPref({
    required this.id,
    required this.spaceId,
    required this.createdAt,
    required this.createdBy,
    required this.updatedBy,
    required this.hlc,
    required this.deleted,
    required this.nodeId,
    required this.icsExport,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['space_id'] = Variable<String>(spaceId);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['created_by'] = Variable<String>(createdBy);
    map['updated_by'] = Variable<String>(updatedBy);
    map['hlc'] = Variable<String>(hlc);
    map['deleted'] = Variable<bool>(deleted);
    map['node_id'] = Variable<String>(nodeId);
    map['ics_export'] = Variable<bool>(icsExport);
    return map;
  }

  NodeUserPrefsCompanion toCompanion(bool nullToAbsent) {
    return NodeUserPrefsCompanion(
      id: Value(id),
      spaceId: Value(spaceId),
      createdAt: Value(createdAt),
      createdBy: Value(createdBy),
      updatedBy: Value(updatedBy),
      hlc: Value(hlc),
      deleted: Value(deleted),
      nodeId: Value(nodeId),
      icsExport: Value(icsExport),
    );
  }

  factory NodeUserPref.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return NodeUserPref(
      id: serializer.fromJson<String>(json['id']),
      spaceId: serializer.fromJson<String>(json['spaceId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      createdBy: serializer.fromJson<String>(json['createdBy']),
      updatedBy: serializer.fromJson<String>(json['updatedBy']),
      hlc: serializer.fromJson<String>(json['hlc']),
      deleted: serializer.fromJson<bool>(json['deleted']),
      nodeId: serializer.fromJson<String>(json['nodeId']),
      icsExport: serializer.fromJson<bool>(json['icsExport']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'spaceId': serializer.toJson<String>(spaceId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'createdBy': serializer.toJson<String>(createdBy),
      'updatedBy': serializer.toJson<String>(updatedBy),
      'hlc': serializer.toJson<String>(hlc),
      'deleted': serializer.toJson<bool>(deleted),
      'nodeId': serializer.toJson<String>(nodeId),
      'icsExport': serializer.toJson<bool>(icsExport),
    };
  }

  NodeUserPref copyWith({
    String? id,
    String? spaceId,
    DateTime? createdAt,
    String? createdBy,
    String? updatedBy,
    String? hlc,
    bool? deleted,
    String? nodeId,
    bool? icsExport,
  }) => NodeUserPref(
    id: id ?? this.id,
    spaceId: spaceId ?? this.spaceId,
    createdAt: createdAt ?? this.createdAt,
    createdBy: createdBy ?? this.createdBy,
    updatedBy: updatedBy ?? this.updatedBy,
    hlc: hlc ?? this.hlc,
    deleted: deleted ?? this.deleted,
    nodeId: nodeId ?? this.nodeId,
    icsExport: icsExport ?? this.icsExport,
  );
  NodeUserPref copyWithCompanion(NodeUserPrefsCompanion data) {
    return NodeUserPref(
      id: data.id.present ? data.id.value : this.id,
      spaceId: data.spaceId.present ? data.spaceId.value : this.spaceId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      createdBy: data.createdBy.present ? data.createdBy.value : this.createdBy,
      updatedBy: data.updatedBy.present ? data.updatedBy.value : this.updatedBy,
      hlc: data.hlc.present ? data.hlc.value : this.hlc,
      deleted: data.deleted.present ? data.deleted.value : this.deleted,
      nodeId: data.nodeId.present ? data.nodeId.value : this.nodeId,
      icsExport: data.icsExport.present ? data.icsExport.value : this.icsExport,
    );
  }

  @override
  String toString() {
    return (StringBuffer('NodeUserPref(')
          ..write('id: $id, ')
          ..write('spaceId: $spaceId, ')
          ..write('createdAt: $createdAt, ')
          ..write('createdBy: $createdBy, ')
          ..write('updatedBy: $updatedBy, ')
          ..write('hlc: $hlc, ')
          ..write('deleted: $deleted, ')
          ..write('nodeId: $nodeId, ')
          ..write('icsExport: $icsExport')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    spaceId,
    createdAt,
    createdBy,
    updatedBy,
    hlc,
    deleted,
    nodeId,
    icsExport,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NodeUserPref &&
          other.id == this.id &&
          other.spaceId == this.spaceId &&
          other.createdAt == this.createdAt &&
          other.createdBy == this.createdBy &&
          other.updatedBy == this.updatedBy &&
          other.hlc == this.hlc &&
          other.deleted == this.deleted &&
          other.nodeId == this.nodeId &&
          other.icsExport == this.icsExport);
}

class NodeUserPrefsCompanion extends UpdateCompanion<NodeUserPref> {
  final Value<String> id;
  final Value<String> spaceId;
  final Value<DateTime> createdAt;
  final Value<String> createdBy;
  final Value<String> updatedBy;
  final Value<String> hlc;
  final Value<bool> deleted;
  final Value<String> nodeId;
  final Value<bool> icsExport;
  final Value<int> rowid;
  const NodeUserPrefsCompanion({
    this.id = const Value.absent(),
    this.spaceId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.createdBy = const Value.absent(),
    this.updatedBy = const Value.absent(),
    this.hlc = const Value.absent(),
    this.deleted = const Value.absent(),
    this.nodeId = const Value.absent(),
    this.icsExport = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  NodeUserPrefsCompanion.insert({
    required String id,
    required String spaceId,
    required DateTime createdAt,
    required String createdBy,
    required String updatedBy,
    required String hlc,
    this.deleted = const Value.absent(),
    required String nodeId,
    this.icsExport = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       spaceId = Value(spaceId),
       createdAt = Value(createdAt),
       createdBy = Value(createdBy),
       updatedBy = Value(updatedBy),
       hlc = Value(hlc),
       nodeId = Value(nodeId);
  static Insertable<NodeUserPref> custom({
    Expression<String>? id,
    Expression<String>? spaceId,
    Expression<DateTime>? createdAt,
    Expression<String>? createdBy,
    Expression<String>? updatedBy,
    Expression<String>? hlc,
    Expression<bool>? deleted,
    Expression<String>? nodeId,
    Expression<bool>? icsExport,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (spaceId != null) 'space_id': spaceId,
      if (createdAt != null) 'created_at': createdAt,
      if (createdBy != null) 'created_by': createdBy,
      if (updatedBy != null) 'updated_by': updatedBy,
      if (hlc != null) 'hlc': hlc,
      if (deleted != null) 'deleted': deleted,
      if (nodeId != null) 'node_id': nodeId,
      if (icsExport != null) 'ics_export': icsExport,
      if (rowid != null) 'rowid': rowid,
    });
  }

  NodeUserPrefsCompanion copyWith({
    Value<String>? id,
    Value<String>? spaceId,
    Value<DateTime>? createdAt,
    Value<String>? createdBy,
    Value<String>? updatedBy,
    Value<String>? hlc,
    Value<bool>? deleted,
    Value<String>? nodeId,
    Value<bool>? icsExport,
    Value<int>? rowid,
  }) {
    return NodeUserPrefsCompanion(
      id: id ?? this.id,
      spaceId: spaceId ?? this.spaceId,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      updatedBy: updatedBy ?? this.updatedBy,
      hlc: hlc ?? this.hlc,
      deleted: deleted ?? this.deleted,
      nodeId: nodeId ?? this.nodeId,
      icsExport: icsExport ?? this.icsExport,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (spaceId.present) {
      map['space_id'] = Variable<String>(spaceId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (createdBy.present) {
      map['created_by'] = Variable<String>(createdBy.value);
    }
    if (updatedBy.present) {
      map['updated_by'] = Variable<String>(updatedBy.value);
    }
    if (hlc.present) {
      map['hlc'] = Variable<String>(hlc.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<bool>(deleted.value);
    }
    if (nodeId.present) {
      map['node_id'] = Variable<String>(nodeId.value);
    }
    if (icsExport.present) {
      map['ics_export'] = Variable<bool>(icsExport.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NodeUserPrefsCompanion(')
          ..write('id: $id, ')
          ..write('spaceId: $spaceId, ')
          ..write('createdAt: $createdAt, ')
          ..write('createdBy: $createdBy, ')
          ..write('updatedBy: $updatedBy, ')
          ..write('hlc: $hlc, ')
          ..write('deleted: $deleted, ')
          ..write('nodeId: $nodeId, ')
          ..write('icsExport: $icsExport, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ChangeLogTable extends ChangeLog
    with TableInfo<$ChangeLogTable, ChangeOp> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChangeLogTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _opIdMeta = const VerificationMeta('opId');
  @override
  late final GeneratedColumn<String> opId = GeneratedColumn<String>(
    'op_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _spaceIdMeta = const VerificationMeta(
    'spaceId',
  );
  @override
  late final GeneratedColumn<String> spaceId = GeneratedColumn<String>(
    'space_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rowTableMeta = const VerificationMeta(
    'rowTable',
  );
  @override
  late final GeneratedColumn<String> rowTable = GeneratedColumn<String>(
    'table_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rowIdMeta = const VerificationMeta('rowId');
  @override
  late final GeneratedColumn<String> rowId = GeneratedColumn<String>(
    'row_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _columnNameMeta = const VerificationMeta(
    'columnName',
  );
  @override
  late final GeneratedColumn<String> columnName = GeneratedColumn<String>(
    'column_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _hlcMeta = const VerificationMeta('hlc');
  @override
  late final GeneratedColumn<String> hlc = GeneratedColumn<String>(
    'hlc',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _originDeviceIdMeta = const VerificationMeta(
    'originDeviceId',
  );
  @override
  late final GeneratedColumn<String> originDeviceId = GeneratedColumn<String>(
    'origin_device_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _authorUserIdMeta = const VerificationMeta(
    'authorUserId',
  );
  @override
  late final GeneratedColumn<String> authorUserId = GeneratedColumn<String>(
    'author_user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _schemaVersionMeta = const VerificationMeta(
    'schemaVersion',
  );
  @override
  late final GeneratedColumn<int> schemaVersion = GeneratedColumn<int>(
    'schema_version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    opId,
    spaceId,
    rowTable,
    rowId,
    columnName,
    value,
    hlc,
    originDeviceId,
    authorUserId,
    schemaVersion,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'change_log';
  @override
  VerificationContext validateIntegrity(
    Insertable<ChangeOp> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('op_id')) {
      context.handle(
        _opIdMeta,
        opId.isAcceptableOrUnknown(data['op_id']!, _opIdMeta),
      );
    } else if (isInserting) {
      context.missing(_opIdMeta);
    }
    if (data.containsKey('space_id')) {
      context.handle(
        _spaceIdMeta,
        spaceId.isAcceptableOrUnknown(data['space_id']!, _spaceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_spaceIdMeta);
    }
    if (data.containsKey('table_name')) {
      context.handle(
        _rowTableMeta,
        rowTable.isAcceptableOrUnknown(data['table_name']!, _rowTableMeta),
      );
    } else if (isInserting) {
      context.missing(_rowTableMeta);
    }
    if (data.containsKey('row_id')) {
      context.handle(
        _rowIdMeta,
        rowId.isAcceptableOrUnknown(data['row_id']!, _rowIdMeta),
      );
    } else if (isInserting) {
      context.missing(_rowIdMeta);
    }
    if (data.containsKey('column_name')) {
      context.handle(
        _columnNameMeta,
        columnName.isAcceptableOrUnknown(data['column_name']!, _columnNameMeta),
      );
    } else if (isInserting) {
      context.missing(_columnNameMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    if (data.containsKey('hlc')) {
      context.handle(
        _hlcMeta,
        hlc.isAcceptableOrUnknown(data['hlc']!, _hlcMeta),
      );
    } else if (isInserting) {
      context.missing(_hlcMeta);
    }
    if (data.containsKey('origin_device_id')) {
      context.handle(
        _originDeviceIdMeta,
        originDeviceId.isAcceptableOrUnknown(
          data['origin_device_id']!,
          _originDeviceIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_originDeviceIdMeta);
    }
    if (data.containsKey('author_user_id')) {
      context.handle(
        _authorUserIdMeta,
        authorUserId.isAcceptableOrUnknown(
          data['author_user_id']!,
          _authorUserIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_authorUserIdMeta);
    }
    if (data.containsKey('schema_version')) {
      context.handle(
        _schemaVersionMeta,
        schemaVersion.isAcceptableOrUnknown(
          data['schema_version']!,
          _schemaVersionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_schemaVersionMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {opId};
  @override
  ChangeOp map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ChangeOp(
      opId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}op_id'],
      )!,
      spaceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}space_id'],
      )!,
      rowTable: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}table_name'],
      )!,
      rowId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}row_id'],
      )!,
      columnName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}column_name'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
      hlc: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}hlc'],
      )!,
      originDeviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}origin_device_id'],
      )!,
      authorUserId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}author_user_id'],
      )!,
      schemaVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}schema_version'],
      )!,
    );
  }

  @override
  $ChangeLogTable createAlias(String alias) {
    return $ChangeLogTable(attachedDatabase, alias);
  }
}

class ChangeOp extends DataClass implements Insertable<ChangeOp> {
  final String opId;
  final String spaceId;

  /// SQL name of the table the op applies to.
  final String rowTable;
  final String rowId;
  final String columnName;

  /// JSON-encoded SQL value (string, number or null; booleans are 0/1).
  final String value;
  final String hlc;
  final String originDeviceId;
  final String authorUserId;
  final int schemaVersion;
  const ChangeOp({
    required this.opId,
    required this.spaceId,
    required this.rowTable,
    required this.rowId,
    required this.columnName,
    required this.value,
    required this.hlc,
    required this.originDeviceId,
    required this.authorUserId,
    required this.schemaVersion,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['op_id'] = Variable<String>(opId);
    map['space_id'] = Variable<String>(spaceId);
    map['table_name'] = Variable<String>(rowTable);
    map['row_id'] = Variable<String>(rowId);
    map['column_name'] = Variable<String>(columnName);
    map['value'] = Variable<String>(value);
    map['hlc'] = Variable<String>(hlc);
    map['origin_device_id'] = Variable<String>(originDeviceId);
    map['author_user_id'] = Variable<String>(authorUserId);
    map['schema_version'] = Variable<int>(schemaVersion);
    return map;
  }

  ChangeLogCompanion toCompanion(bool nullToAbsent) {
    return ChangeLogCompanion(
      opId: Value(opId),
      spaceId: Value(spaceId),
      rowTable: Value(rowTable),
      rowId: Value(rowId),
      columnName: Value(columnName),
      value: Value(value),
      hlc: Value(hlc),
      originDeviceId: Value(originDeviceId),
      authorUserId: Value(authorUserId),
      schemaVersion: Value(schemaVersion),
    );
  }

  factory ChangeOp.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ChangeOp(
      opId: serializer.fromJson<String>(json['opId']),
      spaceId: serializer.fromJson<String>(json['spaceId']),
      rowTable: serializer.fromJson<String>(json['rowTable']),
      rowId: serializer.fromJson<String>(json['rowId']),
      columnName: serializer.fromJson<String>(json['columnName']),
      value: serializer.fromJson<String>(json['value']),
      hlc: serializer.fromJson<String>(json['hlc']),
      originDeviceId: serializer.fromJson<String>(json['originDeviceId']),
      authorUserId: serializer.fromJson<String>(json['authorUserId']),
      schemaVersion: serializer.fromJson<int>(json['schemaVersion']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'opId': serializer.toJson<String>(opId),
      'spaceId': serializer.toJson<String>(spaceId),
      'rowTable': serializer.toJson<String>(rowTable),
      'rowId': serializer.toJson<String>(rowId),
      'columnName': serializer.toJson<String>(columnName),
      'value': serializer.toJson<String>(value),
      'hlc': serializer.toJson<String>(hlc),
      'originDeviceId': serializer.toJson<String>(originDeviceId),
      'authorUserId': serializer.toJson<String>(authorUserId),
      'schemaVersion': serializer.toJson<int>(schemaVersion),
    };
  }

  ChangeOp copyWith({
    String? opId,
    String? spaceId,
    String? rowTable,
    String? rowId,
    String? columnName,
    String? value,
    String? hlc,
    String? originDeviceId,
    String? authorUserId,
    int? schemaVersion,
  }) => ChangeOp(
    opId: opId ?? this.opId,
    spaceId: spaceId ?? this.spaceId,
    rowTable: rowTable ?? this.rowTable,
    rowId: rowId ?? this.rowId,
    columnName: columnName ?? this.columnName,
    value: value ?? this.value,
    hlc: hlc ?? this.hlc,
    originDeviceId: originDeviceId ?? this.originDeviceId,
    authorUserId: authorUserId ?? this.authorUserId,
    schemaVersion: schemaVersion ?? this.schemaVersion,
  );
  ChangeOp copyWithCompanion(ChangeLogCompanion data) {
    return ChangeOp(
      opId: data.opId.present ? data.opId.value : this.opId,
      spaceId: data.spaceId.present ? data.spaceId.value : this.spaceId,
      rowTable: data.rowTable.present ? data.rowTable.value : this.rowTable,
      rowId: data.rowId.present ? data.rowId.value : this.rowId,
      columnName: data.columnName.present
          ? data.columnName.value
          : this.columnName,
      value: data.value.present ? data.value.value : this.value,
      hlc: data.hlc.present ? data.hlc.value : this.hlc,
      originDeviceId: data.originDeviceId.present
          ? data.originDeviceId.value
          : this.originDeviceId,
      authorUserId: data.authorUserId.present
          ? data.authorUserId.value
          : this.authorUserId,
      schemaVersion: data.schemaVersion.present
          ? data.schemaVersion.value
          : this.schemaVersion,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ChangeOp(')
          ..write('opId: $opId, ')
          ..write('spaceId: $spaceId, ')
          ..write('rowTable: $rowTable, ')
          ..write('rowId: $rowId, ')
          ..write('columnName: $columnName, ')
          ..write('value: $value, ')
          ..write('hlc: $hlc, ')
          ..write('originDeviceId: $originDeviceId, ')
          ..write('authorUserId: $authorUserId, ')
          ..write('schemaVersion: $schemaVersion')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    opId,
    spaceId,
    rowTable,
    rowId,
    columnName,
    value,
    hlc,
    originDeviceId,
    authorUserId,
    schemaVersion,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChangeOp &&
          other.opId == this.opId &&
          other.spaceId == this.spaceId &&
          other.rowTable == this.rowTable &&
          other.rowId == this.rowId &&
          other.columnName == this.columnName &&
          other.value == this.value &&
          other.hlc == this.hlc &&
          other.originDeviceId == this.originDeviceId &&
          other.authorUserId == this.authorUserId &&
          other.schemaVersion == this.schemaVersion);
}

class ChangeLogCompanion extends UpdateCompanion<ChangeOp> {
  final Value<String> opId;
  final Value<String> spaceId;
  final Value<String> rowTable;
  final Value<String> rowId;
  final Value<String> columnName;
  final Value<String> value;
  final Value<String> hlc;
  final Value<String> originDeviceId;
  final Value<String> authorUserId;
  final Value<int> schemaVersion;
  final Value<int> rowid;
  const ChangeLogCompanion({
    this.opId = const Value.absent(),
    this.spaceId = const Value.absent(),
    this.rowTable = const Value.absent(),
    this.rowId = const Value.absent(),
    this.columnName = const Value.absent(),
    this.value = const Value.absent(),
    this.hlc = const Value.absent(),
    this.originDeviceId = const Value.absent(),
    this.authorUserId = const Value.absent(),
    this.schemaVersion = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ChangeLogCompanion.insert({
    required String opId,
    required String spaceId,
    required String rowTable,
    required String rowId,
    required String columnName,
    required String value,
    required String hlc,
    required String originDeviceId,
    required String authorUserId,
    required int schemaVersion,
    this.rowid = const Value.absent(),
  }) : opId = Value(opId),
       spaceId = Value(spaceId),
       rowTable = Value(rowTable),
       rowId = Value(rowId),
       columnName = Value(columnName),
       value = Value(value),
       hlc = Value(hlc),
       originDeviceId = Value(originDeviceId),
       authorUserId = Value(authorUserId),
       schemaVersion = Value(schemaVersion);
  static Insertable<ChangeOp> custom({
    Expression<String>? opId,
    Expression<String>? spaceId,
    Expression<String>? rowTable,
    Expression<String>? rowId,
    Expression<String>? columnName,
    Expression<String>? value,
    Expression<String>? hlc,
    Expression<String>? originDeviceId,
    Expression<String>? authorUserId,
    Expression<int>? schemaVersion,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (opId != null) 'op_id': opId,
      if (spaceId != null) 'space_id': spaceId,
      if (rowTable != null) 'table_name': rowTable,
      if (rowId != null) 'row_id': rowId,
      if (columnName != null) 'column_name': columnName,
      if (value != null) 'value': value,
      if (hlc != null) 'hlc': hlc,
      if (originDeviceId != null) 'origin_device_id': originDeviceId,
      if (authorUserId != null) 'author_user_id': authorUserId,
      if (schemaVersion != null) 'schema_version': schemaVersion,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ChangeLogCompanion copyWith({
    Value<String>? opId,
    Value<String>? spaceId,
    Value<String>? rowTable,
    Value<String>? rowId,
    Value<String>? columnName,
    Value<String>? value,
    Value<String>? hlc,
    Value<String>? originDeviceId,
    Value<String>? authorUserId,
    Value<int>? schemaVersion,
    Value<int>? rowid,
  }) {
    return ChangeLogCompanion(
      opId: opId ?? this.opId,
      spaceId: spaceId ?? this.spaceId,
      rowTable: rowTable ?? this.rowTable,
      rowId: rowId ?? this.rowId,
      columnName: columnName ?? this.columnName,
      value: value ?? this.value,
      hlc: hlc ?? this.hlc,
      originDeviceId: originDeviceId ?? this.originDeviceId,
      authorUserId: authorUserId ?? this.authorUserId,
      schemaVersion: schemaVersion ?? this.schemaVersion,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (opId.present) {
      map['op_id'] = Variable<String>(opId.value);
    }
    if (spaceId.present) {
      map['space_id'] = Variable<String>(spaceId.value);
    }
    if (rowTable.present) {
      map['table_name'] = Variable<String>(rowTable.value);
    }
    if (rowId.present) {
      map['row_id'] = Variable<String>(rowId.value);
    }
    if (columnName.present) {
      map['column_name'] = Variable<String>(columnName.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (hlc.present) {
      map['hlc'] = Variable<String>(hlc.value);
    }
    if (originDeviceId.present) {
      map['origin_device_id'] = Variable<String>(originDeviceId.value);
    }
    if (authorUserId.present) {
      map['author_user_id'] = Variable<String>(authorUserId.value);
    }
    if (schemaVersion.present) {
      map['schema_version'] = Variable<int>(schemaVersion.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChangeLogCompanion(')
          ..write('opId: $opId, ')
          ..write('spaceId: $spaceId, ')
          ..write('rowTable: $rowTable, ')
          ..write('rowId: $rowId, ')
          ..write('columnName: $columnName, ')
          ..write('value: $value, ')
          ..write('hlc: $hlc, ')
          ..write('originDeviceId: $originDeviceId, ')
          ..write('authorUserId: $authorUserId, ')
          ..write('schemaVersion: $schemaVersion, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DevicesTable extends Devices with TableInfo<$DevicesTable, Device> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DevicesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _devicePublicKeyMeta = const VerificationMeta(
    'devicePublicKey',
  );
  @override
  late final GeneratedColumn<String> devicePublicKey = GeneratedColumn<String>(
    'device_public_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _signedByUserKeyMeta = const VerificationMeta(
    'signedByUserKey',
  );
  @override
  late final GeneratedColumn<String> signedByUserKey = GeneratedColumn<String>(
    'signed_by_user_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
    'label',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isThisDeviceMeta = const VerificationMeta(
    'isThisDevice',
  );
  @override
  late final GeneratedColumn<bool> isThisDevice = GeneratedColumn<bool>(
    'is_this_device',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_this_device" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    deviceId,
    userId,
    devicePublicKey,
    signedByUserKey,
    label,
    isThisDevice,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'devices';
  @override
  VerificationContext validateIntegrity(
    Insertable<Device> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_deviceIdMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('device_public_key')) {
      context.handle(
        _devicePublicKeyMeta,
        devicePublicKey.isAcceptableOrUnknown(
          data['device_public_key']!,
          _devicePublicKeyMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_devicePublicKeyMeta);
    }
    if (data.containsKey('signed_by_user_key')) {
      context.handle(
        _signedByUserKeyMeta,
        signedByUserKey.isAcceptableOrUnknown(
          data['signed_by_user_key']!,
          _signedByUserKeyMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_signedByUserKeyMeta);
    }
    if (data.containsKey('label')) {
      context.handle(
        _labelMeta,
        label.isAcceptableOrUnknown(data['label']!, _labelMeta),
      );
    }
    if (data.containsKey('is_this_device')) {
      context.handle(
        _isThisDeviceMeta,
        isThisDevice.isAcceptableOrUnknown(
          data['is_this_device']!,
          _isThisDeviceMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {deviceId};
  @override
  Device map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Device(
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      devicePublicKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_public_key'],
      )!,
      signedByUserKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}signed_by_user_key'],
      )!,
      label: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}label'],
      ),
      isThisDevice: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_this_device'],
      )!,
    );
  }

  @override
  $DevicesTable createAlias(String alias) {
    return $DevicesTable(attachedDatabase, alias);
  }
}

class Device extends DataClass implements Insertable<Device> {
  final String deviceId;
  final String userId;

  /// Base64 Ed25519 public key.
  final String devicePublicKey;

  /// Base64 signature of the device public key by the user identity key.
  final String signedByUserKey;
  final String? label;

  /// True for exactly one row: the device this database lives on.
  final bool isThisDevice;
  const Device({
    required this.deviceId,
    required this.userId,
    required this.devicePublicKey,
    required this.signedByUserKey,
    this.label,
    required this.isThisDevice,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['device_id'] = Variable<String>(deviceId);
    map['user_id'] = Variable<String>(userId);
    map['device_public_key'] = Variable<String>(devicePublicKey);
    map['signed_by_user_key'] = Variable<String>(signedByUserKey);
    if (!nullToAbsent || label != null) {
      map['label'] = Variable<String>(label);
    }
    map['is_this_device'] = Variable<bool>(isThisDevice);
    return map;
  }

  DevicesCompanion toCompanion(bool nullToAbsent) {
    return DevicesCompanion(
      deviceId: Value(deviceId),
      userId: Value(userId),
      devicePublicKey: Value(devicePublicKey),
      signedByUserKey: Value(signedByUserKey),
      label: label == null && nullToAbsent
          ? const Value.absent()
          : Value(label),
      isThisDevice: Value(isThisDevice),
    );
  }

  factory Device.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Device(
      deviceId: serializer.fromJson<String>(json['deviceId']),
      userId: serializer.fromJson<String>(json['userId']),
      devicePublicKey: serializer.fromJson<String>(json['devicePublicKey']),
      signedByUserKey: serializer.fromJson<String>(json['signedByUserKey']),
      label: serializer.fromJson<String?>(json['label']),
      isThisDevice: serializer.fromJson<bool>(json['isThisDevice']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'deviceId': serializer.toJson<String>(deviceId),
      'userId': serializer.toJson<String>(userId),
      'devicePublicKey': serializer.toJson<String>(devicePublicKey),
      'signedByUserKey': serializer.toJson<String>(signedByUserKey),
      'label': serializer.toJson<String?>(label),
      'isThisDevice': serializer.toJson<bool>(isThisDevice),
    };
  }

  Device copyWith({
    String? deviceId,
    String? userId,
    String? devicePublicKey,
    String? signedByUserKey,
    Value<String?> label = const Value.absent(),
    bool? isThisDevice,
  }) => Device(
    deviceId: deviceId ?? this.deviceId,
    userId: userId ?? this.userId,
    devicePublicKey: devicePublicKey ?? this.devicePublicKey,
    signedByUserKey: signedByUserKey ?? this.signedByUserKey,
    label: label.present ? label.value : this.label,
    isThisDevice: isThisDevice ?? this.isThisDevice,
  );
  Device copyWithCompanion(DevicesCompanion data) {
    return Device(
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      userId: data.userId.present ? data.userId.value : this.userId,
      devicePublicKey: data.devicePublicKey.present
          ? data.devicePublicKey.value
          : this.devicePublicKey,
      signedByUserKey: data.signedByUserKey.present
          ? data.signedByUserKey.value
          : this.signedByUserKey,
      label: data.label.present ? data.label.value : this.label,
      isThisDevice: data.isThisDevice.present
          ? data.isThisDevice.value
          : this.isThisDevice,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Device(')
          ..write('deviceId: $deviceId, ')
          ..write('userId: $userId, ')
          ..write('devicePublicKey: $devicePublicKey, ')
          ..write('signedByUserKey: $signedByUserKey, ')
          ..write('label: $label, ')
          ..write('isThisDevice: $isThisDevice')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    deviceId,
    userId,
    devicePublicKey,
    signedByUserKey,
    label,
    isThisDevice,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Device &&
          other.deviceId == this.deviceId &&
          other.userId == this.userId &&
          other.devicePublicKey == this.devicePublicKey &&
          other.signedByUserKey == this.signedByUserKey &&
          other.label == this.label &&
          other.isThisDevice == this.isThisDevice);
}

class DevicesCompanion extends UpdateCompanion<Device> {
  final Value<String> deviceId;
  final Value<String> userId;
  final Value<String> devicePublicKey;
  final Value<String> signedByUserKey;
  final Value<String?> label;
  final Value<bool> isThisDevice;
  final Value<int> rowid;
  const DevicesCompanion({
    this.deviceId = const Value.absent(),
    this.userId = const Value.absent(),
    this.devicePublicKey = const Value.absent(),
    this.signedByUserKey = const Value.absent(),
    this.label = const Value.absent(),
    this.isThisDevice = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DevicesCompanion.insert({
    required String deviceId,
    required String userId,
    required String devicePublicKey,
    required String signedByUserKey,
    this.label = const Value.absent(),
    this.isThisDevice = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : deviceId = Value(deviceId),
       userId = Value(userId),
       devicePublicKey = Value(devicePublicKey),
       signedByUserKey = Value(signedByUserKey);
  static Insertable<Device> custom({
    Expression<String>? deviceId,
    Expression<String>? userId,
    Expression<String>? devicePublicKey,
    Expression<String>? signedByUserKey,
    Expression<String>? label,
    Expression<bool>? isThisDevice,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (deviceId != null) 'device_id': deviceId,
      if (userId != null) 'user_id': userId,
      if (devicePublicKey != null) 'device_public_key': devicePublicKey,
      if (signedByUserKey != null) 'signed_by_user_key': signedByUserKey,
      if (label != null) 'label': label,
      if (isThisDevice != null) 'is_this_device': isThisDevice,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DevicesCompanion copyWith({
    Value<String>? deviceId,
    Value<String>? userId,
    Value<String>? devicePublicKey,
    Value<String>? signedByUserKey,
    Value<String?>? label,
    Value<bool>? isThisDevice,
    Value<int>? rowid,
  }) {
    return DevicesCompanion(
      deviceId: deviceId ?? this.deviceId,
      userId: userId ?? this.userId,
      devicePublicKey: devicePublicKey ?? this.devicePublicKey,
      signedByUserKey: signedByUserKey ?? this.signedByUserKey,
      label: label ?? this.label,
      isThisDevice: isThisDevice ?? this.isThisDevice,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (devicePublicKey.present) {
      map['device_public_key'] = Variable<String>(devicePublicKey.value);
    }
    if (signedByUserKey.present) {
      map['signed_by_user_key'] = Variable<String>(signedByUserKey.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (isThisDevice.present) {
      map['is_this_device'] = Variable<bool>(isThisDevice.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DevicesCompanion(')
          ..write('deviceId: $deviceId, ')
          ..write('userId: $userId, ')
          ..write('devicePublicKey: $devicePublicKey, ')
          ..write('signedByUserKey: $signedByUserKey, ')
          ..write('label: $label, ')
          ..write('isThisDevice: $isThisDevice, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $NodesTable nodes = $NodesTable(this);
  late final NodeSearch nodeSearch = NodeSearch(this);
  late final Trigger nodesSearchInsert = Trigger(
    'CREATE TRIGGER nodes_search_insert AFTER INSERT ON nodes BEGIN INSERT INTO node_search ("rowid", title, body_md) VALUES (new."rowid", new.title, new.body_md);END',
    'nodes_search_insert',
  );
  late final Trigger nodesSearchDelete = Trigger(
    'CREATE TRIGGER nodes_search_delete AFTER DELETE ON nodes BEGIN INSERT INTO node_search (node_search, "rowid", title, body_md) VALUES (\'delete\', old."rowid", old.title, old.body_md);END',
    'nodes_search_delete',
  );
  late final Trigger nodesSearchUpdate = Trigger(
    'CREATE TRIGGER nodes_search_update AFTER UPDATE OF title, body_md ON nodes BEGIN INSERT INTO node_search (node_search, "rowid", title, body_md) VALUES (\'delete\', old."rowid", old.title, old.body_md);INSERT INTO node_search ("rowid", title, body_md) VALUES (new."rowid", new.title, new.body_md);END',
    'nodes_search_update',
  );
  late final AttachmentSearch attachmentSearch = AttachmentSearch(this);
  late final $UsersTable users = $UsersTable(this);
  late final $SpacesTable spaces = $SpacesTable(this);
  late final $SpaceMembersTable spaceMembers = $SpaceMembersTable(this);
  late final $OccurrenceCompletionsTable occurrenceCompletions =
      $OccurrenceCompletionsTable(this);
  late final $PlacementsTable placements = $PlacementsTable(this);
  late final $LinksTable links = $LinksTable(this);
  late final $CoreValuesTable coreValues = $CoreValuesTable(this);
  late final $NodeValuesTable nodeValues = $NodeValuesTable(this);
  late final $TagsTable tags = $TagsTable(this);
  late final $NodeTagsTable nodeTags = $NodeTagsTable(this);
  late final $AttachmentsTable attachments = $AttachmentsTable(this);
  late final $AnnotationsTable annotations = $AnnotationsTable(this);
  late final $RemindersTable reminders = $RemindersTable(this);
  late final $NodeUserPrefsTable nodeUserPrefs = $NodeUserPrefsTable(this);
  late final $ChangeLogTable changeLog = $ChangeLogTable(this);
  late final $DevicesTable devices = $DevicesTable(this);
  late final Index nodesParentSort = Index(
    'nodes_parent_sort',
    'CREATE INDEX nodes_parent_sort ON nodes (parent_id, sort_key)',
  );
  late final Index placementsParent = Index(
    'placements_parent',
    'CREATE INDEX placements_parent ON placements (parent_node_id, sort_key)',
  );
  late final Index placementsNode = Index(
    'placements_node',
    'CREATE INDEX placements_node ON placements (node_id)',
  );
  late final Index linksUnique = Index(
    'links_unique',
    'CREATE UNIQUE INDEX links_unique ON links (from_node_id, target_kind, target_id) WHERE deleted = 0',
  );
  late final Index linksTarget = Index(
    'links_target',
    'CREATE INDEX links_target ON links (target_kind, target_id)',
  );
  late final Index nodeValuesNode = Index(
    'node_values_node',
    'CREATE INDEX node_values_node ON node_values (node_id)',
  );
  late final Index nodeValuesValue = Index(
    'node_values_value',
    'CREATE INDEX node_values_value ON node_values (value_id)',
  );
  late final Index nodeTagsNode = Index(
    'node_tags_node',
    'CREATE INDEX node_tags_node ON node_tags (node_id)',
  );
  late final Index nodeTagsTag = Index(
    'node_tags_tag',
    'CREATE INDEX node_tags_tag ON node_tags (tag_id)',
  );
  late final Index attachmentsNode = Index(
    'attachments_node',
    'CREATE INDEX attachments_node ON attachments (node_id)',
  );
  late final Index annotationsAttachment = Index(
    'annotations_attachment',
    'CREATE INDEX annotations_attachment ON annotations (attachment_id)',
  );
  late final Index remindersNode = Index(
    'reminders_node',
    'CREATE INDEX reminders_node ON reminders (node_id)',
  );
  late final Index nodeUserPrefsNode = Index(
    'node_user_prefs_node',
    'CREATE INDEX node_user_prefs_node ON node_user_prefs (node_id)',
  );
  late final Index occurrenceCompletionsNode = Index(
    'occurrence_completions_node',
    'CREATE INDEX occurrence_completions_node ON occurrence_completions (node_id, occurrence_date)',
  );
  late final Index changeLogHlc = Index(
    'change_log_hlc',
    'CREATE INDEX change_log_hlc ON change_log (hlc)',
  );
  late final Index changeLogField = Index(
    'change_log_field',
    'CREATE INDEX change_log_field ON change_log (table_name, row_id, column_name)',
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    nodes,
    nodeSearch,
    nodesSearchInsert,
    nodesSearchDelete,
    nodesSearchUpdate,
    attachmentSearch,
    users,
    spaces,
    spaceMembers,
    occurrenceCompletions,
    placements,
    links,
    coreValues,
    nodeValues,
    tags,
    nodeTags,
    attachments,
    annotations,
    reminders,
    nodeUserPrefs,
    changeLog,
    devices,
    nodesParentSort,
    placementsParent,
    placementsNode,
    linksUnique,
    linksTarget,
    nodeValuesNode,
    nodeValuesValue,
    nodeTagsNode,
    nodeTagsTag,
    attachmentsNode,
    annotationsAttachment,
    remindersNode,
    nodeUserPrefsNode,
    occurrenceCompletionsNode,
    changeLogHlc,
    changeLogField,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'nodes',
        limitUpdateKind: UpdateKind.insert,
      ),
      result: [TableUpdate('node_search', kind: UpdateKind.insert)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'nodes',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('node_search', kind: UpdateKind.insert)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'nodes',
        limitUpdateKind: UpdateKind.update,
      ),
      result: [TableUpdate('node_search', kind: UpdateKind.insert)],
    ),
  ]);
  @override
  DriftDatabaseOptions get options =>
      const DriftDatabaseOptions(storeDateTimeAsText: true);
}

typedef $$NodesTableCreateCompanionBuilder = NodesCompanion Function({
  required String id,
  required String spaceId,
  required DateTime createdAt,
  required String createdBy,
  required String updatedBy,
  required String hlc,
  Value<bool> deleted,
  Value<String?> parentId,
  required String sortKey,
  required NodeType type,
  required String title,
  Value<String> bodyMd,
  Value<String> bodyFormat,
  Value<ChildView?> childView,
  Value<NodeStatus> status,
  Value<String?> completedBy,
  Value<DateTime?> completedAt,
  Value<int?> priority,
  Value<int?> estimateMinutes,
  Value<DateTime?> startAt,
  Value<DateTime?> endAt,
  Value<String?> timeZone,
  Value<DateTime?> dueAt,
  Value<String?> dueDate,
  Value<String?> rrule,
  Value<String?> repeatStart,
  Value<bool> exclusiveChildren,
  Value<bool> sharedWithChildren,
  Value<Lifecycle> lifecycle,
  Value<DateTime?> lifecycleAt,
  Value<String?> lifecycleRootId,
  Value<int> rowid,
});
typedef $$NodesTableUpdateCompanionBuilder = NodesCompanion Function({
  Value<String> id,
  Value<String> spaceId,
  Value<DateTime> createdAt,
  Value<String> createdBy,
  Value<String> updatedBy,
  Value<String> hlc,
  Value<bool> deleted,
  Value<String?> parentId,
  Value<String> sortKey,
  Value<NodeType> type,
  Value<String> title,
  Value<String> bodyMd,
  Value<String> bodyFormat,
  Value<ChildView?> childView,
  Value<NodeStatus> status,
  Value<String?> completedBy,
  Value<DateTime?> completedAt,
  Value<int?> priority,
  Value<int?> estimateMinutes,
  Value<DateTime?> startAt,
  Value<DateTime?> endAt,
  Value<String?> timeZone,
  Value<DateTime?> dueAt,
  Value<String?> dueDate,
  Value<String?> rrule,
  Value<String?> repeatStart,
  Value<bool> exclusiveChildren,
  Value<bool> sharedWithChildren,
  Value<Lifecycle> lifecycle,
  Value<DateTime?> lifecycleAt,
  Value<String?> lifecycleRootId,
  Value<int> rowid,
});

class $$NodesTableFilterComposer extends Composer<_$AppDatabase, $NodesTable> {
  $$NodesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get spaceId => $composableBuilder(
    column: $table.spaceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdBy => $composableBuilder(
    column: $table.createdBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get updatedBy => $composableBuilder(
    column: $table.updatedBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get hlc => $composableBuilder(
    column: $table.hlc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get parentId => $composableBuilder(
    column: $table.parentId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sortKey => $composableBuilder(
    column: $table.sortKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<NodeType, NodeType, String> get type =>
      $composableBuilder(
        column: $table.type,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get bodyMd => $composableBuilder(
    column: $table.bodyMd,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get bodyFormat => $composableBuilder(
    column: $table.bodyFormat,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<ChildView?, ChildView, String> get childView =>
      $composableBuilder(
        column: $table.childView,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<NodeStatus, NodeStatus, String> get status =>
      $composableBuilder(
        column: $table.status,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get completedBy => $composableBuilder(
    column: $table.completedBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get estimateMinutes => $composableBuilder(
    column: $table.estimateMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startAt => $composableBuilder(
    column: $table.startAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endAt => $composableBuilder(
    column: $table.endAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get timeZone => $composableBuilder(
    column: $table.timeZone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dueAt => $composableBuilder(
    column: $table.dueAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rrule => $composableBuilder(
    column: $table.rrule,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get repeatStart => $composableBuilder(
    column: $table.repeatStart,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get exclusiveChildren => $composableBuilder(
    column: $table.exclusiveChildren,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get sharedWithChildren => $composableBuilder(
    column: $table.sharedWithChildren,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<Lifecycle, Lifecycle, String> get lifecycle =>
      $composableBuilder(
        column: $table.lifecycle,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<DateTime> get lifecycleAt => $composableBuilder(
    column: $table.lifecycleAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lifecycleRootId => $composableBuilder(
    column: $table.lifecycleRootId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$NodesTableOrderingComposer
    extends Composer<_$AppDatabase, $NodesTable> {
  $$NodesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get spaceId => $composableBuilder(
    column: $table.spaceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdBy => $composableBuilder(
    column: $table.createdBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get updatedBy => $composableBuilder(
    column: $table.updatedBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get hlc => $composableBuilder(
    column: $table.hlc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get parentId => $composableBuilder(
    column: $table.parentId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sortKey => $composableBuilder(
    column: $table.sortKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get bodyMd => $composableBuilder(
    column: $table.bodyMd,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get bodyFormat => $composableBuilder(
    column: $table.bodyFormat,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get childView => $composableBuilder(
    column: $table.childView,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get completedBy => $composableBuilder(
    column: $table.completedBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get estimateMinutes => $composableBuilder(
    column: $table.estimateMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startAt => $composableBuilder(
    column: $table.startAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endAt => $composableBuilder(
    column: $table.endAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get timeZone => $composableBuilder(
    column: $table.timeZone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dueAt => $composableBuilder(
    column: $table.dueAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rrule => $composableBuilder(
    column: $table.rrule,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get repeatStart => $composableBuilder(
    column: $table.repeatStart,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get exclusiveChildren => $composableBuilder(
    column: $table.exclusiveChildren,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get sharedWithChildren => $composableBuilder(
    column: $table.sharedWithChildren,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lifecycle => $composableBuilder(
    column: $table.lifecycle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lifecycleAt => $composableBuilder(
    column: $table.lifecycleAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lifecycleRootId => $composableBuilder(
    column: $table.lifecycleRootId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$NodesTableAnnotationComposer
    extends Composer<_$AppDatabase, $NodesTable> {
  $$NodesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get spaceId =>
      $composableBuilder(column: $table.spaceId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get createdBy =>
      $composableBuilder(column: $table.createdBy, builder: (column) => column);

  GeneratedColumn<String> get updatedBy =>
      $composableBuilder(column: $table.updatedBy, builder: (column) => column);

  GeneratedColumn<String> get hlc =>
      $composableBuilder(column: $table.hlc, builder: (column) => column);

  GeneratedColumn<bool> get deleted =>
      $composableBuilder(column: $table.deleted, builder: (column) => column);

  GeneratedColumn<String> get parentId =>
      $composableBuilder(column: $table.parentId, builder: (column) => column);

  GeneratedColumn<String> get sortKey =>
      $composableBuilder(column: $table.sortKey, builder: (column) => column);

  GeneratedColumnWithTypeConverter<NodeType, String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get bodyMd =>
      $composableBuilder(column: $table.bodyMd, builder: (column) => column);

  GeneratedColumn<String> get bodyFormat => $composableBuilder(
    column: $table.bodyFormat,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<ChildView?, String> get childView =>
      $composableBuilder(column: $table.childView, builder: (column) => column);

  GeneratedColumnWithTypeConverter<NodeStatus, String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get completedBy => $composableBuilder(
    column: $table.completedBy,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get priority =>
      $composableBuilder(column: $table.priority, builder: (column) => column);

  GeneratedColumn<int> get estimateMinutes => $composableBuilder(
    column: $table.estimateMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get startAt =>
      $composableBuilder(column: $table.startAt, builder: (column) => column);

  GeneratedColumn<DateTime> get endAt =>
      $composableBuilder(column: $table.endAt, builder: (column) => column);

  GeneratedColumn<String> get timeZone =>
      $composableBuilder(column: $table.timeZone, builder: (column) => column);

  GeneratedColumn<DateTime> get dueAt =>
      $composableBuilder(column: $table.dueAt, builder: (column) => column);

  GeneratedColumn<String> get dueDate =>
      $composableBuilder(column: $table.dueDate, builder: (column) => column);

  GeneratedColumn<String> get rrule =>
      $composableBuilder(column: $table.rrule, builder: (column) => column);

  GeneratedColumn<String> get repeatStart => $composableBuilder(
    column: $table.repeatStart,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get exclusiveChildren => $composableBuilder(
    column: $table.exclusiveChildren,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get sharedWithChildren => $composableBuilder(
    column: $table.sharedWithChildren,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<Lifecycle, String> get lifecycle =>
      $composableBuilder(column: $table.lifecycle, builder: (column) => column);

  GeneratedColumn<DateTime> get lifecycleAt => $composableBuilder(
    column: $table.lifecycleAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get lifecycleRootId => $composableBuilder(
    column: $table.lifecycleRootId,
    builder: (column) => column,
  );
}

class $$NodesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $NodesTable,
          Node,
          $$NodesTableFilterComposer,
          $$NodesTableOrderingComposer,
          $$NodesTableAnnotationComposer,
          $$NodesTableCreateCompanionBuilder,
          $$NodesTableUpdateCompanionBuilder,
          (Node, BaseReferences<_$AppDatabase, $NodesTable, Node>),
          Node,
          PrefetchHooks Function()
        > {
  $$NodesTableTableManager(_$AppDatabase db, $NodesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NodesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$NodesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$NodesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> spaceId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<String> createdBy = const Value.absent(),
                Value<String> updatedBy = const Value.absent(),
                Value<String> hlc = const Value.absent(),
                Value<bool> deleted = const Value.absent(),
                Value<String?> parentId = const Value.absent(),
                Value<String> sortKey = const Value.absent(),
                Value<NodeType> type = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> bodyMd = const Value.absent(),
                Value<String> bodyFormat = const Value.absent(),
                Value<ChildView?> childView = const Value.absent(),
                Value<NodeStatus> status = const Value.absent(),
                Value<String?> completedBy = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
                Value<int?> priority = const Value.absent(),
                Value<int?> estimateMinutes = const Value.absent(),
                Value<DateTime?> startAt = const Value.absent(),
                Value<DateTime?> endAt = const Value.absent(),
                Value<String?> timeZone = const Value.absent(),
                Value<DateTime?> dueAt = const Value.absent(),
                Value<String?> dueDate = const Value.absent(),
                Value<String?> rrule = const Value.absent(),
                Value<String?> repeatStart = const Value.absent(),
                Value<bool> exclusiveChildren = const Value.absent(),
                Value<bool> sharedWithChildren = const Value.absent(),
                Value<Lifecycle> lifecycle = const Value.absent(),
                Value<DateTime?> lifecycleAt = const Value.absent(),
                Value<String?> lifecycleRootId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => NodesCompanion(
                id: id,
                spaceId: spaceId,
                createdAt: createdAt,
                createdBy: createdBy,
                updatedBy: updatedBy,
                hlc: hlc,
                deleted: deleted,
                parentId: parentId,
                sortKey: sortKey,
                type: type,
                title: title,
                bodyMd: bodyMd,
                bodyFormat: bodyFormat,
                childView: childView,
                status: status,
                completedBy: completedBy,
                completedAt: completedAt,
                priority: priority,
                estimateMinutes: estimateMinutes,
                startAt: startAt,
                endAt: endAt,
                timeZone: timeZone,
                dueAt: dueAt,
                dueDate: dueDate,
                rrule: rrule,
                repeatStart: repeatStart,
                exclusiveChildren: exclusiveChildren,
                sharedWithChildren: sharedWithChildren,
                lifecycle: lifecycle,
                lifecycleAt: lifecycleAt,
                lifecycleRootId: lifecycleRootId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String spaceId,
                required DateTime createdAt,
                required String createdBy,
                required String updatedBy,
                required String hlc,
                Value<bool> deleted = const Value.absent(),
                Value<String?> parentId = const Value.absent(),
                required String sortKey,
                required NodeType type,
                required String title,
                Value<String> bodyMd = const Value.absent(),
                Value<String> bodyFormat = const Value.absent(),
                Value<ChildView?> childView = const Value.absent(),
                Value<NodeStatus> status = const Value.absent(),
                Value<String?> completedBy = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
                Value<int?> priority = const Value.absent(),
                Value<int?> estimateMinutes = const Value.absent(),
                Value<DateTime?> startAt = const Value.absent(),
                Value<DateTime?> endAt = const Value.absent(),
                Value<String?> timeZone = const Value.absent(),
                Value<DateTime?> dueAt = const Value.absent(),
                Value<String?> dueDate = const Value.absent(),
                Value<String?> rrule = const Value.absent(),
                Value<String?> repeatStart = const Value.absent(),
                Value<bool> exclusiveChildren = const Value.absent(),
                Value<bool> sharedWithChildren = const Value.absent(),
                Value<Lifecycle> lifecycle = const Value.absent(),
                Value<DateTime?> lifecycleAt = const Value.absent(),
                Value<String?> lifecycleRootId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => NodesCompanion.insert(
                id: id,
                spaceId: spaceId,
                createdAt: createdAt,
                createdBy: createdBy,
                updatedBy: updatedBy,
                hlc: hlc,
                deleted: deleted,
                parentId: parentId,
                sortKey: sortKey,
                type: type,
                title: title,
                bodyMd: bodyMd,
                bodyFormat: bodyFormat,
                childView: childView,
                status: status,
                completedBy: completedBy,
                completedAt: completedAt,
                priority: priority,
                estimateMinutes: estimateMinutes,
                startAt: startAt,
                endAt: endAt,
                timeZone: timeZone,
                dueAt: dueAt,
                dueDate: dueDate,
                rrule: rrule,
                repeatStart: repeatStart,
                exclusiveChildren: exclusiveChildren,
                sharedWithChildren: sharedWithChildren,
                lifecycle: lifecycle,
                lifecycleAt: lifecycleAt,
                lifecycleRootId: lifecycleRootId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$NodesTable, Node>(table),
                  BaseReferences<_$AppDatabase, $NodesTable, Node>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$NodesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $NodesTable,
      Node,
      $$NodesTableFilterComposer,
      $$NodesTableOrderingComposer,
      $$NodesTableAnnotationComposer,
      $$NodesTableCreateCompanionBuilder,
      $$NodesTableUpdateCompanionBuilder,
      (Node, BaseReferences<_$AppDatabase, $NodesTable, Node>),
      Node,
      PrefetchHooks Function()
    >;
typedef $NodeSearchCreateCompanionBuilder = NodeSearchCompanion Function({
  required String title,
  required String bodyMd,
  Value<int> rowid,
});
typedef $NodeSearchUpdateCompanionBuilder = NodeSearchCompanion Function({
  Value<String> title,
  Value<String> bodyMd,
  Value<int> rowid,
});

class $NodeSearchFilterComposer extends Composer<_$AppDatabase, NodeSearch> {
  $NodeSearchFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get bodyMd => $composableBuilder(
    column: $table.bodyMd,
    builder: (column) => ColumnFilters(column),
  );
}

class $NodeSearchOrderingComposer extends Composer<_$AppDatabase, NodeSearch> {
  $NodeSearchOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get bodyMd => $composableBuilder(
    column: $table.bodyMd,
    builder: (column) => ColumnOrderings(column),
  );
}

class $NodeSearchAnnotationComposer
    extends Composer<_$AppDatabase, NodeSearch> {
  $NodeSearchAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get bodyMd =>
      $composableBuilder(column: $table.bodyMd, builder: (column) => column);
}

class $NodeSearchTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          NodeSearch,
          NodeSearchData,
          $NodeSearchFilterComposer,
          $NodeSearchOrderingComposer,
          $NodeSearchAnnotationComposer,
          $NodeSearchCreateCompanionBuilder,
          $NodeSearchUpdateCompanionBuilder,
          (
            NodeSearchData,
            BaseReferences<_$AppDatabase, NodeSearch, NodeSearchData>,
          ),
          NodeSearchData,
          PrefetchHooks Function()
        > {
  $NodeSearchTableManager(_$AppDatabase db, NodeSearch table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $NodeSearchFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $NodeSearchOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $NodeSearchAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> title = const Value.absent(),
            Value<String> bodyMd = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) => NodeSearchCompanion(title: title, bodyMd: bodyMd, rowid: rowid),
          createCompanionCallback:
              ({
                required String title,
                required String bodyMd,
                Value<int> rowid = const Value.absent(),
              }) => NodeSearchCompanion.insert(
                title: title,
                bodyMd: bodyMd,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<NodeSearch, NodeSearchData>(table),
                  BaseReferences<_$AppDatabase, NodeSearch, NodeSearchData>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $NodeSearchProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      NodeSearch,
      NodeSearchData,
      $NodeSearchFilterComposer,
      $NodeSearchOrderingComposer,
      $NodeSearchAnnotationComposer,
      $NodeSearchCreateCompanionBuilder,
      $NodeSearchUpdateCompanionBuilder,
      (
        NodeSearchData,
        BaseReferences<_$AppDatabase, NodeSearch, NodeSearchData>,
      ),
      NodeSearchData,
      PrefetchHooks Function()
    >;
typedef $AttachmentSearchCreateCompanionBuilder =
    AttachmentSearchCompanion Function({
      required String attachmentId,
      required String filename,
      required String content,
      Value<int> rowid,
    });
typedef $AttachmentSearchUpdateCompanionBuilder =
    AttachmentSearchCompanion Function({
      Value<String> attachmentId,
      Value<String> filename,
      Value<String> content,
      Value<int> rowid,
    });

class $AttachmentSearchFilterComposer
    extends Composer<_$AppDatabase, AttachmentSearch> {
  $AttachmentSearchFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get attachmentId => $composableBuilder(
    column: $table.attachmentId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get filename => $composableBuilder(
    column: $table.filename,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnFilters(column),
  );
}

class $AttachmentSearchOrderingComposer
    extends Composer<_$AppDatabase, AttachmentSearch> {
  $AttachmentSearchOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get attachmentId => $composableBuilder(
    column: $table.attachmentId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get filename => $composableBuilder(
    column: $table.filename,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnOrderings(column),
  );
}

class $AttachmentSearchAnnotationComposer
    extends Composer<_$AppDatabase, AttachmentSearch> {
  $AttachmentSearchAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get attachmentId => $composableBuilder(
    column: $table.attachmentId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get filename =>
      $composableBuilder(column: $table.filename, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);
}

class $AttachmentSearchTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          AttachmentSearch,
          AttachmentSearchData,
          $AttachmentSearchFilterComposer,
          $AttachmentSearchOrderingComposer,
          $AttachmentSearchAnnotationComposer,
          $AttachmentSearchCreateCompanionBuilder,
          $AttachmentSearchUpdateCompanionBuilder,
          (
            AttachmentSearchData,
            BaseReferences<
              _$AppDatabase,
              AttachmentSearch,
              AttachmentSearchData
            >,
          ),
          AttachmentSearchData,
          PrefetchHooks Function()
        > {
  $AttachmentSearchTableManager(_$AppDatabase db, AttachmentSearch table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $AttachmentSearchFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $AttachmentSearchOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $AttachmentSearchAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> attachmentId = const Value.absent(),
                Value<String> filename = const Value.absent(),
                Value<String> content = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AttachmentSearchCompanion(
                attachmentId: attachmentId,
                filename: filename,
                content: content,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String attachmentId,
                required String filename,
                required String content,
                Value<int> rowid = const Value.absent(),
              }) => AttachmentSearchCompanion.insert(
                attachmentId: attachmentId,
                filename: filename,
                content: content,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<AttachmentSearch, AttachmentSearchData>(table),
                  BaseReferences<
                    _$AppDatabase,
                    AttachmentSearch,
                    AttachmentSearchData
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $AttachmentSearchProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      AttachmentSearch,
      AttachmentSearchData,
      $AttachmentSearchFilterComposer,
      $AttachmentSearchOrderingComposer,
      $AttachmentSearchAnnotationComposer,
      $AttachmentSearchCreateCompanionBuilder,
      $AttachmentSearchUpdateCompanionBuilder,
      (
        AttachmentSearchData,
        BaseReferences<_$AppDatabase, AttachmentSearch, AttachmentSearchData>,
      ),
      AttachmentSearchData,
      PrefetchHooks Function()
    >;
typedef $$UsersTableCreateCompanionBuilder = UsersCompanion Function({
  required String id,
  required String spaceId,
  required DateTime createdAt,
  required String createdBy,
  required String updatedBy,
  required String hlc,
  Value<bool> deleted,
  required String identityPublicKey,
  Value<int> rowid,
});
typedef $$UsersTableUpdateCompanionBuilder = UsersCompanion Function({
  Value<String> id,
  Value<String> spaceId,
  Value<DateTime> createdAt,
  Value<String> createdBy,
  Value<String> updatedBy,
  Value<String> hlc,
  Value<bool> deleted,
  Value<String> identityPublicKey,
  Value<int> rowid,
});

class $$UsersTableFilterComposer extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get spaceId => $composableBuilder(
    column: $table.spaceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdBy => $composableBuilder(
    column: $table.createdBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get updatedBy => $composableBuilder(
    column: $table.updatedBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get hlc => $composableBuilder(
    column: $table.hlc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get identityPublicKey => $composableBuilder(
    column: $table.identityPublicKey,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UsersTableOrderingComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get spaceId => $composableBuilder(
    column: $table.spaceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdBy => $composableBuilder(
    column: $table.createdBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get updatedBy => $composableBuilder(
    column: $table.updatedBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get hlc => $composableBuilder(
    column: $table.hlc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get identityPublicKey => $composableBuilder(
    column: $table.identityPublicKey,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UsersTableAnnotationComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get spaceId =>
      $composableBuilder(column: $table.spaceId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get createdBy =>
      $composableBuilder(column: $table.createdBy, builder: (column) => column);

  GeneratedColumn<String> get updatedBy =>
      $composableBuilder(column: $table.updatedBy, builder: (column) => column);

  GeneratedColumn<String> get hlc =>
      $composableBuilder(column: $table.hlc, builder: (column) => column);

  GeneratedColumn<bool> get deleted =>
      $composableBuilder(column: $table.deleted, builder: (column) => column);

  GeneratedColumn<String> get identityPublicKey => $composableBuilder(
    column: $table.identityPublicKey,
    builder: (column) => column,
  );
}

class $$UsersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UsersTable,
          User,
          $$UsersTableFilterComposer,
          $$UsersTableOrderingComposer,
          $$UsersTableAnnotationComposer,
          $$UsersTableCreateCompanionBuilder,
          $$UsersTableUpdateCompanionBuilder,
          (User, BaseReferences<_$AppDatabase, $UsersTable, User>),
          User,
          PrefetchHooks Function()
        > {
  $$UsersTableTableManager(_$AppDatabase db, $UsersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UsersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UsersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UsersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> spaceId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<String> createdBy = const Value.absent(),
                Value<String> updatedBy = const Value.absent(),
                Value<String> hlc = const Value.absent(),
                Value<bool> deleted = const Value.absent(),
                Value<String> identityPublicKey = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UsersCompanion(
                id: id,
                spaceId: spaceId,
                createdAt: createdAt,
                createdBy: createdBy,
                updatedBy: updatedBy,
                hlc: hlc,
                deleted: deleted,
                identityPublicKey: identityPublicKey,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String spaceId,
                required DateTime createdAt,
                required String createdBy,
                required String updatedBy,
                required String hlc,
                Value<bool> deleted = const Value.absent(),
                required String identityPublicKey,
                Value<int> rowid = const Value.absent(),
              }) => UsersCompanion.insert(
                id: id,
                spaceId: spaceId,
                createdAt: createdAt,
                createdBy: createdBy,
                updatedBy: updatedBy,
                hlc: hlc,
                deleted: deleted,
                identityPublicKey: identityPublicKey,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$UsersTable, User>(table),
                  BaseReferences<_$AppDatabase, $UsersTable, User>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UsersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UsersTable,
      User,
      $$UsersTableFilterComposer,
      $$UsersTableOrderingComposer,
      $$UsersTableAnnotationComposer,
      $$UsersTableCreateCompanionBuilder,
      $$UsersTableUpdateCompanionBuilder,
      (User, BaseReferences<_$AppDatabase, $UsersTable, User>),
      User,
      PrefetchHooks Function()
    >;
typedef $$SpacesTableCreateCompanionBuilder = SpacesCompanion Function({
  required String id,
  required String spaceId,
  required DateTime createdAt,
  required String createdBy,
  required String updatedBy,
  required String hlc,
  Value<bool> deleted,
  required SpaceKind kind,
  Value<String?> rootNodeId,
  Value<String?> mergedIntoSpaceId,
  Value<int> rowid,
});
typedef $$SpacesTableUpdateCompanionBuilder = SpacesCompanion Function({
  Value<String> id,
  Value<String> spaceId,
  Value<DateTime> createdAt,
  Value<String> createdBy,
  Value<String> updatedBy,
  Value<String> hlc,
  Value<bool> deleted,
  Value<SpaceKind> kind,
  Value<String?> rootNodeId,
  Value<String?> mergedIntoSpaceId,
  Value<int> rowid,
});

class $$SpacesTableFilterComposer
    extends Composer<_$AppDatabase, $SpacesTable> {
  $$SpacesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get spaceId => $composableBuilder(
    column: $table.spaceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdBy => $composableBuilder(
    column: $table.createdBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get updatedBy => $composableBuilder(
    column: $table.updatedBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get hlc => $composableBuilder(
    column: $table.hlc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<SpaceKind, SpaceKind, String> get kind =>
      $composableBuilder(
        column: $table.kind,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get rootNodeId => $composableBuilder(
    column: $table.rootNodeId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mergedIntoSpaceId => $composableBuilder(
    column: $table.mergedIntoSpaceId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SpacesTableOrderingComposer
    extends Composer<_$AppDatabase, $SpacesTable> {
  $$SpacesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get spaceId => $composableBuilder(
    column: $table.spaceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdBy => $composableBuilder(
    column: $table.createdBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get updatedBy => $composableBuilder(
    column: $table.updatedBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get hlc => $composableBuilder(
    column: $table.hlc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rootNodeId => $composableBuilder(
    column: $table.rootNodeId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mergedIntoSpaceId => $composableBuilder(
    column: $table.mergedIntoSpaceId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SpacesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SpacesTable> {
  $$SpacesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get spaceId =>
      $composableBuilder(column: $table.spaceId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get createdBy =>
      $composableBuilder(column: $table.createdBy, builder: (column) => column);

  GeneratedColumn<String> get updatedBy =>
      $composableBuilder(column: $table.updatedBy, builder: (column) => column);

  GeneratedColumn<String> get hlc =>
      $composableBuilder(column: $table.hlc, builder: (column) => column);

  GeneratedColumn<bool> get deleted =>
      $composableBuilder(column: $table.deleted, builder: (column) => column);

  GeneratedColumnWithTypeConverter<SpaceKind, String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<String> get rootNodeId => $composableBuilder(
    column: $table.rootNodeId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get mergedIntoSpaceId => $composableBuilder(
    column: $table.mergedIntoSpaceId,
    builder: (column) => column,
  );
}

class $$SpacesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SpacesTable,
          Space,
          $$SpacesTableFilterComposer,
          $$SpacesTableOrderingComposer,
          $$SpacesTableAnnotationComposer,
          $$SpacesTableCreateCompanionBuilder,
          $$SpacesTableUpdateCompanionBuilder,
          (Space, BaseReferences<_$AppDatabase, $SpacesTable, Space>),
          Space,
          PrefetchHooks Function()
        > {
  $$SpacesTableTableManager(_$AppDatabase db, $SpacesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SpacesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SpacesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SpacesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> spaceId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<String> createdBy = const Value.absent(),
                Value<String> updatedBy = const Value.absent(),
                Value<String> hlc = const Value.absent(),
                Value<bool> deleted = const Value.absent(),
                Value<SpaceKind> kind = const Value.absent(),
                Value<String?> rootNodeId = const Value.absent(),
                Value<String?> mergedIntoSpaceId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SpacesCompanion(
                id: id,
                spaceId: spaceId,
                createdAt: createdAt,
                createdBy: createdBy,
                updatedBy: updatedBy,
                hlc: hlc,
                deleted: deleted,
                kind: kind,
                rootNodeId: rootNodeId,
                mergedIntoSpaceId: mergedIntoSpaceId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String spaceId,
                required DateTime createdAt,
                required String createdBy,
                required String updatedBy,
                required String hlc,
                Value<bool> deleted = const Value.absent(),
                required SpaceKind kind,
                Value<String?> rootNodeId = const Value.absent(),
                Value<String?> mergedIntoSpaceId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SpacesCompanion.insert(
                id: id,
                spaceId: spaceId,
                createdAt: createdAt,
                createdBy: createdBy,
                updatedBy: updatedBy,
                hlc: hlc,
                deleted: deleted,
                kind: kind,
                rootNodeId: rootNodeId,
                mergedIntoSpaceId: mergedIntoSpaceId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SpacesTable, Space>(table),
                  BaseReferences<_$AppDatabase, $SpacesTable, Space>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SpacesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SpacesTable,
      Space,
      $$SpacesTableFilterComposer,
      $$SpacesTableOrderingComposer,
      $$SpacesTableAnnotationComposer,
      $$SpacesTableCreateCompanionBuilder,
      $$SpacesTableUpdateCompanionBuilder,
      (Space, BaseReferences<_$AppDatabase, $SpacesTable, Space>),
      Space,
      PrefetchHooks Function()
    >;
typedef $$SpaceMembersTableCreateCompanionBuilder =
    SpaceMembersCompanion Function({
      required String id,
      required String spaceId,
      required DateTime createdAt,
      required String createdBy,
      required String updatedBy,
      required String hlc,
      Value<bool> deleted,
      required String userId,
      required MemberRole role,
      required DateTime joinedAt,
      Value<int> rowid,
    });
typedef $$SpaceMembersTableUpdateCompanionBuilder =
    SpaceMembersCompanion Function({
      Value<String> id,
      Value<String> spaceId,
      Value<DateTime> createdAt,
      Value<String> createdBy,
      Value<String> updatedBy,
      Value<String> hlc,
      Value<bool> deleted,
      Value<String> userId,
      Value<MemberRole> role,
      Value<DateTime> joinedAt,
      Value<int> rowid,
    });

class $$SpaceMembersTableFilterComposer
    extends Composer<_$AppDatabase, $SpaceMembersTable> {
  $$SpaceMembersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get spaceId => $composableBuilder(
    column: $table.spaceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdBy => $composableBuilder(
    column: $table.createdBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get updatedBy => $composableBuilder(
    column: $table.updatedBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get hlc => $composableBuilder(
    column: $table.hlc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<MemberRole, MemberRole, String> get role =>
      $composableBuilder(
        column: $table.role,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<DateTime> get joinedAt => $composableBuilder(
    column: $table.joinedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SpaceMembersTableOrderingComposer
    extends Composer<_$AppDatabase, $SpaceMembersTable> {
  $$SpaceMembersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get spaceId => $composableBuilder(
    column: $table.spaceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdBy => $composableBuilder(
    column: $table.createdBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get updatedBy => $composableBuilder(
    column: $table.updatedBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get hlc => $composableBuilder(
    column: $table.hlc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get joinedAt => $composableBuilder(
    column: $table.joinedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SpaceMembersTableAnnotationComposer
    extends Composer<_$AppDatabase, $SpaceMembersTable> {
  $$SpaceMembersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get spaceId =>
      $composableBuilder(column: $table.spaceId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get createdBy =>
      $composableBuilder(column: $table.createdBy, builder: (column) => column);

  GeneratedColumn<String> get updatedBy =>
      $composableBuilder(column: $table.updatedBy, builder: (column) => column);

  GeneratedColumn<String> get hlc =>
      $composableBuilder(column: $table.hlc, builder: (column) => column);

  GeneratedColumn<bool> get deleted =>
      $composableBuilder(column: $table.deleted, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumnWithTypeConverter<MemberRole, String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<DateTime> get joinedAt =>
      $composableBuilder(column: $table.joinedAt, builder: (column) => column);
}

class $$SpaceMembersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SpaceMembersTable,
          SpaceMember,
          $$SpaceMembersTableFilterComposer,
          $$SpaceMembersTableOrderingComposer,
          $$SpaceMembersTableAnnotationComposer,
          $$SpaceMembersTableCreateCompanionBuilder,
          $$SpaceMembersTableUpdateCompanionBuilder,
          (
            SpaceMember,
            BaseReferences<_$AppDatabase, $SpaceMembersTable, SpaceMember>,
          ),
          SpaceMember,
          PrefetchHooks Function()
        > {
  $$SpaceMembersTableTableManager(_$AppDatabase db, $SpaceMembersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SpaceMembersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SpaceMembersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SpaceMembersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> spaceId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<String> createdBy = const Value.absent(),
                Value<String> updatedBy = const Value.absent(),
                Value<String> hlc = const Value.absent(),
                Value<bool> deleted = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<MemberRole> role = const Value.absent(),
                Value<DateTime> joinedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SpaceMembersCompanion(
                id: id,
                spaceId: spaceId,
                createdAt: createdAt,
                createdBy: createdBy,
                updatedBy: updatedBy,
                hlc: hlc,
                deleted: deleted,
                userId: userId,
                role: role,
                joinedAt: joinedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String spaceId,
                required DateTime createdAt,
                required String createdBy,
                required String updatedBy,
                required String hlc,
                Value<bool> deleted = const Value.absent(),
                required String userId,
                required MemberRole role,
                required DateTime joinedAt,
                Value<int> rowid = const Value.absent(),
              }) => SpaceMembersCompanion.insert(
                id: id,
                spaceId: spaceId,
                createdAt: createdAt,
                createdBy: createdBy,
                updatedBy: updatedBy,
                hlc: hlc,
                deleted: deleted,
                userId: userId,
                role: role,
                joinedAt: joinedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SpaceMembersTable, SpaceMember>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $SpaceMembersTable,
                    SpaceMember
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SpaceMembersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SpaceMembersTable,
      SpaceMember,
      $$SpaceMembersTableFilterComposer,
      $$SpaceMembersTableOrderingComposer,
      $$SpaceMembersTableAnnotationComposer,
      $$SpaceMembersTableCreateCompanionBuilder,
      $$SpaceMembersTableUpdateCompanionBuilder,
      (
        SpaceMember,
        BaseReferences<_$AppDatabase, $SpaceMembersTable, SpaceMember>,
      ),
      SpaceMember,
      PrefetchHooks Function()
    >;
typedef $$OccurrenceCompletionsTableCreateCompanionBuilder =
    OccurrenceCompletionsCompanion Function({
      required String id,
      required String spaceId,
      required DateTime createdAt,
      required String createdBy,
      required String updatedBy,
      required String hlc,
      Value<bool> deleted,
      required String nodeId,
      required String occurrenceDate,
      required String completedBy,
      required DateTime completedAt,
      Value<String?> note,
      Value<int> rowid,
    });
typedef $$OccurrenceCompletionsTableUpdateCompanionBuilder =
    OccurrenceCompletionsCompanion Function({
      Value<String> id,
      Value<String> spaceId,
      Value<DateTime> createdAt,
      Value<String> createdBy,
      Value<String> updatedBy,
      Value<String> hlc,
      Value<bool> deleted,
      Value<String> nodeId,
      Value<String> occurrenceDate,
      Value<String> completedBy,
      Value<DateTime> completedAt,
      Value<String?> note,
      Value<int> rowid,
    });

class $$OccurrenceCompletionsTableFilterComposer
    extends Composer<_$AppDatabase, $OccurrenceCompletionsTable> {
  $$OccurrenceCompletionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get spaceId => $composableBuilder(
    column: $table.spaceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdBy => $composableBuilder(
    column: $table.createdBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get updatedBy => $composableBuilder(
    column: $table.updatedBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get hlc => $composableBuilder(
    column: $table.hlc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nodeId => $composableBuilder(
    column: $table.nodeId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get occurrenceDate => $composableBuilder(
    column: $table.occurrenceDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get completedBy => $composableBuilder(
    column: $table.completedBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );
}

class $$OccurrenceCompletionsTableOrderingComposer
    extends Composer<_$AppDatabase, $OccurrenceCompletionsTable> {
  $$OccurrenceCompletionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get spaceId => $composableBuilder(
    column: $table.spaceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdBy => $composableBuilder(
    column: $table.createdBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get updatedBy => $composableBuilder(
    column: $table.updatedBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get hlc => $composableBuilder(
    column: $table.hlc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nodeId => $composableBuilder(
    column: $table.nodeId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get occurrenceDate => $composableBuilder(
    column: $table.occurrenceDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get completedBy => $composableBuilder(
    column: $table.completedBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$OccurrenceCompletionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $OccurrenceCompletionsTable> {
  $$OccurrenceCompletionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get spaceId =>
      $composableBuilder(column: $table.spaceId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get createdBy =>
      $composableBuilder(column: $table.createdBy, builder: (column) => column);

  GeneratedColumn<String> get updatedBy =>
      $composableBuilder(column: $table.updatedBy, builder: (column) => column);

  GeneratedColumn<String> get hlc =>
      $composableBuilder(column: $table.hlc, builder: (column) => column);

  GeneratedColumn<bool> get deleted =>
      $composableBuilder(column: $table.deleted, builder: (column) => column);

  GeneratedColumn<String> get nodeId =>
      $composableBuilder(column: $table.nodeId, builder: (column) => column);

  GeneratedColumn<String> get occurrenceDate => $composableBuilder(
    column: $table.occurrenceDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get completedBy => $composableBuilder(
    column: $table.completedBy,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);
}

class $$OccurrenceCompletionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $OccurrenceCompletionsTable,
          OccurrenceCompletion,
          $$OccurrenceCompletionsTableFilterComposer,
          $$OccurrenceCompletionsTableOrderingComposer,
          $$OccurrenceCompletionsTableAnnotationComposer,
          $$OccurrenceCompletionsTableCreateCompanionBuilder,
          $$OccurrenceCompletionsTableUpdateCompanionBuilder,
          (
            OccurrenceCompletion,
            BaseReferences<
              _$AppDatabase,
              $OccurrenceCompletionsTable,
              OccurrenceCompletion
            >,
          ),
          OccurrenceCompletion,
          PrefetchHooks Function()
        > {
  $$OccurrenceCompletionsTableTableManager(
    _$AppDatabase db,
    $OccurrenceCompletionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OccurrenceCompletionsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$OccurrenceCompletionsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$OccurrenceCompletionsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> spaceId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<String> createdBy = const Value.absent(),
                Value<String> updatedBy = const Value.absent(),
                Value<String> hlc = const Value.absent(),
                Value<bool> deleted = const Value.absent(),
                Value<String> nodeId = const Value.absent(),
                Value<String> occurrenceDate = const Value.absent(),
                Value<String> completedBy = const Value.absent(),
                Value<DateTime> completedAt = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => OccurrenceCompletionsCompanion(
                id: id,
                spaceId: spaceId,
                createdAt: createdAt,
                createdBy: createdBy,
                updatedBy: updatedBy,
                hlc: hlc,
                deleted: deleted,
                nodeId: nodeId,
                occurrenceDate: occurrenceDate,
                completedBy: completedBy,
                completedAt: completedAt,
                note: note,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String spaceId,
                required DateTime createdAt,
                required String createdBy,
                required String updatedBy,
                required String hlc,
                Value<bool> deleted = const Value.absent(),
                required String nodeId,
                required String occurrenceDate,
                required String completedBy,
                required DateTime completedAt,
                Value<String?> note = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => OccurrenceCompletionsCompanion.insert(
                id: id,
                spaceId: spaceId,
                createdAt: createdAt,
                createdBy: createdBy,
                updatedBy: updatedBy,
                hlc: hlc,
                deleted: deleted,
                nodeId: nodeId,
                occurrenceDate: occurrenceDate,
                completedBy: completedBy,
                completedAt: completedAt,
                note: note,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<
                    $OccurrenceCompletionsTable,
                    OccurrenceCompletion
                  >(table),
                  BaseReferences<
                    _$AppDatabase,
                    $OccurrenceCompletionsTable,
                    OccurrenceCompletion
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$OccurrenceCompletionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $OccurrenceCompletionsTable,
      OccurrenceCompletion,
      $$OccurrenceCompletionsTableFilterComposer,
      $$OccurrenceCompletionsTableOrderingComposer,
      $$OccurrenceCompletionsTableAnnotationComposer,
      $$OccurrenceCompletionsTableCreateCompanionBuilder,
      $$OccurrenceCompletionsTableUpdateCompanionBuilder,
      (
        OccurrenceCompletion,
        BaseReferences<
          _$AppDatabase,
          $OccurrenceCompletionsTable,
          OccurrenceCompletion
        >,
      ),
      OccurrenceCompletion,
      PrefetchHooks Function()
    >;
typedef $$PlacementsTableCreateCompanionBuilder = PlacementsCompanion Function({
  required String id,
  required String spaceId,
  required DateTime createdAt,
  required String createdBy,
  required String updatedBy,
  required String hlc,
  Value<bool> deleted,
  required String nodeId,
  Value<String?> parentNodeId,
  required String sortKey,
  Value<int> rowid,
});
typedef $$PlacementsTableUpdateCompanionBuilder = PlacementsCompanion Function({
  Value<String> id,
  Value<String> spaceId,
  Value<DateTime> createdAt,
  Value<String> createdBy,
  Value<String> updatedBy,
  Value<String> hlc,
  Value<bool> deleted,
  Value<String> nodeId,
  Value<String?> parentNodeId,
  Value<String> sortKey,
  Value<int> rowid,
});

class $$PlacementsTableFilterComposer
    extends Composer<_$AppDatabase, $PlacementsTable> {
  $$PlacementsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get spaceId => $composableBuilder(
    column: $table.spaceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdBy => $composableBuilder(
    column: $table.createdBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get updatedBy => $composableBuilder(
    column: $table.updatedBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get hlc => $composableBuilder(
    column: $table.hlc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nodeId => $composableBuilder(
    column: $table.nodeId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get parentNodeId => $composableBuilder(
    column: $table.parentNodeId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sortKey => $composableBuilder(
    column: $table.sortKey,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PlacementsTableOrderingComposer
    extends Composer<_$AppDatabase, $PlacementsTable> {
  $$PlacementsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get spaceId => $composableBuilder(
    column: $table.spaceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdBy => $composableBuilder(
    column: $table.createdBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get updatedBy => $composableBuilder(
    column: $table.updatedBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get hlc => $composableBuilder(
    column: $table.hlc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nodeId => $composableBuilder(
    column: $table.nodeId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get parentNodeId => $composableBuilder(
    column: $table.parentNodeId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sortKey => $composableBuilder(
    column: $table.sortKey,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PlacementsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PlacementsTable> {
  $$PlacementsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get spaceId =>
      $composableBuilder(column: $table.spaceId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get createdBy =>
      $composableBuilder(column: $table.createdBy, builder: (column) => column);

  GeneratedColumn<String> get updatedBy =>
      $composableBuilder(column: $table.updatedBy, builder: (column) => column);

  GeneratedColumn<String> get hlc =>
      $composableBuilder(column: $table.hlc, builder: (column) => column);

  GeneratedColumn<bool> get deleted =>
      $composableBuilder(column: $table.deleted, builder: (column) => column);

  GeneratedColumn<String> get nodeId =>
      $composableBuilder(column: $table.nodeId, builder: (column) => column);

  GeneratedColumn<String> get parentNodeId => $composableBuilder(
    column: $table.parentNodeId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sortKey =>
      $composableBuilder(column: $table.sortKey, builder: (column) => column);
}

class $$PlacementsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PlacementsTable,
          Placement,
          $$PlacementsTableFilterComposer,
          $$PlacementsTableOrderingComposer,
          $$PlacementsTableAnnotationComposer,
          $$PlacementsTableCreateCompanionBuilder,
          $$PlacementsTableUpdateCompanionBuilder,
          (
            Placement,
            BaseReferences<_$AppDatabase, $PlacementsTable, Placement>,
          ),
          Placement,
          PrefetchHooks Function()
        > {
  $$PlacementsTableTableManager(_$AppDatabase db, $PlacementsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PlacementsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PlacementsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PlacementsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> spaceId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<String> createdBy = const Value.absent(),
                Value<String> updatedBy = const Value.absent(),
                Value<String> hlc = const Value.absent(),
                Value<bool> deleted = const Value.absent(),
                Value<String> nodeId = const Value.absent(),
                Value<String?> parentNodeId = const Value.absent(),
                Value<String> sortKey = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PlacementsCompanion(
                id: id,
                spaceId: spaceId,
                createdAt: createdAt,
                createdBy: createdBy,
                updatedBy: updatedBy,
                hlc: hlc,
                deleted: deleted,
                nodeId: nodeId,
                parentNodeId: parentNodeId,
                sortKey: sortKey,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String spaceId,
                required DateTime createdAt,
                required String createdBy,
                required String updatedBy,
                required String hlc,
                Value<bool> deleted = const Value.absent(),
                required String nodeId,
                Value<String?> parentNodeId = const Value.absent(),
                required String sortKey,
                Value<int> rowid = const Value.absent(),
              }) => PlacementsCompanion.insert(
                id: id,
                spaceId: spaceId,
                createdAt: createdAt,
                createdBy: createdBy,
                updatedBy: updatedBy,
                hlc: hlc,
                deleted: deleted,
                nodeId: nodeId,
                parentNodeId: parentNodeId,
                sortKey: sortKey,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PlacementsTable, Placement>(table),
                  BaseReferences<_$AppDatabase, $PlacementsTable, Placement>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PlacementsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PlacementsTable,
      Placement,
      $$PlacementsTableFilterComposer,
      $$PlacementsTableOrderingComposer,
      $$PlacementsTableAnnotationComposer,
      $$PlacementsTableCreateCompanionBuilder,
      $$PlacementsTableUpdateCompanionBuilder,
      (Placement, BaseReferences<_$AppDatabase, $PlacementsTable, Placement>),
      Placement,
      PrefetchHooks Function()
    >;
typedef $$LinksTableCreateCompanionBuilder = LinksCompanion Function({
  required String id,
  required String spaceId,
  required DateTime createdAt,
  required String createdBy,
  required String updatedBy,
  required String hlc,
  Value<bool> deleted,
  required String fromNodeId,
  required LinkKind targetKind,
  Value<String?> targetId,
  Value<String?> url,
  Value<String?> label,
  required LinkOrigin origin,
  Value<int> rowid,
});
typedef $$LinksTableUpdateCompanionBuilder = LinksCompanion Function({
  Value<String> id,
  Value<String> spaceId,
  Value<DateTime> createdAt,
  Value<String> createdBy,
  Value<String> updatedBy,
  Value<String> hlc,
  Value<bool> deleted,
  Value<String> fromNodeId,
  Value<LinkKind> targetKind,
  Value<String?> targetId,
  Value<String?> url,
  Value<String?> label,
  Value<LinkOrigin> origin,
  Value<int> rowid,
});

class $$LinksTableFilterComposer extends Composer<_$AppDatabase, $LinksTable> {
  $$LinksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get spaceId => $composableBuilder(
    column: $table.spaceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdBy => $composableBuilder(
    column: $table.createdBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get updatedBy => $composableBuilder(
    column: $table.updatedBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get hlc => $composableBuilder(
    column: $table.hlc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fromNodeId => $composableBuilder(
    column: $table.fromNodeId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<LinkKind, LinkKind, String> get targetKind =>
      $composableBuilder(
        column: $table.targetKind,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get targetId => $composableBuilder(
    column: $table.targetId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get url => $composableBuilder(
    column: $table.url,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<LinkOrigin, LinkOrigin, String> get origin =>
      $composableBuilder(
        column: $table.origin,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );
}

class $$LinksTableOrderingComposer
    extends Composer<_$AppDatabase, $LinksTable> {
  $$LinksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get spaceId => $composableBuilder(
    column: $table.spaceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdBy => $composableBuilder(
    column: $table.createdBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get updatedBy => $composableBuilder(
    column: $table.updatedBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get hlc => $composableBuilder(
    column: $table.hlc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fromNodeId => $composableBuilder(
    column: $table.fromNodeId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get targetKind => $composableBuilder(
    column: $table.targetKind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get targetId => $composableBuilder(
    column: $table.targetId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get url => $composableBuilder(
    column: $table.url,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get origin => $composableBuilder(
    column: $table.origin,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LinksTableAnnotationComposer
    extends Composer<_$AppDatabase, $LinksTable> {
  $$LinksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get spaceId =>
      $composableBuilder(column: $table.spaceId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get createdBy =>
      $composableBuilder(column: $table.createdBy, builder: (column) => column);

  GeneratedColumn<String> get updatedBy =>
      $composableBuilder(column: $table.updatedBy, builder: (column) => column);

  GeneratedColumn<String> get hlc =>
      $composableBuilder(column: $table.hlc, builder: (column) => column);

  GeneratedColumn<bool> get deleted =>
      $composableBuilder(column: $table.deleted, builder: (column) => column);

  GeneratedColumn<String> get fromNodeId => $composableBuilder(
    column: $table.fromNodeId,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<LinkKind, String> get targetKind =>
      $composableBuilder(
        column: $table.targetKind,
        builder: (column) => column,
      );

  GeneratedColumn<String> get targetId =>
      $composableBuilder(column: $table.targetId, builder: (column) => column);

  GeneratedColumn<String> get url =>
      $composableBuilder(column: $table.url, builder: (column) => column);

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumnWithTypeConverter<LinkOrigin, String> get origin =>
      $composableBuilder(column: $table.origin, builder: (column) => column);
}

class $$LinksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LinksTable,
          Link,
          $$LinksTableFilterComposer,
          $$LinksTableOrderingComposer,
          $$LinksTableAnnotationComposer,
          $$LinksTableCreateCompanionBuilder,
          $$LinksTableUpdateCompanionBuilder,
          (Link, BaseReferences<_$AppDatabase, $LinksTable, Link>),
          Link,
          PrefetchHooks Function()
        > {
  $$LinksTableTableManager(_$AppDatabase db, $LinksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LinksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LinksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LinksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> spaceId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<String> createdBy = const Value.absent(),
                Value<String> updatedBy = const Value.absent(),
                Value<String> hlc = const Value.absent(),
                Value<bool> deleted = const Value.absent(),
                Value<String> fromNodeId = const Value.absent(),
                Value<LinkKind> targetKind = const Value.absent(),
                Value<String?> targetId = const Value.absent(),
                Value<String?> url = const Value.absent(),
                Value<String?> label = const Value.absent(),
                Value<LinkOrigin> origin = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LinksCompanion(
                id: id,
                spaceId: spaceId,
                createdAt: createdAt,
                createdBy: createdBy,
                updatedBy: updatedBy,
                hlc: hlc,
                deleted: deleted,
                fromNodeId: fromNodeId,
                targetKind: targetKind,
                targetId: targetId,
                url: url,
                label: label,
                origin: origin,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String spaceId,
                required DateTime createdAt,
                required String createdBy,
                required String updatedBy,
                required String hlc,
                Value<bool> deleted = const Value.absent(),
                required String fromNodeId,
                required LinkKind targetKind,
                Value<String?> targetId = const Value.absent(),
                Value<String?> url = const Value.absent(),
                Value<String?> label = const Value.absent(),
                required LinkOrigin origin,
                Value<int> rowid = const Value.absent(),
              }) => LinksCompanion.insert(
                id: id,
                spaceId: spaceId,
                createdAt: createdAt,
                createdBy: createdBy,
                updatedBy: updatedBy,
                hlc: hlc,
                deleted: deleted,
                fromNodeId: fromNodeId,
                targetKind: targetKind,
                targetId: targetId,
                url: url,
                label: label,
                origin: origin,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$LinksTable, Link>(table),
                  BaseReferences<_$AppDatabase, $LinksTable, Link>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LinksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LinksTable,
      Link,
      $$LinksTableFilterComposer,
      $$LinksTableOrderingComposer,
      $$LinksTableAnnotationComposer,
      $$LinksTableCreateCompanionBuilder,
      $$LinksTableUpdateCompanionBuilder,
      (Link, BaseReferences<_$AppDatabase, $LinksTable, Link>),
      Link,
      PrefetchHooks Function()
    >;
typedef $$CoreValuesTableCreateCompanionBuilder = CoreValuesCompanion Function({
  required String id,
  required String spaceId,
  required DateTime createdAt,
  required String createdBy,
  required String updatedBy,
  required String hlc,
  Value<bool> deleted,
  required String name,
  Value<String> statement,
  Value<int?> color,
  Value<String?> icon,
  required String sortKey,
  Value<int> rowid,
});
typedef $$CoreValuesTableUpdateCompanionBuilder = CoreValuesCompanion Function({
  Value<String> id,
  Value<String> spaceId,
  Value<DateTime> createdAt,
  Value<String> createdBy,
  Value<String> updatedBy,
  Value<String> hlc,
  Value<bool> deleted,
  Value<String> name,
  Value<String> statement,
  Value<int?> color,
  Value<String?> icon,
  Value<String> sortKey,
  Value<int> rowid,
});

class $$CoreValuesTableFilterComposer
    extends Composer<_$AppDatabase, $CoreValuesTable> {
  $$CoreValuesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get spaceId => $composableBuilder(
    column: $table.spaceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdBy => $composableBuilder(
    column: $table.createdBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get updatedBy => $composableBuilder(
    column: $table.updatedBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get hlc => $composableBuilder(
    column: $table.hlc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get statement => $composableBuilder(
    column: $table.statement,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sortKey => $composableBuilder(
    column: $table.sortKey,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CoreValuesTableOrderingComposer
    extends Composer<_$AppDatabase, $CoreValuesTable> {
  $$CoreValuesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get spaceId => $composableBuilder(
    column: $table.spaceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdBy => $composableBuilder(
    column: $table.createdBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get updatedBy => $composableBuilder(
    column: $table.updatedBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get hlc => $composableBuilder(
    column: $table.hlc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get statement => $composableBuilder(
    column: $table.statement,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sortKey => $composableBuilder(
    column: $table.sortKey,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CoreValuesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CoreValuesTable> {
  $$CoreValuesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get spaceId =>
      $composableBuilder(column: $table.spaceId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get createdBy =>
      $composableBuilder(column: $table.createdBy, builder: (column) => column);

  GeneratedColumn<String> get updatedBy =>
      $composableBuilder(column: $table.updatedBy, builder: (column) => column);

  GeneratedColumn<String> get hlc =>
      $composableBuilder(column: $table.hlc, builder: (column) => column);

  GeneratedColumn<bool> get deleted =>
      $composableBuilder(column: $table.deleted, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get statement =>
      $composableBuilder(column: $table.statement, builder: (column) => column);

  GeneratedColumn<int> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  GeneratedColumn<String> get icon =>
      $composableBuilder(column: $table.icon, builder: (column) => column);

  GeneratedColumn<String> get sortKey =>
      $composableBuilder(column: $table.sortKey, builder: (column) => column);
}

class $$CoreValuesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CoreValuesTable,
          CoreValue,
          $$CoreValuesTableFilterComposer,
          $$CoreValuesTableOrderingComposer,
          $$CoreValuesTableAnnotationComposer,
          $$CoreValuesTableCreateCompanionBuilder,
          $$CoreValuesTableUpdateCompanionBuilder,
          (
            CoreValue,
            BaseReferences<_$AppDatabase, $CoreValuesTable, CoreValue>,
          ),
          CoreValue,
          PrefetchHooks Function()
        > {
  $$CoreValuesTableTableManager(_$AppDatabase db, $CoreValuesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CoreValuesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CoreValuesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CoreValuesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> spaceId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<String> createdBy = const Value.absent(),
                Value<String> updatedBy = const Value.absent(),
                Value<String> hlc = const Value.absent(),
                Value<bool> deleted = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> statement = const Value.absent(),
                Value<int?> color = const Value.absent(),
                Value<String?> icon = const Value.absent(),
                Value<String> sortKey = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CoreValuesCompanion(
                id: id,
                spaceId: spaceId,
                createdAt: createdAt,
                createdBy: createdBy,
                updatedBy: updatedBy,
                hlc: hlc,
                deleted: deleted,
                name: name,
                statement: statement,
                color: color,
                icon: icon,
                sortKey: sortKey,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String spaceId,
                required DateTime createdAt,
                required String createdBy,
                required String updatedBy,
                required String hlc,
                Value<bool> deleted = const Value.absent(),
                required String name,
                Value<String> statement = const Value.absent(),
                Value<int?> color = const Value.absent(),
                Value<String?> icon = const Value.absent(),
                required String sortKey,
                Value<int> rowid = const Value.absent(),
              }) => CoreValuesCompanion.insert(
                id: id,
                spaceId: spaceId,
                createdAt: createdAt,
                createdBy: createdBy,
                updatedBy: updatedBy,
                hlc: hlc,
                deleted: deleted,
                name: name,
                statement: statement,
                color: color,
                icon: icon,
                sortKey: sortKey,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CoreValuesTable, CoreValue>(table),
                  BaseReferences<_$AppDatabase, $CoreValuesTable, CoreValue>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CoreValuesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CoreValuesTable,
      CoreValue,
      $$CoreValuesTableFilterComposer,
      $$CoreValuesTableOrderingComposer,
      $$CoreValuesTableAnnotationComposer,
      $$CoreValuesTableCreateCompanionBuilder,
      $$CoreValuesTableUpdateCompanionBuilder,
      (CoreValue, BaseReferences<_$AppDatabase, $CoreValuesTable, CoreValue>),
      CoreValue,
      PrefetchHooks Function()
    >;
typedef $$NodeValuesTableCreateCompanionBuilder = NodeValuesCompanion Function({
  required String id,
  required String spaceId,
  required DateTime createdAt,
  required String createdBy,
  required String updatedBy,
  required String hlc,
  Value<bool> deleted,
  required String nodeId,
  required String valueId,
  Value<int> rowid,
});
typedef $$NodeValuesTableUpdateCompanionBuilder = NodeValuesCompanion Function({
  Value<String> id,
  Value<String> spaceId,
  Value<DateTime> createdAt,
  Value<String> createdBy,
  Value<String> updatedBy,
  Value<String> hlc,
  Value<bool> deleted,
  Value<String> nodeId,
  Value<String> valueId,
  Value<int> rowid,
});

class $$NodeValuesTableFilterComposer
    extends Composer<_$AppDatabase, $NodeValuesTable> {
  $$NodeValuesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get spaceId => $composableBuilder(
    column: $table.spaceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdBy => $composableBuilder(
    column: $table.createdBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get updatedBy => $composableBuilder(
    column: $table.updatedBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get hlc => $composableBuilder(
    column: $table.hlc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nodeId => $composableBuilder(
    column: $table.nodeId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get valueId => $composableBuilder(
    column: $table.valueId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$NodeValuesTableOrderingComposer
    extends Composer<_$AppDatabase, $NodeValuesTable> {
  $$NodeValuesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get spaceId => $composableBuilder(
    column: $table.spaceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdBy => $composableBuilder(
    column: $table.createdBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get updatedBy => $composableBuilder(
    column: $table.updatedBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get hlc => $composableBuilder(
    column: $table.hlc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nodeId => $composableBuilder(
    column: $table.nodeId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get valueId => $composableBuilder(
    column: $table.valueId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$NodeValuesTableAnnotationComposer
    extends Composer<_$AppDatabase, $NodeValuesTable> {
  $$NodeValuesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get spaceId =>
      $composableBuilder(column: $table.spaceId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get createdBy =>
      $composableBuilder(column: $table.createdBy, builder: (column) => column);

  GeneratedColumn<String> get updatedBy =>
      $composableBuilder(column: $table.updatedBy, builder: (column) => column);

  GeneratedColumn<String> get hlc =>
      $composableBuilder(column: $table.hlc, builder: (column) => column);

  GeneratedColumn<bool> get deleted =>
      $composableBuilder(column: $table.deleted, builder: (column) => column);

  GeneratedColumn<String> get nodeId =>
      $composableBuilder(column: $table.nodeId, builder: (column) => column);

  GeneratedColumn<String> get valueId =>
      $composableBuilder(column: $table.valueId, builder: (column) => column);
}

class $$NodeValuesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $NodeValuesTable,
          NodeValue,
          $$NodeValuesTableFilterComposer,
          $$NodeValuesTableOrderingComposer,
          $$NodeValuesTableAnnotationComposer,
          $$NodeValuesTableCreateCompanionBuilder,
          $$NodeValuesTableUpdateCompanionBuilder,
          (
            NodeValue,
            BaseReferences<_$AppDatabase, $NodeValuesTable, NodeValue>,
          ),
          NodeValue,
          PrefetchHooks Function()
        > {
  $$NodeValuesTableTableManager(_$AppDatabase db, $NodeValuesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NodeValuesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$NodeValuesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$NodeValuesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> spaceId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<String> createdBy = const Value.absent(),
                Value<String> updatedBy = const Value.absent(),
                Value<String> hlc = const Value.absent(),
                Value<bool> deleted = const Value.absent(),
                Value<String> nodeId = const Value.absent(),
                Value<String> valueId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => NodeValuesCompanion(
                id: id,
                spaceId: spaceId,
                createdAt: createdAt,
                createdBy: createdBy,
                updatedBy: updatedBy,
                hlc: hlc,
                deleted: deleted,
                nodeId: nodeId,
                valueId: valueId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String spaceId,
                required DateTime createdAt,
                required String createdBy,
                required String updatedBy,
                required String hlc,
                Value<bool> deleted = const Value.absent(),
                required String nodeId,
                required String valueId,
                Value<int> rowid = const Value.absent(),
              }) => NodeValuesCompanion.insert(
                id: id,
                spaceId: spaceId,
                createdAt: createdAt,
                createdBy: createdBy,
                updatedBy: updatedBy,
                hlc: hlc,
                deleted: deleted,
                nodeId: nodeId,
                valueId: valueId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$NodeValuesTable, NodeValue>(table),
                  BaseReferences<_$AppDatabase, $NodeValuesTable, NodeValue>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$NodeValuesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $NodeValuesTable,
      NodeValue,
      $$NodeValuesTableFilterComposer,
      $$NodeValuesTableOrderingComposer,
      $$NodeValuesTableAnnotationComposer,
      $$NodeValuesTableCreateCompanionBuilder,
      $$NodeValuesTableUpdateCompanionBuilder,
      (NodeValue, BaseReferences<_$AppDatabase, $NodeValuesTable, NodeValue>),
      NodeValue,
      PrefetchHooks Function()
    >;
typedef $$TagsTableCreateCompanionBuilder = TagsCompanion Function({
  required String id,
  required String spaceId,
  required DateTime createdAt,
  required String createdBy,
  required String updatedBy,
  required String hlc,
  Value<bool> deleted,
  required String name,
  Value<int?> color,
  required TagKind kind,
  Value<bool> favorite,
  Value<bool> kept,
  Value<int> rowid,
});
typedef $$TagsTableUpdateCompanionBuilder = TagsCompanion Function({
  Value<String> id,
  Value<String> spaceId,
  Value<DateTime> createdAt,
  Value<String> createdBy,
  Value<String> updatedBy,
  Value<String> hlc,
  Value<bool> deleted,
  Value<String> name,
  Value<int?> color,
  Value<TagKind> kind,
  Value<bool> favorite,
  Value<bool> kept,
  Value<int> rowid,
});

class $$TagsTableFilterComposer extends Composer<_$AppDatabase, $TagsTable> {
  $$TagsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get spaceId => $composableBuilder(
    column: $table.spaceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdBy => $composableBuilder(
    column: $table.createdBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get updatedBy => $composableBuilder(
    column: $table.updatedBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get hlc => $composableBuilder(
    column: $table.hlc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<TagKind, TagKind, String> get kind =>
      $composableBuilder(
        column: $table.kind,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<bool> get favorite => $composableBuilder(
    column: $table.favorite,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get kept => $composableBuilder(
    column: $table.kept,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TagsTableOrderingComposer extends Composer<_$AppDatabase, $TagsTable> {
  $$TagsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get spaceId => $composableBuilder(
    column: $table.spaceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdBy => $composableBuilder(
    column: $table.createdBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get updatedBy => $composableBuilder(
    column: $table.updatedBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get hlc => $composableBuilder(
    column: $table.hlc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get favorite => $composableBuilder(
    column: $table.favorite,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get kept => $composableBuilder(
    column: $table.kept,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TagsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TagsTable> {
  $$TagsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get spaceId =>
      $composableBuilder(column: $table.spaceId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get createdBy =>
      $composableBuilder(column: $table.createdBy, builder: (column) => column);

  GeneratedColumn<String> get updatedBy =>
      $composableBuilder(column: $table.updatedBy, builder: (column) => column);

  GeneratedColumn<String> get hlc =>
      $composableBuilder(column: $table.hlc, builder: (column) => column);

  GeneratedColumn<bool> get deleted =>
      $composableBuilder(column: $table.deleted, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  GeneratedColumnWithTypeConverter<TagKind, String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<bool> get favorite =>
      $composableBuilder(column: $table.favorite, builder: (column) => column);

  GeneratedColumn<bool> get kept =>
      $composableBuilder(column: $table.kept, builder: (column) => column);
}

class $$TagsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TagsTable,
          Tag,
          $$TagsTableFilterComposer,
          $$TagsTableOrderingComposer,
          $$TagsTableAnnotationComposer,
          $$TagsTableCreateCompanionBuilder,
          $$TagsTableUpdateCompanionBuilder,
          (Tag, BaseReferences<_$AppDatabase, $TagsTable, Tag>),
          Tag,
          PrefetchHooks Function()
        > {
  $$TagsTableTableManager(_$AppDatabase db, $TagsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TagsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TagsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TagsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> spaceId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<String> createdBy = const Value.absent(),
                Value<String> updatedBy = const Value.absent(),
                Value<String> hlc = const Value.absent(),
                Value<bool> deleted = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int?> color = const Value.absent(),
                Value<TagKind> kind = const Value.absent(),
                Value<bool> favorite = const Value.absent(),
                Value<bool> kept = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TagsCompanion(
                id: id,
                spaceId: spaceId,
                createdAt: createdAt,
                createdBy: createdBy,
                updatedBy: updatedBy,
                hlc: hlc,
                deleted: deleted,
                name: name,
                color: color,
                kind: kind,
                favorite: favorite,
                kept: kept,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String spaceId,
                required DateTime createdAt,
                required String createdBy,
                required String updatedBy,
                required String hlc,
                Value<bool> deleted = const Value.absent(),
                required String name,
                Value<int?> color = const Value.absent(),
                required TagKind kind,
                Value<bool> favorite = const Value.absent(),
                Value<bool> kept = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TagsCompanion.insert(
                id: id,
                spaceId: spaceId,
                createdAt: createdAt,
                createdBy: createdBy,
                updatedBy: updatedBy,
                hlc: hlc,
                deleted: deleted,
                name: name,
                color: color,
                kind: kind,
                favorite: favorite,
                kept: kept,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$TagsTable, Tag>(table),
                  BaseReferences<_$AppDatabase, $TagsTable, Tag>(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TagsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TagsTable,
      Tag,
      $$TagsTableFilterComposer,
      $$TagsTableOrderingComposer,
      $$TagsTableAnnotationComposer,
      $$TagsTableCreateCompanionBuilder,
      $$TagsTableUpdateCompanionBuilder,
      (Tag, BaseReferences<_$AppDatabase, $TagsTable, Tag>),
      Tag,
      PrefetchHooks Function()
    >;
typedef $$NodeTagsTableCreateCompanionBuilder = NodeTagsCompanion Function({
  required String id,
  required String spaceId,
  required DateTime createdAt,
  required String createdBy,
  required String updatedBy,
  required String hlc,
  Value<bool> deleted,
  required String nodeId,
  required String tagId,
  required LinkOrigin origin,
  Value<int> rowid,
});
typedef $$NodeTagsTableUpdateCompanionBuilder = NodeTagsCompanion Function({
  Value<String> id,
  Value<String> spaceId,
  Value<DateTime> createdAt,
  Value<String> createdBy,
  Value<String> updatedBy,
  Value<String> hlc,
  Value<bool> deleted,
  Value<String> nodeId,
  Value<String> tagId,
  Value<LinkOrigin> origin,
  Value<int> rowid,
});

class $$NodeTagsTableFilterComposer
    extends Composer<_$AppDatabase, $NodeTagsTable> {
  $$NodeTagsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get spaceId => $composableBuilder(
    column: $table.spaceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdBy => $composableBuilder(
    column: $table.createdBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get updatedBy => $composableBuilder(
    column: $table.updatedBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get hlc => $composableBuilder(
    column: $table.hlc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nodeId => $composableBuilder(
    column: $table.nodeId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tagId => $composableBuilder(
    column: $table.tagId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<LinkOrigin, LinkOrigin, String> get origin =>
      $composableBuilder(
        column: $table.origin,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );
}

class $$NodeTagsTableOrderingComposer
    extends Composer<_$AppDatabase, $NodeTagsTable> {
  $$NodeTagsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get spaceId => $composableBuilder(
    column: $table.spaceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdBy => $composableBuilder(
    column: $table.createdBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get updatedBy => $composableBuilder(
    column: $table.updatedBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get hlc => $composableBuilder(
    column: $table.hlc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nodeId => $composableBuilder(
    column: $table.nodeId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tagId => $composableBuilder(
    column: $table.tagId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get origin => $composableBuilder(
    column: $table.origin,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$NodeTagsTableAnnotationComposer
    extends Composer<_$AppDatabase, $NodeTagsTable> {
  $$NodeTagsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get spaceId =>
      $composableBuilder(column: $table.spaceId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get createdBy =>
      $composableBuilder(column: $table.createdBy, builder: (column) => column);

  GeneratedColumn<String> get updatedBy =>
      $composableBuilder(column: $table.updatedBy, builder: (column) => column);

  GeneratedColumn<String> get hlc =>
      $composableBuilder(column: $table.hlc, builder: (column) => column);

  GeneratedColumn<bool> get deleted =>
      $composableBuilder(column: $table.deleted, builder: (column) => column);

  GeneratedColumn<String> get nodeId =>
      $composableBuilder(column: $table.nodeId, builder: (column) => column);

  GeneratedColumn<String> get tagId =>
      $composableBuilder(column: $table.tagId, builder: (column) => column);

  GeneratedColumnWithTypeConverter<LinkOrigin, String> get origin =>
      $composableBuilder(column: $table.origin, builder: (column) => column);
}

class $$NodeTagsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $NodeTagsTable,
          NodeTag,
          $$NodeTagsTableFilterComposer,
          $$NodeTagsTableOrderingComposer,
          $$NodeTagsTableAnnotationComposer,
          $$NodeTagsTableCreateCompanionBuilder,
          $$NodeTagsTableUpdateCompanionBuilder,
          (NodeTag, BaseReferences<_$AppDatabase, $NodeTagsTable, NodeTag>),
          NodeTag,
          PrefetchHooks Function()
        > {
  $$NodeTagsTableTableManager(_$AppDatabase db, $NodeTagsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NodeTagsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$NodeTagsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$NodeTagsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> spaceId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<String> createdBy = const Value.absent(),
                Value<String> updatedBy = const Value.absent(),
                Value<String> hlc = const Value.absent(),
                Value<bool> deleted = const Value.absent(),
                Value<String> nodeId = const Value.absent(),
                Value<String> tagId = const Value.absent(),
                Value<LinkOrigin> origin = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => NodeTagsCompanion(
                id: id,
                spaceId: spaceId,
                createdAt: createdAt,
                createdBy: createdBy,
                updatedBy: updatedBy,
                hlc: hlc,
                deleted: deleted,
                nodeId: nodeId,
                tagId: tagId,
                origin: origin,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String spaceId,
                required DateTime createdAt,
                required String createdBy,
                required String updatedBy,
                required String hlc,
                Value<bool> deleted = const Value.absent(),
                required String nodeId,
                required String tagId,
                required LinkOrigin origin,
                Value<int> rowid = const Value.absent(),
              }) => NodeTagsCompanion.insert(
                id: id,
                spaceId: spaceId,
                createdAt: createdAt,
                createdBy: createdBy,
                updatedBy: updatedBy,
                hlc: hlc,
                deleted: deleted,
                nodeId: nodeId,
                tagId: tagId,
                origin: origin,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$NodeTagsTable, NodeTag>(table),
                  BaseReferences<_$AppDatabase, $NodeTagsTable, NodeTag>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$NodeTagsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $NodeTagsTable,
      NodeTag,
      $$NodeTagsTableFilterComposer,
      $$NodeTagsTableOrderingComposer,
      $$NodeTagsTableAnnotationComposer,
      $$NodeTagsTableCreateCompanionBuilder,
      $$NodeTagsTableUpdateCompanionBuilder,
      (NodeTag, BaseReferences<_$AppDatabase, $NodeTagsTable, NodeTag>),
      NodeTag,
      PrefetchHooks Function()
    >;
typedef $$AttachmentsTableCreateCompanionBuilder =
    AttachmentsCompanion Function({
      required String id,
      required String spaceId,
      required DateTime createdAt,
      required String createdBy,
      required String updatedBy,
      required String hlc,
      Value<bool> deleted,
      required String nodeId,
      required String contentHash,
      required String filename,
      required String mime,
      required int sizeBytes,
      required AttachmentKind kind,
      Value<int?> width,
      Value<int?> height,
      Value<int> rowid,
    });
typedef $$AttachmentsTableUpdateCompanionBuilder =
    AttachmentsCompanion Function({
      Value<String> id,
      Value<String> spaceId,
      Value<DateTime> createdAt,
      Value<String> createdBy,
      Value<String> updatedBy,
      Value<String> hlc,
      Value<bool> deleted,
      Value<String> nodeId,
      Value<String> contentHash,
      Value<String> filename,
      Value<String> mime,
      Value<int> sizeBytes,
      Value<AttachmentKind> kind,
      Value<int?> width,
      Value<int?> height,
      Value<int> rowid,
    });

class $$AttachmentsTableFilterComposer
    extends Composer<_$AppDatabase, $AttachmentsTable> {
  $$AttachmentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get spaceId => $composableBuilder(
    column: $table.spaceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdBy => $composableBuilder(
    column: $table.createdBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get updatedBy => $composableBuilder(
    column: $table.updatedBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get hlc => $composableBuilder(
    column: $table.hlc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nodeId => $composableBuilder(
    column: $table.nodeId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get contentHash => $composableBuilder(
    column: $table.contentHash,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get filename => $composableBuilder(
    column: $table.filename,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mime => $composableBuilder(
    column: $table.mime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sizeBytes => $composableBuilder(
    column: $table.sizeBytes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<AttachmentKind, AttachmentKind, String>
  get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<int> get width => $composableBuilder(
    column: $table.width,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get height => $composableBuilder(
    column: $table.height,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AttachmentsTableOrderingComposer
    extends Composer<_$AppDatabase, $AttachmentsTable> {
  $$AttachmentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get spaceId => $composableBuilder(
    column: $table.spaceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdBy => $composableBuilder(
    column: $table.createdBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get updatedBy => $composableBuilder(
    column: $table.updatedBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get hlc => $composableBuilder(
    column: $table.hlc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nodeId => $composableBuilder(
    column: $table.nodeId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get contentHash => $composableBuilder(
    column: $table.contentHash,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get filename => $composableBuilder(
    column: $table.filename,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mime => $composableBuilder(
    column: $table.mime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sizeBytes => $composableBuilder(
    column: $table.sizeBytes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get width => $composableBuilder(
    column: $table.width,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get height => $composableBuilder(
    column: $table.height,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AttachmentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AttachmentsTable> {
  $$AttachmentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get spaceId =>
      $composableBuilder(column: $table.spaceId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get createdBy =>
      $composableBuilder(column: $table.createdBy, builder: (column) => column);

  GeneratedColumn<String> get updatedBy =>
      $composableBuilder(column: $table.updatedBy, builder: (column) => column);

  GeneratedColumn<String> get hlc =>
      $composableBuilder(column: $table.hlc, builder: (column) => column);

  GeneratedColumn<bool> get deleted =>
      $composableBuilder(column: $table.deleted, builder: (column) => column);

  GeneratedColumn<String> get nodeId =>
      $composableBuilder(column: $table.nodeId, builder: (column) => column);

  GeneratedColumn<String> get contentHash => $composableBuilder(
    column: $table.contentHash,
    builder: (column) => column,
  );

  GeneratedColumn<String> get filename =>
      $composableBuilder(column: $table.filename, builder: (column) => column);

  GeneratedColumn<String> get mime =>
      $composableBuilder(column: $table.mime, builder: (column) => column);

  GeneratedColumn<int> get sizeBytes =>
      $composableBuilder(column: $table.sizeBytes, builder: (column) => column);

  GeneratedColumnWithTypeConverter<AttachmentKind, String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<int> get width =>
      $composableBuilder(column: $table.width, builder: (column) => column);

  GeneratedColumn<int> get height =>
      $composableBuilder(column: $table.height, builder: (column) => column);
}

class $$AttachmentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AttachmentsTable,
          Attachment,
          $$AttachmentsTableFilterComposer,
          $$AttachmentsTableOrderingComposer,
          $$AttachmentsTableAnnotationComposer,
          $$AttachmentsTableCreateCompanionBuilder,
          $$AttachmentsTableUpdateCompanionBuilder,
          (
            Attachment,
            BaseReferences<_$AppDatabase, $AttachmentsTable, Attachment>,
          ),
          Attachment,
          PrefetchHooks Function()
        > {
  $$AttachmentsTableTableManager(_$AppDatabase db, $AttachmentsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AttachmentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AttachmentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AttachmentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> spaceId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<String> createdBy = const Value.absent(),
                Value<String> updatedBy = const Value.absent(),
                Value<String> hlc = const Value.absent(),
                Value<bool> deleted = const Value.absent(),
                Value<String> nodeId = const Value.absent(),
                Value<String> contentHash = const Value.absent(),
                Value<String> filename = const Value.absent(),
                Value<String> mime = const Value.absent(),
                Value<int> sizeBytes = const Value.absent(),
                Value<AttachmentKind> kind = const Value.absent(),
                Value<int?> width = const Value.absent(),
                Value<int?> height = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AttachmentsCompanion(
                id: id,
                spaceId: spaceId,
                createdAt: createdAt,
                createdBy: createdBy,
                updatedBy: updatedBy,
                hlc: hlc,
                deleted: deleted,
                nodeId: nodeId,
                contentHash: contentHash,
                filename: filename,
                mime: mime,
                sizeBytes: sizeBytes,
                kind: kind,
                width: width,
                height: height,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String spaceId,
                required DateTime createdAt,
                required String createdBy,
                required String updatedBy,
                required String hlc,
                Value<bool> deleted = const Value.absent(),
                required String nodeId,
                required String contentHash,
                required String filename,
                required String mime,
                required int sizeBytes,
                required AttachmentKind kind,
                Value<int?> width = const Value.absent(),
                Value<int?> height = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AttachmentsCompanion.insert(
                id: id,
                spaceId: spaceId,
                createdAt: createdAt,
                createdBy: createdBy,
                updatedBy: updatedBy,
                hlc: hlc,
                deleted: deleted,
                nodeId: nodeId,
                contentHash: contentHash,
                filename: filename,
                mime: mime,
                sizeBytes: sizeBytes,
                kind: kind,
                width: width,
                height: height,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AttachmentsTable, Attachment>(table),
                  BaseReferences<_$AppDatabase, $AttachmentsTable, Attachment>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AttachmentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AttachmentsTable,
      Attachment,
      $$AttachmentsTableFilterComposer,
      $$AttachmentsTableOrderingComposer,
      $$AttachmentsTableAnnotationComposer,
      $$AttachmentsTableCreateCompanionBuilder,
      $$AttachmentsTableUpdateCompanionBuilder,
      (
        Attachment,
        BaseReferences<_$AppDatabase, $AttachmentsTable, Attachment>,
      ),
      Attachment,
      PrefetchHooks Function()
    >;
typedef $$AnnotationsTableCreateCompanionBuilder =
    AnnotationsCompanion Function({
      required String id,
      required String spaceId,
      required DateTime createdAt,
      required String createdBy,
      required String updatedBy,
      required String hlc,
      Value<bool> deleted,
      required String attachmentId,
      required AnnotationKind kind,
      required String dataJson,
      required int color,
      required int z,
      Value<int> rowid,
    });
typedef $$AnnotationsTableUpdateCompanionBuilder =
    AnnotationsCompanion Function({
      Value<String> id,
      Value<String> spaceId,
      Value<DateTime> createdAt,
      Value<String> createdBy,
      Value<String> updatedBy,
      Value<String> hlc,
      Value<bool> deleted,
      Value<String> attachmentId,
      Value<AnnotationKind> kind,
      Value<String> dataJson,
      Value<int> color,
      Value<int> z,
      Value<int> rowid,
    });

class $$AnnotationsTableFilterComposer
    extends Composer<_$AppDatabase, $AnnotationsTable> {
  $$AnnotationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get spaceId => $composableBuilder(
    column: $table.spaceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdBy => $composableBuilder(
    column: $table.createdBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get updatedBy => $composableBuilder(
    column: $table.updatedBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get hlc => $composableBuilder(
    column: $table.hlc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get attachmentId => $composableBuilder(
    column: $table.attachmentId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<AnnotationKind, AnnotationKind, String>
  get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get dataJson => $composableBuilder(
    column: $table.dataJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get z => $composableBuilder(
    column: $table.z,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AnnotationsTableOrderingComposer
    extends Composer<_$AppDatabase, $AnnotationsTable> {
  $$AnnotationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get spaceId => $composableBuilder(
    column: $table.spaceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdBy => $composableBuilder(
    column: $table.createdBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get updatedBy => $composableBuilder(
    column: $table.updatedBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get hlc => $composableBuilder(
    column: $table.hlc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get attachmentId => $composableBuilder(
    column: $table.attachmentId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dataJson => $composableBuilder(
    column: $table.dataJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get z => $composableBuilder(
    column: $table.z,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AnnotationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AnnotationsTable> {
  $$AnnotationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get spaceId =>
      $composableBuilder(column: $table.spaceId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get createdBy =>
      $composableBuilder(column: $table.createdBy, builder: (column) => column);

  GeneratedColumn<String> get updatedBy =>
      $composableBuilder(column: $table.updatedBy, builder: (column) => column);

  GeneratedColumn<String> get hlc =>
      $composableBuilder(column: $table.hlc, builder: (column) => column);

  GeneratedColumn<bool> get deleted =>
      $composableBuilder(column: $table.deleted, builder: (column) => column);

  GeneratedColumn<String> get attachmentId => $composableBuilder(
    column: $table.attachmentId,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<AnnotationKind, String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<String> get dataJson =>
      $composableBuilder(column: $table.dataJson, builder: (column) => column);

  GeneratedColumn<int> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  GeneratedColumn<int> get z =>
      $composableBuilder(column: $table.z, builder: (column) => column);
}

class $$AnnotationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AnnotationsTable,
          Annotation,
          $$AnnotationsTableFilterComposer,
          $$AnnotationsTableOrderingComposer,
          $$AnnotationsTableAnnotationComposer,
          $$AnnotationsTableCreateCompanionBuilder,
          $$AnnotationsTableUpdateCompanionBuilder,
          (
            Annotation,
            BaseReferences<_$AppDatabase, $AnnotationsTable, Annotation>,
          ),
          Annotation,
          PrefetchHooks Function()
        > {
  $$AnnotationsTableTableManager(_$AppDatabase db, $AnnotationsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AnnotationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AnnotationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AnnotationsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> spaceId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<String> createdBy = const Value.absent(),
                Value<String> updatedBy = const Value.absent(),
                Value<String> hlc = const Value.absent(),
                Value<bool> deleted = const Value.absent(),
                Value<String> attachmentId = const Value.absent(),
                Value<AnnotationKind> kind = const Value.absent(),
                Value<String> dataJson = const Value.absent(),
                Value<int> color = const Value.absent(),
                Value<int> z = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AnnotationsCompanion(
                id: id,
                spaceId: spaceId,
                createdAt: createdAt,
                createdBy: createdBy,
                updatedBy: updatedBy,
                hlc: hlc,
                deleted: deleted,
                attachmentId: attachmentId,
                kind: kind,
                dataJson: dataJson,
                color: color,
                z: z,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String spaceId,
                required DateTime createdAt,
                required String createdBy,
                required String updatedBy,
                required String hlc,
                Value<bool> deleted = const Value.absent(),
                required String attachmentId,
                required AnnotationKind kind,
                required String dataJson,
                required int color,
                required int z,
                Value<int> rowid = const Value.absent(),
              }) => AnnotationsCompanion.insert(
                id: id,
                spaceId: spaceId,
                createdAt: createdAt,
                createdBy: createdBy,
                updatedBy: updatedBy,
                hlc: hlc,
                deleted: deleted,
                attachmentId: attachmentId,
                kind: kind,
                dataJson: dataJson,
                color: color,
                z: z,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AnnotationsTable, Annotation>(table),
                  BaseReferences<_$AppDatabase, $AnnotationsTable, Annotation>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AnnotationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AnnotationsTable,
      Annotation,
      $$AnnotationsTableFilterComposer,
      $$AnnotationsTableOrderingComposer,
      $$AnnotationsTableAnnotationComposer,
      $$AnnotationsTableCreateCompanionBuilder,
      $$AnnotationsTableUpdateCompanionBuilder,
      (
        Annotation,
        BaseReferences<_$AppDatabase, $AnnotationsTable, Annotation>,
      ),
      Annotation,
      PrefetchHooks Function()
    >;
typedef $$RemindersTableCreateCompanionBuilder = RemindersCompanion Function({
  required String id,
  required String spaceId,
  required DateTime createdAt,
  required String createdBy,
  required String updatedBy,
  required String hlc,
  Value<bool> deleted,
  required String nodeId,
  required int minutesBefore,
  Value<int> rowid,
});
typedef $$RemindersTableUpdateCompanionBuilder = RemindersCompanion Function({
  Value<String> id,
  Value<String> spaceId,
  Value<DateTime> createdAt,
  Value<String> createdBy,
  Value<String> updatedBy,
  Value<String> hlc,
  Value<bool> deleted,
  Value<String> nodeId,
  Value<int> minutesBefore,
  Value<int> rowid,
});

class $$RemindersTableFilterComposer
    extends Composer<_$AppDatabase, $RemindersTable> {
  $$RemindersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get spaceId => $composableBuilder(
    column: $table.spaceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdBy => $composableBuilder(
    column: $table.createdBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get updatedBy => $composableBuilder(
    column: $table.updatedBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get hlc => $composableBuilder(
    column: $table.hlc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nodeId => $composableBuilder(
    column: $table.nodeId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get minutesBefore => $composableBuilder(
    column: $table.minutesBefore,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RemindersTableOrderingComposer
    extends Composer<_$AppDatabase, $RemindersTable> {
  $$RemindersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get spaceId => $composableBuilder(
    column: $table.spaceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdBy => $composableBuilder(
    column: $table.createdBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get updatedBy => $composableBuilder(
    column: $table.updatedBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get hlc => $composableBuilder(
    column: $table.hlc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nodeId => $composableBuilder(
    column: $table.nodeId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get minutesBefore => $composableBuilder(
    column: $table.minutesBefore,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RemindersTableAnnotationComposer
    extends Composer<_$AppDatabase, $RemindersTable> {
  $$RemindersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get spaceId =>
      $composableBuilder(column: $table.spaceId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get createdBy =>
      $composableBuilder(column: $table.createdBy, builder: (column) => column);

  GeneratedColumn<String> get updatedBy =>
      $composableBuilder(column: $table.updatedBy, builder: (column) => column);

  GeneratedColumn<String> get hlc =>
      $composableBuilder(column: $table.hlc, builder: (column) => column);

  GeneratedColumn<bool> get deleted =>
      $composableBuilder(column: $table.deleted, builder: (column) => column);

  GeneratedColumn<String> get nodeId =>
      $composableBuilder(column: $table.nodeId, builder: (column) => column);

  GeneratedColumn<int> get minutesBefore => $composableBuilder(
    column: $table.minutesBefore,
    builder: (column) => column,
  );
}

class $$RemindersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RemindersTable,
          Reminder,
          $$RemindersTableFilterComposer,
          $$RemindersTableOrderingComposer,
          $$RemindersTableAnnotationComposer,
          $$RemindersTableCreateCompanionBuilder,
          $$RemindersTableUpdateCompanionBuilder,
          (Reminder, BaseReferences<_$AppDatabase, $RemindersTable, Reminder>),
          Reminder,
          PrefetchHooks Function()
        > {
  $$RemindersTableTableManager(_$AppDatabase db, $RemindersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RemindersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RemindersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RemindersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> spaceId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<String> createdBy = const Value.absent(),
                Value<String> updatedBy = const Value.absent(),
                Value<String> hlc = const Value.absent(),
                Value<bool> deleted = const Value.absent(),
                Value<String> nodeId = const Value.absent(),
                Value<int> minutesBefore = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RemindersCompanion(
                id: id,
                spaceId: spaceId,
                createdAt: createdAt,
                createdBy: createdBy,
                updatedBy: updatedBy,
                hlc: hlc,
                deleted: deleted,
                nodeId: nodeId,
                minutesBefore: minutesBefore,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String spaceId,
                required DateTime createdAt,
                required String createdBy,
                required String updatedBy,
                required String hlc,
                Value<bool> deleted = const Value.absent(),
                required String nodeId,
                required int minutesBefore,
                Value<int> rowid = const Value.absent(),
              }) => RemindersCompanion.insert(
                id: id,
                spaceId: spaceId,
                createdAt: createdAt,
                createdBy: createdBy,
                updatedBy: updatedBy,
                hlc: hlc,
                deleted: deleted,
                nodeId: nodeId,
                minutesBefore: minutesBefore,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$RemindersTable, Reminder>(table),
                  BaseReferences<_$AppDatabase, $RemindersTable, Reminder>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RemindersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RemindersTable,
      Reminder,
      $$RemindersTableFilterComposer,
      $$RemindersTableOrderingComposer,
      $$RemindersTableAnnotationComposer,
      $$RemindersTableCreateCompanionBuilder,
      $$RemindersTableUpdateCompanionBuilder,
      (Reminder, BaseReferences<_$AppDatabase, $RemindersTable, Reminder>),
      Reminder,
      PrefetchHooks Function()
    >;
typedef $$NodeUserPrefsTableCreateCompanionBuilder =
    NodeUserPrefsCompanion Function({
      required String id,
      required String spaceId,
      required DateTime createdAt,
      required String createdBy,
      required String updatedBy,
      required String hlc,
      Value<bool> deleted,
      required String nodeId,
      Value<bool> icsExport,
      Value<int> rowid,
    });
typedef $$NodeUserPrefsTableUpdateCompanionBuilder =
    NodeUserPrefsCompanion Function({
      Value<String> id,
      Value<String> spaceId,
      Value<DateTime> createdAt,
      Value<String> createdBy,
      Value<String> updatedBy,
      Value<String> hlc,
      Value<bool> deleted,
      Value<String> nodeId,
      Value<bool> icsExport,
      Value<int> rowid,
    });

class $$NodeUserPrefsTableFilterComposer
    extends Composer<_$AppDatabase, $NodeUserPrefsTable> {
  $$NodeUserPrefsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get spaceId => $composableBuilder(
    column: $table.spaceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdBy => $composableBuilder(
    column: $table.createdBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get updatedBy => $composableBuilder(
    column: $table.updatedBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get hlc => $composableBuilder(
    column: $table.hlc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nodeId => $composableBuilder(
    column: $table.nodeId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get icsExport => $composableBuilder(
    column: $table.icsExport,
    builder: (column) => ColumnFilters(column),
  );
}

class $$NodeUserPrefsTableOrderingComposer
    extends Composer<_$AppDatabase, $NodeUserPrefsTable> {
  $$NodeUserPrefsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get spaceId => $composableBuilder(
    column: $table.spaceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdBy => $composableBuilder(
    column: $table.createdBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get updatedBy => $composableBuilder(
    column: $table.updatedBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get hlc => $composableBuilder(
    column: $table.hlc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nodeId => $composableBuilder(
    column: $table.nodeId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get icsExport => $composableBuilder(
    column: $table.icsExport,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$NodeUserPrefsTableAnnotationComposer
    extends Composer<_$AppDatabase, $NodeUserPrefsTable> {
  $$NodeUserPrefsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get spaceId =>
      $composableBuilder(column: $table.spaceId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get createdBy =>
      $composableBuilder(column: $table.createdBy, builder: (column) => column);

  GeneratedColumn<String> get updatedBy =>
      $composableBuilder(column: $table.updatedBy, builder: (column) => column);

  GeneratedColumn<String> get hlc =>
      $composableBuilder(column: $table.hlc, builder: (column) => column);

  GeneratedColumn<bool> get deleted =>
      $composableBuilder(column: $table.deleted, builder: (column) => column);

  GeneratedColumn<String> get nodeId =>
      $composableBuilder(column: $table.nodeId, builder: (column) => column);

  GeneratedColumn<bool> get icsExport =>
      $composableBuilder(column: $table.icsExport, builder: (column) => column);
}

class $$NodeUserPrefsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $NodeUserPrefsTable,
          NodeUserPref,
          $$NodeUserPrefsTableFilterComposer,
          $$NodeUserPrefsTableOrderingComposer,
          $$NodeUserPrefsTableAnnotationComposer,
          $$NodeUserPrefsTableCreateCompanionBuilder,
          $$NodeUserPrefsTableUpdateCompanionBuilder,
          (
            NodeUserPref,
            BaseReferences<_$AppDatabase, $NodeUserPrefsTable, NodeUserPref>,
          ),
          NodeUserPref,
          PrefetchHooks Function()
        > {
  $$NodeUserPrefsTableTableManager(_$AppDatabase db, $NodeUserPrefsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NodeUserPrefsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$NodeUserPrefsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$NodeUserPrefsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> spaceId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<String> createdBy = const Value.absent(),
                Value<String> updatedBy = const Value.absent(),
                Value<String> hlc = const Value.absent(),
                Value<bool> deleted = const Value.absent(),
                Value<String> nodeId = const Value.absent(),
                Value<bool> icsExport = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => NodeUserPrefsCompanion(
                id: id,
                spaceId: spaceId,
                createdAt: createdAt,
                createdBy: createdBy,
                updatedBy: updatedBy,
                hlc: hlc,
                deleted: deleted,
                nodeId: nodeId,
                icsExport: icsExport,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String spaceId,
                required DateTime createdAt,
                required String createdBy,
                required String updatedBy,
                required String hlc,
                Value<bool> deleted = const Value.absent(),
                required String nodeId,
                Value<bool> icsExport = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => NodeUserPrefsCompanion.insert(
                id: id,
                spaceId: spaceId,
                createdAt: createdAt,
                createdBy: createdBy,
                updatedBy: updatedBy,
                hlc: hlc,
                deleted: deleted,
                nodeId: nodeId,
                icsExport: icsExport,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$NodeUserPrefsTable, NodeUserPref>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $NodeUserPrefsTable,
                    NodeUserPref
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$NodeUserPrefsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $NodeUserPrefsTable,
      NodeUserPref,
      $$NodeUserPrefsTableFilterComposer,
      $$NodeUserPrefsTableOrderingComposer,
      $$NodeUserPrefsTableAnnotationComposer,
      $$NodeUserPrefsTableCreateCompanionBuilder,
      $$NodeUserPrefsTableUpdateCompanionBuilder,
      (
        NodeUserPref,
        BaseReferences<_$AppDatabase, $NodeUserPrefsTable, NodeUserPref>,
      ),
      NodeUserPref,
      PrefetchHooks Function()
    >;
typedef $$ChangeLogTableCreateCompanionBuilder = ChangeLogCompanion Function({
  required String opId,
  required String spaceId,
  required String rowTable,
  required String rowId,
  required String columnName,
  required String value,
  required String hlc,
  required String originDeviceId,
  required String authorUserId,
  required int schemaVersion,
  Value<int> rowid,
});
typedef $$ChangeLogTableUpdateCompanionBuilder = ChangeLogCompanion Function({
  Value<String> opId,
  Value<String> spaceId,
  Value<String> rowTable,
  Value<String> rowId,
  Value<String> columnName,
  Value<String> value,
  Value<String> hlc,
  Value<String> originDeviceId,
  Value<String> authorUserId,
  Value<int> schemaVersion,
  Value<int> rowid,
});

class $$ChangeLogTableFilterComposer
    extends Composer<_$AppDatabase, $ChangeLogTable> {
  $$ChangeLogTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get opId => $composableBuilder(
    column: $table.opId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get spaceId => $composableBuilder(
    column: $table.spaceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rowTable => $composableBuilder(
    column: $table.rowTable,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rowId => $composableBuilder(
    column: $table.rowId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get columnName => $composableBuilder(
    column: $table.columnName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get hlc => $composableBuilder(
    column: $table.hlc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get originDeviceId => $composableBuilder(
    column: $table.originDeviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get authorUserId => $composableBuilder(
    column: $table.authorUserId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get schemaVersion => $composableBuilder(
    column: $table.schemaVersion,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ChangeLogTableOrderingComposer
    extends Composer<_$AppDatabase, $ChangeLogTable> {
  $$ChangeLogTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get opId => $composableBuilder(
    column: $table.opId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get spaceId => $composableBuilder(
    column: $table.spaceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rowTable => $composableBuilder(
    column: $table.rowTable,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rowId => $composableBuilder(
    column: $table.rowId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get columnName => $composableBuilder(
    column: $table.columnName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get hlc => $composableBuilder(
    column: $table.hlc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get originDeviceId => $composableBuilder(
    column: $table.originDeviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get authorUserId => $composableBuilder(
    column: $table.authorUserId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get schemaVersion => $composableBuilder(
    column: $table.schemaVersion,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ChangeLogTableAnnotationComposer
    extends Composer<_$AppDatabase, $ChangeLogTable> {
  $$ChangeLogTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get opId =>
      $composableBuilder(column: $table.opId, builder: (column) => column);

  GeneratedColumn<String> get spaceId =>
      $composableBuilder(column: $table.spaceId, builder: (column) => column);

  GeneratedColumn<String> get rowTable =>
      $composableBuilder(column: $table.rowTable, builder: (column) => column);

  GeneratedColumn<String> get rowId =>
      $composableBuilder(column: $table.rowId, builder: (column) => column);

  GeneratedColumn<String> get columnName => $composableBuilder(
    column: $table.columnName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  GeneratedColumn<String> get hlc =>
      $composableBuilder(column: $table.hlc, builder: (column) => column);

  GeneratedColumn<String> get originDeviceId => $composableBuilder(
    column: $table.originDeviceId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get authorUserId => $composableBuilder(
    column: $table.authorUserId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get schemaVersion => $composableBuilder(
    column: $table.schemaVersion,
    builder: (column) => column,
  );
}

class $$ChangeLogTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ChangeLogTable,
          ChangeOp,
          $$ChangeLogTableFilterComposer,
          $$ChangeLogTableOrderingComposer,
          $$ChangeLogTableAnnotationComposer,
          $$ChangeLogTableCreateCompanionBuilder,
          $$ChangeLogTableUpdateCompanionBuilder,
          (ChangeOp, BaseReferences<_$AppDatabase, $ChangeLogTable, ChangeOp>),
          ChangeOp,
          PrefetchHooks Function()
        > {
  $$ChangeLogTableTableManager(_$AppDatabase db, $ChangeLogTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChangeLogTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ChangeLogTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ChangeLogTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> opId = const Value.absent(),
                Value<String> spaceId = const Value.absent(),
                Value<String> rowTable = const Value.absent(),
                Value<String> rowId = const Value.absent(),
                Value<String> columnName = const Value.absent(),
                Value<String> value = const Value.absent(),
                Value<String> hlc = const Value.absent(),
                Value<String> originDeviceId = const Value.absent(),
                Value<String> authorUserId = const Value.absent(),
                Value<int> schemaVersion = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ChangeLogCompanion(
                opId: opId,
                spaceId: spaceId,
                rowTable: rowTable,
                rowId: rowId,
                columnName: columnName,
                value: value,
                hlc: hlc,
                originDeviceId: originDeviceId,
                authorUserId: authorUserId,
                schemaVersion: schemaVersion,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String opId,
                required String spaceId,
                required String rowTable,
                required String rowId,
                required String columnName,
                required String value,
                required String hlc,
                required String originDeviceId,
                required String authorUserId,
                required int schemaVersion,
                Value<int> rowid = const Value.absent(),
              }) => ChangeLogCompanion.insert(
                opId: opId,
                spaceId: spaceId,
                rowTable: rowTable,
                rowId: rowId,
                columnName: columnName,
                value: value,
                hlc: hlc,
                originDeviceId: originDeviceId,
                authorUserId: authorUserId,
                schemaVersion: schemaVersion,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ChangeLogTable, ChangeOp>(table),
                  BaseReferences<_$AppDatabase, $ChangeLogTable, ChangeOp>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ChangeLogTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ChangeLogTable,
      ChangeOp,
      $$ChangeLogTableFilterComposer,
      $$ChangeLogTableOrderingComposer,
      $$ChangeLogTableAnnotationComposer,
      $$ChangeLogTableCreateCompanionBuilder,
      $$ChangeLogTableUpdateCompanionBuilder,
      (ChangeOp, BaseReferences<_$AppDatabase, $ChangeLogTable, ChangeOp>),
      ChangeOp,
      PrefetchHooks Function()
    >;
typedef $$DevicesTableCreateCompanionBuilder = DevicesCompanion Function({
  required String deviceId,
  required String userId,
  required String devicePublicKey,
  required String signedByUserKey,
  Value<String?> label,
  Value<bool> isThisDevice,
  Value<int> rowid,
});
typedef $$DevicesTableUpdateCompanionBuilder = DevicesCompanion Function({
  Value<String> deviceId,
  Value<String> userId,
  Value<String> devicePublicKey,
  Value<String> signedByUserKey,
  Value<String?> label,
  Value<bool> isThisDevice,
  Value<int> rowid,
});

class $$DevicesTableFilterComposer
    extends Composer<_$AppDatabase, $DevicesTable> {
  $$DevicesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get devicePublicKey => $composableBuilder(
    column: $table.devicePublicKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get signedByUserKey => $composableBuilder(
    column: $table.signedByUserKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isThisDevice => $composableBuilder(
    column: $table.isThisDevice,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DevicesTableOrderingComposer
    extends Composer<_$AppDatabase, $DevicesTable> {
  $$DevicesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get devicePublicKey => $composableBuilder(
    column: $table.devicePublicKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get signedByUserKey => $composableBuilder(
    column: $table.signedByUserKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isThisDevice => $composableBuilder(
    column: $table.isThisDevice,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DevicesTableAnnotationComposer
    extends Composer<_$AppDatabase, $DevicesTable> {
  $$DevicesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get devicePublicKey => $composableBuilder(
    column: $table.devicePublicKey,
    builder: (column) => column,
  );

  GeneratedColumn<String> get signedByUserKey => $composableBuilder(
    column: $table.signedByUserKey,
    builder: (column) => column,
  );

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumn<bool> get isThisDevice => $composableBuilder(
    column: $table.isThisDevice,
    builder: (column) => column,
  );
}

class $$DevicesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DevicesTable,
          Device,
          $$DevicesTableFilterComposer,
          $$DevicesTableOrderingComposer,
          $$DevicesTableAnnotationComposer,
          $$DevicesTableCreateCompanionBuilder,
          $$DevicesTableUpdateCompanionBuilder,
          (Device, BaseReferences<_$AppDatabase, $DevicesTable, Device>),
          Device,
          PrefetchHooks Function()
        > {
  $$DevicesTableTableManager(_$AppDatabase db, $DevicesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DevicesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DevicesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DevicesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> deviceId = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String> devicePublicKey = const Value.absent(),
                Value<String> signedByUserKey = const Value.absent(),
                Value<String?> label = const Value.absent(),
                Value<bool> isThisDevice = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DevicesCompanion(
                deviceId: deviceId,
                userId: userId,
                devicePublicKey: devicePublicKey,
                signedByUserKey: signedByUserKey,
                label: label,
                isThisDevice: isThisDevice,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String deviceId,
                required String userId,
                required String devicePublicKey,
                required String signedByUserKey,
                Value<String?> label = const Value.absent(),
                Value<bool> isThisDevice = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DevicesCompanion.insert(
                deviceId: deviceId,
                userId: userId,
                devicePublicKey: devicePublicKey,
                signedByUserKey: signedByUserKey,
                label: label,
                isThisDevice: isThisDevice,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$DevicesTable, Device>(table),
                  BaseReferences<_$AppDatabase, $DevicesTable, Device>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DevicesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DevicesTable,
      Device,
      $$DevicesTableFilterComposer,
      $$DevicesTableOrderingComposer,
      $$DevicesTableAnnotationComposer,
      $$DevicesTableCreateCompanionBuilder,
      $$DevicesTableUpdateCompanionBuilder,
      (Device, BaseReferences<_$AppDatabase, $DevicesTable, Device>),
      Device,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$NodesTableTableManager get nodes =>
      $$NodesTableTableManager(_db, _db.nodes);
  $NodeSearchTableManager get nodeSearch =>
      $NodeSearchTableManager(_db, _db.nodeSearch);
  $AttachmentSearchTableManager get attachmentSearch =>
      $AttachmentSearchTableManager(_db, _db.attachmentSearch);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db, _db.users);
  $$SpacesTableTableManager get spaces =>
      $$SpacesTableTableManager(_db, _db.spaces);
  $$SpaceMembersTableTableManager get spaceMembers =>
      $$SpaceMembersTableTableManager(_db, _db.spaceMembers);
  $$OccurrenceCompletionsTableTableManager get occurrenceCompletions =>
      $$OccurrenceCompletionsTableTableManager(_db, _db.occurrenceCompletions);
  $$PlacementsTableTableManager get placements =>
      $$PlacementsTableTableManager(_db, _db.placements);
  $$LinksTableTableManager get links =>
      $$LinksTableTableManager(_db, _db.links);
  $$CoreValuesTableTableManager get coreValues =>
      $$CoreValuesTableTableManager(_db, _db.coreValues);
  $$NodeValuesTableTableManager get nodeValues =>
      $$NodeValuesTableTableManager(_db, _db.nodeValues);
  $$TagsTableTableManager get tags => $$TagsTableTableManager(_db, _db.tags);
  $$NodeTagsTableTableManager get nodeTags =>
      $$NodeTagsTableTableManager(_db, _db.nodeTags);
  $$AttachmentsTableTableManager get attachments =>
      $$AttachmentsTableTableManager(_db, _db.attachments);
  $$AnnotationsTableTableManager get annotations =>
      $$AnnotationsTableTableManager(_db, _db.annotations);
  $$RemindersTableTableManager get reminders =>
      $$RemindersTableTableManager(_db, _db.reminders);
  $$NodeUserPrefsTableTableManager get nodeUserPrefs =>
      $$NodeUserPrefsTableTableManager(_db, _db.nodeUserPrefs);
  $$ChangeLogTableTableManager get changeLog =>
      $$ChangeLogTableTableManager(_db, _db.changeLog);
  $$DevicesTableTableManager get devices =>
      $$DevicesTableTableManager(_db, _db.devices);
}
