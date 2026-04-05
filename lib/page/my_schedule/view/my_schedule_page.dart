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
    return BlocProvider(
      create: (_) => MyScheduleBloc(
        metaClubApiClient: MetaClubApiClient(httpService: instance()),
      )..add(const MyScheduleLoadEvent()),
      child: BlocListener<BottomNavCubit, BottomNavState>(
        listenWhen: (prev, curr) =>
            curr.tab == BottomNavTab.schedule && prev.tab != BottomNavTab.schedule,
        listener: (context, _) {
          // Refetch whenever the user enters the Schedule tab so data is always fresh
          // (initial fetch can race with auth/session setup at app startup).
          final bloc = context.read<MyScheduleBloc>();
          bloc.add(MyScheduleLoadEvent(weekStart: bloc.state.weekStart));
        },
        child: const MyScheduleContentScreen(),
      ),
    );
  }
}
