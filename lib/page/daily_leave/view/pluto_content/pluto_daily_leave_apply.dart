import 'package:core/core.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:onesthrm/page/daily_leave/bloc/daily_leave_bloc.dart';
import 'package:onesthrm/page/daily_leave/bloc/daily_leave_event.dart';
import 'package:onesthrm/page/daily_leave/bloc/daily_leave_state.dart';
import 'package:onesthrm/page/daily_leave/view/pluto_content/pluto_daily_leave_reason.dart';
import 'package:onesthrm/page/daily_leave/view/pluto_content/pluto_daily_leave_select_time.dart';


class PlutoDailyLeaveApply extends StatelessWidget {
  const PlutoDailyLeaveApply({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              child: Text(
                "select_time".tr(),
                style: TextStyle(fontSize: 14.r, fontWeight: FontWeight.w600, color: Colors.black87),
              ),
            ),
            BlocBuilder<DailyLeaveBloc, DailyLeaveState>(
                builder: (BuildContext context, state) {
                  return Column(
                    children: [
                      ...List.generate(
                        context.read<DailyLeaveBloc>().leave?.length ?? 0,
                            (index) {
                          final leaveType = context.watch<DailyLeaveBloc>().leave?[index];
                          final isSelected = state.leaveTypeModel == leaveType;
                          return GestureDetector(
                            onTap: () {
                              if (leaveType != null) {
                                context.read<DailyLeaveBloc>().add(SelectLeaveType(leaveTypeModel: leaveType));
                              }
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
                              decoration: BoxDecoration(
                                color: isSelected ? Branding.colors.primaryLight.withValues(alpha: 0.08) : Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isSelected ? Branding.colors.primaryLight : Colors.grey.shade300,
                                  width: isSelected ? 2 : 1,
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 20.r,
                                      height: 20.r,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: isSelected ? Branding.colors.primaryLight : Colors.grey.shade400,
                                          width: 2,
                                        ),
                                      ),
                                      child: isSelected
                                          ? Center(
                                        child: Container(
                                          width: 10.r,
                                          height: 10.r,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Branding.colors.primaryLight,
                                          ),
                                        ),
                                      )
                                          : null,
                                    ),
                                    SizedBox(width: 12.w),
                                    Expanded(
                                      child: Text(
                                        leaveType?.title ?? '',
                                        style: TextStyle(
                                          fontSize: 14.r,
                                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                                          color: isSelected ? Branding.colors.primaryLight : Colors.black87,
                                        ),
                                      ).tr(),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 8.h),
                      /// leave time select
                      const PlutoDailyLeaveSelectTime(),
                    ],
                  );
                }),
            SizedBox(height: 8.h),
            /// daily leave reason
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Text(
                "write_reason".tr(),
                style: TextStyle(fontSize: 14.r, fontWeight: FontWeight.w600, color: Colors.black87),
              ),
            ),
            SizedBox(height: 4.h),
            const PlutoDailyLeaveReason(),
          ],
        ),
      ),
    );
  }
}
