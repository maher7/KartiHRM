// GENERATED-LIKE CODE — hand-written Hive TypeAdapter for NotificationDbEntity

part of 'notification_db_entity.dart';

class NotificationDbEntityAdapter extends TypeAdapter<NotificationDbEntity> {
  @override
  final int typeId = 0;

  @override
  NotificationDbEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NotificationDbEntity(
      fields[0] as String,
      fields[1] as String,
      fields[2] as int,
      fields[3] as String,
      fields[4] as String,
      fields[5] as DateTime,
      fields[6] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, NotificationDbEntity obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.key)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.id)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.date)
      ..writeByte(5)
      ..write(obj.created)
      ..writeByte(6)
      ..write(obj.seen);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NotificationDbEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
