import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meta_club_api/meta_club_api.dart';
import 'package:onesthrm/page/support/content/priority_type.dart';
import 'package:onesthrm/page/support/content/type_name_widget.dart';
import 'package:onesthrm/page/support/view/support_details/support_details.dart';
import 'package:onesthrm/res/nav_utail.dart';

class SupportTicketItem extends StatelessWidget {
  final SupportModel supportModel;

  const SupportTicketItem({super.key, required this.supportModel});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            NavUtil.navigateScreen(
                context,
                SupportDetails(
                  supportModel: supportModel,
                ));
          },
          child: Padding(
            padding: EdgeInsets.all(14.r),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        supportModel.subject ?? "",
                        style: TextStyle(
                            fontSize: 14.r,
                            color: Colors.black87,
                            fontWeight: FontWeight.w600),
                      ).tr(),
                      SizedBox(height: 8.h),
                      Row(
                        children: [
                          Icon(Icons.calendar_today_outlined, size: 12.r, color: Colors.black38),
                          SizedBox(width: 4.w),
                          Text(
                            supportModel.date ?? "",
                            style: TextStyle(fontSize: 11.r, color: Colors.black45),
                          ),
                          SizedBox(width: 10.w),
                          TypeNameWidget(supportModel: supportModel),
                          SizedBox(width: 6.w),
                          PriorityType(supportModel: supportModel),
                        ],
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.black26,
                  size: 16.r,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
