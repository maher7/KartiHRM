import 'package:core/core.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:location_track/location_track.dart';
import 'package:meta_club_api/meta_club_api.dart';
import 'package:onesthrm/page/attendance/attendance.dart';
import 'package:toggle_switch/toggle_switch.dart';

class ShowCurrentLocation extends StatelessWidget {
  final DashboardModel homeData;

  const ShowCurrentLocation({super.key, required this.homeData});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.h),
          padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.h),
          decoration: BoxDecoration(
            color: Branding.colors.primaryLight.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(12.0),
            border: Border.all(
              color: Branding.colors.primaryLight.withValues(alpha: 0.15),
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.location_on_rounded,
                color: Branding.colors.primaryLight,
                size: 20.r,
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  context.read<AttendanceBloc>().state.location ?? instance<LocationServiceProvider>().place,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 12.r,
                    color: Colors.black87,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: 8.w),
              InkWell(
                onTap: () async {
                  if (context.read<AttendanceBloc>().state.locationLoaded) {
                    context.read<AttendanceBloc>().add(OnLocationRefreshEvent());
                  }
                },
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: Branding.colors.primaryLight,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        context.read<AttendanceBloc>().state.locationLoaded
                            ? Icons.refresh_rounded
                            : Icons.hourglass_top_rounded,
                        color: Colors.white,
                        size: 14.r,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        'refresh'.tr(),
                        style: TextStyle(fontSize: 11.r, color: Colors.white, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
        SizedBox(height: 12.h),
        Text("choose_your_remote_mode".tr(),
            style: GoogleFonts.nunitoSans(fontSize: 13.r, color: Colors.black54, fontWeight: FontWeight.w600)),
        SizedBox(height: 8.h),
        FutureBuilder<int?>(
          future: SharedUtil.getRemoteModeType(),
          builder: (context, snapshot) {
            return SizedBox(
              height: 40.0.h,
              child: ToggleSwitch(
                minWidth: 110.0.w,
                borderColor: [Branding.colors.primaryLight],
                borderWidth: 2.5,
                cornerRadius: 30.0,
                activeBgColors: const [
                  [Colors.white],
                  [Colors.white]
                ],
                activeFgColor: Branding.colors.primaryLight,
                inactiveBgColor: Branding.colors.primaryLight,
                inactiveFgColor: Colors.white,
                initialLabelIndex: snapshot.data,
                icons: const [FontAwesomeIcons.house, FontAwesomeIcons.building],
                totalSwitches: 2,
                fontSize: 14.r,
                iconSize: 17.r,
                labels: ['home'.tr(), 'office'.tr()],
                radiusStyle: true,
                onToggle: (index) {
                  context.read<AttendanceBloc>().add(OnRemoteModeChanged(mode: index ?? 0));
                },
              ),
            );
          },
        )
      ],
    );
  }
}
