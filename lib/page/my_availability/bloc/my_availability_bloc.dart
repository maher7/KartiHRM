import 'dart:async';
import 'package:core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:meta_club_api/meta_club_api.dart';

part 'my_availability_event.dart';
part 'my_availability_state.dart';

class MyAvailabilityBloc extends Bloc<MyAvailabilityEvent, MyAvailabilityState> {
  final MetaClubApiClient metaClubApiClient;

  MyAvailabilityBloc({required this.metaClubApiClient})
      : super(const MyAvailabilityState(status: NetworkStatus.initial)) {
    on<MyAvailabilityLoadEvent>(_onLoad);
    on<MyAvailabilityWeekChangeEvent>(_onWeekChange);
    on<MyAvailabilitySetDayEvent>(_onSetDay);
    on<MyAvailabilitySubmitEvent>(_onSubmit);
  }

  String _normalizeToSunday(String? input) {
    DateTime base;
    if (input != null) {
      try {
        base = DateTime.parse(input);
      } catch (_) {
        base = DateTime.now();
      }
    } else {
      base = DateTime.now();
    }
    final sun = DateTime(base.year, base.month, base.day - (base.weekday % 7));
    return DateFormat('yyyy-MM-dd', 'en').format(sun);
  }

  List<AvailabilityItem> _seedWeek() => List<AvailabilityItem>.generate(
        7,
        (i) => AvailabilityItem(day: i, state: AvailabilityState.can),
      );

  FutureOr<void> _onLoad(
      MyAvailabilityLoadEvent event, Emitter<MyAvailabilityState> emit) async {
    final weekStart = _normalizeToSunday(event.weekStart);
    emit(state.copyWith(
      status: NetworkStatus.loading,
      weekStart: weekStart,
      submitStatus: NetworkStatus.initial,
      clearError: true,
    ));

    final result = await metaClubApiClient.getAvailability(weekStart: weekStart);
    result.fold(
      (failure) => emit(state.copyWith(
        status: NetworkStatus.failure,
        weekStart: weekStart,
        errorMessage: 'Failed to load availability',
        items: _seedWeek(),
      )),
      (res) {
        // Merge server items onto a full 7-day seed so every day is editable.
        final seed = _seedWeek();
        if (res != null) {
          for (final item in res.items) {
            if (item.day >= 0 && item.day < 7) {
              seed[item.day] = item;
            }
          }
        }
        emit(state.copyWith(
          status: NetworkStatus.success,
          weekStart: weekStart,
          items: seed,
        ));
      },
    );
  }

  FutureOr<void> _onWeekChange(
      MyAvailabilityWeekChangeEvent event, Emitter<MyAvailabilityState> emit) async {
    add(MyAvailabilityLoadEvent(weekStart: event.weekStart));
  }

  FutureOr<void> _onSetDay(
      MyAvailabilitySetDayEvent event, Emitter<MyAvailabilityState> emit) async {
    final updated = [...state.items];
    final idx = updated.indexWhere((i) => i.day == event.day);
    final current = idx >= 0
        ? updated[idx]
        : AvailabilityItem(day: event.day, state: AvailabilityState.can);
    final next = current.copyWith(
      state: event.state ?? current.state,
      from: event.from ?? current.from,
      to: event.to ?? current.to,
      note: event.note ?? current.note,
    );
    if (idx >= 0) {
      updated[idx] = next;
    } else {
      updated.add(next);
    }
    emit(state.copyWith(items: updated, submitStatus: NetworkStatus.initial));
  }

  FutureOr<void> _onSubmit(
      MyAvailabilitySubmitEvent event, Emitter<MyAvailabilityState> emit) async {
    final weekStart = state.weekStart;
    if (weekStart == null || state.items.isEmpty) return;
    emit(state.copyWith(submitStatus: NetworkStatus.loading, clearError: true));

    final result = await metaClubApiClient.saveAvailability(
      weekStart: weekStart,
      userId: event.userId,
      items: state.items,
    );
    result.fold(
      (failure) => emit(state.copyWith(
        submitStatus: NetworkStatus.failure,
        errorMessage: 'Failed to submit availability',
      )),
      (_) => emit(state.copyWith(submitStatus: NetworkStatus.success)),
    );
  }
}
