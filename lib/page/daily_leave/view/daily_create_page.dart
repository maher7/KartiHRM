import 'package:core/core.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onesthrm/page/authentication/bloc/authentication_bloc.dart';
import 'package:onesthrm/page/daily_leave/bloc/daily_leave_bloc.dart';
import 'package:onesthrm/page/daily_leave/bloc/daily_leave_event.dart';
import 'package:onesthrm/page/daily_leave/view/content/daily_leave_create/daily_leave_apply.dart';

class DailyCreatePage extends StatelessWidget {
  const DailyCreatePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthenticationBloc>().state.data;
    final bloc = context.watch<DailyLeaveBloc>();
    final formKey = GlobalKey<FormState>();
    return Scaffold(
      appBar: AppBar(
        title: Text(tr("partial_leave")),
      ),
      body: Form(
        key: formKey,
        child: Column(
          children: [
            /// apply daily leaves
            const DailyLeaveApply(),

            /// daily leave action button
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: SafeArea(
                top: false,
                child: SizedBox(
                  width: double.infinity,
                  height: 48,
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
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                    child: bloc.state.status == NetworkStatus.loading
                        ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : Text("apply".tr(), style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600)),
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
