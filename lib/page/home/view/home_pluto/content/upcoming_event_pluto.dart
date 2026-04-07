import 'package:core/core.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meta_club_api/meta_club_api.dart';
import 'package:onesthrm/page/home/bloc/home_bloc.dart';
import 'package:onesthrm/page/language/bloc/language_bloc.dart';

class PlutoUpcomingEvent extends StatefulWidget {
  const PlutoUpcomingEvent({super.key});

  @override
  State<PlutoUpcomingEvent> createState() => _PlutoUpcomingEventState();
}

class _PlutoUpcomingEventState extends State<PlutoUpcomingEvent> {
  final PageController _pageController = PageController(viewportFraction: 0.92);
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageBloc, LanguageState>(
      builder: (context, _) {
        final dashboardModel = context.read<HomeBloc>().state.dashboardModel;
        final events = dashboardModel?.data?.upcomingEvents ?? [];
        final hasEvents = events.isNotEmpty;

        // Clamp current page if event list shrinks
        if (_currentPage >= events.length && events.isNotEmpty) {
          _currentPage = 0;
        }

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 16.h, bottom: 10.h),
                child: Row(
                  children: [
                    Icon(Icons.event_rounded, size: 18.r, color: Branding.colors.primaryLight),
                    SizedBox(width: 6.w),
                    Text(
                      "upcoming_events".tr(),
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15.r,
                        color: Colors.black87,
                      ),
                    ),
                    if (hasEvents) ...[
                      SizedBox(width: 6.w),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 2.h),
                        decoration: BoxDecoration(
                          color: Branding.colors.primaryLight.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Text(
                          '${_currentPage + 1}/${events.length}',
                          style: TextStyle(
                            fontSize: 10.r,
                            fontWeight: FontWeight.w700,
                            color: Branding.colors.primaryLight,
                          ),
                        ),
                      ),
                    ],
                    const Spacer(),
                    if (hasEvents && events.length > 1)
                      Text(
                        'swipe_hint'.tr(),
                        style: TextStyle(
                          fontSize: 10.r,
                          color: Colors.grey.shade500,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                  ],
                ),
              ),

              // No events: compact empty state
              if (!hasEvents)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 16.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(10.r),
                        decoration: BoxDecoration(
                          color: Branding.colors.primaryLight.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Icon(
                          Icons.event_available_rounded,
                          color: Branding.colors.primaryLight,
                          size: 22.r,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'no_upcoming_events'.tr(),
                              style: TextStyle(
                                fontSize: 13.r,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              'public_holiday_and_even'.tr(),
                              style: TextStyle(
                                fontSize: 11.r,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

              // Events: swipeable carousel
              if (hasEvents) ...[
                SizedBox(
                  height: 100.h,
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: events.length,
                    onPageChanged: (i) => setState(() => _currentPage = i),
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4.w),
                        child: _EventCard(data: events[index]),
                      );
                    },
                  ),
                ),
                SizedBox(height: 10.h),
                // Dot indicators
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      events.length,
                      (i) => AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        margin: EdgeInsets.symmetric(horizontal: 3.w),
                        width: _currentPage == i ? 18.w : 6.w,
                        height: 6.h,
                        decoration: BoxDecoration(
                          color: _currentPage == i
                              ? Branding.colors.primaryLight
                              : Branding.colors.primaryLight.withValues(alpha: 0.25),
                          borderRadius: BorderRadius.circular(3.r),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _EventCard extends StatelessWidget {
  const _EventCard({required this.data});
  final UpcomingEvent data;

  ({IconData icon, Color color, String label, List<Color> gradient}) _typeStyle() {
    switch (data.type) {
      case 'holiday':
        return (
          icon: Icons.beach_access_rounded,
          color: const Color(0xFFEF6C00),
          label: 'holiday'.tr(),
          gradient: [const Color(0xFFFFB74D), const Color(0xFFEF6C00)],
        );
      case 'appointment':
        return (
          icon: Icons.event_note_rounded,
          color: const Color(0xFF5E81F4),
          label: 'appointment'.tr(),
          gradient: [const Color(0xFF7E9EFF), const Color(0xFF4262DA)],
        );
      case 'birthday':
        return (
          icon: Icons.cake_rounded,
          color: const Color(0xFFEC407A),
          label: 'birthday'.tr(),
          gradient: [const Color(0xFFFF7AA7), const Color(0xFFC2185B)],
        );
      case 'notice':
        return (
          icon: Icons.notifications_active_rounded,
          color: const Color(0xFF00897B),
          label: 'notice'.tr(),
          gradient: [const Color(0xFF4DB6AC), const Color(0xFF00695C)],
        );
      default:
        return (
          icon: Icons.event_rounded,
          color: Branding.colors.primaryLight,
          label: 'event'.tr(),
          gradient: [Branding.colors.primaryLight, Branding.colors.primaryDark],
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final style = _typeStyle();
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: [
          BoxShadow(
            color: style.color.withValues(alpha: 0.12),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          // Colored gradient icon block
          Container(
            height: 72.h,
            width: 56.w,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: style.gradient,
              ),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(style.icon, color: Colors.white, size: 28.r),
          ),
          SizedBox(width: 14.w),
          // Details
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: style.color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Text(
                    style.label,
                    style: TextStyle(
                      fontSize: 9.r,
                      fontWeight: FontWeight.w800,
                      color: style.color,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  data.title ?? '',
                  style: TextStyle(
                    fontSize: 14.r,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 3.h),
                Row(
                  children: [
                    Icon(Icons.calendar_today_rounded, size: 11.r, color: Colors.grey.shade500),
                    SizedBox(width: 4.w),
                    Flexible(
                      child: Text(
                        '${data.date ?? data.startDate ?? ''}${data.day != null && data.day!.isNotEmpty ? ' · ${data.day}' : ''}',
                        style: TextStyle(
                          fontSize: 11.r,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
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
