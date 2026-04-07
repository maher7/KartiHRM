import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onesthrm/page/all_natification/bloc/notification_bloc.dart';

part 'bottom_nav_state.dart';

class BottomNavCubit extends Cubit<BottomNavState> {
  BottomNavCubit() : super(const BottomNavState());

  void setTab(BottomNavTab tab) {
    // Mark badge as viewed so it won't reappear on API refresh
    // unless the count actually increases (new data arrived).
    switch (tab) {
      case BottomNavTab.leave:
        markBadgeViewed('leave', leaveBadgeCount);
        break;
      case BottomNavTab.schedule:
        markBadgeViewed('schedule', scheduleBadgeCount);
        break;
      case BottomNavTab.menu:
        markBadgeViewed('menu', menuBadgeCount);
        break;
      default:
        break;
    }
    emit(BottomNavState(tab: tab));
  }
}
