import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:onesthrm/page/home/bloc/home_bloc.dart';
import 'package:onesthrm/page/language/bloc/language_bloc.dart';

class PlutoUpcomingEvent extends StatelessWidget {
  const PlutoUpcomingEvent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageBloc, LanguageState>(
      builder: (context, _) {
        final dashboardModel = context.read<HomeBloc>().state.dashboardModel;
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 16.h, bottom: 8.h),
                child: Text(
                  "upcoming_events".tr(),
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.r,
                      color: Colors.black87),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 6,
                        offset: const Offset(0, 2)),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        'assets/images/new_Upcoming_Event.png',
                        height: 140.h,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 10.h, horizontal: 12.w),
                        child: Text(
                          'public_holiday_and_even'.tr(),
                          style: TextStyle(
                              fontSize: 12.r,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey.shade600),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (dashboardModel?.data?.upcomingEvents?.isNotEmpty == true)
                SizedBox(
                    height: 220.h,
                    child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount:
                            dashboardModel?.data?.upcomingEvents?.length ?? 0,
                        itemBuilder: (BuildContext context, int index) {
                          final data =
                              dashboardModel?.data?.upcomingEvents?[index];
                          final rawImage = data?.image;
                          final imageUrl = (rawImage != null &&
                                  rawImage.toString() != 'null' &&
                                  rawImage.toString().isNotEmpty &&
                                  Uri.tryParse(rawImage.toString())
                                          ?.hasScheme ==
                                      true)
                              ? rawImage.toString()
                              : '';
                          return Padding(
                            padding: EdgeInsets.only(right: 12.w, top: 12.h),
                            child: Container(
                              width: 200.w,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                      color:
                                          Colors.black.withValues(alpha: 0.05),
                                      blurRadius: 6,
                                      offset: const Offset(0, 2)),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    (imageUrl.isNotEmpty)
                                        ? CachedNetworkImage(
                                            height: 120.h,
                                            width: double.infinity,
                                            fit: BoxFit.cover,
                                            imageUrl: imageUrl,
                                            placeholder: (context, url) =>
                                                Container(
                                              height: 120.h,
                                              color: Colors.grey.shade100,
                                              child: Center(
                                                  child: Image.asset(
                                                      "assets/images/placeholder_image.png")),
                                            ),
                                            errorWidget:
                                                (context, url, error) =>
                                                    Container(
                                              height: 120.h,
                                              color: Colors.grey.shade100,
                                              child: const Center(
                                                  child: Icon(
                                                      Icons
                                                          .image_not_supported_outlined,
                                                      color: Colors.grey)),
                                            ),
                                          )
                                        : Container(
                                            height: 120.h,
                                            color: Colors.grey.shade100,
                                            child: const Center(
                                                child: Icon(Icons.event,
                                                    color: Colors.grey)),
                                          ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10.w, vertical: 8.h),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text("${data?.startDate}",
                                              style: TextStyle(
                                                  color: Colors.grey.shade500,
                                                  fontSize: 11.r)),
                                          SizedBox(height: 4.h),
                                          Text("${data?.title}",
                                              style: TextStyle(
                                                  fontSize: 14.r,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.black87),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        })),
            ],
          ),
        );
      },
    );
  }
}
