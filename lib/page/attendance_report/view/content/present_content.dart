import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:meta_club_api/meta_club_api.dart';
import 'package:core/core.dart';
import '../../../../res/common/functions.dart';
import '../../../../res/common/toast.dart';
import '../../bloc/attendance_report_bloc.dart';

class DailyReportTile extends StatelessWidget {
  final DailyReport dailyReport;
  final Settings settings;

  const DailyReportTile(
      {super.key, required this.dailyReport, required this.settings});

  @override
  Widget build(BuildContext context) {
    String remoteModeIn =
        (int.tryParse(dailyReport.remoteModeIn ?? "1") == 0) ? "H" : "V";
    String remoteModeOut =
        (int.tryParse(dailyReport.remoteModeOut ?? "0") == 0) ? "H" : "V";

    final inColor = Color(int.parse(getInOutColor(status: dailyReport.checkInStatus)));
    final outColor = Color(int.parse(getInOutColor(status: dailyReport.checkOutStatus)));

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Date column
          Container(
            width: 52.w,
            padding: EdgeInsets.symmetric(vertical: 8.h),
            decoration: BoxDecoration(
              color: Branding.colors.primaryLight.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                Text(
                  dailyReport.weekDay ?? "",
                  style: TextStyle(
                    color: Colors.black45,
                    fontSize: 10.r,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  dailyReport.date ?? "",
                  style: TextStyle(
                    color: Branding.colors.primaryLight,
                    fontSize: 20.r,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 12.w),
          // In/Out details
          Expanded(
            child: Column(
              children: [
                // IN row
                Row(
                  children: [
                    Container(
                      width: 3.w,
                      height: 28.h,
                      decoration: BoxDecoration(
                        color: inColor,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      "IN".tr(),
                      style: TextStyle(
                        fontSize: 10.r,
                        color: Colors.black38,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 10.w),
                    if (dailyReport.checkIn?.isNotEmpty == true) ...[
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          color: inColor,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          dailyReport.checkIn ?? "",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.r,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      _buildModeIndicator(remoteModeIn, () {
                        getReasonIn(dailyReport.checkInLocation);
                      }),
                      if (dailyReport.checkInReason?.isNotEmpty == true)
                        InkWell(
                          onTap: () => getReasonIn(dailyReport.checkInReason),
                          child: Padding(
                            padding: EdgeInsets.all(4.r),
                            child: Icon(
                              Icons.info_outline_rounded,
                              color: Branding.colors.primaryLight,
                              size: 16.r,
                            ),
                          ),
                        ),
                    ],
                  ],
                ),
                SizedBox(height: 6.h),
                // OUT row
                Row(
                  children: [
                    Container(
                      width: 3.w,
                      height: 28.h,
                      decoration: BoxDecoration(
                        color: dailyReport.checkOut?.isNotEmpty == true
                            ? outColor
                            : Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      "OUT".tr(),
                      style: TextStyle(
                        fontSize: 10.r,
                        color: Colors.black38,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 6.w),
                    if (dailyReport.checkOut?.isNotEmpty == true) ...[
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          color: outColor,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          dailyReport.checkOut ?? "",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.r,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      if (dailyReport.remoteModeOut?.isNotEmpty == true)
                        _buildModeIndicator(remoteModeOut, () {
                          getReasonIn(dailyReport.checkOutLocation);
                        }),
                      if (dailyReport.checkOutReason?.isNotEmpty == true)
                        InkWell(
                          onTap: () => getReasonIn(dailyReport.checkOutReason),
                          child: Padding(
                            padding: EdgeInsets.all(4.r),
                            child: Icon(
                              Icons.info_outline_rounded,
                              color: Branding.colors.primaryLight,
                              size: 16.r,
                            ),
                          ),
                        ),
                    ] else
                      Text(
                        "--:--",
                        style: TextStyle(
                          fontSize: 12.r,
                          color: Colors.black26,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          // Multi-check-in button
          if (settings.data?.multiCheckIn ?? false)
            InkWell(
              onTap: () {
                context.read<AttendanceReportBloc>().add(
                    MultiAttendanceEvent(
                        date: dailyReport.fullDate!,
                        context: context,
                        dailyReport: dailyReport));
              },
              child: Lottie.asset(
                'assets/images/report_one.json',
                height: 36.h,
                width: 36.w,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildModeIndicator(String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 20.w,
        height: 20.h,
        margin: EdgeInsets.only(right: 4.w),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: label == "H" ? Branding.colors.primaryLight : deepColorGreen,
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: 9.r,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
