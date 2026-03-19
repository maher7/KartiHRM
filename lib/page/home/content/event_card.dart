import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meta_club_api/meta_club_api.dart';
import 'package:core/core.dart';
import 'event_card_item.dart';

class EventCard extends StatelessWidget {

  const EventCard({super.key, required this.data, this.days = false, this.onPressed});

  final TodayData? data;
  final bool? days;
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 2.0),
      child: Material(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onPressed,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0.h, horizontal: 14.0),
            child: SizedBox(
              width: 85.w,
              child: Column(
                children: [
                  Image.network(
                    '${data?.image}',
                    height: 22.h,
                    color: Colors.white,
                  ),
                  SizedBox(height: 6.h),
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.end,
                    children: [
                      Text(
                        '${data?.number}',
                        style: TextStyle(
                          fontSize: 20.r,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (days == true)
                        Padding(
                          padding: EdgeInsets.only(bottom: 3.h),
                          child: Text(
                            'days'.tr(),
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.8),
                              fontSize: 11.r,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    data?.title ?? '',
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 11.r,
                      color: Colors.white.withValues(alpha: 0.85),
                      fontWeight: FontWeight.w500,
                    ),
                  ).tr(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class EventCard2 extends StatelessWidget {
  const EventCard2(
      {super.key, required this.data, this.days = false, this.onPressed});

  final CurrentMonthData? data;
  final bool? days;
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 4.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: onPressed,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0.h, horizontal: 12.0),
              child: SizedBox(
                width: 90.w,
                child: Column(
                  children: [
                    Image.network(
                      '${data?.image}',
                      height: 20.h,
                      color: Branding.colors.primaryLight,
                    ),
                    SizedBox(height: 6.h),
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.end,
                      children: [
                        Text(
                          '${data?.number}',
                          style: TextStyle(
                            fontSize: 20.r,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        if (days == true)
                          Padding(
                            padding: EdgeInsets.only(bottom: 3.h),
                            child: Text(
                              'days'.tr(),
                              style: TextStyle(
                                color: Colors.black45,
                                fontSize: 11.r,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      data?.title ?? '',
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 11.r,
                        color: Colors.black54,
                        fontWeight: FontWeight.w500,
                      ),
                    ).tr(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class UpcomingEventCard extends StatelessWidget {
  const UpcomingEventCard({super.key, required this.events});

  final List<UpcomingEvent> events;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10.0, left: 16, right: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
            child: Image.asset(
              'assets/images/new_Upcoming_Event.png',
              height: 120.h,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(14.0.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('upcoming_events'.tr(),
                    style: TextStyle(
                        fontSize: 16.r,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.3)),
                SizedBox(height: 2.h),
                Text('public_holiday_and_even'.tr(),
                    style: TextStyle(
                        fontSize: 12.r,
                        fontWeight: FontWeight.w400,
                        color: Colors.black45)),
                SizedBox(height: 10.h),
                Column(
                  children: events
                      .map((e) => EventCardItem(upcomingItems: e))
                      .toList(),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class UpcomingEventCardMars extends StatelessWidget {
  const UpcomingEventCardMars({super.key, required this.events});

  final List<UpcomingEvent> events;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10.0, left: 16, right: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: primaryBorderColor),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
            child: Image.asset(
              'assets/images/new_Upcoming_Event.png',
              height: 120.h,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(14.0.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('upcoming_events'.tr(),
                    style: TextStyle(
                        fontSize: 16.r,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.3)),
                SizedBox(height: 2.h),
                Text('public_holiday_and_even'.tr(),
                    style: TextStyle(
                        fontSize: 12.r,
                        fontWeight: FontWeight.w400,
                        color: Colors.black45)),
                SizedBox(height: 10.h),
                Column(
                  children: events
                      .map((e) => EventCardItem(upcomingItems: e))
                      .toList(),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class UpcomingEventCardNeptune extends StatelessWidget {
  const UpcomingEventCardNeptune({super.key, required this.events});

  final List<UpcomingEvent> events;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10.0, left: 16, right: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: primaryBorderColor),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
            child: Image.asset(
              'assets/images/new_Upcoming_Event.png',
              height: 120.h,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(14.0.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('upcoming_events'.tr(),
                    style: TextStyle(
                        fontSize: 16.r,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.3)),
                SizedBox(height: 2.h),
                Text('public_holiday_and_even'.tr(),
                    style: TextStyle(
                        fontSize: 12.r,
                        fontWeight: FontWeight.w400,
                        color: Colors.black45)),
                SizedBox(height: 10.h),
                Column(
                  children: events
                      .map((e) => EventCardItem(upcomingItems: e))
                      .toList(),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
