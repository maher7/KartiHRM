import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:onesthrm/page/authentication/bloc/authentication_bloc.dart';
import 'package:onesthrm/page/daily_leave/bloc/daily_leave_bloc.dart';
import 'package:onesthrm/page/daily_leave/model/leave_list_model.dart';
import 'package:onesthrm/page/daily_leave/view/pluto_content/pluto_daily_leave_tile.dart';
import 'package:onesthrm/page/daily_leave/view/pluto_content/pluto_leave_type_screen.dart';
import 'package:onesthrm/res/nav_utail.dart';

class PlutoDailyLeaveReject extends StatelessWidget {
  const PlutoDailyLeaveReject({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthenticationBloc>().state.data;
    final dailyLeaveBloc = context.read<DailyLeaveBloc>();
    final rejected = dailyLeaveBloc.state.dailyLeaveSummaryModel?.dailyLeaveSummaryData?.rejected;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 16.h),
        Text("rejected_leave".tr(), style: TextStyle(fontSize: 15.r, fontWeight: FontWeight.w700, color: Colors.black87)),
        SizedBox(height: 8.h),
        Row(
          children: [
            Expanded(
              child: PlutoDailyLeaveTile(
                onTap: () {
                  NavUtil.navigateScreen(context, BlocProvider.value(value: context.read<DailyLeaveBloc>(),
                    child: PlutoLeaveTypeScreen(appBarName: "early_leave".tr(),
                      leaveListData: LeaveListModel(userId: user!.user!.id!.toString(), month: '',
                          leaveStatus: 'rejected', leaveType: "early_leave"),
                    ),
                  ),
                  );
                },
                title: 'early_leave'.tr(), value: rejected?.earlyLeave.toString() ?? '', color: const Color(0xFFE53935),
              ),
            ),
            SizedBox(width: 12.w,),
            Expanded(
              child: PlutoDailyLeaveTile(
                onTap: () {
                  NavUtil.navigateScreen(context, BlocProvider.value(value: context.read<DailyLeaveBloc>(),
                        child: PlutoLeaveTypeScreen(appBarName: "late_leave".tr(), leaveListData: LeaveListModel(userId: user!.user!.id!.toString(), month: '',
                              leaveStatus: 'rejected', leaveType: "late_arrive"),
                        )),
                  );
                },
                title: 'late_leave'.tr(), value: rejected?.lateArrive.toString() ?? '', color: const Color(0xFFE53935),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
