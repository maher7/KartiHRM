import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:onesthrm/page/all_natification/bloc/notification_bloc.dart';
import 'package:onesthrm/page/home/router/home__menu_router.dart';
import 'package:onesthrm/page/language/bloc/language_bloc.dart';
import 'package:onesthrm/page/leave/view/leave_tab_page.dart';
import 'package:onesthrm/page/my_schedule/view/my_schedule_page.dart';
import 'package:onesthrm/page/onboarding/bloc/onboarding_bloc.dart';
import '../../home/view/home_page.dart';
import '../bloc/bottom_nav_cubit.dart';
import 'bottom_nav_item.dart';

class BottomNavContent extends StatelessWidget {
  const BottomNavContent({super.key});

  @override
  Widget build(BuildContext context) {
    DateTime timeBackPressed = DateTime.now();
    final selectedTab = context.select((BottomNavCubit cubit) => cubit.state.tab);

    return BlocBuilder<LanguageBloc, LanguageState>(
      builder: (_, langState) {
      return BlocBuilder<OnboardingBloc, OnboardingState>(
      builder: (_, __) {
        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
          systemNavigationBarColor: Branding.colors.primaryDark, // navigation bar color
          statusBarColor: Branding.colors.primaryDark, // status bar color
        ));

        return PopScope(
          canPop: false,
          onPopInvoked: (didPop) async {
            final differences = DateTime.now().difference(timeBackPressed);
            timeBackPressed = DateTime.now();
            if (differences >= const Duration(seconds: 2)) {
              String msg = "Press the back button to exit";
              Fluttertoast.showToast(
                msg: msg,
              );
            } else {
              Fluttertoast.cancel();
              SystemNavigator.pop();
            }
          },
          child: Scaffold(
            extendBody: true,
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(0.0),
              child: AppBar(
                automaticallyImplyLeading: false,
              ),
            ),
            bottomNavigationBar: ColoredBox(
              color: Colors.white,
              child: BottomAppBar(
                  elevation: 4,
                  color: Colors.white,
                  shape: const CircularNotchedRectangle(),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: BottomNavItem(
                          icon: 'assets/home_icon/home.svg',
                          label: 'home'.tr(),
                          isSelected: selectedTab == BottomNavTab.home,
                          tab: BottomNavTab.home,
                        ),
                      ),
                      Expanded(
                        child: ValueListenableBuilder<int>(
                          valueListenable: scheduleBadgeCount,
                          builder: (context, count, _) => BottomNavItem(
                            icon: 'assets/home_icon/attendance.svg',
                            label: 'schedule'.tr(),
                            isSelected: selectedTab == BottomNavTab.schedule,
                            tab: BottomNavTab.schedule,
                            badgeCount: selectedTab == BottomNavTab.schedule ? 0 : count,
                          ),
                        ),
                      ),
                      const SizedBox(width: 48),
                      Expanded(
                        child: ValueListenableBuilder<int>(
                          valueListenable: leaveBadgeCount,
                          builder: (context, count, _) => BottomNavItem(
                            icon: 'assets/home_icon/leave.svg',
                            label: 'leave'.tr(),
                            isSelected: selectedTab == BottomNavTab.leave,
                            tab: BottomNavTab.leave,
                            badgeCount: selectedTab == BottomNavTab.leave ? 0 : count,
                          ),
                        ),
                      ),
                      Expanded(
                        child: ValueListenableBuilder<int>(
                          valueListenable: unreadNotificationCount,
                          builder: (context, count, _) => BottomNavItem(
                            icon: 'assets/home_icon/notifications.svg',
                            label: 'alerts'.tr(),
                            isSelected: selectedTab == BottomNavTab.notification,
                            tab: BottomNavTab.notification,
                            badgeCount: count,
                          ),
                        ),
                      ),
                    ],
                  )),
            ),
            floatingActionButton: ValueListenableBuilder<int>(
              valueListenable: menuBadgeCount,
              builder: (context, count, _) => _MenuFab(
                isSelected: selectedTab == BottomNavTab.menu,
                isTablet: DeviceUtil.isTablet,
                badgeCount: count,
                onPressed: () {
                  context.read<BottomNavCubit>().setTab(BottomNavTab.menu);
                },
              ),
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
            body: IndexedStack(
              index: selectedTab.index,
              // Order must match BottomNavTab enum: home, schedule, menu, leave, notification
              children: [const HomePage(), const MySchedulePage(), chooseMenu(), const LeaveTabPage(), chooseNotification()],
            ),
          ),
        );
      },
    );
    },
    );
  }
}

/// Elevated center FAB with a "Menu" label so users recognise it as a button.
class _MenuFab extends StatelessWidget {
  const _MenuFab({
    required this.isSelected,
    required this.isTablet,
    required this.onPressed,
    this.badgeCount = 0,
  });

  final bool isSelected;
  final bool isTablet;
  final VoidCallback onPressed;
  final int badgeCount;

  @override
  Widget build(BuildContext context) {
    final bgColor = isSelected ? Branding.colors.primaryDark : Colors.white;
    final fgColor = isSelected ? Colors.white : Branding.colors.primaryDark;
    final fabSize = isTablet ? 64.0 : 52.0;
    final iconPad = isTablet ? 14.0 : 10.0;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: fabSize,
              height: fabSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: bgColor,
                border: Border.all(
                  color: Branding.colors.primaryLight.withValues(alpha: 0.3),
                  width: 2.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Branding.colors.primaryLight.withValues(alpha: 0.25),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                shape: const CircleBorder(),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: onPressed,
                  child: Padding(
                    padding: EdgeInsets.all(iconPad),
                    child: Image.asset(
                      isTablet ? 'assets/images/FavLogo.png' : 'assets/home_icon/FavLogo.png',
                      color: fgColor,
                    ),
                  ),
                ),
              ),
            ),
            if (badgeCount > 0)
              Positioned(
                top: -4,
                right: -4,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Color(0xFFE53935),
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                  child: Text(
                    badgeCount > 99 ? '99+' : '$badgeCount',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          'menu'.tr(),
          style: TextStyle(
            fontSize: 10,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected ? Branding.colors.primaryDark : Colors.grey.shade500,
          ),
        ),
      ],
    );
  }
}
