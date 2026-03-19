import 'package:core/core.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:location_track/location_track.dart';
import 'package:meta_club_api/meta_club_api.dart';
import 'package:onesthrm/page/visit/view/visit_details_page/visit_details_page.dart';
import 'package:onesthrm/res/nav_utail.dart';
import '../../../authentication/bloc/authentication_bloc.dart';
import '../../bloc/visit_bloc.dart';

class VisitListItem extends StatelessWidget {
  final MyVisit? myVisit;

  const VisitListItem({super.key, this.myVisit});

  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthenticationBloc>().state.data;

    if (user?.user != null) {
      instance<LocationServiceProvider>().getCurrentLocationStream(
          uid: '${globalState.get(companyId)}${user!.user!.id!}',
          metaClubApiClient: MetaClubApiClient(httpService: instance()));
    }

    Color statusColor;
    try {
      statusColor = Color(int.parse(myVisit?.statusColor ?? "0xFFFF8F5E"));
    } catch (_) {
      statusColor = const Color(0xFFFF8F5E);
    }

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
                BlocProvider.value(
                    value: context.read<VisitBloc>(),
                    child: VisitDetailsPage(
                      visitID: myVisit!.id!,
                    )));
          },
          child: Padding(
            padding: EdgeInsets.all(14.r),
            child: Row(
              children: [
                Container(
                  width: 4.w,
                  height: 40.h,
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        myVisit?.title ?? "",
                        style: TextStyle(
                            fontSize: 14.r,
                            color: Colors.black87,
                            fontWeight: FontWeight.w600),
                      ).tr(),
                      SizedBox(height: 6.h),
                      Row(
                        children: [
                          Icon(Icons.calendar_today_outlined, size: 12.r, color: Colors.black38),
                          SizedBox(width: 4.w),
                          Text(
                            myVisit?.date ?? "",
                            style: TextStyle(fontSize: 11.r, color: Colors.black45),
                          ),
                          SizedBox(width: 10.w),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 3.h),
                            decoration: BoxDecoration(
                              color: statusColor,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              myVisit?.status ?? "",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10.r,
                                  fontWeight: FontWeight.w600),
                            ).tr(),
                          ),
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
