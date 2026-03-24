import 'package:core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta_club_api/meta_club_api.dart';
import 'package:onesthrm/page/appointment/appoinment_list/view/appointment_screen.dart';
import 'package:onesthrm/res/nav_utail.dart';

part 'notification_event.dart';
part 'notification_state.dart';

/// Global unread notification count — listened by bottom nav badge
final ValueNotifier<int> unreadNotificationCount = ValueNotifier<int>(0);

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final MetaClubApiClient _metaClubApiClient;

  NotificationBloc({required MetaClubApiClient metaClubApiClient})
      : _metaClubApiClient = metaClubApiClient,
        super(const NotificationState(
          status: NetworkStatus.initial,
        )) {
    on<LoadNotificationData>(_onNotificationDataLoad);
    on<RouteSlug>(_onRoutSlag);
    on<ClearNoticeButton>(_onClearData);
    on<MarkNotificationAsRead>(_onMarkAsRead);
  }

  void _onNotificationDataLoad(
      LoadNotificationData event, Emitter<NotificationState> emit) async {
    emit(state.copy(status: NetworkStatus.loading));
    final notificationResponse = await _metaClubApiClient.getNotification();
    notificationResponse.fold((l) {
      emit(const NotificationState(status: NetworkStatus.failure));
    }, (r) {
      // Update global unread count for badge
      final unread = r?.data?.notifications?.where((n) => n.isRead == false).length ?? 0;
      unreadNotificationCount.value = unread;
      emit(state.copy(
          notificationResponse: r,
          status: NetworkStatus.success));
    });
  }

  void _onRoutSlag(RouteSlug event, Emitter<NotificationState> emit) async {
    switch (event.slugName) {
      case 'daily_leave':
        break;
      // return NavUtil.navigateScreen(context, const DailyLeave());
      case 'leave_request':
        break;
      // return NavUtil.navigateScreen(context, const LeaveSummary());
      case 'appointment_request':
        NavUtil.navigateScreen(event.context, const AppointmentScreen());
        break;
      default:
        return debugPrint('default');
    }
  }

  void _onClearData(
      ClearNoticeButton event, Emitter<NotificationState> emit) async {
    await _metaClubApiClient.clearAllNotificationApi();
  }

  void _onMarkAsRead(
      MarkNotificationAsRead event, Emitter<NotificationState> emit) async {
    await _metaClubApiClient.markNotificationAsRead(event.notificationId);
    // Refresh the list to reflect read status
    add(LoadNotificationData());
  }
}
