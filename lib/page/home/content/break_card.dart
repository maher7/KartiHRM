import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:meta_club_api/meta_club_api.dart';
import 'package:onesthrm/page/attendance/bloc/offline_attendance_bloc/offline_attendance_qubit.dart';
import 'package:onesthrm/page/attendance/bloc/offline_attendance_bloc/offline_attendance_state.dart';
import 'package:onesthrm/page/break/break_route.dart';
import 'package:onesthrm/page/language/bloc/language_bloc.dart';
import 'package:user_repository/user_repository.dart';
import 'package:core/core.dart';

class BreakCard extends StatelessWidget {
  final Settings? settings;
  final LoginData? user;
  final DashboardModel? dashboardModel;

  const BreakCard(
      {super.key,
      required this.settings,
      required this.user,
      required this.dashboardModel});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageBloc, LanguageState>(
      builder: (context, _) {
        return BlocBuilder<OfflineCubit, OfflineAttendanceState>(
            builder: (context, offlineState) {
          return offlineState.isCheckedIn
              ? Container(
                  margin:
                      EdgeInsets.symmetric(vertical: 4.0.h, horizontal: 16.0),
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
                  child: Material(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(16.0),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16.0),
                      onTap: () {
                        BreakRoute.breakOrQrCompanyRoute(
                            context: context,
                            inBreak: globalState.get(isBreak) == true);
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 12.h, horizontal: 20.0),
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(8.r),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFF3E0),
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: Lottie.asset(
                                'assets/images/tea_time.json',
                                height: 32.h,
                                width: 32.w,
                              ),
                            ),
                            SizedBox(width: 16.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    globalState.get(isBreak) == true
                                        ? "you're_in_break".tr()
                                        : "take_coffee".tr(),
                                    style: TextStyle(
                                      fontSize: 15.r,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  SizedBox(height: 2.h),
                                  Text(
                                    globalState.get(isBreak) == true
                                        ? dashboardModel?.data?.config
                                                ?.breakStatus?.breakTime ??
                                            ''
                                        : 'break'.tr(),
                                    style: TextStyle(
                                      color: const Color(0xFFE65100),
                                      fontSize: 13.r,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 16.r,
                              color: Colors.black26,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              : const SizedBox.shrink();
        });
      },
    );
  }
}
