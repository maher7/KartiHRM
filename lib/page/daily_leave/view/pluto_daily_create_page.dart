import 'package:core/core.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:onesthrm/page/authentication/bloc/authentication_bloc.dart';
import 'package:onesthrm/page/daily_leave/bloc/daily_leave_bloc.dart';
import 'package:onesthrm/page/daily_leave/bloc/daily_leave_event.dart';
import 'package:onesthrm/page/daily_leave/view/pluto_content/pluto_daily_leave_apply.dart';


class PlutoDailyCreatePage extends StatelessWidget {
  const PlutoDailyCreatePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthenticationBloc>().state.data;
    final bloc = context.watch<DailyLeaveBloc>();
    final formKey = GlobalKey<FormState>();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text(tr("partial_leave"), style: const TextStyle(color: Colors.black)),
        backgroundColor: Colors.white, iconTheme: IconThemeData(color: Branding.colors.textPrimary),),
      body: Form(
        key: formKey,
        child: Column(
          children: [
            /// apply daily leaves
            const PlutoDailyLeaveApply(),

            /// daily leave action button
            Container(
              padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 12.h, bottom: 12.h),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 8, offset: const Offset(0, -2)),
                ],
              ),
              child: SafeArea(
                top: false,
                child: SizedBox(
                  width: double.infinity,
                  height: 48.h,
                  child: ElevatedButton(
                    onPressed: bloc.state.status == NetworkStatus.loading
                        ? null
                        : () {
                      if (formKey.currentState!.validate() && bloc.state.status == NetworkStatus.success) {
                        context.read<DailyLeaveBloc>().add(ApplyLeave(userId: user!.user!.id!, context: context));
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Branding.colors.primaryLight,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                    child: bloc.state.status == NetworkStatus.loading
                        ? SizedBox(width: 20.r, height: 20.r, child: const CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                        : Text("apply".tr(), style: TextStyle(fontSize: 16.r, fontWeight: FontWeight.w600)),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
