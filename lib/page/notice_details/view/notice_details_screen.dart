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

  /// Strip HTML tags and redundant "Notice:" prefix
  String _clean(String? text) {
    if (text == null) return '';
    // Strip HTML tags first
    var cleaned = text.replaceAll(RegExp(r'<[^>]*>'), '').trim();
    // Strip "Notice:" prefix
    if (cleaned.toLowerCase().startsWith('notice:')) {
      cleaned = cleaned.substring(7).trim();
    }
    if (cleaned.toLowerCase().startsWith('notice:')) {
      cleaned = cleaned.substring(7).trim();
    }
    return cleaned;
  }

  String _formatDate(String? rawDate) {
    if (rawDate == null || rawDate.isEmpty) return '';
    try {
      final parsed = DateTime.parse(rawDate);
      const months = ['', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      final h = parsed.hour > 12 ? parsed.hour - 12 : (parsed.hour == 0 ? 12 : parsed.hour);
      final ampm = parsed.hour >= 12 ? 'PM' : 'AM';
      return '${parsed.day.toString().padLeft(2, '0')} ${months[parsed.month]} ${parsed.year}, ${h.toString().padLeft(2, '0')}:${parsed.minute.toString().padLeft(2, '0')} $ampm';
    } catch (_) {
      return rawDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    final cleanTitle = _clean(title);
    final cleanBody = _clean(body);

    // Determine what to show as heading vs content
    final hasTitle = cleanTitle.isNotEmpty;
    final hasBody = cleanBody.isNotEmpty;
    final displayTitle = hasTitle ? cleanTitle : (hasBody ? cleanBody : 'Notification');
    final displayContent = hasBody ? cleanBody : (hasTitle ? cleanTitle : null);
    // Don't duplicate: if title == body, only show as content
    final showTitleInHeader = hasTitle && hasBody && cleanTitle != cleanBody;
    final isHtml = displayContent != null && displayContent.contains('<');

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Branding.colors.textPrimary),
        title: Text(
          tr("notice_details"),
          style: TextStyle(fontSize: 16.r, color: Colors.black87),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header section
            Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 16.h),
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
                  if (showTitleInHeader)
                    Text(
                      displayTitle,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 18.r,
                        color: Colors.black87,
                      ),
                    ),
                  if (showTitleInHeader) SizedBox(height: 8.h),
                  if (date != null && date!.isNotEmpty)
                    Row(
                      children: [
                        Icon(Icons.access_time_rounded, size: 14.r, color: Colors.black38),
                        SizedBox(width: 6.w),
                        Text(
                          _formatDate(date),
                          style: TextStyle(fontSize: 12.r, color: Colors.black45),
                        ),
                      ],
                    ),
                ],
              ),
            ),

            Divider(height: 1, color: Colors.grey.shade200),

            // Body content
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
              child: displayContent != null
                  ? isHtml
                      ? Html(
                          data: displayContent,
                          style: {
                            "body": Style(
                              fontSize: FontSize(15.r),
                              lineHeight: const LineHeight(1.7),
                              color: Colors.black87,
                              padding: HtmlPaddings.zero,
                              margin: Margins.zero,
                            ),
                            "p": Style(
                              fontSize: FontSize(15.r),
                              lineHeight: const LineHeight(1.7),
                              margin: Margins.only(bottom: 10),
                            ),
                            "span": Style(fontSize: FontSize(15.r)),
                            "b": Style(fontWeight: FontWeight.w700),
                            "br": Style(margin: Margins.only(bottom: 4)),
                          },
                        )
                      : Text(
                          displayContent,
                          style: TextStyle(
                            fontSize: 15.r,
                            height: 1.7,
                            color: Colors.black87,
                          ),
                        )
                  : Text(
                      "No content available",
                      style: TextStyle(fontSize: 14.r, color: Colors.grey),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
