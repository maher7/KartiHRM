part of 'bottom_nav_cubit.dart';

/// Tab order matches the IndexedStack in BottomNavContent.
/// Visual order: Home | Schedule | [FAB=menu] | Leave | Alerts
enum BottomNavTab { home, schedule, menu, leave, notification }

class BottomNavState extends Equatable {
const BottomNavState({
this.tab = BottomNavTab.home,
});

final BottomNavTab tab;

@override
List<Object> get props => [tab];
}