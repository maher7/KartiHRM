import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meta_club_api/meta_club_api.dart';
import 'package:onesthrm/page/attendance/bloc/offline_attendance_bloc/offline_attendance_qubit.dart';
import 'package:onesthrm/page/attendance/bloc/offline_attendance_bloc/offline_attendance_state.dart';
import 'package:onesthrm/page/break/break_route.dart';
import 'package:onesthrm/page/language/bloc/language_bloc.dart';
import 'package:user_repository/user_repository.dart';
import 'package:core/core.dart';

class PlutoBreakCard extends StatelessWidget {
  final Settings? settings;
  final LoginData? user;
  final DashboardModel? dashboardModel;

  const PlutoBreakCard(
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
            final attendance = dashboardModel?.data?.attendanceData;
            final isCheckedIn = offlineState.isCheckedIn || (attendance?.inTime?.isNotEmpty == true);
            final isCheckedOut = offlineState.isCheckedOut || (attendance?.outTime?.isNotEmpty == true);
            final isActive = isCheckedIn && !isCheckedOut;
            final inBreak = globalState.get(isBreak) == true;

            final List<Color> gradient = !isActive
                ? [const Color(0xFFE0E4EA), const Color(0xFFCFD4DD)]
                : inBreak
                    ? [const Color(0xFFE65100), const Color(0xFFFF8F00)]
                    : [Branding.colors.primaryLight, Branding.colors.primaryDark];
            final textColor = isActive ? Colors.white : Colors.grey.shade600;

            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: gradient,
                ),
                borderRadius: BorderRadius.circular(16.0),
                boxShadow: isActive
                    ? [
                        BoxShadow(
                          color: gradient.last.withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : null,
              ),
              child: Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(16.0),
                child: InkWell(
                  borderRadius: BorderRadius.circular(16.0),
                  onTap: isActive
                      ? () {
                          BreakRoute.breakOrQrCompanyRoute(context: context, inBreak: inBreak);
                        }
                      : null,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 12.w),
                    child: Row(
                      children: [
                        Icon(
                          inBreak
                              ? Icons.coffee_rounded
                              : Icons.free_breakfast_rounded,
                          color: textColor,
                          size: 20.r,
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                !isActive
                                    ? 'check_in_first'.tr()
                                    : inBreak
                                        ? "you're_in_break".tr()
                                        : "take_coffee".tr(),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: isActive
                                      ? Colors.white.withValues(alpha: 0.8)
                                      : Colors.grey.shade500,
                                  fontSize: 10.r,
                                ),
                              ),
                              Text(
                                inBreak
                                    ? dashboardModel?.data?.config?.breakStatus
                                            ?.breakTime ??
                                        ''
                                    : 'break'.tr(),
                                style: TextStyle(
                                  color: textColor,
                                  fontSize: 13.r,
                                  fontWeight: FontWeight.w700,
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
      },
    );
  }
}
