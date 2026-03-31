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
            // Tappable date selector
            BlocBuilder<DailyLeaveBloc, DailyLeaveState>(
              builder: (context, state) {
                final date = state.selectedDate ?? DateTime.now();
                return GestureDetector(
                  onTap: () async {
                    final bloc = context.read<DailyLeaveBloc>();
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: date,
                      firstDate: DateTime.now().subtract(const Duration(days: 7)),
                      lastDate: DateTime.now().add(const Duration(days: 30)),
                    );
                    if (picked != null) {
                      bloc.add(SelectLeaveDate(picked));
                    }
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                    padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(8.r),
                          decoration: BoxDecoration(
                            color: Branding.colors.primaryLight.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(Icons.calendar_today_rounded, size: 18.r, color: Branding.colors.primaryLight),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'date'.tr(),
                                style: TextStyle(fontSize: 11.r, color: Colors.grey.shade600),
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                getDateAsString(format: 'EEEE, dd MMM yyyy', dateTime: date) ?? '',
                                style: TextStyle(fontSize: 14.r, fontWeight: FontWeight.w500, color: Colors.black87),
                              ),
                            ],
                          ),
                        ),
                        Icon(Icons.chevron_right_rounded, size: 20.r, color: Colors.grey.shade400),
                      ],
                    ),
                  ),
                );
              },
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
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
