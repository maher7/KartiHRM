import 'dart:async';
import 'package:core/core.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:event_bus_plus/res/event_bus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:offline_attendance/domain/offline_attendance_repository.dart';
import 'package:onesthrm/main.dart';
import 'offline_attendance_state.dart';

class OfflineCubit extends Cubit<OfflineAttendanceState> {
  final OfflineAttendanceRepository offlineAttendanceRepo;
  late StreamSubscription<OnOnlineAttendanceUpdateEvent> onlineSubscription;
  late StreamSubscription<OnOfflineAttendanceUpdateEvent> offlineSubscription;
  final EventBus eventBus;

  OfflineCubit({required this.offlineAttendanceRepo, required this.eventBus}) : super(const OfflineAttendanceState()) {
    _initializeState();

    onlineSubscription = eventBus.on<OnOnlineAttendanceUpdateEvent>().listen((event) {
      updateAppWidget(isCheckedIn: event.body.inTime != null && event.body.outTime == null);
      onOnlineCheckInOutData(body: event.body);
    });

    offlineSubscription = eventBus.on<OnOfflineAttendanceUpdateEvent>().listen((event) {
      onOfflineCheckInOutData(body: event.body);
    });
  }

  /// Initialize state: server is the source of truth, local DB is fallback for offline
  Future<void> _initializeState() async {
    // Don't emit anything yet — wait for the server data via OnOnlineAttendanceUpdateEvent
    // which is fired by HomeBloc._onHomeDataLoad after the dashboard API responds.
    // The event listener (line 20) will call onOnlineCheckInOutData and emit the correct state.
    //
    // Only use local DB as an immediate fallback so the UI isn't blank while waiting:
    final today = DateFormat('yyyy-MM-dd', 'en').format(DateTime.now());
    AttendanceBody? localData = await offlineAttendanceRepo.getCheckDataByDate(date: today);
    if (isClosed) return;

    if (localData != null) {
      bool isCheckedIn = localData.inTime != null && localData.outTime == null;
      bool isCheckedOut = localData.inTime != null && localData.outTime != null;
      if (isCheckedOut) isCheckedIn = false;

      emit(state.copyWith(
        isCheckedIn: isCheckedIn,
        isCheckedOut: isCheckedOut,
        attendanceBody: localData,
      ));
    }
    // If localData is null, do NOT emit isCheckedIn=false yet.
    // Wait for server response which will arrive via the event bus.
    // If server also has no data, onOnlineCheckInOutData will emit false.
  }

  onOnlineCheckInOutData({AttendanceBody? body}) async {
    final date = DateFormat('yyyy-MM-dd', 'en').format(DateTime.now());

    if (body != null && (body.inTime != null || body.attendanceId != null)) {
      // API says user has attendance data for today
      bool isCheckedIn = body.inTime != null;
      bool isCheckedOut = body.outTime != null;

      if (isCheckedOut) {
        isCheckedIn = false;
        body = body.copyWith(attendanceId: null);
      }

      // Persist to local DB
      try {
        await offlineAttendanceRepo.checkInOut(
          checkData: body,
          isCheckedIn: isCheckedIn,
          isCheckedOut: isCheckedOut,
          multipleAttendanceEnabled: true,
        );
      } catch (e) {
        debugPrint('OfflineCubit: checkInOut failed: $e');
      }
      if (isClosed) return;

      // Read back from local DB to confirm
      AttendanceBody? localAttendanceData = await offlineAttendanceRepo.getCheckDataByDate(date: date);
      if (isClosed) return;

      if (isCheckedOut && body.isOffline == true) {
        eventBus.fire(const OfflineDataSycEvent());
      }

      // Even if local read fails, emit the API state as truth
      emit(state.copyWith(
        isCheckedIn: isCheckedIn,
        isCheckedOut: isCheckedOut,
        attendanceBody: localAttendanceData ?? body,
      ));
    } else {
      // API says no attendance for today — check local DB before resetting
      AttendanceBody? localAttendanceData = await offlineAttendanceRepo.getCheckDataByDate(date: date);
      if (isClosed) return;

      if (localAttendanceData != null && localAttendanceData.inTime != null) {
        // Local DB has check-in data for today — keep it (offline check-in)
        bool isCheckedIn = localAttendanceData.outTime == null;
        bool isCheckedOut = localAttendanceData.outTime != null;
        if (isCheckedOut) isCheckedIn = false;
        emit(state.copyWith(isCheckedIn: isCheckedIn, isCheckedOut: isCheckedOut, attendanceBody: localAttendanceData));
      } else {
        // No data anywhere — reset
        emit(state.copyWith(isCheckedIn: false, isCheckedOut: false, attendanceBody: null));
      }
    }
  }

  onOfflineCheckInOutData({AttendanceBody? body}) async {
    final date = DateFormat('yyyy-MM-dd', 'en').format(DateTime.now());
    bool isCheckedIn = await offlineAttendanceRepo.isAlreadyInCheckedIn(date: date);
    bool isCheckedOut = await offlineAttendanceRepo.isAlreadyInCheckedOut(date: date);
    AttendanceBody? localAttendanceData = await offlineAttendanceRepo.getCheckDataByDate(date: date);

    if (body != null) {
      ///for offline attendance we need date, outTime, inTime
      if (isCheckedIn && isCheckedOut == false) {
        body = body.copyWith(inTime: localAttendanceData?.inTime);
        body = body.copyWith(outTime: DateFormat('h:mm a', 'en').format(DateTime.now()));
      } else {
        body = body.copyWith(inTime: DateFormat('h:mm a', 'en').format(DateTime.now()));
        body = body.copyWith(outTime: null);
      }

      offlineAttendanceRepo
          .offlineCheckInOut(checkData: body, isCheckedIn: isCheckedIn, isCheckedOut: isCheckedOut, multipleAttendanceEnabled: true)
          .then((_) async {
        if (isClosed) return;
        isCheckedIn = await offlineAttendanceRepo.isAlreadyInCheckedIn(date: date);
        isCheckedOut = await offlineAttendanceRepo.isAlreadyInCheckedOut(date: date);
        localAttendanceData = await offlineAttendanceRepo.getCheckDataByDate(date: date);
        if (isClosed) return;
        if (localAttendanceData?.inTime != null) {
          isCheckedIn = true;
        }
        if (localAttendanceData?.outTime != null) {
          isCheckedOut = true;
          isCheckedIn = false;
        }
        if (localAttendanceData?.inTime != null && localAttendanceData?.outTime != null) {
          isCheckedIn = false;
          isCheckedOut = false;
        }
        emit(state.copyWith(isCheckedIn: isCheckedIn, isCheckedOut: isCheckedOut, attendanceBody: localAttendanceData));
      });
    } else {
      emit(state.copyWith(isCheckedIn: isCheckedIn, isCheckedOut: isCheckedOut, attendanceBody: localAttendanceData));
    }
  }

  @override
  Future<void> close() {
    onlineSubscription.cancel();
    offlineSubscription.cancel();
    return super.close();
  }
}
