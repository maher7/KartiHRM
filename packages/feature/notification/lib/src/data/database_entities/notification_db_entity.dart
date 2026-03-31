import 'package:hive/hive.dart';

part 'notification_db_entity.g.dart';

@HiveType(typeId: 0)
class NotificationDbEntity extends HiveObject {
  @HiveField(0)
  final String key;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final int id;

  @HiveField(3)
  final String description;

  @HiveField(4)
  final String date;

  @HiveField(5)
  final DateTime created;

  @HiveField(6)
  bool seen;

  NotificationDbEntity(
    this.key,
    this.title,
    this.id,
    this.description,
    this.date,
    this.created,
    this.seen,
  );
}
