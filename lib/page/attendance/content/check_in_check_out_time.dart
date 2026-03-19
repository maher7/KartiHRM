import 'package:core/core.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:onesthrm/page/attendance/attendance.dart';
import 'package:onesthrm/page/attendance/bloc/offline_attendance_bloc/offline_attendance_qubit.dart';
import 'package:onesthrm/page/attendance/bloc/offline_attendance_bloc/offline_attendance_state.dart';

class CheckInCheckOutTime extends StatelessWidget {

  const CheckInCheckOutTime({super.key});

  @override
  Widget build(BuildContext context) {

    return BlocBuilder<OfflineCubit,OfflineAttendanceState>(
      builder: (context,offlineState){

        final body = offlineState.attendanceBody;

        return BlocBuilder<AttendanceBloc,AttendanceState>(
          builder: (context,state){
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 16.0),
              padding: EdgeInsets.symmetric(vertical: 16.h),
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildTimeColumn(
                    icon: Icons.login_rounded,
                    iconColor: Branding.colors.primaryLight,
                    time: body?.inTime ?? "--:--",
                    label: "check_in".tr(),
                  ),
                  Container(
                    height: 40.h,
                    width: 1,
                    color: Colors.black.withValues(alpha: 0.08),
                  ),
                  _buildTimeColumn(
                    icon: Icons.logout_rounded,
                    iconColor: colorDeepRed,
                    time: body?.outTime ?? "--:--",
                    label: "check_out".tr(),
                  ),
                  Container(
                    height: 40.h,
                    width: 1,
                    color: Colors.black.withValues(alpha: 0.08),
                  ),
                  _buildTimeColumn(
                    icon: Icons.timer_outlined,
                    iconColor: deepColorGreen,
                    time: timeDifference(time1: body?.inTime, time2: body?.outTime) ?? "--:--",
                    label: "working_hr".tr(),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildTimeColumn({
    required IconData icon,
    required Color iconColor,
    required String time,
    required String label,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.all(8.r),
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: iconColor, size: 18.r),
        ),
        SizedBox(height: 8.h),
        Text(
          time,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.r, color: Colors.black87),
        ),
        SizedBox(height: 2.h),
        Text(
          label,
          style: TextStyle(fontSize: 11.r, color: Colors.black45),
        ),
      ],
    );
  }
}
