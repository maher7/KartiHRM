import 'package:core/core.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onesthrm/page/authentication/bloc/authentication_bloc.dart';
import 'package:onesthrm/page/daily_leave/view/daily_leave_page.dart';
import 'package:onesthrm/page/daily_leave/view/pluto_daily_leave_page.dart';
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
          ScreenHeader(
            title: 'leaves_and_requests'.tr(),
            subtitle: subtitle,
            showBack: false,
            bottom: _LeaveToggle(
              isFullDay: _isFullDay,
              onChanged: (value) => setState(() => _isFullDay = value),
            ),
          ),
          Expanded(
            child: _isFullDay ? const LeavePage() : _partialLeavePage(),
          ),
        ],
      ),
    );
  }
}

class _LeaveToggle extends StatelessWidget {
  const _LeaveToggle({required this.isFullDay, required this.onChanged});

  final bool isFullDay;
  final ValueChanged<bool> onChanged;

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
              onTap: () => onChanged(true),
            ),
          ),
          Expanded(
            child: _ToggleSegment(
              label: 'partial_leave'.tr(),
              selected: !isFullDay,
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
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

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
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Branding.colors.primaryDark : Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}
