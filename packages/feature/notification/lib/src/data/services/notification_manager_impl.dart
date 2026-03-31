import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:notification/notification.dart';
import 'package:notification/src/data/database_entities/notification_db_entity.dart';
import 'notification_repository_database.dart';

class NotificationManagerImpl extends NotificationManager {
  final NotificationRepositoryDatabase notificationRepositoryDatabase;
  final FirebaseMessaging? firebaseMessaging;

  NotificationManagerImpl({required this.notificationRepositoryDatabase, this.firebaseMessaging});

  bool _initialized = false;

  @override
  void cleanUp() {
    if (!_initialized) {
      return;
    }
    notificationRepositoryDatabase.removeAllData();
    notificationRepositoryDatabase.close();
  }

  @override
  void createNotification(
      {required int id,
      required String title,
      required String description,
      required String payload,
      bool seen = false,
      String? date}) {
    notificationRepositoryDatabase.createNotification(
        id: id, title: title, description: description, date: date, seen: seen);
  }

  @override
  void deleteNotification({required String notificationId}) {
    notificationRepositoryDatabase.deleteNotification(notificationKey: notificationId);
  }

  @override
  Future<String?> getApnsToken() async {
    if (Platform.isIOS) {
      return await firebaseMessaging?.getAPNSToken();
    }
    return null;
  }

  @override
  Future<String?> getFcmToken() {
    return firebaseMessaging?.getToken() ?? Future.value(null);
  }

  @override
  List<NotificationDbEntity> getNotifications() {
    return notificationRepositoryDatabase.notifications;
  }

  @override
  Stream<List<NotificationDbEntity>> getNotificationStream() {
    return notificationRepositoryDatabase.changes;
  }

  @override
  Future<void> initializeNotification() async {
    await notificationRepositoryDatabase.initialize();
    notificationRepositoryDatabase.purgeOldNotification(12);
    _initialized = true;
  }

  @override
  void updateNotification({required String notificationId, required bool seen}) {
    notificationRepositoryDatabase.updateNotification(notificationKey: notificationId, seen: seen);
  }
}
