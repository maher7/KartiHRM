import 'package:core/core.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:onesthrm/page/authentication/bloc/authentication_bloc.dart';
import 'package:onesthrm/page/daily_leave/view/daily_leave_page.dart';
import 'package:onesthrm/page/daily_leave/view/pluto_daily_leave_page.dart';
import 'package:onesthrm/page/home/bloc/home_bloc.dart';
import 'package:onesthrm/page/leave/view/leave_page.dart';
import 'package:onesthrm/res/widgets/screen_header.dart';

/// Wrapper for the Leave bottom-nav tab that lets the user toggle between
/// Full Day leave and Partial (daily) leave on a single screen.
class LeaveTabPage extends StatefulWidget {
  const LeaveTabPage({super.key});

  @override
  State<LeaveTabPage> createState() => _LeaveTabPageState();
}

class _LeaveTabPageState extends State<LeaveTabPage> {
  bool _isFullDay = true;
  bool _viewedFullDay = true;   // starts on Full Day, so it's viewed
  bool _viewedPartial = false;

  Widget _partialLeavePage() {
    final name = globalState.get(dashboardStyleId);
    switch (name) {
      case 'pluto':
        return const PlutoDailyLeavePage();
      default:
        return const DailyLeavePage();
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthenticationBloc>().state.data?.user;
    final roleLabel = user?.isAdmin == true
        ? 'admin'.tr()
        : user?.isHr == true
            ? 'hr_manager'.tr()
            : 'employee'.tr();
    final subtitle = user?.name != null ? '${user!.name} · $roleLabel' : roleLabel;
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: Column(
        children: [
          Builder(builder: (context) {
            final badges = context.watch<HomeBloc>().state.dashboardModel?.data?.badges;
            final fullDayPending = badges?['leave_full'] ?? 0;
            final partialPending = badges?['leave_partial'] ?? 0;
            return ScreenHeader(
              title: 'leaves_and_requests'.tr(),
              subtitle: subtitle,
              showBack: false,
              bottom: _LeaveToggle(
                isFullDay: _isFullDay,
                fullDayBadge: _viewedFullDay ? 0 : fullDayPending,
                partialBadge: _viewedPartial ? 0 : partialPending,
                onChanged: (value) => setState(() {
                  _isFullDay = value;
                  if (value) {
                    _viewedFullDay = true;
                  } else {
                    _viewedPartial = true;
                  }
                }),
              ),
            );
          }),
          Expanded(
            child: _isFullDay ? const LeavePage() : _partialLeavePage(),
          ),
        ],
      ),
    );
  }
}

class _LeaveToggle extends StatelessWidget {
  const _LeaveToggle({required this.isFullDay, required this.onChanged, this.fullDayBadge = 0, this.partialBadge = 0});

  final bool isFullDay;
  final ValueChanged<bool> onChanged;
  final int fullDayBadge;
  final int partialBadge;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        children: [
          Expanded(
            child: _ToggleSegment(
              label: 'full_day_leave'.tr(),
              selected: isFullDay,
              badgeCount: fullDayBadge,
              onTap: () => onChanged(true),
            ),
          ),
          Expanded(
            child: _ToggleSegment(
              label: 'partial_leave'.tr(),
              selected: !isFullDay,
              badgeCount: partialBadge,
              onTap: () => onChanged(false),
            ),
          ),
        ],
      ),
    );
  }
}

class _ToggleSegment extends StatelessWidget {
  const _ToggleSegment({
    required this.label,
    required this.selected,
    required this.onTap,
    this.badgeCount = 0,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final int badgeCount;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: selected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: TextStyle(
                color: selected ? Branding.colors.primaryDark : Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
            if (badgeCount > 0) ...[
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: selected ? const Color(0xFFE53935) : Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '$badgeCount',
                  style: TextStyle(
                    color: selected ? Colors.white : Branding.colors.primaryDark,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
