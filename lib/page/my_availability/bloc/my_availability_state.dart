part of 'my_availability_bloc.dart';

class MyAvailabilityState extends Equatable {
  const MyAvailabilityState({
    this.status = NetworkStatus.initial,
    this.submitStatus = NetworkStatus.initial,
    this.items = const <AvailabilityItem>[],
    this.weekStart,
    this.errorMessage,
  });

  final NetworkStatus status;
  final NetworkStatus submitStatus;
  final List<AvailabilityItem> items;
  final String? weekStart;
  final String? errorMessage;

  MyAvailabilityState copyWith({
    NetworkStatus? status,
    NetworkStatus? submitStatus,
    List<AvailabilityItem>? items,
    String? weekStart,
    String? errorMessage,
    bool clearError = false,
  }) {
    return MyAvailabilityState(
      status: status ?? this.status,
      submitStatus: submitStatus ?? this.submitStatus,
      items: items ?? this.items,
      weekStart: weekStart ?? this.weekStart,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [status, submitStatus, items, weekStart, errorMessage];
}
