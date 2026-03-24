import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meta_club_api/meta_club_api.dart';
import 'package:onesthrm/page/home/content/pluto_event_card.dart';
import 'package:onesthrm/page/home/router/home__menu_router.dart';
import 'package:onesthrm/page/menu/content/menu_profile.dart';
import 'package:user_repository/user_repository.dart';
import 'package:core/core.dart';

class PlutoHomeHeader extends StatelessWidget {
  final Settings? settings;
  final LoginData? user;
  final DashboardModel? dashboardModel;

  const PlutoHomeHeader({super.key, required this.settings, required this.user, required this.dashboardModel});

  @override
  Widget build(BuildContext context) {
    // Filter today items — only show those with count > 0
    final todayItems = dashboardModel?.data?.today
        ?.where((item) {
          final num = item.number;
          if (num is int) return num > 0;
          if (num is String) return (int.tryParse(num) ?? 0) > 0;
          return false;
        })
        .toList() ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Gradient header
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Branding.colors.primaryDark, Branding.colors.primaryLight],
            ),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white.withValues(alpha: 0.4), width: 2),
                    ),
                    child: const MenuProfile(),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          settings?.data?.timeWish?.wish ?? dashboardModel?.data?.config?.timeWish?.wish ?? '',
                          style: TextStyle(fontSize: 13.r, color: Colors.white.withValues(alpha: 0.8)),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          '${user?.user?.name}',
                          style: TextStyle(fontSize: 16.r, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Today Summary — only if there are items with count > 0
        if (todayItems.isNotEmpty) ...[
          SizedBox(height: 12.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Text(
              'today_summary'.tr(),
              style: TextStyle(fontSize: 16.r, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
          ),
          SizedBox(height: 8.h),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(children: List.generate(
              todayItems.length,
              (index) => PlutoEventCard(
                data: todayItems[index],
                onPressed: () => routeSlug(todayItems[index].slug, context),
              ),
            )),
          ),
        ],
      ],
    );
  }
}
