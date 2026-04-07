import 'package:core/core.dart';
import 'package:equatable/equatable.dart';

/// Severity level of the announcement — drives the colored badge shown in the
/// ticker. Parsed from the headline text by [BulletinBloc].
enum BulletinType { info, urgent }

class BulletinState extends Equatable {
  final NetworkStatus status;
  final String? headline;
  final bool dismissed;
  final BulletinType type;

  const BulletinState({
    this.status = NetworkStatus.initial,
    this.headline,
    this.dismissed = false,
    this.type = BulletinType.info,
  });

  BulletinState copyWith(
      {NetworkStatus? status, String? headline, bool? dismissed, BulletinType? type}) {
    return BulletinState(
      status: status ?? this.status,
      headline: headline ?? this.headline,
      dismissed: dismissed ?? this.dismissed,
      type: type ?? this.type,
    );
  }

  @override
  List<Object?> get props => [status, headline, dismissed, type];
}
