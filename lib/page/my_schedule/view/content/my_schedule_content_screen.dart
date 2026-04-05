import 'package:core/core.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meta_club_api/meta_club_api.dart';
import 'package:onesthrm/page/language/bloc/language_bloc.dart';
import 'package:onesthrm/page/my_schedule/my_schedule.dart';
import 'package:onesthrm/res/widgets/screen_header.dart';

class MyScheduleContentScreen extends StatefulWidget {
  const MyScheduleContentScreen({super.key});

  @override
  State<MyScheduleContentScreen> createState() => _MyScheduleContentScreenState();
}

class _MyScheduleContentScreenState extends State<MyScheduleContentScreen> {
  int _selectedDayIndex = -1;
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  /// Format hours: whole numbers as "8", fractional as "7.5"
  String _fmtHours(num h) =>
      h.truncateToDouble() == h ? h.toInt().toString() : h.toStringAsFixed(1);

  /// Parse "HH:mm" or "HH:mm:ss" into minutes since midnight for sorting
  int _timeToMinutes(String? t) {
    if (t == null || t.isEmpty) return 1 << 30;
    try {
      final parts = t.split(':');
      return int.parse(parts[0]) * 60 + int.parse(parts[1]);
    } catch (_) {
      return 1 << 30;
    }
  }

  /// Determine shift period icon and label from time string
  ({IconData icon, String label, Color color}) _shiftPeriod(String? from) {
    if (from == null || from.isEmpty) return (icon: Icons.schedule, label: 'shift'.tr(), color: Colors.grey);
    try {
      final parts = from.split(':');
      final hour = int.parse(parts[0]);
      if (hour >= 5 && hour < 12) return (icon: Icons.wb_sunny_rounded, label: 'morning'.tr(), color: const Color(0xFFF59E0B));
      if (hour >= 12 && hour < 17) return (icon: Icons.wb_cloudy_rounded, label: 'afternoon'.tr(), color: const Color(0xFFEF6C00));
      if (hour >= 17 && hour < 21) return (icon: Icons.nights_stay_rounded, label: 'evening'.tr(), color: const Color(0xFF5C6BC0));
      return (icon: Icons.dark_mode_rounded, label: 'night'.tr(), color: const Color(0xFF283593));
    } catch (_) {
      return (icon: Icons.schedule, label: 'shift'.tr(), color: Colors.grey);
    }
  }

  bool _isCurrentShift(ScheduleShift shift, int dayIndex, DateTime weekStart) {
    // Skip shifts without a valid day assignment (prevents null day being bucketed as Sunday)
    if (shift.day == null) return false;
    final now = DateTime.now();
    final shiftDate = DateTime(weekStart.year, weekStart.month, weekStart.day + dayIndex);
    if (shift.from == null || shift.to == null) return false;
    try {
      final fromParts = shift.from!.split(':');
      final toParts = shift.to!.split(':');
      final fromMinutes = int.parse(fromParts[0]) * 60 + int.parse(fromParts[1]);
      final toMinutes = int.parse(toParts[0]) * 60 + int.parse(toParts[1]);
      final nowMinutes = now.hour * 60 + now.minute;
      final isOvernight = toMinutes <= fromMinutes;
      // Is "now" on the shift's start date?
      final onShiftDate = shiftDate.year == now.year && shiftDate.month == now.month && shiftDate.day == now.day;
      // For overnight shifts, "now" is also valid on the following calendar day (past midnight portion)
      final nextDate = DateTime(shiftDate.year, shiftDate.month, shiftDate.day + 1);
      final onNextDate = nextDate.year == now.year && nextDate.month == now.month && nextDate.day == now.day;
      if (!isOvernight) {
        return onShiftDate && nowMinutes >= fromMinutes && nowMinutes <= toMinutes;
      }
      // Overnight: either in [from..24:00) of shift date, or in [00:00..to] of the next date
      return (onShiftDate && nowMinutes >= fromMinutes) ||
          (onNextDate && nowMinutes <= toMinutes);
    } catch (_) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageBloc, LanguageState>(
      builder: (context, _) {
        return Scaffold(
          backgroundColor: const Color(0xFFF5F6FA),
          body: BlocBuilder<MyScheduleBloc, MyScheduleState>(
            builder: (context, state) {
              return Column(
                children: [
                  ScreenHeader(
                    title: 'my_schedule'.tr(),
                    subtitle: _scheduleSubtitle(state),
                    showBack: false,
                    bottom: _buildWeekNav(context, state),
                  ),
                  _buildDayTabs(context, state),
                  Expanded(child: _buildBody(context, state)),
                ],
              );
            },
          ),
        );
      },
    );
  }

  String? _scheduleSubtitle(MyScheduleState state) {
    final weekStart = state.weekStart;
    DateTime current;
    try {
      current = DateTime.parse(weekStart ?? '');
    } catch (_) {
      final now = DateTime.now();
      current = DateTime(now.year, now.month, now.day - (now.weekday % 7));
    }
    final end = DateTime(current.year, current.month, current.day + 6);
    final dayFmt = DateFormat('d', 'en');
    final monthFmt = DateFormat('MMM', 'en');
    final sameMonth = current.month == end.month;
    return sameMonth
        ? '${monthFmt.format(current)} ${dayFmt.format(current)} - ${dayFmt.format(end)}, ${current.year}'
        : '${monthFmt.format(current)} ${dayFmt.format(current)} - ${monthFmt.format(end)} ${dayFmt.format(end)}';
  }

  Widget _buildWeekNav(BuildContext context, MyScheduleState state) {
    final weekStart = state.weekStart;
    DateTime current;
    try {
      current = DateTime.parse(weekStart ?? '');
    } catch (_) {
      final now = DateTime.now();
      current = DateTime(now.year, now.month, now.day - (now.weekday % 7));
    }
    // DST-safe calendar arithmetic
    final prev = DateTime(current.year, current.month, current.day - 7);
    final next = DateTime(current.year, current.month, current.day + 7);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12.r),
      ),
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
      child: Row(
        children: [
          _navArrow(
            icon: Icons.arrow_back_ios_rounded,
            onTap: () {
              setState(() => _selectedDayIndex = -1);
              context.read<MyScheduleBloc>().add(MyScheduleWeekChangeEvent(
                  weekStart: DateFormat('yyyy-MM-dd', 'en').format(prev)));
            },
          ),
          Expanded(
            child: Center(
              child: state.schedule != null
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _headerStat(Icons.event_note_rounded, '${state.schedule!.totalShifts ?? 0} ${'shifts_count'.tr()}'),
                        SizedBox(width: 14.w),
                        _headerStat(Icons.timer_outlined, '${_fmtHours(state.schedule!.totalHours ?? 0)} ${'hours_total'.tr()}'),
                      ],
                    )
                  : Text(
                      'loading_schedule'.tr(),
                      style: TextStyle(fontSize: 11.sp, color: Colors.white.withValues(alpha: 0.8)),
                    ),
            ),
          ),
          _navArrow(
            icon: Icons.arrow_forward_ios_rounded,
            onTap: () {
              setState(() => _selectedDayIndex = -1);
              context.read<MyScheduleBloc>().add(MyScheduleWeekChangeEvent(
                  weekStart: DateFormat('yyyy-MM-dd', 'en').format(next)));
            },
          ),
        ],
      ),
    );
  }

  Widget _navArrow({required IconData icon, required VoidCallback onTap}) {
    return InkWell(
      borderRadius: BorderRadius.circular(8.r),
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.all(8.r),
        child: Icon(icon, size: 16.r, color: Colors.white),
      ),
    );
  }

  Widget _headerStat(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13.r, color: Colors.white.withValues(alpha: 0.9)),
        SizedBox(width: 4.w),
        Text(text, style: TextStyle(fontSize: 11.sp, color: Colors.white, fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _buildDayTabs(BuildContext context, MyScheduleState state) {
    DateTime start;
    try {
      start = DateTime.parse(state.weekStart ?? '');
    } catch (_) {
      final now = DateTime.now();
      start = DateTime(now.year, now.month, now.day - (now.weekday % 7));
    }

    final today = DateTime.now();
    final dayAbbr = [
      'day_abbr_sun'.tr(), 'day_abbr_mon'.tr(), 'day_abbr_tue'.tr(),
      'day_abbr_wed'.tr(), 'day_abbr_thu'.tr(), 'day_abbr_fri'.tr(), 'day_abbr_sat'.tr(),
    ];
    final shifts = state.schedule?.shifts ?? [];

    return Container(
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(12.w, 0, 12.w, 14.h),
      child: Row(
        children: List.generate(7, (i) {
          final day = DateTime(start.year, start.month, start.day + i);
          final isToday = day.year == today.year && day.month == today.month && day.day == today.day;
          final isSelected = _selectedDayIndex == i;
          final dayShiftCount = shifts.where((s) => s.day == i).length;

          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedDayIndex = _selectedDayIndex == i ? -1 : i;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: EdgeInsets.symmetric(horizontal: 3.w),
                padding: EdgeInsets.symmetric(vertical: 8.h),
                decoration: BoxDecoration(
                  gradient: isSelected
                      ? LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Branding.colors.primaryDark, Branding.colors.primaryLight],
                        )
                      : null,
                  color: isSelected ? null : (isToday ? Branding.colors.primaryLight.withValues(alpha: 0.08) : Colors.transparent),
                  borderRadius: BorderRadius.circular(14.r),
                  border: isToday && !isSelected
                      ? Border.all(color: Branding.colors.primaryLight.withValues(alpha: 0.4), width: 1.5)
                      : null,
                  boxShadow: isSelected
                      ? [BoxShadow(color: Branding.colors.primaryDark.withValues(alpha: 0.25), blurRadius: 8, offset: const Offset(0, 3))]
                      : null,
                ),
                child: Column(
                  children: [
                    Text(
                      dayAbbr[i],
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                        color: isSelected ? Colors.white70 : Colors.grey[500],
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      '${day.day}',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w800,
                        color: isSelected ? Colors.white : (isToday ? Branding.colors.primaryDark : Colors.black87),
                      ),
                    ),
                    SizedBox(height: 4.h),
                    if (dayShiftCount > 0)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          dayShiftCount.clamp(0, 3),
                          (j) => Container(
                            width: 5.r,
                            height: 5.r,
                            margin: EdgeInsets.symmetric(horizontal: 1.w),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isSelected ? Colors.white : Branding.colors.primaryLight,
                            ),
                          ),
                        ),
                      )
                    else
                      SizedBox(height: 5.r),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildBody(BuildContext context, MyScheduleState state) {
    if (state.status == NetworkStatus.loading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 40.r,
              height: 40.r,
              child: CircularProgressIndicator(strokeWidth: 3, color: Branding.colors.primaryLight),
            ),
            SizedBox(height: 16.h),
            Text('loading_schedule'.tr(), style: TextStyle(fontSize: 13.sp, color: Colors.grey[500])),
          ],
        ),
      );
    }

    if (state.status == NetworkStatus.failure) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(32.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.cloud_off_rounded, size: 56.r, color: Colors.grey[300]),
              SizedBox(height: 16.h),
              Text('couldnt_load_schedule'.tr(), style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600, color: Colors.grey[600])),
              SizedBox(height: 6.h),
              Text(state.errorMessage ?? 'check_your_connection_and_try_again'.tr(),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13.sp, color: Colors.grey[400])),
              SizedBox(height: 20.h),
              TextButton.icon(
                onPressed: () => context.read<MyScheduleBloc>().add(MyScheduleLoadEvent(weekStart: state.weekStart)),
                icon: const Icon(Icons.refresh_rounded),
                label: Text('retry'.tr()),
                style: TextButton.styleFrom(foregroundColor: Branding.colors.primaryLight),
              ),
            ],
          ),
        ),
      );
    }

    final allShifts = state.schedule?.shifts ?? [];
    final shifts = _selectedDayIndex == -1
        ? allShifts
        : allShifts.where((s) => s.day == _selectedDayIndex).toList();

    if (shifts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(20.r),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.event_busy_rounded, size: 48.r, color: Colors.grey[350]),
            ),
            SizedBox(height: 16.h),
            Text(
              _selectedDayIndex == -1 ? 'no_shifts_this_week'.tr() : 'day_off'.tr(),
              style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.w600, color: Colors.grey[600]),
            ),
            SizedBox(height: 6.h),
            Text(
              _selectedDayIndex == -1
                  ? 'no_work_schedule_assigned_for_this_week'.tr()
                  : 'you_have_no_shifts_scheduled_for_this_day'.tr(),
              style: TextStyle(fontSize: 13.sp, color: Colors.grey[400]),
            ),
          ],
        ),
      );
    }

    // Parse week start for current shift detection
    DateTime weekStart;
    try {
      weekStart = DateTime.parse(state.weekStart ?? '');
    } catch (_) {
      final now = DateTime.now();
      weekStart = DateTime(now.year, now.month, now.day - (now.weekday % 7));
    }

    // Group shifts by day (skip shifts without a day assignment)
    final grouped = <int, List<ScheduleShift>>{};
    for (final s in shifts) {
      if (s.day == null) continue;
      grouped.putIfAbsent(s.day!, () => []).add(s);
    }
    // Sort shifts within each day by start time
    for (final list in grouped.values) {
      list.sort((a, b) => _timeToMinutes(a.from).compareTo(_timeToMinutes(b.from)));
    }
    final sortedDays = grouped.keys.toList()..sort();

    return RefreshIndicator(
      color: Branding.colors.primaryLight,
      onRefresh: () async {
        context.read<MyScheduleBloc>().add(MyScheduleLoadEvent(weekStart: state.weekStart));
      },
      child: ListView.builder(
        controller: _scrollController,
        padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 24.h),
        itemCount: sortedDays.length,
        itemBuilder: (context, index) {
          final dayIndex = sortedDays[index];
          final dayShifts = grouped[dayIndex]!;
          return _buildDaySection(context, weekStart, dayIndex, dayShifts);
        },
      ),
    );
  }

  Widget _buildDaySection(BuildContext context, DateTime weekStart, int dayIndex, List<ScheduleShift> shifts) {
    const dayKeys = ['sunday', 'monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday'];
    final dayName = dayIndex < dayKeys.length ? dayKeys[dayIndex].tr() : '';
    final dayDate = DateTime(weekStart.year, weekStart.month, weekStart.day + dayIndex);
    final now = DateTime.now();
    final isToday = dayDate.year == now.year && dayDate.month == now.month && dayDate.day == now.day;
    final isPast = dayDate.isBefore(DateTime(now.year, now.month, now.day));

    // Total hours for this day
    double dayHours = 0;
    for (final s in shifts) {
      dayHours += s.hours ?? 0;
    }

    return Padding(
      padding: EdgeInsets.only(bottom: 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Day header
          Padding(
            padding: EdgeInsets.only(bottom: 10.h),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: isToday ? Branding.colors.primaryDark : (isPast ? Colors.grey[300] : Colors.grey[200]),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    dayName,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w700,
                      color: isToday ? Colors.white : (isPast ? Colors.grey[600] : Colors.black87),
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                Text(
                  DateFormat('d MMM', 'en').format(dayDate),
                  style: TextStyle(fontSize: 12.sp, color: Colors.grey[500], fontWeight: FontWeight.w500),
                ),
                const Spacer(),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Text(
                    '${shifts.length} ${shifts.length > 1 ? 'shifts_count'.tr() : 'shift_count'.tr()} · ${_fmtHours(dayHours)} ${'hrs_short'.tr()}',
                    style: TextStyle(fontSize: 10.sp, color: Colors.grey[600], fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),
          // Shift cards
          ...shifts.asMap().entries.map((entry) {
            final isCurrent = _isCurrentShift(entry.value, dayIndex, weekStart);
            return _buildShiftCard(context, entry.value, dayIndex, isCurrent, isPast);
          }),
        ],
      ),
    );
  }

  Widget _buildShiftCard(BuildContext context, ScheduleShift shift, int dayIndex, bool isCurrent, bool isPast) {
    final period = _shiftPeriod(shift.from);

    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: isCurrent ? Border.all(color: Colors.green, width: 1.5) : null,
        boxShadow: [
          BoxShadow(
            color: isCurrent
                ? Colors.green.withValues(alpha: 0.12)
                : Colors.black.withValues(alpha: 0.04),
            blurRadius: isCurrent ? 12 : 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14.r),
        child: Row(
          children: [
            // Color accent bar
            Container(
              width: 5.w,
              height: 80.h,
              color: isCurrent ? Colors.green : period.color,
            ),
            SizedBox(width: 14.w),
            // Period icon
            Container(
              padding: EdgeInsets.all(10.r),
              decoration: BoxDecoration(
                color: (isCurrent ? Colors.green : period.color).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                period.icon,
                color: isCurrent ? Colors.green : period.color,
                size: 22.r,
              ),
            ),
            SizedBox(width: 14.w),
            // Details
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 12.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          shift.roleName ?? period.label,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w700,
                            color: isPast && !isCurrent ? Colors.grey[500] : Colors.black87,
                          ),
                        ),
                        if (isCurrent) ...[
                          SizedBox(width: 8.w),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(6.r),
                            ),
                            child: Text('now_label'.tr(), style: TextStyle(fontSize: 9.sp, color: Colors.white, fontWeight: FontWeight.w800)),
                          ),
                        ],
                      ],
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      '${shift.from ?? ''} - ${shift.to ?? ''}',
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: isPast && !isCurrent ? Colors.grey[400] : Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Hours badge
            if (shift.hours != null)
              Container(
                margin: EdgeInsetsDirectional.only(end: 14.w),
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: (isCurrent ? Colors.green : period.color).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(
                    color: (isCurrent ? Colors.green : period.color).withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      _fmtHours(shift.hours ?? 0),
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w800,
                        color: isCurrent ? Colors.green : period.color,
                      ),
                    ),
                    SizedBox(width: 3.w),
                    Text(
                      'h',
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: isCurrent ? Colors.green : period.color,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
