import 'package:core/core.dart';
import 'package:equatable/equatable.dart';

class BulletinState extends Equatable {
  final NetworkStatus status;
  final String? headline;
  final bool dismissed;

  const BulletinState({this.status = NetworkStatus.initial, this.headline, this.dismissed = false});

  BulletinState copyWith({NetworkStatus? status, String? headline, bool? dismissed}) {
    return BulletinState(
      status: status ?? this.status,
      headline: headline ?? this.headline,
      dismissed: dismissed ?? this.dismissed,
    );
  }

  @override
  List<Object?> get props => [status, headline, dismissed];
}
