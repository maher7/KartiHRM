import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onesthrm/page/home/content/home_bottom.dart';
import 'package:onesthrm/page/home/view/home_pluto/content/pluto_check_break_content.dart';
import 'package:onesthrm/page/home/view/home_pluto/content/pluto_home_header.dart';
import 'package:onesthrm/page/language/bloc/language_bloc.dart';
import '../../../../authentication/bloc/authentication_bloc.dart';
import '../../../bloc/home_bloc.dart';
import '../../../content/my_stats_card.dart';

class HomePlutoContent extends StatefulWidget {
  const HomePlutoContent({super.key});

  @override
  State<HomePlutoContent> createState() => _HomePlutoContentState();
}

class _HomePlutoContentState extends State<HomePlutoContent> {
  bool _locationInitialized = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, homeState) {
        final user = context.read<AuthenticationBloc>().state.data;

        if (user?.user != null && !_locationInitialized) {
          _locationInitialized = true;
          context.read<HomeBloc>().add(OnLocationEnabled(user: user!.user!, locationProvider: instance()));
        }

        return BlocBuilder<LanguageBloc, LanguageState>(
          builder: (context, state) {
            return RefreshIndicator(
              color: Branding.colors.primaryLight,
              onRefresh: () async {
                context.read<HomeBloc>().add(OnHomeRefresh());
                // Wait briefly for data to reload
                await Future.delayed(const Duration(milliseconds: 800));
              },
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  PlutoHomeHeader(settings: homeState.settings, user: user, dashboardModel: homeState.dashboardModel),
                  PlutoCheckBreakContent(
                      settings: homeState.settings, user: user, dashboardModel: homeState.dashboardModel),
                  MyStatsCard(dashboardModel: homeState.dashboardModel, settings: homeState.settings),
                  HomeBottom(settings: homeState.settings, user: user, dashboardModel: homeState.dashboardModel),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
