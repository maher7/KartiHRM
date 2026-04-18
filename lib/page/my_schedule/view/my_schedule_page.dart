import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta_club_api/meta_club_api.dart';
import 'package:onesthrm/page/bottom_navigation/bloc/bottom_nav_cubit.dart';
import 'package:onesthrm/page/my_schedule/my_schedule.dart';

class MySchedulePage extends StatelessWidget {
  const MySchedulePage({super.key});

  @override
  Widget build(BuildContext context) {
    final bottomNav = _tryReadBottomNav(context);

    Widget content = const MyScheduleContentScreen();
    if (bottomNav != null) {
      content = BlocListener<BottomNavCubit, BottomNavState>(
        bloc: bottomNav,
        listenWhen: (prev, curr) =>
            curr.tab == BottomNavTab.schedule && prev.tab != BottomNavTab.schedule,
        listener: (context, _) {
          final bloc = context.read<MyScheduleBloc>();
          bloc.add(MyScheduleLoadEvent(weekStart: bloc.state.weekStart));
        },
        child: content,
      );
    }

    return BlocProvider(
      create: (_) => MyScheduleBloc(
        metaClubApiClient: MetaClubApiClient(httpService: instance()),
      )..add(const MyScheduleLoadEvent()),
      child: content,
    );
  }

  static BottomNavCubit? _tryReadBottomNav(BuildContext context) {
    try {
      return context.read<BottomNavCubit>();
    } catch (_) {
      return null;
    }
  }
}
