import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meta_club_api/meta_club_api.dart';
import 'package:onesthrm/page/attendance/bloc/offline_attendance_bloc/offline_attendance_qubit.dart';
import 'package:onesthrm/page/attendance/bloc/offline_attendance_bloc/offline_attendance_state.dart';
import 'package:onesthrm/page/attendance_method/view/attendane_method_screen.dart';
import 'package:onesthrm/page/authentication/bloc/authentication_bloc.dart';
import 'package:onesthrm/page/home/bloc/bloc.dart';
import 'package:onesthrm/page/language/bloc/language_bloc.dart';
import 'package:user_repository/user_repository.dart';
import 'package:core/core.dart';

class PlutoCheckInOutCard extends StatelessWidget {
  final Settings? settings;
  final LoginData? user;
  final DashboardModel? dashboardModel;

  const PlutoCheckInOutCard(
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
          final isCheckedIn = offlineState.isCheckedIn;
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isCheckedIn
                    ? [colorDeepRed, colorDeepRed.withValues(alpha: 0.8)]
                    : [
                        Branding.colors.primaryLight,
                        Branding.colors.primaryDark
                      ],
              ),
              borderRadius: BorderRadius.circular(16.0),
              boxShadow: [
                BoxShadow(
                  color: (isCheckedIn
                          ? colorDeepRed
                          : Branding.colors.primaryLight)
                      .withValues(alpha: 0.3),
                  blurRadius: 8,
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
                  context.read<HomeBloc>().add(OnLocationRefresh(
                      user: context.read<AuthenticationBloc>().state.data?.user,
                      locationProvider: instance()));
                  Navigator.push(
                      context,
                      AttendanceMethodScreen.route(
                          homeBloc: context.read<HomeBloc>()));
                },
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 10.h, horizontal: 12.w),
                  child: Row(
                    children: [
                      Icon(
                        isCheckedIn
                            ? Icons.logout_rounded
                            : Icons.login_rounded,
                        color: Colors.white,
                        size: 20.r,
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              isCheckedIn == false
                                  ? "start_time".tr()
                                  : "done_for_today".tr(),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyle(
                                fontSize: 10.r,
                                color: Colors.white.withValues(alpha: 0.8),
                              ),
                            ),
                            Text(
                              isCheckedIn == false
                                  ? "check_in".tr()
                                  : "check_out".tr(),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13.r,
                                  fontWeight: FontWeight.w700),
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
        });
      },
    );
  }
}
