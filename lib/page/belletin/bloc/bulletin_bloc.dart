import 'dart:async';
import 'package:core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onesthrm/page/belletin/bloc/bulletin_state.dart';

typedef BulletinBlocFactory = BulletinBloc Function();

class BulletinBloc extends Cubit<BulletinState> {
  String? _lastDismissedHeadline;

  BulletinBloc() : super(const BulletinState()) {
    loadHeadline();
    Timer.periodic(const Duration(minutes: 10), (_) {
      loadHeadline();
    });
  }

  void loadHeadline() async {
    emit(state.copyWith(status: NetworkStatus.loading));
    await Future.delayed(const Duration(seconds: 1));
    SharedUtil.getValue(bulletinKey).then((data) {
      // If a new headline arrives (different from dismissed one), show it
      final isDismissed = data == _lastDismissedHeadline;
      emit(state.copyWith(status: NetworkStatus.success, headline: data, dismissed: isDismissed));
    });
  }

  void dismiss() {
    _lastDismissedHeadline = state.headline;
    emit(state.copyWith(dismissed: true));
  }
}
