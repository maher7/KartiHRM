import 'dart:async';
import 'package:core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:meta_club_api/meta_club_api.dart';

part 'my_schedule_event.dart';
part 'my_schedule_state.dart';

class MyScheduleBloc extends Bloc<MyScheduleEvent, MyScheduleState> {
  final MetaClubApiClient metaClubApiClient;

  MyScheduleBloc({required this.metaClubApiClient})
      : super(const MyScheduleState(status: NetworkStatus.initial)) {
    on<MyScheduleLoadEvent>(_onLoad);
    on<MyScheduleWeekChangeEvent>(_onWeekChange);
  }

  FutureOr<void> _onLoad(
      MyScheduleLoadEvent event, Emitter<MyScheduleState> emit) async {
    // Default to current week (Sunday start), normalize any date to its Sunday
    String weekStart;
    if (event.weekStart != null) {
      try {
        final d = DateTime.parse(event.weekStart!);
        // DST-safe: use calendar arithmetic rather than Duration(days: N)
        final sun = DateTime(d.year, d.month, d.day - (d.weekday % 7));
        weekStart = DateFormat('yyyy-MM-dd', 'en').format(sun);
      } catch (_) {
        weekStart = event.weekStart!;
      }
    } else {
      final now = DateTime.now();
      final sunday = DateTime(now.year, now.month, now.day - (now.weekday % 7));
      weekStart = DateFormat('yyyy-MM-dd', 'en').format(sunday);
    }

    // When switching to a different week, clear old schedule so stale data
    // (day-dots/stats) doesn't flash while new data loads.
    final isDifferentWeek = state.weekStart != null && state.weekStart != weekStart;
    emit(MyScheduleState(
      status: NetworkStatus.loading,
      weekStart: weekStart,
      schedule: isDifferentWeek ? null : state.schedule,
    ));

    final result = await metaClubApiClient.getMySchedule(weekStart: weekStart);

    result.fold(
      (failure) {
        debugPrint('MySchedule error: $failure');
        emit(state.copyWith(
          status: NetworkStatus.failure,
          weekStart: weekStart,
          errorMessage: 'Failed to load schedule',
        ));
      },
      (schedule) => emit(state.copyWith(
        status: NetworkStatus.success,
        schedule: schedule,
        weekStart: weekStart,
      )),
    );
  }

  FutureOr<void> _onWeekChange(
      MyScheduleWeekChangeEvent event, Emitter<MyScheduleState> emit) async {
    add(MyScheduleLoadEvent(weekStart: event.weekStart));
  }
}
