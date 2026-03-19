import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:onesthrm/page/daily_leave/bloc/daily_leave_bloc.dart';
import 'package:onesthrm/page/daily_leave/bloc/daily_leave_event.dart';
import 'package:core/core.dart';

class DailyLeaveSelectTime extends StatelessWidget {
  const DailyLeaveSelectTime({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final approxTime = context.watch<DailyLeaveBloc>().state.approxTime;
    return Container(
      margin: EdgeInsets.only(top: 8.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 2.h),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        onTap: () {
          showTimePicker(context: context, initialTime: TimeOfDay.now())
              .then((value) {
            if (value != null) {
              var selectedTime = value.format(context);
              context
                  .read<DailyLeaveBloc>()
                  .add(SelectApproxTime(selectedTime));
            }
          });
        },
        leading: Container(
          padding: EdgeInsets.all(8.r),
          decoration: BoxDecoration(
            color: Branding.colors.primaryLight.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(Icons.access_time_rounded, size: 20.r, color: Branding.colors.primaryLight),
        ),
        title: Text(
          'approximate_time'.tr(),
          style: TextStyle(fontSize: 12.r, color: Colors.black45),
        ),
        subtitle: Text(
          approxTime ?? 'select_time'.tr(),
          style: TextStyle(
            fontSize: 14.r,
            fontWeight: approxTime != null ? FontWeight.w600 : FontWeight.w400,
            color: approxTime != null ? Colors.black87 : Colors.black26,
          ),
        ),
        trailing: Icon(
          Icons.keyboard_arrow_down_rounded,
          size: 22.r,
          color: Colors.black38,
        ),
      ),
    );
  }
}
