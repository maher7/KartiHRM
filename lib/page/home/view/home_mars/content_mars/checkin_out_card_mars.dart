import 'package:core/core.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meta_club_api/meta_club_api.dart';
import 'package:onesthrm/page/attendance/bloc/offline_attendance_bloc/offline_attendance_qubit.dart';
import 'package:onesthrm/page/attendance_method/view/attendane_method_screen.dart';
import 'package:onesthrm/page/home/bloc/bloc.dart';
import 'package:user_repository/user_repository.dart';
import '../../../../attendance/bloc/offline_attendance_bloc/offline_attendance_state.dart';
import '../../../../authentication/bloc/authentication_bloc.dart';

class CheckInOutCardMars extends StatelessWidget {
  final Settings? settings;
  final LoginData? user;
  final DashboardModel? dashboardModel;

  const CheckInOutCardMars(
      {super.key,
      required this.settings,
      required this.user,
      required this.dashboardModel});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OfflineCubit, OfflineAttendanceState>(
      builder: (context, offlineState) {
        final attendance = dashboardModel?.data?.attendanceData;
        final inTime = attendance?.inTime;
        final outTime = attendance?.outTime;

        // State logic:
        // - no inTime → needs Check In (primary)
        // - inTime + no outTime → currently working, can Check Out (primary)
        // - inTime + outTime → done for today (muted)
        final isCheckedIn = offlineState.isCheckedIn || (inTime != null && inTime.isNotEmpty);
        final isCheckedOut = offlineState.isCheckedOut || (outTime != null && outTime.isNotEmpty);
        final isDoneForToday = isCheckedIn && isCheckedOut;
        final needsAction = !isDoneForToday;

        final actionLabel = !isCheckedIn ? 'check_in'.tr() : 'check_out'.tr();
        final statusLabel = isDoneForToday
            ? 'done_for_today'.tr()
            : !isCheckedIn
                ? 'ready_to_start'.tr()
                : 'working_now'.tr();

        // Show the appropriate time pill
        final timeDetail = isDoneForToday
            ? '${'in'.tr()} $inTime · ${'out'.tr()} $outTime'
            : isCheckedIn
                ? '${'checked_in_at'.tr()} $inTime'
                : '';

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 4.h),
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(14.r),
            child: InkWell(
              borderRadius: BorderRadius.circular(14.r),
              onTap: needsAction
                  ? () {
                      context.read<HomeBloc>().add(OnLocationRefresh(
                          user: context.read<AuthenticationBloc>().state.data?.user,
                          locationProvider: instance()));
                      Navigator.push(context, AttendanceMethodScreen.route(homeBloc: context.read<HomeBloc>()));
                    }
                  : null,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                decoration: BoxDecoration(
                  gradient: needsAction
                      ? LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Branding.colors.primaryDark,
                            Branding.colors.primaryLight,
                          ],
                        )
                      : null,
                  color: needsAction ? null : const Color(0xFFF1F3F8),
                  borderRadius: BorderRadius.circular(14.r),
                  boxShadow: needsAction
                      ? [
                          BoxShadow(
                            color: Branding.colors.primaryDark.withValues(alpha: 0.25),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : null,
                ),
                child: Row(
                  children: [
                    Container(
                      height: 48.r,
                      width: 48.r,
                      decoration: BoxDecoration(
                        color: needsAction
                            ? Colors.white.withValues(alpha: 0.22)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Icon(
                        isDoneForToday
                            ? Icons.check_circle_rounded
                            : !isCheckedIn
                                ? Icons.login_rounded
                                : Icons.logout_rounded,
                        color: needsAction ? Colors.white : Colors.grey[500],
                        size: 26.r,
                      ),
                    ),
                    SizedBox(width: 14.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              Text(
                                statusLabel,
                                style: TextStyle(
                                  fontSize: 12.r,
                                  fontWeight: FontWeight.w500,
                                  color: needsAction
                                      ? Colors.white.withValues(alpha: 0.85)
                                      : Colors.grey[600],
                                ),
                              ),
                              if (needsAction) ...[
                                SizedBox(width: 6.w),
                                _PulsingDot(color: Colors.white),
                              ],
                            ],
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            isDoneForToday
                                ? 'done_for_today'.tr()
                                : actionLabel,
                            style: TextStyle(
                              fontSize: 17.r,
                              fontWeight: FontWeight.w700,
                              color: needsAction ? Colors.white : Colors.grey[500],
                            ),
                          ),
                          if (timeDetail.isNotEmpty) ...[
                            SizedBox(height: 3.h),
                            Text(
                              timeDetail,
                              style: TextStyle(
                                fontSize: 11.r,
                                color: needsAction
                                    ? Colors.white.withValues(alpha: 0.8)
                                    : Colors.grey[500],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    if (needsAction)
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: Colors.white.withValues(alpha: 0.85),
                        size: 14.r,
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

class _PulsingDot extends StatefulWidget {
  const _PulsingDot({required this.color});
  final Color color;

  @override
  State<_PulsingDot> createState() => _PulsingDotState();
}

class _PulsingDotState extends State<_PulsingDot> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: Tween(begin: 0.4, end: 1.0).animate(_controller),
      child: Container(
        width: 6,
        height: 6,
        decoration: BoxDecoration(
          color: widget.color,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
