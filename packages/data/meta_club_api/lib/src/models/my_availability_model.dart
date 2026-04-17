import 'package:equatable/equatable.dart';

/// The 4 availability states an employee can pick for each day of the week.
/// Mirrors the backend contract in SchedulingController::saveAvailability().
enum AvailabilityState { can, want, preferNot, cannot }

extension AvailabilityStateX on AvailabilityState {
  /// Wire format matches the backend's validation ('can'|'want'|'prefer_not'|'cannot')
  String get wireValue {
    switch (this) {
      case AvailabilityState.can:
        return 'can';
      case AvailabilityState.want:
        return 'want';
      case AvailabilityState.preferNot:
        return 'prefer_not';
      case AvailabilityState.cannot:
        return 'cannot';
    }
  }

  static AvailabilityState fromWire(String? value) {
    switch (value) {
      case 'want':
        return AvailabilityState.want;
      case 'prefer_not':
        return AvailabilityState.preferNot;
      case 'cannot':
        return AvailabilityState.cannot;
      case 'can':
      default:
        return AvailabilityState.can;
    }
  }
}

/// A single day's availability entry (row in the per-week per-company JSON file).
class AvailabilityItem extends Equatable {
  const AvailabilityItem({
    this.id,
    required this.day,
    required this.state,
    this.from,
    this.to,
    this.note,
    this.submittedAt,
  });

  final String? id;
  final int day; // 0..6 (Sun=0)
  final AvailabilityState state;
  final String? from; // HH:mm
  final String? to; // HH:mm
  final String? note;
  final String? submittedAt;

  factory AvailabilityItem.fromJson(Map<String, dynamic> json) =>
      AvailabilityItem(
        id: json['id']?.toString(),
        day: int.tryParse(json['day']?.toString() ?? '0') ?? 0,
        state: AvailabilityStateX.fromWire(json['state']?.toString()),
        from: json['from']?.toString(),
        to: json['to']?.toString(),
        note: json['note']?.toString(),
        submittedAt: json['submitted_at']?.toString(),
      );

  /// Body shape expected by `POST /api/scheduling/availability` — fields the
  /// server writes as-is (id/userId/week_start/submitted_at are server-set).
  Map<String, dynamic> toSubmitJson() => {
        'day': day,
        'state': state.wireValue,
        if (from != null && from!.isNotEmpty) 'from': from,
        if (to != null && to!.isNotEmpty) 'to': to,
        if (note != null && note!.isNotEmpty) 'note': note,
      };

  AvailabilityItem copyWith({
    String? id,
    int? day,
    AvailabilityState? state,
    String? from,
    String? to,
    String? note,
    String? submittedAt,
  }) =>
      AvailabilityItem(
        id: id ?? this.id,
        day: day ?? this.day,
        state: state ?? this.state,
        from: from ?? this.from,
        to: to ?? this.to,
        note: note ?? this.note,
        submittedAt: submittedAt ?? this.submittedAt,
      );

  @override
  List<Object?> get props => [id, day, state, from, to, note, submittedAt];
}

/// Response from `GET /api/scheduling/availability?week_start=YYYY-MM-DD`.
/// The backend returns a bare JSON array of items; this wrapper lets us carry
/// the week_start alongside for UI convenience.
class MyAvailabilityResponse extends Equatable {
  const MyAvailabilityResponse({
    required this.weekStart,
    this.items = const [],
  });

  final String weekStart;
  final List<AvailabilityItem> items;

  factory MyAvailabilityResponse.fromJsonList(
    String weekStart,
    dynamic rawList,
  ) {
    final items = <AvailabilityItem>[];
    if (rawList is List) {
      for (final row in rawList) {
        if (row is Map<String, dynamic>) {
          items.add(AvailabilityItem.fromJson(row));
        }
      }
    }
    return MyAvailabilityResponse(weekStart: weekStart, items: items);
  }

  @override
  List<Object?> get props => [weekStart, items];
}
