import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:onesthrm/page/daily_leave/bloc/daily_leave_event.dart';
import 'package:onesthrm/page/daily_leave/view/content/daily_leave_create/daily_leave_reason.dart';
import 'package:onesthrm/page/daily_leave/view/content/daily_leave_create/daily_leave_select_time.dart';
import 'package:core/core.dart';

import '../../../bloc/daily_leave_bloc.dart';
import '../../../bloc/daily_leave_state.dart';

class DailyLeaveApply extends StatelessWidget {
  const DailyLeaveApply({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Leave type selection header
            Text(
              'select_leave_type_and_time'.tr(),
              style: TextStyle(
                fontSize: 14.r,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 12.h),

            BlocBuilder<DailyLeaveBloc, DailyLeaveState>(
                builder: (BuildContext context, state) {
              return Column(
                children: [
                  ...List.generate(
                    context.read<DailyLeaveBloc>().leave?.length ?? 0,
                    (index) {
                      final leaveType = context.watch<DailyLeaveBloc>().leave?[index];
                      final isSelected = state.leaveTypeModel == leaveType;
                      return Container(
                        margin: EdgeInsets.only(bottom: 8.h),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Branding.colors.primaryLight.withValues(alpha: 0.06)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? Branding.colors.primaryLight
                                : Colors.grey.shade200,
                            width: isSelected ? 1.5 : 1,
                          ),
                        ),
                        child: RadioListTile(
                          contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 2.h),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          activeColor: Branding.colors.primaryLight,
                          title: Text(
                            leaveType?.title ?? '',
                            style: TextStyle(
                              fontSize: 14.r,
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                              color: isSelected ? Branding.colors.primaryLight : Colors.black87,
                            ),
                          ).tr(),
                          value: leaveType,
                          groupValue: state.leaveTypeModel,
                          onChanged: (value) {
                            context.read<DailyLeaveBloc>().add(SelectLeaveType(leaveTypeModel: value!));
                          },
                        ),
                      );
                    },
                  ),

                  /// leave time select
                  const DailyLeaveSelectTime(),
                ],
              );
            }),

            SizedBox(height: 8.h),

            // Reason header
            Text(
              'write_reason'.tr(),
              style: TextStyle(
                fontSize: 14.r,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 8.h),

            /// daily leave reason
            const DailyLeaveReason(),
          ],
        ),
      ),
    );
  }
}
