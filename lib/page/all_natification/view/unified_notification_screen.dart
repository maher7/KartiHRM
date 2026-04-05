import 'package:core/core.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meta_club_api/meta_club_api.dart';
import 'package:onesthrm/page/all_natification/bloc/notification_bloc.dart' as nb;
import 'package:onesthrm/page/all_natification/content/notification_cart_content.dart';
import 'package:onesthrm/page/notice_details/view/notice_details_screen.dart';
import 'package:onesthrm/page/notice_list/bloc/notice_list_bloc.dart' as nlb;
import 'package:onesthrm/page/notice_list/content/notice_list_content.dart';
import 'package:onesthrm/res/nav_utail.dart';
import 'package:onesthrm/res/widgets/screen_header.dart';

/// Unified screen with two tabs: Notifications and Announcements.
class UnifiedNotificationScreen extends StatelessWidget {
  final int initialTab;

  const UnifiedNotificationScreen({super.key, this.initialTab = 0});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: initialTab,
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F6FA),
        body: Column(
          children: [
            ScreenHeader(
              title: tr("notifications"),
              showBack: false,
              bottom: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: TabBar(
                  indicatorSize: TabBarIndicatorSize.tab,
                  dividerColor: Colors.transparent,
                  indicator: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  labelColor: Branding.colors.primaryDark,
                  unselectedLabelColor: Colors.white,
                  labelStyle: TextStyle(fontWeight: FontWeight.w700, fontSize: 13.r),
                  unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 13.r),
                  padding: EdgeInsets.all(4.r),
                  tabs: [
                    Tab(text: tr("notifications")),
                    Tab(text: tr("announcements")),
                  ],
                ),
              ),
            ),
            const Expanded(
              child: TabBarView(
                children: [
                  _NotificationsTab(),
                  _AnnouncementsTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Strip HTML tags and clean notification text for display
String _cleanText(String? text) {
  if (text == null) return '';
  var cleaned = text.replaceAll(RegExp(r'<[^>]*>'), '').trim();
  // Strip "Notice:" prefix if present (legacy notifications)
  if (cleaned.toLowerCase().startsWith('notice:')) {
    cleaned = cleaned.substring(7).trim();
  }
  if (cleaned.toLowerCase().startsWith('notice:')) {
    cleaned = cleaned.substring(7).trim();
  }
  return cleaned;
}

/// Tab 1: Push notifications + system events (leave, attendance, etc.)
class _NotificationsTab extends StatelessWidget {
  const _NotificationsTab();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => nb.NotificationBloc(metaClubApiClient: MetaClubApiClient(httpService: instance()))
        ..add(nb.LoadNotificationData()),
      child: BlocBuilder<nb.NotificationBloc, nb.NotificationState>(
        builder: (context, state) {
          if (state.status == NetworkStatus.loading) {
            return ListView.builder(
              shrinkWrap: true,
              itemBuilder: (_, __) => const TileShimmer(titleHeight: 55.0),
              itemCount: 8,
            );
          }

          final notifications = state.notificationResponse?.data?.notifications ?? [];
          final hasData = notifications.isNotEmpty;

          return Column(
            children: [
              if (hasData)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      onTap: () {
                        context.read<nb.NotificationBloc>().add(nb.ClearNoticeButton());
                        context.read<nb.NotificationBloc>().add(nb.LoadNotificationData());
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 8.w),
                        child: Text(
                          tr("clear_all"),
                          style: TextStyle(
                            color: Branding.colors.primaryLight,
                            fontWeight: FontWeight.w600,
                            fontSize: 12.r,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    context.read<nb.NotificationBloc>().add(nb.LoadNotificationData());
                    await Future.delayed(const Duration(milliseconds: 500));
                  },
                  child: hasData
                      ? ListView.builder(
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemCount: notifications.length,
                          itemBuilder: (context, index) {
                            final data = notifications[index];
                            return InkWell(
                              onTap: () {
                                // Mark as read
                                if (data.id != null && data.isRead == false) {
                                  context.read<nb.NotificationBloc>().add(
                                    nb.MarkNotificationAsRead(notificationId: data.id!),
                                  );
                                }
                                // Route by slug if available
                                if (data.slag != null && data.slag!.isNotEmpty && data.slag != 'push_notify') {
                                  context.read<nb.NotificationBloc>().add(nb.RouteSlug(
                                      context: context,
                                      slugName: data.slag,
                                      data: state.notificationResponse));
                                } else {
                                  // Show notification details
                                  final cleanTitle = _cleanText(data.title);
                                  final cleanBody = _cleanText(data.body);
                                  final displayTitle = cleanTitle.isNotEmpty ? cleanTitle : cleanBody;
                                  final displayBody = (cleanTitle.isNotEmpty && cleanBody.isNotEmpty && cleanTitle != cleanBody)
                                      ? cleanBody : null;
                                  NavUtil.navigateScreen(
                                    context,
                                    NoticeDetailsScreen(
                                      noticeId: data.id,
                                      title: displayTitle,
                                      body: displayBody,
                                      date: data.date,
                                      image: data.image,
                                    ),
                                  );
                                }
                              },
                              child: NotificationCartContent(data: data),
                            );
                          },
                        )
                      : LayoutBuilder(
                          builder: (context, constraints) => SingleChildScrollView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            child: SizedBox(
                              height: constraints.maxHeight,
                              child: const Center(child: NoDataFoundWidget()),
                            ),
                          ),
                        ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// Tab 2: Company announcements/notices
class _AnnouncementsTab extends StatelessWidget {
  const _AnnouncementsTab();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => nlb.NotificationListBloc(metaClubApiClient: MetaClubApiClient(httpService: instance()))
        ..add(nlb.LoadNotificationListData()),
      child: BlocBuilder<nlb.NotificationListBloc, nlb.NoticeListState>(
        builder: (context, state) {
          if (state.status == NetworkStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          final notices = state.noticeListModel?.data?.notices?.data;
          final hasData = notices?.isNotEmpty == true;

          if (state.status == NetworkStatus.success || state.status == NetworkStatus.failure) {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<nlb.NotificationListBloc>().add(nlb.LoadNotificationListData());
                await Future.delayed(const Duration(milliseconds: 500));
              },
              child: hasData
                  ? ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: notices!.length,
                      itemBuilder: (context, index) {
                        return NoticeListContent(data: notices[index]);
                      },
                    )
                  : LayoutBuilder(
                      builder: (context, constraints) => SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: SizedBox(
                          height: constraints.maxHeight,
                          child: state.status == NetworkStatus.failure
                              ? Center(child: Text('failed_to_load_notification'.tr()))
                              : const Center(child: NoDataFoundWidget()),
                        ),
                      ),
                    ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
