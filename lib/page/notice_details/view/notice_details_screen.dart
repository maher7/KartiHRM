import 'package:core/core.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meta_club_api/meta_club_api.dart';

class NoticeDetailsScreen extends StatelessWidget {
  final int? noticeId;
  final String? image;
  final String? title;
  final String? date;
  final String? body;
  final NotificationDataModel? notificationResponse;

  const NoticeDetailsScreen(
      {super.key,
      this.noticeId,
      this.notificationResponse,
      this.title,
      this.image,
      this.body,
      this.date});

  String _formatDate(String? rawDate) {
    if (rawDate == null || rawDate.isEmpty) return '';
    try {
      final parsed = DateTime.parse(rawDate);
      return DateFormat('dd MMM yyyy, hh:mm a').format(parsed);
    } catch (_) {
      return rawDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          tr("notice_details"),
          style: TextStyle(fontSize: 16.r),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header section
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20.r),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Branding.colors.primaryLight.withValues(alpha: 0.08),
                    Colors.white,
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    title ?? "",
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 18.r,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  // Date
                  if (date != null && date!.isNotEmpty)
                    Row(
                      children: [
                        Icon(
                          Icons.access_time_rounded,
                          size: 14.r,
                          color: Colors.black38,
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          _formatDate(date),
                          style: TextStyle(
                            fontSize: 12.r,
                            color: Colors.black45,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),

            Divider(height: 1, color: Colors.grey.shade100),

            // Body content (HTML rendered)
            if (body != null && body!.isNotEmpty)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                child: Html(
                  data: body,
                  style: {
                    "body": Style(
                      fontSize: FontSize(14.r),
                      lineHeight: const LineHeight(1.6),
                      color: Colors.black87,
                      padding: HtmlPaddings.zero,
                      margin: Margins.zero,
                    ),
                    "span": Style(
                      fontSize: FontSize(14.r),
                    ),
                    "b": Style(
                      fontWeight: FontWeight.w700,
                    ),
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
