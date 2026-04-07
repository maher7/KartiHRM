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
              // Hint banner (matches partial leave design)
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                padding: EdgeInsets.all(12.r),
                decoration: BoxDecoration(
                  color: Branding.colors.primaryLight.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Branding.colors.primaryLight.withValues(alpha: 0.15)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline_rounded, color: Branding.colors.primaryLight, size: 20.r),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Text(
                        'full_day_leave_subtitle'.tr(),
                        style: TextStyle(fontSize: 12.r, color: Colors.black54, height: 1.3),
                      ),
                    ),
                  ],
                ),
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
                child: Text("leave_request".tr(),
                    style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.w700,
                        fontSize: 16.r)),
              ),
              SizedBox(height: 12.h),
              LeaveRequestList(userId: user!.user!.id!),
              SizedBox(height: 100.h),
            ],
          ),
        ),
      ),
    );
    },
    );
  }
}
