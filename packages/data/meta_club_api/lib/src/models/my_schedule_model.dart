import 'package:equatable/equatable.dart';

class MyScheduleResponse extends Equatable {
  const MyScheduleResponse({
    this.employeeId,
    this.employeeName,
    this.weekStart,
    this.totalShifts,
    this.totalHours,
    this.shifts = const [],
  });

  final int? employeeId;
  final String? employeeName;
  final String? weekStart;
  final int? totalShifts;
  final double? totalHours;
  final List<ScheduleShift> shifts;

  factory MyScheduleResponse.fromJson(Map<String, dynamic> json) =>
      MyScheduleResponse(
        employeeId: json['employee_id'],
        employeeName: json['employee_name'],
        weekStart: json['week_start'],
        totalShifts: json['total_shifts'],
        totalHours: json['total_hours'] != null
            ? double.tryParse(json['total_hours'].toString())
            : null,
        shifts: json['shifts'] != null
            ? List<ScheduleShift>.from(
                (json['shifts'] as List).map((e) => ScheduleShift.fromJson(e)))
            : [],
      );

  @override
  List<Object?> get props =>
      [employeeId, employeeName, weekStart, totalShifts, totalHours, shifts];
}

class ScheduleShift extends Equatable {
  const ScheduleShift({
    this.id,
    this.day,
    this.dayName,
    this.date,
    this.from,
    this.to,
    this.roleName,
    this.hours,
  });

  final String? id;
  final int? day;
  final String? dayName;
  final String? date;
  final String? from;
  final String? to;
  final String? roleName;
  final double? hours;

  factory ScheduleShift.fromJson(Map<String, dynamic> json) => ScheduleShift(
        id: json['id']?.toString(),
        day: json['day'] != null ? int.tryParse(json['day'].toString()) : null,
        dayName: json['day_name'],
        date: json['date'],
        from: json['from'],
        to: json['to'],
        roleName: json['role_name'],
        hours: json['hours'] != null
            ? double.tryParse(json['hours'].toString())
            : null,
      );

  @override
  List<Object?> get props => [id, day, dayName, date, from, to, roleName, hours];
}
