import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:meta_club_api/meta_club_api.dart';
import 'package:onesthrm/page/home/home.dart';
import 'package:onesthrm/page/home/router/home__menu_router.dart';
import 'package:user_repository/user_repository.dart';
import 'package:core/core.dart';

class HomeHeader extends StatelessWidget {
  final Settings? settings;
  final LoginData? user;
  final DashboardModel? dashboardModel;

  const HomeHeader({super.key, required this.settings, required this.user, required this.dashboardModel});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Branding.colors.primaryDark,
            Branding.colors.primaryLight,
          ],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(20.0, 8.0.h, 20.0, 16.0.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          settings?.data?.timeWish?.wish ?? dashboardModel?.data?.config?.timeWish?.wish ?? '',
                          style: TextStyle(
                            fontSize: 22.r,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.3,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          user?.user?.name ?? '',
                          style: TextStyle(
                            fontSize: 16.r,
                            fontWeight: FontWeight.w600,
                            color: Colors.white.withValues(alpha: 0.95),
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          settings?.data?.timeWish?.subTitle ?? dashboardModel?.data?.config?.timeWish?.wish ?? '',
                          style: TextStyle(
                            fontSize: 13.r,
                            fontWeight: FontWeight.w400,
                            color: Colors.white.withValues(alpha: 0.75),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (settings?.data?.timeWish != null || dashboardModel?.data?.config?.timeWish != null)
                    SvgPicture.network(
                      settings?.data?.timeWish?.image ?? dashboardModel?.data?.config?.timeWish?.image ?? '',
                      semanticsLabel: 'sun',
                      height: 56.h,
                      width: 56.w,
                      placeholderBuilder: (BuildContext context) => const SizedBox(),
                    ),
                ],
              ),
              SizedBox(height: 20.0.h),
              Text(
                'today_summary'.tr(),
                style: TextStyle(
                  fontSize: 14.r,
                  fontWeight: FontWeight.w600,
                  color: Colors.white.withValues(alpha: 0.85),
                  letterSpacing: 0.5,
                ),
              ),
              SizedBox(height: 10.0.h),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Row(
                  children: List.generate(
                    dashboardModel?.data?.today?.length ?? 0,
                    (index) => EventCard(
                      data: dashboardModel?.data?.today![index],
                      onPressed: () => routeSlug(dashboardModel?.data?.today![index].slug, context),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 8.0.h),
            ],
          ),
        ),
      ),
    );
  }
}
