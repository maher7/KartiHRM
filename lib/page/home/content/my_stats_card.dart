import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meta_club_api/meta_club_api.dart';
import 'package:core/core.dart';
import 'package:onesthrm/page/attendance/bloc/offline_attendance_bloc/offline_attendance_qubit.dart';

class MyStatsCard extends StatefulWidget {
  final DashboardModel? dashboardModel;
  final Settings? settings;

  const MyStatsCard({super.key, required this.dashboardModel, this.settings});

  @override
  State<MyStatsCard> createState() => _MyStatsCardState();
}

class _MyStatsCardState extends State<MyStatsCard> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Update every 30 seconds for live working hours
    _timer = Timer.periodic(const Duration(seconds: 30), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  /// Parse time like "7:00 AM" or "15:00" to DateTime today
  DateTime? _parseCheckInTime(String? timeStr) {
    if (timeStr == null || timeStr.isEmpty) return null;
    try {
      // Try "h:mm a" format (7:00 AM)
      return DateFormat('h:mm a', 'en').parse(timeStr);
    } catch (_) {}
    try {
      // Try "hh:mm a" format (07:00 AM)
      return DateFormat('hh:mm a', 'en').parse(timeStr);
    } catch (_) {}
    try {
      // Try "HH:mm" format (15:00)
      return DateFormat('HH:mm', 'en').parse(timeStr);
    } catch (_) {}
    return null;
  }

  String _calcLiveWorkingHours(String? inTimeStr) {
    final parsed = _parseCheckInTime(inTimeStr);
    if (parsed == null) return '--:--';

    final now = DateTime.now();
    var checkIn = DateTime(now.year, now.month, now.day, parsed.hour, parsed.minute);
    // If check-in time appears to be in the future, it was yesterday (overnight shift)
    if (checkIn.isAfter(now)) {
      checkIn = checkIn.subtract(const Duration(days: 1));
    }
    final diff = now.difference(checkIn);
    if (diff.isNegative) return '--:--';

    final hours = diff.inHours;
    final minutes = diff.inMinutes % 60;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    if (widget.dashboardModel == null) return const SizedBox.shrink();

    final attendance = widget.dashboardModel?.data?.attendanceData;
    final currentMonth = widget.dashboardModel?.data?.currentMonth;

    final lateCount = _getMonthStat(currentMonth, 'late_in');
    final absentCount = _getMonthStat(currentMonth, 'absent');

    // Use OfflineCubit for real-time check-in state
    final offlineState = context.watch<OfflineCubit>().state;
    final isCheckedIn = offlineState.isCheckedIn || (attendance?.checkIn == true);
    final isCheckedOut = offlineState.isCheckedOut || (attendance?.checkout == true);
    final inTime = offlineState.attendanceBody?.inTime ?? attendance?.inTime;
    final outTime = offlineState.attendanceBody?.outTime ?? attendance?.outTime;

    // Live working hours: calculate from check-in time if currently checked in
    String workingHours;
    if (isCheckedIn && !isCheckedOut && inTime != null) {
      workingHours = _calcLiveWorkingHours(inTime);
    } else {
      workingHours = attendance?.stayTime ?? '--:--';
    }

    // Status
    String statusText;
    String statusLabel;
    Color statusColor;
    IconData statusIcon;

    if (isCheckedOut && outTime != null) {
      statusText = 'checked_out'.tr();
      statusLabel = outTime;
      statusColor = const Color(0xFF546E7A);
      statusIcon = Icons.logout_rounded;
    } else if (isCheckedIn && inTime != null) {
      statusText = 'checked_in'.tr();
      statusLabel = inTime;
      statusColor = const Color(0xFF2E7D32);
      statusIcon = Icons.login_rounded;
    } else {
      statusText = 'not_checked_in'.tr();
      statusLabel = '';
      statusColor = const Color(0xFFE65100);
      statusIcon = Icons.pending_outlined;
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.h),
      padding: EdgeInsets.all(14.r),
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
          // Title
          Row(
            children: [
              Icon(Icons.insights_rounded, size: 16.r, color: Branding.colors.primaryLight),
              SizedBox(width: 6.w),
              Text(
                'my_stats'.tr(),
                style: TextStyle(fontSize: 13.r, fontWeight: FontWeight.w700, color: Colors.black87),
              ),
            ],
          ),
          SizedBox(height: 12.h),

          // Full-width status banner
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isCheckedIn && !isCheckedOut
                        ? const Color(0xFF4CAF50)
                        : statusColor,
                  ),
                ),
                SizedBox(width: 10.w),
                Icon(statusIcon, color: statusColor, size: 18.r),
                SizedBox(width: 8.w),
                Text(
                  statusText,
                  style: TextStyle(
                    fontSize: 13.r,
                    fontWeight: FontWeight.w700,
                    color: statusColor,
                  ),
                ),
                if (statusLabel.isNotEmpty) ...[
                  SizedBox(width: 6.w),
                  Text(
                    statusLabel,
                    style: TextStyle(
                      fontSize: 12.r,
                      fontWeight: FontWeight.w500,
                      color: statusColor.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ],
            ),
          ),
          SizedBox(height: 10.h),

          // 3-column stats row with dividers
          IntrinsicHeight(
            child: Row(
              children: [
                Expanded(
                  child: _MiniStat(
                    icon: Icons.timer_outlined,
                    color: deepColorGreen,
                    value: workingHours,
                    label: 'working_hr'.tr(),
                  ),
                ),
                VerticalDivider(width: 16.w, thickness: 1, color: Colors.grey.shade200),
                Expanded(
                  child: _MiniStat(
                    icon: Icons.running_with_errors_rounded,
                    color: lateCount > 0 ? const Color(0xFFE53935) : deepColorGreen,
                    value: '$lateCount',
                    label: 'late'.tr(),
                    showCheck: lateCount == 0,
                  ),
                ),
                VerticalDivider(width: 16.w, thickness: 1, color: Colors.grey.shade200),
                Expanded(
                  child: _MiniStat(
                    icon: Icons.event_busy_rounded,
                    color: absentCount > 0 ? const Color(0xFFE53935) : const Color(0xFF37474F),
                    value: '$absentCount',
                    label: 'absent'.tr(),
                  ),
                ),
              ],
            ),
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
}

class _MiniStat extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String value;
  final String label;
  final bool showCheck;

  const _MiniStat({
    required this.icon,
    required this.color,
    required this.value,
    required this.label,
    this.showCheck = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 4.w),
      child: Column(
        children: [
          Icon(icon, color: color, size: 18.r),
          SizedBox(height: 4.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 15.r,
                  fontWeight: FontWeight.w800,
                  color: color,
                ),
              ),
              if (showCheck) ...[
                SizedBox(width: 2.w),
                Icon(Icons.check_circle_rounded, size: 12.r, color: deepColorGreen),
              ],
            ],
          ),
          SizedBox(height: 2.h),
          Text(
            label,
            style: TextStyle(fontSize: 9.r, color: Colors.black45, fontWeight: FontWeight.w500),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
