import 'package:uuid/uuid.dart';

const _uuid = Uuid();

/// A new UUIDv7: generated on any device, sorts by creation time (§5).
String newId() => _uuid.v7();
