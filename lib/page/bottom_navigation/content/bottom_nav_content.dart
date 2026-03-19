import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:onesthrm/page/home/router/home__menu_router.dart';
import 'package:onesthrm/page/leave/view/leave_page.dart';
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
                        child: BottomNavItem(
                          icon: 'assets/home_icon/leave.svg',
                          label: 'leave'.tr(),
                          isSelected: selectedTab == BottomNavTab.leave,
                          tab: BottomNavTab.leave,
                        ),
                      ),
                      const SizedBox(width: 48),
                      Expanded(
                        child: BottomNavItem(
                          icon: 'assets/home_icon/attendance.svg',
                          label: 'partial'.tr(),
                          isSelected: selectedTab == BottomNavTab.attendance,
                          tab: BottomNavTab.attendance,
                        ),
                      ),
                      Expanded(
                        child: BottomNavItem(
                          icon: 'assets/home_icon/notifications.svg',
                          label: 'alerts'.tr(),
                          isSelected: selectedTab == BottomNavTab.notification,
                          tab: BottomNavTab.notification,
                        ),
                      ),
                    ],
                  )),
            ),
            floatingActionButton: DeviceUtil.isTablet
                ? FloatingActionButton.large(
                    foregroundColor: Colors.white,
                    backgroundColor: selectedTab == BottomNavTab.menu ? Branding.colors.primaryLight : Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Image.asset(
                        'assets/images/FavLogo.png',
                        color: selectedTab == BottomNavTab.menu ? Colors.white : Branding.colors.primaryLight,
                      ),
                    ),
                    onPressed: () {
                      context.read<BottomNavCubit>().setTab(BottomNavTab.menu);
                      // myPage.jumpToPage(2);
                    })
                : FloatingActionButton(
                    backgroundColor: selectedTab == BottomNavTab.menu ? Branding.colors.primaryDark : Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Image.asset('assets/home_icon/FavLogo.png',
                          color: selectedTab == BottomNavTab.menu ? Colors.white : Branding.colors.primaryDark),
                    ),
                    onPressed: () {
                      context.read<BottomNavCubit>().setTab(BottomNavTab.menu);
                      // myPage.jumpToPage(2);
                    }),
            floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
            body: IndexedStack(
              index: selectedTab.index,
              children: [const HomePage(), const LeavePage(), chooseMenu(), chooseDailyLeave(), chooseNotification()],
            ),
          ),
        );
      },
    );
  }
}
