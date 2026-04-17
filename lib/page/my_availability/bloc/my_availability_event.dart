part of 'my_availability_bloc.dart';

abstract class MyAvailabilityEvent extends Equatable {
  const MyAvailabilityEvent();

  @override
  List<Object?> get props => [];
}

class MyAvailabilityLoadEvent extends MyAvailabilityEvent {
  const MyAvailabilityLoadEvent({this.weekStart});

  final String? weekStart;

  @override
  List<Object?> get props => [weekStart];
}

class MyAvailabilityWeekChangeEvent extends MyAvailabilityEvent {
  const MyAvailabilityWeekChangeEvent({required this.weekStart});

  final String weekStart;

  @override
  List<Object?> get props => [weekStart];
}

/// Update one day's entry in-place. Any null field leaves the current value.
class MyAvailabilitySetDayEvent extends MyAvailabilityEvent {
  const MyAvailabilitySetDayEvent({
    required this.day,
    this.state,
    this.from,
    this.to,
    this.note,
  });

  final int day;
  final AvailabilityState? state;
  final String? from;
  final String? to;
  final String? note;

  @override
  List<Object?> get props => [day, state, from, to, note];
}

class MyAvailabilitySubmitEvent extends MyAvailabilityEvent {
  const MyAvailabilitySubmitEvent({required this.userId});

  final int userId;

  @override
  List<Object?> get props => [userId];
}
