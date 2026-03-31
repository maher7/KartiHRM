import 'dart:async';
import 'package:core/core.dart';
import 'package:equatable/equatable.dart';
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
    emit(state.copyWith(status: NetworkStatus.loading));

    // Default to current week (Sunday start), normalize any date to its Sunday
    String weekStart;
    if (event.weekStart != null) {
      try {
        final d = DateTime.parse(event.weekStart!);
        final sun = d.subtract(Duration(days: d.weekday % 7));
        weekStart = DateFormat('yyyy-MM-dd', 'en').format(sun);
      } catch (_) {
        weekStart = event.weekStart!;
      }
    } else {
      final now = DateTime.now();
      final sunday = now.subtract(Duration(days: now.weekday % 7));
      weekStart = DateFormat('yyyy-MM-dd', 'en').format(sunday);
    }

    final result = await metaClubApiClient.getMySchedule(weekStart: weekStart);

    result.fold(
      (failure) => emit(state.copyWith(
        status: NetworkStatus.failure,
        weekStart: weekStart,
        errorMessage: 'Failed to load schedule',
      )),
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
