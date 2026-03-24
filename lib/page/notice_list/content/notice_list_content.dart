import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meta_club_api/meta_club_api.dart';
import 'package:onesthrm/page/notice_details/view/notice_details_screen.dart';
import 'package:onesthrm/res/nav_utail.dart';

class NoticeListContent extends StatelessWidget {
  const NoticeListContent({
    super.key,
    required this.data,
  });

  final NoticeListDatum? data;

  String _formatDate(String? raw) {
    if (raw == null || raw.isEmpty) return '';
    try {
      final parsed = DateTime.parse(raw);
      final now = DateTime.now();
      final diff = now.difference(parsed);
      if (diff.inMinutes < 1) return 'Just now';
      if (diff.inHours < 1) return '${diff.inMinutes}m ago';
      if (diff.inHours < 24) return '${diff.inHours}h ago';
      if (diff.inDays < 7) return '${diff.inDays}d ago';
      const months = ['', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      return '${parsed.day.toString().padLeft(2, '0')} ${months[parsed.month]} ${parsed.year}';
    } catch (_) {
      return raw;
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasDescription = data?.description != null && data!.description!.trim().isNotEmpty;

    return InkWell(
      onTap: () {
        NavUtil.navigateScreen(
          context,
          NoticeDetailsScreen(
            image: data?.file,
            title: data?.subject,
            date: data?.date,
            body: data?.description,
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Padding(
          padding: EdgeInsets.all(12.r),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Announcement icon
              Container(
                width: 42.r,
                height: 42.r,
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.campaign_rounded, color: const Color(0xFF388E3C), size: 22.r),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data?.subject ?? '',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 13.r,
                        color: Colors.black87,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (hasDescription) ...[
                      SizedBox(height: 4.h),
                      Text(
                        data!.description!,
                        style: TextStyle(
                          fontSize: 12.r,
                          color: Colors.black54,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    SizedBox(height: 4.h),
                    Text(
                      _formatDate(data?.date),
                      style: TextStyle(color: Colors.black38, fontSize: 10.r),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: Colors.black26, size: 20.r),
            ],
          ),
        ),
      ),
    );
  }
}
