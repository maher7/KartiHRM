import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:onesthrm/page/daily_leave/bloc/daily_leave_bloc.dart';
import 'package:core/core.dart';

class DailyLeaveReason extends StatelessWidget {
  const DailyLeaveReason({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: context.read<DailyLeaveBloc>().reasonTextController,
      maxLines: 5,
      validator: (val) => val!.isEmpty ? "reason_can't_be_empty".tr() : null,
      style: TextStyle(fontSize: 14.r),
      decoration: InputDecoration(
        floatingLabelBehavior: FloatingLabelBehavior.always,
        contentPadding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 16.w),
        hintText: 'write_here'.tr(),
        hintStyle: TextStyle(fontSize: 13.r, color: Colors.black26),
        filled: true,
        fillColor: Colors.grey.shade50,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Branding.colors.primaryLight, width: 1.5),
          borderRadius: BorderRadius.circular(12.0),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade200),
          borderRadius: BorderRadius.circular(12.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade200),
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
    );
  }
}
