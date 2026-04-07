import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:onesthrm/page/attendance/content/animated_circular_button.dart';
import 'package:onesthrm/page/authentication/bloc/authentication_bloc.dart';
import 'package:onesthrm/page/daily_leave/bloc/daily_leave_bloc.dart';
import 'package:onesthrm/page/language/bloc/language_bloc.dart';
import 'package:core/core.dart';
import 'package:onesthrm/page/daily_leave/bloc/daily_leave_event.dart';
import 'package:onesthrm/page/daily_leave/view/pluto_content/pluto_daily_leave_status_content.dart';
import 'package:onesthrm/page/daily_leave/view/pluto_daily_create_page.dart';
import 'package:onesthrm/res/nav_utail.dart';


class PlutoDailyLeaveContent extends StatelessWidget {
  const PlutoDailyLeaveContent({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthenticationBloc>().state.data;
    return BlocBuilder<LanguageBloc, LanguageState>(
      builder: (context, _) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: () async {
          final bloc = context.read<DailyLeaveBloc>();
          bloc.add(DailyLeaveSummary(user!.user!.id!));
          await bloc.stream.firstWhere((s) => s.status != NetworkStatus.loading);
        },
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            // Explanation banner
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
                      'daily_leave_subtitle'.tr(),
                      style: TextStyle(fontSize: 12.r, color: Colors.black54, height: 1.3),
                    ),
                  ),
                ],
              ),
            ),
            // Apply button
            AnimatedCircularButton(
              onComplete: () {
                NavUtil.navigateScreen(context, BlocProvider.value(value: context.read<DailyLeaveBloc>(), child: const PlutoDailyCreatePage()));
              },
              title: "apply_partial_leave".tr(), color: Branding.colors.primaryLight,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: Text(
                'history'.tr(),
                style: TextStyle(fontSize: 15.r, fontWeight: FontWeight.w700, color: Colors.black87),
              ),
            ),
            const PlutoDailyLeaveStatusContent()
          ],
        ),
      ),
    );
    },
    );
  }
}
