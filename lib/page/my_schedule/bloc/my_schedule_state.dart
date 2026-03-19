part of 'my_schedule_bloc.dart';

class MyScheduleState extends Equatable {
  const MyScheduleState({
    this.status = NetworkStatus.initial,
    this.schedule,
    this.weekStart,
    this.errorMessage,
  });

  final NetworkStatus status;
  final MyScheduleResponse? schedule;
  final String? weekStart;
  final String? errorMessage;

  MyScheduleState copyWith({
    NetworkStatus? status,
    MyScheduleResponse? schedule,
    String? weekStart,
    String? errorMessage,
  }) {
    return MyScheduleState(
      status: status ?? this.status,
      schedule: schedule ?? this.schedule,
      weekStart: weekStart ?? this.weekStart,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, schedule, weekStart, errorMessage];
}
