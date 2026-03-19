import 'package:core/core.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:onesthrm/page/attendance_report/bloc/attendance_report_bloc.dart';

class PlutoAttendanceReportContent extends StatelessWidget {
  const PlutoAttendanceReportContent({super.key, required this.bloc});
  final AttendanceReportBloc bloc;

  @override
  Widget build(BuildContext context) {
    final attendanceSummery = bloc.state.attendanceReport?.reportData?.attendanceSummary;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 8.h),
            child: Text(
              "attendance_report".tr(),
              style: TextStyle(fontSize: 15.r, fontWeight: FontWeight.w700, color: Colors.black87),
            ),
          ),
          Divider(height: 1, color: Colors.grey.shade200),
          Padding(
            padding: EdgeInsets.all(12.r),
            child: GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 3,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 1.2,
              children: [
                _buildSummaryTile("working_days".tr(), attendanceSummery?.workingDays ?? '', Branding.colors.primaryLight),
                _buildSummaryTile("on_time".tr(), attendanceSummery?.totalOnTimeIn ?? '', const Color(0xFF4CAF50)),
                _buildSummaryTile("late".tr(), attendanceSummery?.totalLateIn ?? '', const Color(0xFFE53935)),
                _buildSummaryTile("left_timely".tr(), attendanceSummery?.totalLeftTimely ?? '', const Color(0xFF4CAF50)),
                _buildSummaryTile("left_early".tr(), attendanceSummery?.totalLeftEarly ?? '', const Color(0xFFE53935)),
                _buildSummaryTile("on_leave".tr(), attendanceSummery?.totalLeave ?? '', const Color(0xFFBDBDBD)),
                _buildSummaryTile("absent".tr(), attendanceSummery?.absent ?? '', const Color(0xFF212121)),
                _buildSummaryTile("left_later".tr(), attendanceSummery?.absent ?? '', const Color(0xFFFFA726)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryTile(String label, String value, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 11.r, color: Colors.grey.shade600),
          ),
          SizedBox(height: 4.h),
          Text(
            value,
            style: TextStyle(fontSize: 18.r, color: color, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
