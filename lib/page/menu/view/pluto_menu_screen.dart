import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hrm_framework/hrm_framework.dart';
import 'package:onesthrm/page/language/bloc/language_bloc.dart';
import 'package:onesthrm/page/menu/bloc/menu_bloc.dart';
import 'package:onesthrm/page/menu/content/menu_profile.dart';
import 'package:onesthrm/page/menu/content/pluto_menu_header.dart';
import 'package:onesthrm/page/menu_drawer/view/menu_drawer.dart';
import 'package:onesthrm/page/profile/view/pluto_profile_page.dart';
import '../../authentication/bloc/authentication_bloc.dart';
import '../content/pluto_menu_list.dart';

class PlutoMenuScreen extends StatefulWidget {
  const PlutoMenuScreen({super.key});

  static final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  State<PlutoMenuScreen> createState() => _PlutoMenuScreenState();
}

class _PlutoMenuScreenState extends State<PlutoMenuScreen> with TickerProviderStateMixin {
  late AnimationController animationController;

  @override
  void initState() {
    animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 2000));
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthenticationBloc>().state.data;

    return BlocProvider(
        create: (context) => MenuBloc(
            loginData: user!,
            color: Branding.colors.primaryLight,
            getAppName: instance<GetAppNameUseCase>(),
            getAppVersion: instance<GetAppVersionUseCase>())
          ..add(RouteSlug(context: context))
          ..add(OnAppServiceEvent()),
        child: Scaffold(
            key: PlutoMenuScreen._scaffoldKey,
            endDrawer: const MenuDrawer(),
            extendBody: true,
            body: BlocBuilder<LanguageBloc, LanguageState>(builder: (context, state) {
              return Column(
                children: [
                  /// Header with gradient
                  InkWell(
                    onTap: () {
                      Navigator.push(context, PlutoProfileScreen.route(user?.user?.id));
                    },
                    child: Container(
                      margin: EdgeInsets.zero,
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
                          padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 20.h),
                          child: Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white.withValues(alpha: 0.4), width: 2),
                                ),
                                child: const MenuProfile(),
                              ),
                              SizedBox(width: 16.w),
                              const PlutoMenuHeader(),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: IconButton(
                                    onPressed: () {
                                      PlutoMenuScreen._scaffoldKey.currentState?.openEndDrawer();
                                    },
                                    icon: Image.asset('assets/images/bergur_menu.png', height: 20.0.h, width: 20.0.w, fit: BoxFit.cover, color: Colors.white)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  /// Menu List
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0.w, vertical: 12.h),
                      child: PlutoMenuList(
                        animationController: animationController,
                      ),
                    ),
                  ),
                  const SizedBox(height: 36.0)
                ],
              );
            })));
  }
}
