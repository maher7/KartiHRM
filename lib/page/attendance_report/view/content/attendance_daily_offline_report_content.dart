import 'package:core/core.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:offline_attendance/domain/offline_attendance_repository.dart';
import 'offline_present_content.dart';

class AttendanceDailyOfflineReportContent extends StatelessWidget {

  const AttendanceDailyOfflineReportContent({super.key});

  @override
  Widget build(BuildContext context) {

    final futureData = instance<OfflineAttendanceRepository>().getAllOfflineCheckData();

    return FutureBuilder(future: futureData, builder: (context,snapshot){
      if(snapshot.hasData){
        final data = snapshot.data;
        return data!.isNotEmpty ? Container(
          margin: EdgeInsets.symmetric(horizontal: 16.0),
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                tr("daily_report"),
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w700,
                  fontSize: 16.r,
                ),
              ),
              SizedBox(height: 12.h),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: data.length,
                itemBuilder: (BuildContext context, int index) {
                  final attendance = data[index];
                  return DailyOfflineReportTile(dailyReport: attendance);
                },
              ),
              SizedBox(height: 16.h),
              Container(
                padding: EdgeInsets.all(12.r),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    _buildLegendRow(
                      color: Branding.colors.primaryLight,
                      label: tr("h"),
                      description: tr("check_in_check_out_from_home"),
                    ),
                    SizedBox(height: 8.h),
                    _buildLegendRow(
                      color: deepColorGreen,
                      label: tr("v"),
                      description: tr("check_in_check_out_from_office"),
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      children: [
                        Icon(
                          FontAwesomeIcons.fileLines,
                          size: 13.r,
                          color: Branding.colors.primaryLight,
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Text(
                            tr("reason_for_late_check_in_early_check_out"),
                            style: TextStyle(fontSize: 11.r, color: Colors.black54),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ): const SizedBox.shrink();
      }
      return const SizedBox.shrink();
    });
  }

  Widget _buildLegendRow({
    required Color color,
    required String label,
    required String description,
  }) {
    return Row(
      children: [
        Container(
          width: 18,
          height: 18,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontSize: 10.r,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            description,
            style: TextStyle(fontSize: 11.r, color: Colors.black54),
          ),
        ),
      ],
    );
  }
}
