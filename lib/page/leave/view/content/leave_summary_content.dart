import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:onesthrm/page/attendance/content/animated_circular_button.dart';
import 'package:onesthrm/page/authentication/bloc/authentication_bloc.dart';
import 'package:onesthrm/page/home/bloc/home_bloc.dart';
import 'package:onesthrm/page/language/bloc/language_bloc.dart';
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
    return BlocBuilder<LanguageBloc, LanguageState>(
      builder: (context, _) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "full_day_leave".tr(),
          style: TextStyle(fontSize: 16.r),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          final bloc = context.read<LeaveBloc>();
          bloc.add(LeaveSummaryApi(user!.user!.id!));
          bloc.add(LeaveRequest(user.user!.id!));
          await bloc.stream.firstWhere((s) => s.status != NetworkStatus.loading);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
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
              // Leave request header with month picker
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("leave_request".tr(),
                        style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.w700,
                            fontSize: 16.r)),
                    BlocBuilder<LeaveBloc, LeaveState>(
                      builder: (context, state) {
                        final monthStr = state.currentMonth ?? getDateAsString(format: 'y-MM', dateTime: DateTime.now()) ?? '';
                        String displayDate;
                        try {
                          final parts = monthStr.split('-');
                          final dt = DateTime(int.parse(parts[0]), int.parse(parts[1]));
                          displayDate = getDateAsString(format: 'MMM yyyy', dateTime: dt) ?? monthStr;
                        } catch (_) {
                          displayDate = monthStr;
                        }
                        return InkWell(
                          borderRadius: BorderRadius.circular(20),
                          onTap: () {
                            context.read<LeaveBloc>().add(SelectDatePicker(user!.user!.id!, context));
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                            decoration: BoxDecoration(
                              color: Branding.colors.primaryLight.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.calendar_month_rounded, color: Branding.colors.primaryLight, size: 14.r),
                                SizedBox(width: 4.w),
                                Text(displayDate, style: TextStyle(color: Branding.colors.primaryLight, fontSize: 12.r, fontWeight: FontWeight.w500)),
                                SizedBox(width: 2.w),
                                Icon(Icons.arrow_drop_down_rounded, color: Branding.colors.primaryLight, size: 16.r),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 12.h),
              LeaveRequestList(userId: user!.user!.id!)
            ],
          ),
        ),
      ),
    );
    },
    );
  }
}
