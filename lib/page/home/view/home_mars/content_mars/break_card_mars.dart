import 'package:core/core.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:meta_club_api/meta_club_api.dart';
import 'package:onesthrm/page/attendance/bloc/offline_attendance_bloc/offline_attendance_qubit.dart';
import 'package:onesthrm/page/attendance/bloc/offline_attendance_bloc/offline_attendance_state.dart';
import 'package:onesthrm/page/break/break_route.dart';
import 'package:user_repository/user_repository.dart';

class BreakCardMars extends StatelessWidget {
  final Settings? settings;
  final LoginData? user;
  final DashboardModel? dashboardModel;

  const BreakCardMars({super.key, required this.settings, required this.user, required this.dashboardModel});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OfflineCubit, OfflineAttendanceState>(
      builder: (context, offlineState) {
        final attendance = dashboardModel?.data?.attendanceData;
        final isCheckedIn = offlineState.isCheckedIn || (attendance?.inTime?.isNotEmpty == true);
        final isCheckedOut = offlineState.isCheckedOut || (attendance?.outTime?.isNotEmpty == true);
        final isActive = isCheckedIn && !isCheckedOut;
        final inBreak = globalState.get(isBreak) == true;

        return Opacity(
          opacity: isActive ? 1.0 : 0.45,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: primaryBorderColor),
            ),
            margin: EdgeInsets.symmetric(vertical: 8.0.h, horizontal: 18.0),
            child: InkWell(
              onTap: isActive
                  ? () {
                      BreakRoute.breakOrQrCompanyRoute(context: context, inBreak: inBreak);
                    }
                  : null,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 5.0.h),
                child: Row(
                  children: [
                    Expanded(
                      child: Lottie.asset(
                        'assets/images/tea_time.json',
                        height: 55.0.h,
                        width: 55.0.w,
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            inBreak ? "you're_in_break".tr() : "take_coffee".tr(),
                            style: TextStyle(fontSize: 16.r, fontWeight: FontWeight.w500, height: 1.5, letterSpacing: 0.5),
                          ),
                          Text(
                            inBreak
                                ? '${dashboardModel?.data?.config?.breakStatus?.breakTime}'
                                : isActive
                                    ? 'break'.tr()
                                    : 'check_in_first'.tr(),
                            style: TextStyle(
                              color: isActive ? Branding.colors.primaryLight : Colors.grey[500],
                              fontSize: isActive ? 16.r : 12.r,
                              fontWeight: FontWeight.w500,
                              height: 1.5,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
