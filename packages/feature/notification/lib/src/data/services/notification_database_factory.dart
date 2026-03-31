import 'package:hive_flutter/hive_flutter.dart';
import 'package:notification/src/data/database_entities/notification_db_entity.dart';

class NotificationDatabaseFactory {
  static const _boxName = 'hrm_notifications';
  static bool _hiveInitialized = false;

  Future<Box<NotificationDbEntity>> generateDatabase() async {
    if (!_hiveInitialized) {
      await Hive.initFlutter();
      _hiveInitialized = true;
    }
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(NotificationDbEntityAdapter());
    }
    if (Hive.isBoxOpen(_boxName)) {
      return Hive.box<NotificationDbEntity>(_boxName);
    }
    return await Hive.openBox<NotificationDbEntity>(_boxName);
  }
}
