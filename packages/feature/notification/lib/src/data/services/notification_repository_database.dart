import 'dart:async';
import 'package:core/core.dart';
import 'package:hive/hive.dart';
import 'package:notification/src/data/database_entities/notification_db_entity.dart';
import 'package:notification/src/data/services/notification_database_factory.dart';

class NotificationRepositoryDatabase {
  final NotificationDatabaseFactory databaseFactory;

  NotificationRepositoryDatabase({required this.databaseFactory});

  Box<NotificationDbEntity>? _box;

  /// Stream controller to broadcast changes (replaces Realm's reactive query)
  final _changeController = StreamController<List<NotificationDbEntity>>.broadcast();
  Stream<List<NotificationDbEntity>> get changes => _changeController.stream;

  List<NotificationDbEntity> get notifications => _box?.values.toList() ?? [];

  Future<void> initialize() async {
    _box = await databaseFactory.generateDatabase();
  }

  void _notifyChanges() {
    if (_box != null && !_changeController.isClosed) {
      _changeController.add(_box!.values.toList());
    }
  }

  void purgeOldNotification(int monthCount) {
    if (_box == null) return;
    final cutOff = DateTime.now().subtract(Duration(days: monthCount * 30));
    final keysToDelete = <dynamic>[];
    for (final entry in _box!.toMap().entries) {
      if (entry.value.created.isBefore(cutOff)) {
        keysToDelete.add(entry.key);
      }
    }
    if (keysToDelete.isNotEmpty) {
      _box!.deleteAll(keysToDelete);
      _notifyChanges();
    }
  }

  void clean() {
    removeAllData();
  }

  void close() {
    _changeController.close();
    _box?.close();
    _box = null;
  }

  void createNotification(
      {required int id, required String title, required String description, bool seen = false, String? date}) {
    final key = generateNewUUID();
    final notification = NotificationDbEntity(key, title, id, description, date ?? '', currentDate(), seen);
    _box?.put(key, notification);
    _notifyChanges();
  }

  void updateNotification({required String notificationKey, required bool seen}) {
    final notification = _box?.get(notificationKey);
    if (notification != null) {
      notification.seen = seen;
      notification.save();
      _notifyChanges();
    }
  }

  void removeAllData() {
    _box?.clear();
    _notifyChanges();
  }

  void deleteNotification({required String notificationKey}) {
    _box?.delete(notificationKey);
    _notifyChanges();
  }
}
