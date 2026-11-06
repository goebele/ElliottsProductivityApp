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
  late final $DevicesTable devices = $DevicesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    users,
    spaces,
    spaceMembers,
    devices,
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
  $$DevicesTableTableManager get devices =>
      $$DevicesTableTableManager(_db, _db.devices);
}
