import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta_club_api/meta_club_api.dart';
import 'package:onesthrm/page/my_schedule/my_schedule.dart';

class MySchedulePage extends StatelessWidget {
  const MySchedulePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MyScheduleBloc(
        metaClubApiClient: MetaClubApiClient(httpService: instance()),
      )..add(const MyScheduleLoadEvent()),
      child: const MyScheduleContentScreen(),
    );
  }
}
