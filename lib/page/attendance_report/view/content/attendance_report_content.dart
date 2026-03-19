import 'package:core/core.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:onesthrm/page/attendance_report/view/content/summery_tile.dart';
import '../../bloc/bloc.dart';

class AttendanceReportContent extends StatelessWidget {
  const AttendanceReportContent({super.key, required this.bloc});
  final AttendanceReportBloc bloc;

  @override
  Widget build(BuildContext context) {
    final attendanceSummery =
        bloc.state.attendanceReport?.reportData?.attendanceSummary;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 8.h),
            child: Text(
              'report_summary'.tr(),
              style: TextStyle(
                fontSize: 16.r,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
          ),
          SummeryTile(
              titleValue: attendanceSummery?.workingDays ?? '',
              title: 'working_days',
              color: Branding.colors.primaryLight),
          SummeryTile(
              titleValue: attendanceSummery?.totalOnTimeIn ?? '',
              title: 'on_time',
              color: const Color(0xFF4CAF50)),
          SummeryTile(
              titleValue: attendanceSummery?.totalLateIn ?? '',
              title: 'late',
              color: const Color(0xFFE53935)),
          SummeryTile(
              titleValue: attendanceSummery?.totalLeftTimely ?? '',
              title: 'left_timely',
              color: const Color(0xFF66BB6A)),
          SummeryTile(
              titleValue: attendanceSummery?.totalLeftEarly ?? '',
              title: 'left_early',
              color: const Color(0xFFFF7043)),
          SummeryTile(
              titleValue: attendanceSummery?.totalLeave ?? '',
              title: 'on_leave',
              color: const Color(0xFF78909C)),
          SummeryTile(
              titleValue: attendanceSummery?.absent ?? '',
              title: 'absent',
              color: const Color(0xFF37474F)),
          SummeryTile(
              titleValue: attendanceSummery?.totalLeftLater ?? '',
              title: 'left_later',
              color: const Color(0xFFFFA726)),
          SizedBox(height: 8.h),
        ],
      ),
    );
  }
}
