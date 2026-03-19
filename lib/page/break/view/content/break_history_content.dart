import 'package:core/core.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:onesthrm/page/break/bloc/break_bloc.dart';
import '../../../leave/view/content/general_list_shimmer.dart';

class BreakHistoryContent extends StatelessWidget {
  const BreakHistoryContent({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<BreakBloc>().state;

    if (state.status == NetworkStatus.loading) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            SizedBox(height: 16.h),
            RectangularCardShimmer(height: 30.h, width: 184.w),
            const GeneralListShimmer(),
          ],
        ),
      );
    } else if (state.status == NetworkStatus.success) {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "last_breaks".tr(),
              style: TextStyle(fontSize: 16.r, fontWeight: FontWeight.w700, color: Colors.black87),
            ),
            SizedBox(height: 12.h),
            if (state.breaks.isEmpty)
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20.h),
                child: Center(
                  child: Text(
                    'you_have_not_taken_a_break'.tr(),
                    style: TextStyle(fontSize: 13.r, color: Colors.black38),
                  ),
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: state.breaks.length,
                separatorBuilder: (context, index) => Divider(height: 1, color: Colors.grey.shade100),
                itemBuilder: (context, index) {
                  final todayHistory = state.breaks.elementAt(index);
                  final isInBreak = globalState.get(isBreak) == true && index == 0;
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    child: Row(
                      children: [
                        Container(
                          width: 4.w,
                          height: 36.h,
                          decoration: BoxDecoration(
                            color: isInBreak ? const Color(0xFFE8356C) : Branding.colors.primaryLight,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                todayHistory.reason ?? "Break Taken".tr(),
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13.r,
                                ),
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                "${todayHistory.breakTime ?? ''} - ${todayHistory.backTime ?? '...'}",
                                style: TextStyle(fontSize: 12.r, color: Colors.black45),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                          decoration: BoxDecoration(
                            color: (isInBreak ? const Color(0xFFE8356C) : Branding.colors.primaryLight)
                                .withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            todayHistory.duration ?? "...",
                            style: TextStyle(
                              fontSize: 12.r,
                              fontWeight: FontWeight.w600,
                              color: isInBreak ? const Color(0xFFE8356C) : Branding.colors.primaryLight,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
          ],
        ),
      );
    } else if (state.status == NetworkStatus.failure) {
      return Center(
        child: Text(
          "failed_to_load_break".tr(),
          style: TextStyle(
              color: Colors.black38,
              fontSize: 14.r,
              fontWeight: FontWeight.w500),
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
