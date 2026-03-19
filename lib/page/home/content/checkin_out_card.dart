import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:meta_club_api/meta_club_api.dart';
import 'package:onesthrm/page/attendance/bloc/offline_attendance_bloc/offline_attendance_qubit.dart';
import 'package:onesthrm/page/attendance/bloc/offline_attendance_bloc/offline_attendance_state.dart';
import 'package:onesthrm/page/attendance_method/view/attendane_method_screen.dart';
import 'package:onesthrm/page/home/bloc/bloc.dart';
import 'package:user_repository/user_repository.dart';
import 'package:core/core.dart';
import '../../authentication/bloc/authentication_bloc.dart';

class CheckInOutCard extends StatelessWidget {
  final Settings? settings;
  final LoginData? user;
  final DashboardModel? dashboardModel;

  const CheckInOutCard({super.key, required this.settings, required this.user, required this.dashboardModel});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OfflineCubit, OfflineAttendanceState>(builder: (context, offlineState) {
      final isCheckedIn = offlineState.isCheckedIn;
      return Container(
        margin: EdgeInsets.symmetric(vertical: 8.0.h, horizontal: 16.0),
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
              context.read<HomeBloc>().add(OnLocationRefresh(
                  user: context.read<AuthenticationBloc>().state.data?.user, locationProvider: instance()));
              Navigator.push(context, AttendanceMethodScreen.route(homeBloc: context.read<HomeBloc>()));
            },
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 20.0),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(12.r),
                    decoration: BoxDecoration(
                      color: (isCheckedIn ? colorDeepRed : Branding.colors.primaryLight).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: SvgPicture.asset(
                      isCheckedIn == offlineState.isCheckedOut
                          ? 'assets/home_icon/in.svg'
                          : 'assets/home_icon/out.svg',
                      height: 28.h,
                      width: 28.w,
                      colorFilter: ColorFilter.mode(
                        isCheckedIn ? colorDeepRed : Branding.colors.primaryLight,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isCheckedIn == false ? "start_time".tr() : "done_for_today".tr(),
                          style: TextStyle(
                            fontSize: 15.r,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          isCheckedIn == false ? "check_in".tr() : "check_out".tr(),
                          style: TextStyle(
                            color: isCheckedIn ? colorDeepRed : Branding.colors.primaryLight,
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
      );
    });
  }
}
