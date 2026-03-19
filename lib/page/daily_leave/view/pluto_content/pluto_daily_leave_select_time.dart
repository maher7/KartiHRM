import 'package:core/core.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:onesthrm/page/daily_leave/bloc/daily_leave_bloc.dart';
import 'package:onesthrm/page/daily_leave/bloc/daily_leave_event.dart';

class PlutoDailyLeaveSelectTime extends StatelessWidget {
  const PlutoDailyLeaveSelectTime({super.key});

  @override
  Widget build(BuildContext context) {
    final approxTime = context.watch<DailyLeaveBloc>().state.approxTime;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          showTimePicker(context: context, initialTime: TimeOfDay.now()).then((value) {
            if (value != null) {
              var selectedTime = value.format(context);
              context.read<DailyLeaveBloc>().add(SelectApproxTime(selectedTime));
            }
          });
        },
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.r),
                decoration: BoxDecoration(
                  color: Branding.colors.primaryLight.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.access_time_rounded, size: 20.r, color: Branding.colors.primaryLight),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'select_time'.tr(),
                      style: TextStyle(fontSize: 11.r, color: Colors.grey.shade600),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      approxTime ?? 'time'.tr(),
                      style: TextStyle(
                        fontSize: 14.r,
                        fontWeight: FontWeight.w500,
                        color: approxTime != null ? Colors.black87 : Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, size: 20.r, color: Colors.grey.shade400),
            ],
          ),
        ),
      ),
    );
  }
}
