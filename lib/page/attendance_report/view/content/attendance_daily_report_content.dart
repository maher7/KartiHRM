import 'package:core/core.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:meta_club_api/meta_club_api.dart';
import 'package:onesthrm/page/attendance_report/view/content/content.dart';
import 'package:user_repository/user_repository.dart';
import '../../bloc/bloc.dart';

class AttendanceDailyReportContent extends StatelessWidget {
  const AttendanceDailyReportContent(
      {super.key,
      required this.bloc,
      required this.user,
      required this.settings});
  final AttendanceReportBloc bloc;
  final LoginData user;
  final Settings settings;

  @override
  Widget build(BuildContext context) {
    final listOfDailyReport =
        bloc.state.attendanceReport?.reportData?.dailyReport;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 8.h),
          Text(
            tr("daily_report"),
            style: TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.w700,
              fontSize: 16.r,
            ),
          ),
          SizedBox(height: 14.h),

          listOfDailyReport != null
              ? ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: listOfDailyReport.length,
                  itemBuilder: (BuildContext context, int index) {
                    final data = listOfDailyReport[index];
                    return DailyReportListTile(
                      dailyReport: data,
                      settings: settings,
                    );
                  },
                )
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: 5,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: TileShimmer(
                        titleHeight: 30.h,
                        isSubTitle: true,
                      ),
                    );
                  },
                ),

          SizedBox(height: 12.h),

          // Legend
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
          SizedBox(height: 20.h),
        ],
      ),
    );
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
