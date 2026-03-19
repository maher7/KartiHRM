import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:onesthrm/page/daily_leave/bloc/daily_leave_bloc.dart';

import 'package:core/core.dart';
import '../../../../res/nav_utail.dart';
import '../../../attendance/content/animated_circular_button.dart';
import '../../../authentication/bloc/authentication_bloc.dart';
import '../../bloc/daily_leave_event.dart';
import '../../bloc/daily_leave_state.dart';
import '../daily_create_page.dart';
import 'daily_leave_status/daily_leave_status_content.dart';

class DailyLeaveContent extends StatelessWidget {
  const DailyLeaveContent({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthenticationBloc>().state.data;
    return Scaffold(
      appBar: AppBar(
        title: Text(tr("partial_leave"), style: TextStyle(fontSize: 16.r),),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () {
                context.read<DailyLeaveBloc>().add(SelectDatePickerDailyLeave(user!.user!.id!, context));
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
      body: ListView(
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
          // Current date indicator
          BlocBuilder<DailyLeaveBloc, DailyLeaveState>(
            builder: (context, state) {
              final monthStr = state.currentMonth ?? getDateAsString(format: 'yyyy-MM', dateTime: DateTime.now()) ?? '';
              String displayDate;
              try {
                final parts = monthStr.split('-');
                final dt = DateTime(int.parse(parts[0]), int.parse(parts[1]));
                displayDate = getDateAsString(format: 'MMMM yyyy', dateTime: dt) ?? monthStr;
              } catch (_) {
                displayDate = monthStr;
              }
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 16.w),
                padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 16.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.date_range_rounded, color: Branding.colors.primaryLight, size: 18.r),
                    SizedBox(width: 8.w),
                    Text(
                      displayDate,
                      style: TextStyle(
                        fontSize: 15.r,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          AnimatedCircularButton(
              onComplete: () {
                NavUtil.navigateScreen(
                    context,
                    BlocProvider.value(
                      value: context.read<DailyLeaveBloc>(),
                      child: const DailyCreatePage(),
                    ));
              },
              title: "apply_partial_leave".tr(),
              color: Branding.colors.primaryLight),
          const DailyLeaveStatusContent()
        ],
      ),
    );
  }
}
