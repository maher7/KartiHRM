part of 'my_schedule_bloc.dart';

abstract class MyScheduleEvent extends Equatable {
  const MyScheduleEvent();

  @override
  List<Object?> get props => [];
}

class MyScheduleLoadEvent extends MyScheduleEvent {
  const MyScheduleLoadEvent({this.weekStart});

  final String? weekStart;

  @override
  List<Object?> get props => [weekStart];
}

class MyScheduleWeekChangeEvent extends MyScheduleEvent {
  const MyScheduleWeekChangeEvent({required this.weekStart});

  final String weekStart;

  @override
  List<Object?> get props => [weekStart];
}
