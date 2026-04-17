import 'package:core/core.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meta_club_api/meta_club_api.dart';
import 'package:onesthrm/page/authentication/bloc/authentication_bloc.dart';
import 'package:onesthrm/page/my_availability/my_availability.dart';
import 'package:onesthrm/res/widgets/screen_header.dart';

/// Week-long 4-state availability editor. Employees pick one of
/// can / want / prefer_not / cannot for each day before the deadline.
class MyAvailabilityContentScreen extends StatelessWidget {
  const MyAvailabilityContentScreen({super.key});

  static const List<String> _dayKeys = [
    'sunday', 'monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday',
  ];

  String _prettyWeekRange(String? weekStartIso) {
    if (weekStartIso == null) return '';
    try {
      final start = DateTime.parse(weekStartIso);
      final end = DateTime(start.year, start.month, start.day + 6);
      String two(int n) => n.toString().padLeft(2, '0');
      return '${two(start.day)}/${two(start.month)} — ${two(end.day)}/${two(end.month)}';
    } catch (_) {
      return weekStartIso;
    }
  }

  String _shiftedWeek(String? weekStartIso, int days) {
    final base = weekStartIso != null ? DateTime.tryParse(weekStartIso) : null;
    final d = base ?? DateTime.now();
    final next = DateTime(d.year, d.month, d.day + days);
    final y = next.year.toString().padLeft(4, '0');
    final m = next.month.toString().padLeft(2, '0');
    final dd = next.day.toString().padLeft(2, '0');
    return '$y-$m-$dd';
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MyAvailabilityBloc, MyAvailabilityState>(
      listenWhen: (p, c) => p.submitStatus != c.submitStatus,
      listener: (context, state) {
        if (state.submitStatus == NetworkStatus.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('availability_submitted'.tr())),
          );
        } else if (state.submitStatus == NetworkStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? 'something_went_wrong'.tr()),
              backgroundColor: Colors.red.shade600,
            ),
          );
        }
      },
      builder: (context, state) {
        final loading = state.status == NetworkStatus.loading;
        final submitting = state.submitStatus == NetworkStatus.loading;
        return Scaffold(
          backgroundColor: const Color(0xFFF5F7FB),
          body: SafeArea(
            child: Column(
              children: [
                ScreenHeader(
                  title: 'my_availability'.tr(),
                  subtitle: _prettyWeekRange(state.weekStart),
                ),
                _WeekNav(
                  weekStart: state.weekStart,
                  onPrev: () => context.read<MyAvailabilityBloc>().add(
                        MyAvailabilityWeekChangeEvent(
                          weekStart: _shiftedWeek(state.weekStart, -7),
                        ),
                      ),
                  onNext: () => context.read<MyAvailabilityBloc>().add(
                        MyAvailabilityWeekChangeEvent(
                          weekStart: _shiftedWeek(state.weekStart, 7),
                        ),
                      ),
                ),
                Expanded(
                  child: loading
                      ? const Center(child: CircularProgressIndicator())
                      : ListView.builder(
                          padding: EdgeInsets.fromLTRB(12.w, 8.h, 12.w, 96.h),
                          itemCount: 7,
                          itemBuilder: (context, i) {
                            final item = state.items.firstWhere(
                              (it) => it.day == i,
                              orElse: () => AvailabilityItem(
                                day: i,
                                state: AvailabilityState.can,
                              ),
                            );
                            return _DayCard(
                              dayLabel: _dayKeys[i].tr(),
                              item: item,
                              onStateChanged: (s) => context
                                  .read<MyAvailabilityBloc>()
                                  .add(MyAvailabilitySetDayEvent(day: i, state: s)),
                              onNoteChanged: (t) => context
                                  .read<MyAvailabilityBloc>()
                                  .add(MyAvailabilitySetDayEvent(day: i, note: t)),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: SafeArea(
            child: Padding(
              padding: EdgeInsets.all(12.w),
              child: SizedBox(
                width: double.infinity,
                height: 48.h,
                child: ElevatedButton.icon(
                  onPressed: submitting
                      ? null
                      : () {
                          final user = context.read<AuthenticationBloc>().state.data;
                          final userId = user?.user?.id ?? 0;
                          if (userId == 0) return;
                          context.read<MyAvailabilityBloc>().add(
                                MyAvailabilitySubmitEvent(userId: userId),
                              );
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2563EB),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  icon: submitting
                      ? SizedBox(
                          width: 18.w,
                          height: 18.w,
                          child: const CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.check_circle_outline),
                  label: Text(
                    'submit_availability'.tr(),
                    style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _WeekNav extends StatelessWidget {
  const _WeekNav({required this.weekStart, required this.onPrev, required this.onNext});

  final String? weekStart;
  final VoidCallback onPrev;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(12.w, 8.h, 12.w, 0),
      child: Row(
        children: [
          IconButton(
            onPressed: onPrev,
            icon: const Icon(Icons.chevron_left),
            style: IconButton.styleFrom(backgroundColor: Colors.white),
          ),
          Expanded(
            child: Center(
              child: Text(
                weekStart ?? '',
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          IconButton(
            onPressed: onNext,
            icon: const Icon(Icons.chevron_right),
            style: IconButton.styleFrom(backgroundColor: Colors.white),
          ),
        ],
      ),
    );
  }
}

class _DayCard extends StatelessWidget {
  const _DayCard({
    required this.dayLabel,
    required this.item,
    required this.onStateChanged,
    required this.onNoteChanged,
  });

  final String dayLabel;
  final AvailabilityItem item;
  final ValueChanged<AvailabilityState> onStateChanged;
  final ValueChanged<String> onNoteChanged;

  static const Map<AvailabilityState, Color> _colors = {
    AvailabilityState.can: Color(0xFF0EA5E9),
    AvailabilityState.want: Color(0xFF16A34A),
    AvailabilityState.preferNot: Color(0xFFF59E0B),
    AvailabilityState.cannot: Color(0xFFDC2626),
  };

  static const Map<AvailabilityState, String> _labelKeys = {
    AvailabilityState.can: 'availability_can',
    AvailabilityState.want: 'availability_want',
    AvailabilityState.preferNot: 'availability_prefer_not',
    AvailabilityState.cannot: 'availability_cannot',
  };

  @override
  Widget build(BuildContext context) {
    final activeColor = _colors[item.state] ?? Colors.grey;
    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: activeColor.withOpacity(0.35), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 10.w,
                height: 10.w,
                decoration: BoxDecoration(color: activeColor, shape: BoxShape.circle),
              ),
              SizedBox(width: 8.w),
              Text(
                dayLabel,
                style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w700),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: AvailabilityState.values.map((s) {
              final selected = s == item.state;
              final color = _colors[s] ?? Colors.grey;
              return GestureDetector(
                onTap: () => onStateChanged(s),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    color: selected ? color : color.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(color: color, width: 1.2),
                  ),
                  child: Text(
                    (_labelKeys[s] ?? '').tr(),
                    style: TextStyle(
                      color: selected ? Colors.white : color,
                      fontWeight: FontWeight.w600,
                      fontSize: 12.sp,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          SizedBox(height: 10.h),
          TextFormField(
            initialValue: item.note ?? '',
            onChanged: onNoteChanged,
            decoration: InputDecoration(
              hintText: 'availability_note_hint'.tr(),
              isDense: true,
              contentPadding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
