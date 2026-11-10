// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
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
  late final $UsersTable users = $UsersTable(this);
  late final $SpacesTable spaces = $SpacesTable(this);
  late final $SpaceMembersTable spaceMembers = $SpaceMembersTable(this);
  late final $NodesTable nodes = $NodesTable(this);
  late final $OccurrenceCompletionsTable occurrenceCompletions =
      $OccurrenceCompletionsTable(this);
  late final $PlacementsTable placements = $PlacementsTable(this);
  late final $LinksTable links = $LinksTable(this);
  late final $ChangeLogTable changeLog = $ChangeLogTable(this);
  late final $DevicesTable devices = $DevicesTable(this);
  late final Index nodesParentSort = Index(
    'nodes_parent_sort',
    'CREATE INDEX nodes_parent_sort ON nodes (parent_id, sort_key)',
  );
  late final Index occurrenceCompletionsNode = Index(
    'occurrence_completions_node',
    'CREATE INDEX occurrence_completions_node ON occurrence_completions (node_id, occurrence_date)',
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
    users,
    spaces,
    spaceMembers,
    nodes,
    occurrenceCompletions,
    placements,
    links,
    changeLog,
    devices,
    nodesParentSort,
    occurrenceCompletionsNode,
    placementsParent,
    placementsNode,
    linksUnique,
    linksTarget,
    changeLogHlc,
    changeLogField,
  ];
  @override
  DriftDatabaseOptions get options =>
      const DriftDatabaseOptions(storeDateTimeAsText: true);
}

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
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db, _db.users);
  $$SpacesTableTableManager get spaces =>
      $$SpacesTableTableManager(_db, _db.spaces);
  $$SpaceMembersTableTableManager get spaceMembers =>
      $$SpaceMembersTableTableManager(_db, _db.spaceMembers);
  $$NodesTableTableManager get nodes =>
      $$NodesTableTableManager(_db, _db.nodes);
  $$OccurrenceCompletionsTableTableManager get occurrenceCompletions =>
      $$OccurrenceCompletionsTableTableManager(_db, _db.occurrenceCompletions);
  $$PlacementsTableTableManager get placements =>
      $$PlacementsTableTableManager(_db, _db.placements);
  $$LinksTableTableManager get links =>
      $$LinksTableTableManager(_db, _db.links);
  $$ChangeLogTableTableManager get changeLog =>
      $$ChangeLogTableTableManager(_db, _db.changeLog);
  $$DevicesTableTableManager get devices =>
      $$DevicesTableTableManager(_db, _db.devices);
}
