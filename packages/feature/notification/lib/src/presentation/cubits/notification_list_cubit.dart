import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:core/core.dart';
import 'package:notification/notification.dart';
import 'package:notification/src/data/database_entities/notification_db_entity.dart';
import 'package:notification/src/domain/usecases/add_notification_usecase.dart';
import 'notification_list_state.dart';

typedef NotificationListCubitFactory = NotificationListCubit Function();

class NotificationListCubit extends Cubit<NotificationListState> {
  final NotificationManager notificationManager;
  final NotificationFromServerUseCase notificationFromServerUseCase;
  final AddNotificationUseCase addNotificationUseCase;

  late StreamSubscription<List<NotificationDbEntity>> _querySubscription;

  NotificationListCubit(
      {required this.notificationManager,
      required this.notificationFromServerUseCase,
      required this.addNotificationUseCase})
      : super(const NotificationListState()) {
    // Emit initial data
    _emitCurrentNotifications();
    // Listen for changes
    _querySubscription = notificationManager.getNotificationStream().listen(_onNotificationsChanged);
    onLoadNotificationServerData();
  }

  void _emitCurrentNotifications() {
    final notifications = notificationManager.getNotifications();
    emit(state.copyWith(readNotifications: notifications, dateFormat: 'M/dd/yyyy'));
  }

  void onLoadNotificationServerData() async {
    emit(state.copyWith(status: NetworkStatus.loading));
    final currentNotifications = notificationManager.getNotifications();
    if (currentNotifications.isEmpty) {
      final notificationResponse = await notificationFromServerUseCase();
      notificationResponse.fold((l) {
        emit(state.copyWith(status: NetworkStatus.failure));
      }, (r) {
        final notifications = r?.data?.notifications ?? [];
        for (var notification in notifications) {
          if (notification.title != null) {
            addNotificationUseCase(
                id: notification.id ?? 0,
                title: notification.title!,
                description: notification.body ?? '',
                payload: '',
                date: notification.date,
                isRead: notification.isRead ?? false);
          }
        }
        emit(state.copyWith(notificationResponse: r, status: NetworkStatus.success));
      });
    } else {
      emit(state.copyWith(status: NetworkStatus.success));
    }
  }

  void _onNotificationsChanged(List<NotificationDbEntity> notifications) {
    if (!isClosed) {
      emit(state.copyWith(readNotifications: notifications, dateFormat: 'M/dd/yyyy'));
    }
  }

  void delete(String notificationKey) {
    notificationManager.deleteNotification(notificationId: notificationKey);
  }

  @override
  Future<void> close() {
    _querySubscription.cancel();
    return super.close();
  }
}
