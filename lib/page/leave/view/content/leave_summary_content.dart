import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:onesthrm/page/attendance/content/animated_circular_button.dart';
import 'package:onesthrm/page/authentication/bloc/authentication_bloc.dart';
import 'package:onesthrm/page/home/bloc/home_bloc.dart';
import 'package:onesthrm/page/leave/bloc/leave_bloc/leave_bloc.dart';
import 'package:onesthrm/page/leave/view/content/leave_request_list.dart';
import 'package:onesthrm/page/leave/view/content/total_leave_count.dart';
import 'package:onesthrm/page/leave/view/leave_type/leave_request_type.dart';
import 'package:core/core.dart';
import 'package:onesthrm/res/nav_utail.dart';
import '../../../attendance/tab_content/tab_animated_circular_button.dart';

class LeaveSummaryContent extends StatelessWidget {
  final LeaveState? state;

  const LeaveSummaryContent({super.key, this.state});

  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthenticationBloc>().state.data;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "full_day_leave".tr(),
          style: TextStyle(fontSize: 16.r),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () {
                context.read<LeaveBloc>().add(SelectDatePicker(user!.user!.id!, context));
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.calendar_month_rounded, color: Colors.white, size: 16),
                    const SizedBox(width: 4),
                    Text('select_month'.tr(), style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 20,
            ),
            DeviceUtil.isTablet
                ? TabAnimatedCircularButton(
                    onComplete: () {
                      NavUtil.navigateScreen(
                          context,
                          MultiBlocProvider(providers: [
                            BlocProvider.value(value: context.read<HomeBloc>()),
                            BlocProvider.value(value: context.read<LeaveBloc>()),
                          ], child: const LeaveRequestType()));
                    },
                    title: "apply_leave".tr(),
                    color: Branding.colors.primaryLight,
                  )
                : AnimatedCircularButton(
                    onComplete: () {
                      NavUtil.navigateScreen(
                          context,
                          MultiBlocProvider(providers: [
                            BlocProvider.value(value: context.read<LeaveBloc>()),
                            BlocProvider.value(value: context.read<HomeBloc>())
                          ], child: const LeaveRequestType()));
                    },
                    title: "apply_leave".tr(),
                    color: Branding.colors.primaryLight),
            SizedBox(height: 16.h),
            const TotalLeaveCount(),
            SizedBox(height: 8.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                children: [
                  Text("leave_request".tr(),
                      style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.w700,
                          fontSize: 16.r)),
                ],
              ),
            ),
            SizedBox(height: 12.h),
            LeaveRequestList(userId: user!.user!.id!)
          ],
        ),
      ),
    );
  }
}
