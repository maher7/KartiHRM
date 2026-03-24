import 'package:core/core.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meta_club_api/meta_club_api.dart';
import 'package:onesthrm/page/my_schedule/my_schedule.dart';

class MyScheduleContentScreen extends StatelessWidget {
  const MyScheduleContentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('my_schedule'.tr())),
      body: BlocBuilder<MyScheduleBloc, MyScheduleState>(
        builder: (context, state) {
          return Column(
            children: [
              _buildWeekSelector(context, state),
              Expanded(child: _buildBody(context, state)),
            ],
          );
        },
      ),
    );
  }

  Widget _buildWeekSelector(BuildContext context, MyScheduleState state) {
    final weekStart = state.weekStart;
    DateTime current;
    try {
      current = DateTime.parse(weekStart ?? '');
    } catch (_) {
      final now = DateTime.now();
      current = now.subtract(Duration(days: now.weekday % 7));
    }

    final prev = current.subtract(const Duration(days: 7));
    final next = current.add(const Duration(days: 7));
    final end = current.add(const Duration(days: 6));
    final fmt = DateFormat('MMM d', 'en');

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {
              context.read<MyScheduleBloc>().add(MyScheduleWeekChangeEvent(
                  weekStart: DateFormat('yyyy-MM-dd', 'en').format(prev)));
            },
            icon: const Icon(Icons.chevron_left),
          ),
          Column(
            children: [
              Text(
                '${fmt.format(current)} - ${fmt.format(end)}',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (state.schedule != null)
                Padding(
                  padding: EdgeInsets.only(top: 4.h),
                  child: Text(
                    '${state.schedule!.totalShifts ?? 0} shifts · ${state.schedule!.totalHours ?? 0}h',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
            ],
          ),
          IconButton(
            onPressed: () {
              context.read<MyScheduleBloc>().add(MyScheduleWeekChangeEvent(
                  weekStart: DateFormat('yyyy-MM-dd', 'en').format(next)));
            },
            icon: const Icon(Icons.chevron_right),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context, MyScheduleState state) {
    if (state.status == NetworkStatus.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.status == NetworkStatus.failure) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48.r, color: Colors.grey[400]),
            SizedBox(height: 12.h),
            Text(
              state.errorMessage ?? 'Failed to load schedule',
              style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
            ),
            SizedBox(height: 16.h),
            ElevatedButton(
              onPressed: () {
                context
                    .read<MyScheduleBloc>()
                    .add(MyScheduleLoadEvent(weekStart: state.weekStart));
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    final shifts = state.schedule?.shifts ?? [];

    if (shifts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.event_available, size: 64.r, color: Colors.grey[300]),
            SizedBox(height: 12.h),
            Text(
              'No shifts this week',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: Colors.grey[500],
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              'You have no shifts assigned for this period',
              style: TextStyle(fontSize: 13.sp, color: Colors.grey[400]),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        context
            .read<MyScheduleBloc>()
            .add(MyScheduleLoadEvent(weekStart: state.weekStart));
      },
      child: ListView.separated(
        padding: EdgeInsets.all(16.w),
        itemCount: shifts.length,
        separatorBuilder: (_, __) => SizedBox(height: 10.h),
        itemBuilder: (context, index) => _buildShiftCard(context, shifts[index]),
      ),
    );
  }

  Widget _buildShiftCard(BuildContext context, ScheduleShift shift) {
    final dayColors = {
      0: Colors.orange,
      1: Colors.blue,
      2: Colors.teal,
      3: Colors.purple,
      4: Colors.indigo,
      5: Colors.green,
      6: Colors.red,
    };

    final color = dayColors[shift.day ?? 0] ?? Colors.grey;

    String dateLabel = '';
    if (shift.date != null) {
      try {
        final d = DateTime.parse(shift.date!);
        dateLabel = DateFormat('MMM d', 'en').format(d);
      } catch (_) {}
    }

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border(left: BorderSide(color: color, width: 4.w)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: EdgeInsets.all(14.w),
      child: Row(
        children: [
          // Day column
          Container(
            width: 56.w,
            padding: EdgeInsets.symmetric(vertical: 8.h),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Column(
              children: [
                Text(
                  shift.dayName?.substring(0, 3) ?? '',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
                ),
                if (dateLabel.isNotEmpty)
                  Text(
                    dateLabel,
                    style: TextStyle(fontSize: 10.sp, color: color),
                  ),
              ],
            ),
          ),
          SizedBox(width: 14.w),
          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.access_time, size: 16.r, color: Colors.grey[600]),
                    SizedBox(width: 6.w),
                    Text(
                      '${shift.from ?? ''} - ${shift.to ?? ''}',
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 6.h),
                Row(
                  children: [
                    if (shift.roleName != null && shift.roleName!.isNotEmpty) ...[
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 8.w, vertical: 3.h),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                        child: Text(
                          shift.roleName!,
                          style: TextStyle(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w500,
                            color: color,
                          ),
                        ),
                      ),
                      SizedBox(width: 8.w),
                    ],
                    if (shift.hours != null)
                      Text(
                        '${shift.hours}h',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.grey[500],
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
