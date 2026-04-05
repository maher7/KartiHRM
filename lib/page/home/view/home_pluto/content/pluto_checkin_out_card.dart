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
            final attendance = dashboardModel?.data?.attendanceData;
            final inTime = attendance?.inTime;
            final outTime = attendance?.outTime;
            final isCheckedIn = offlineState.isCheckedIn || (inTime?.isNotEmpty == true);
            final isCheckedOut = offlineState.isCheckedOut || (outTime?.isNotEmpty == true);
            final isDoneForToday = isCheckedIn && isCheckedOut;
            final needsAction = !isDoneForToday;

            // State-specific styling
            final List<Color> gradient = !needsAction
                ? [const Color(0xFFE0E4EA), const Color(0xFFCFD4DD)]
                : !isCheckedIn
                    ? [Branding.colors.primaryLight, Branding.colors.primaryDark]
                    : [colorDeepRed, colorDeepRed.withValues(alpha: 0.85)];

            final actionLabel = isDoneForToday
                ? 'done_for_today'.tr()
                : !isCheckedIn
                    ? 'check_in'.tr()
                    : 'check_out'.tr();

            final statusLabel = isDoneForToday
                ? ''
                : !isCheckedIn
                    ? 'start_time'.tr()
                    : 'checked_in_at'.tr();

            final timeHint = isDoneForToday
                ? '${'in'.tr()} $inTime · ${'out'.tr()} $outTime'
                : isCheckedIn
                    ? inTime ?? ''
                    : '';

            final icon = isDoneForToday
                ? Icons.check_circle_rounded
                : !isCheckedIn
                    ? Icons.login_rounded
                    : Icons.logout_rounded;

            final textColor = needsAction ? Colors.white : Colors.grey.shade600;

            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: gradient,
                ),
                borderRadius: BorderRadius.circular(16.0),
                boxShadow: needsAction
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
                  onTap: needsAction
                      ? () {
                          context.read<HomeBloc>().add(OnLocationRefresh(
                              user: context.read<AuthenticationBloc>().state.data?.user,
                              locationProvider: instance()));
                          Navigator.push(
                              context,
                              AttendanceMethodScreen.route(
                                  homeBloc: context.read<HomeBloc>()));
                        }
                      : null,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 12.w),
                    child: Row(
                      children: [
                        Icon(icon, color: textColor, size: 20.r),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (statusLabel.isNotEmpty)
                                Text(
                                  statusLabel,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: TextStyle(
                                    fontSize: 10.r,
                                    color: needsAction
                                        ? Colors.white.withValues(alpha: 0.8)
                                        : Colors.grey.shade500,
                                  ),
                                ),
                              Text(
                                actionLabel,
                                style: TextStyle(
                                  color: textColor,
                                  fontSize: 13.r,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              if (timeHint.isNotEmpty) ...[
                                SizedBox(height: 2.h),
                                Text(
                                  timeHint,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: TextStyle(
                                    fontSize: 9.r,
                                    fontWeight: FontWeight.w500,
                                    color: needsAction
                                        ? Colors.white.withValues(alpha: 0.75)
                                        : Colors.grey.shade500,
                                  ),
                                ),
                              ],
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
