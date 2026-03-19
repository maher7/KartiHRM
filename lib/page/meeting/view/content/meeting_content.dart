import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:onesthrm/page/appointment/appoinment_list/content/upcoming_event_widgetg.dart';
import 'package:onesthrm/page/leave/view/content/general_list_shimmer.dart';
import 'package:onesthrm/page/meeting/bloc/meeting_bloc.dart';
import 'package:onesthrm/page/meeting/view/meeting_create_page/meeting_create_page.dart';
import 'package:onesthrm/page/meeting/view/meeting_details_page/meeting_details_page.dart';
import 'package:core/core.dart';
import 'package:onesthrm/res/nav_utail.dart';

class MeetingContent extends StatelessWidget {
  const MeetingContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: Branding.colors.primaryLight,
          onPressed: () {
            NavUtil.navigateScreen(context, BlocProvider.value(value: context.read<MeetingBloc>(), child: const MeetingCreatePage()));
          },
          child: const Icon(Icons.add, color: Colors.white),
        ),
        appBar: AppBar(
          title: const Text("meeting_list").tr(),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () {
                  context.read<MeetingBloc>().add(SelectDatePicker(context));
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.calendar_month_rounded, color: Colors.white, size: 16),
                      const SizedBox(width: 4),
                      Text('select_month'.tr(), style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        body: BlocBuilder<MeetingBloc, MeetingState>(
          builder: (BuildContext context, state) {
            if (state.status == NetworkStatus.loading) {
              return const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: GeneralListShimmer(),
              );
            } else if (state.status == NetworkStatus.success) {
              return Column(
                children: [
                  state.meetingsListResponse?.data?.items?.isNotEmpty == true
                      ? Expanded(
                          child: ListView.builder(
                            shrinkWrap: true,
                            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                            itemCount: state.meetingsListResponse?.data?.items?.length ?? 0,
                            itemBuilder: (BuildContext context, int index) {
                              final data = state.meetingsListResponse?.data?.items?[index];
                              return Container(
                                margin: EdgeInsets.only(bottom: 6.h),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.grey.shade100),
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(12),
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(12),
                                    onTap: () {
                                      NavUtil.navigateScreen(context,
                                          MeetingDetailsPage(data: data));
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.all(4.r),
                                      child: EventWidgets(
                                          isAppointment: true, data: data!),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                      : const Expanded(
                          child: NoDataFoundWidget(title: 'no_meeting_found'),
                        )
                ],
              );
            } else if (state.status == NetworkStatus.failure) {
              return Center(
                child: Text(
                  "failed_to_load_meeting_list".tr(),
                  style: TextStyle(
                      color: Colors.black38,
                      fontSize: 14.r,
                      fontWeight: FontWeight.w500),
                ),
              );
            } else {
              return const SizedBox();
            }
          },
        ));
  }
}
