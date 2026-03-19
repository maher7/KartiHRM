import 'package:core/core.dart';
import 'package:equatable/equatable.dart';

class LeaveDetailsModel extends Equatable {
  final bool? result;
  final String? message;
  final LeaveDetailsData? leaveDetailsData;

  const LeaveDetailsModel({
    this.result,
    this.message,
    this.leaveDetailsData,
  });

  factory LeaveDetailsModel.fromJson(Map<String, dynamic> json) =>
      LeaveDetailsModel(
        result: json["result"],
        message: json["message"],
        leaveDetailsData: json["data"] == null
            ? null
            : LeaveDetailsData.fromJson(json["data"]),
      );

  @override
  List<Object?> get props => [result, message, leaveDetailsData];
}

class LeaveDetailsData extends Equatable {
  final int? id;
  final int? userId;
  final String? name;
  final String? designation;
  final String? department;
  final dynamic employeeId;
  final String? requestedOn;
  final String? type;
  final String? period;
  final int? totalDays;
  final String? note;
  final dynamic apporover;
  final int? availableLeave;
  final int? totalUsed;
  final String? approvedBy;
  final String? referredBy;
  final LeaveStatusEnum? status;
  final String? colorCode;
  final dynamic substitute;
  final String? attachment;
  final String? imageUrl;

  const LeaveDetailsData(
      {this.id,
      this.userId,
      this.name,
      this.designation,
      this.department,
      this.employeeId,
      this.requestedOn,
      this.type,
      this.period,
      this.totalDays,
      this.note,
      this.apporover,
      this.availableLeave,
      this.totalUsed,
      this.approvedBy,
      this.referredBy,
      this.status,
      this.colorCode,
      this.substitute,
      this.attachment,
      this.imageUrl});

  factory LeaveDetailsData.fromJson(Map<String, dynamic> json) =>
      LeaveDetailsData(
          id: json["id"] is int ? json["id"] : int.tryParse(json["id"]?.toString() ?? ''),
          userId: json["user_id"] is int ? json["user_id"] : int.tryParse(json["user_id"]?.toString() ?? ''),
          name: json["name"]?.toString(),
          designation: json["designation"]?.toString(),
          department: json["department"]?.toString(),
          employeeId: json["employee_id"],
          requestedOn: json["requested_on"]?.toString(),
          type: json["type"]?.toString(),
          period: json["period"]?.toString(),
          totalDays: json["total_days"] is int ? json["total_days"] : int.tryParse(json["total_days"]?.toString() ?? ''),
          note: json["note"]?.toString(),
          apporover: json["apporover"],
          availableLeave: json["available_leave"] is int ? json["available_leave"] : int.tryParse(json["available_leave"]?.toString() ?? ''),
          totalUsed: json["total_used"] is int ? json["total_used"] : int.tryParse(json["total_used"]?.toString() ?? ''),
          approvedBy: json["approved_by"],
          referredBy: json["referred_by"],
          status: LeaveStatusEnum.fromString(json["status"]),
          colorCode: json["color_code"],
          substitute: json["substitute"],
          attachment: json["attachment"],
          imageUrl: json['image_url']);

  @override
  List<Object?> get props => [
        id,
        userId,
        name,
        designation,
        department,
        employeeId,
        requestedOn,
        type,
        period,
        totalDays,
        note,
        apporover,
        availableLeave,
        totalUsed,
        approvedBy,
        referredBy,
        status,
        colorCode,
        substitute,
        attachment,
        imageUrl
      ];
}
