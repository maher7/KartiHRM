import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta_club_api/meta_club_api.dart';
import 'package:onesthrm/page/my_availability/my_availability.dart';

class MyAvailabilityPage extends StatelessWidget {
  const MyAvailabilityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MyAvailabilityBloc(
        metaClubApiClient: MetaClubApiClient(httpService: instance()),
      )..add(const MyAvailabilityLoadEvent()),
      child: const MyAvailabilityContentScreen(),
    );
  }
}
