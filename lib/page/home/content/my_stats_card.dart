import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meta_club_api/meta_club_api.dart';
import 'package:core/core.dart';

class MyStatsCard extends StatelessWidget {
  final DashboardModel? dashboardModel;

  const MyStatsCard({super.key, required this.dashboardModel});

  @override
  Widget build(BuildContext context) {
    if (dashboardModel == null) return const SizedBox.shrink();

    final config = dashboardModel?.data?.config;
    final attendance = dashboardModel?.data?.attendanceData;
    final currentMonth = dashboardModel?.data?.currentMonth;

    // Extract monthly stats from currentMonth array
    final lateCount = _getMonthStat(currentMonth, 'late_in');
    final absentCount = _getMonthStat(currentMonth, 'absent');

    // Format shift times
    final shiftStart = _formatTime(config?.dutySchedule?.startTime);
    final shiftEnd = _formatTime(config?.dutySchedule?.endTime);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.h),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
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
          // Title row
          Row(
            children: [
              Icon(
                Icons.insights_rounded,
                size: 18.r,
                color: Branding.colors.primaryLight,
              ),
              SizedBox(width: 8.w),
              Text(
                'my_stats'.tr(),
                style: TextStyle(
                  fontSize: 14.r,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),

          // Stats grid - 2x2
          Row(
            children: [
              // Shift Schedule
              Expanded(
                child: _StatTile(
                  icon: Icons.schedule_rounded,
                  iconColor: Branding.colors.primaryLight,
                  label: 'shift'.tr(),
                  value: shiftStart != null && shiftEnd != null
                      ? '$shiftStart - $shiftEnd'
                      : '--',
                  valueSize: 11.r,
                ),
              ),
              SizedBox(width: 10.w),
              // Working Hours Today
              Expanded(
                child: _StatTile(
                  icon: Icons.timer_outlined,
                  iconColor: deepColorGreen,
                  label: 'working_hr'.tr(),
                  value: attendance?.stayTime ?? '--:--',
                  valueSize: 13.r,
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Row(
            children: [
              // Late this month
              Expanded(
                child: _StatTile(
                  icon: Icons.running_with_errors_rounded,
                  iconColor: const Color(0xFFE53935),
                  label: 'late_this_month'.tr(),
                  value: '$lateCount',
                  valueSize: 16.r,
                  valueColor: lateCount > 0 ? const Color(0xFFE53935) : deepColorGreen,
                ),
              ),
              SizedBox(width: 10.w),
              // Absent this month
              Expanded(
                child: _StatTile(
                  icon: Icons.event_busy_rounded,
                  iconColor: const Color(0xFF37474F),
                  label: 'absent_this_month'.tr(),
                  value: '$absentCount',
                  valueSize: 16.r,
                  valueColor: absentCount > 0 ? const Color(0xFFE53935) : deepColorGreen,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  int _getMonthStat(List<CurrentMonthData>? data, String slug) {
    if (data == null) return 0;
    for (final item in data) {
      if (item.slug == slug) {
        if (item.number is int) return item.number;
        if (item.number is String) return int.tryParse(item.number) ?? 0;
        return 0;
      }
    }
    return 0;
  }

  String? _formatTime(TimeData? time) {
    if (time == null) return null;
    final hour = time.hour ?? 0;
    final min = time.min ?? 0;
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    return '${displayHour.toString().padLeft(2, '0')}:${min.toString().padLeft(2, '0')} $period';
  }
}

class _StatTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  final double valueSize;
  final Color? valueColor;

  const _StatTile({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    this.valueSize = 14,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: iconColor.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(6.r),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: iconColor, size: 16.r),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: valueSize,
                    fontWeight: FontWeight.w700,
                    color: valueColor ?? Colors.black87,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 1.h),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 10.r,
                    color: Colors.black45,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
