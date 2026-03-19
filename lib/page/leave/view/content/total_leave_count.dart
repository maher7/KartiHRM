import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:core/core.dart';
import 'package:onesthrm/page/leave/bloc/leave_bloc/leave_bloc.dart';

class TotalLeaveCount extends StatelessWidget {
  const TotalLeaveCount({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LeaveBloc, LeaveState>(builder: (context, state) {
      final total = state.leaveSummaryModel?.leaveSummaryData?.totalLeave?.toString() ?? "0";
      final used = state.leaveSummaryModel?.leaveSummaryData?.totalUsed?.toString() ?? "0";
      final balance = state.leaveSummaryModel?.leaveSummaryData?.leaveBalance?.toString() ?? "0";

      return Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 12.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            _buildStatColumn(
              value: total,
              label: "total_leaves".tr(),
              color: Branding.colors.primaryLight,
            ),
            _buildDivider(),
            _buildStatColumn(
              value: used,
              label: "leaves_used".tr(),
              color: const Color(0xFFE53935),
            ),
            _buildDivider(),
            _buildStatColumn(
              value: balance,
              label: "leave_balance".tr(),
              color: deepColorGreen,
            ),
          ],
        ),
      );
    });
  }

  Widget _buildStatColumn({
    required String value,
    required String label,
    required Color color,
  }) {
    return Expanded(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              value,
              style: TextStyle(
                fontSize: 22.r,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            label,
            style: TextStyle(
              fontSize: 11.r,
              color: Colors.black45,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 40.h,
      width: 1,
      color: Colors.black.withValues(alpha: 0.08),
    );
  }
}
