import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:onesthrm/page/belletin/bloc/bulletin_bloc.dart';
import 'package:onesthrm/page/belletin/bloc/bulletin_state.dart';
import 'marquee.dart';

class NewsBulletinContent extends StatelessWidget {
  const NewsBulletinContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BulletinBloc, BulletinState>(
      builder: (context, state) {
        final show = state.headline != null && state.headline!.trim().isNotEmpty && !state.dismissed;
        if (!show) return const SizedBox.shrink();

        final isUrgent = state.type == BulletinType.urgent;
        return Container(
          height: DeviceUtil.isTablet ? 55 : 38,
          color: isUrgent ? const Color(0xFFD32F2F) : Branding.colors.primaryLight,
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 10.w),
                child: Icon(
                  isUrgent ? Icons.warning_amber_rounded : Icons.campaign_rounded,
                  color: Colors.white70,
                  size: 16.r,
                ),
              ),
              if (isUrgent)
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 6.w),
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.r),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'URGENT',
                    style: TextStyle(
                      color: const Color(0xFFD32F2F),
                      fontSize: 10.r,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              Expanded(
                child: Marquee(
                  text: state.headline!,
                  style: TextStyle(color: Colors.white, fontSize: 14.r),
                  scrollAxis: Axis.horizontal,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  blankSpace: 20.0,
                  velocity: 30.0,
                  pauseAfterRound: const Duration(seconds: 1),
                  startPadding: 10.0,
                  accelerationDuration: const Duration(seconds: 1),
                  accelerationCurve: Curves.linear,
                  decelerationDuration: const Duration(milliseconds: 100),
                  decelerationCurve: Curves.easeOut,
                ),
              ),
              InkWell(
                onTap: () => context.read<BulletinBloc>().dismiss(),
                child: Container(
                  margin: EdgeInsets.only(right: 8.w),
                  padding: EdgeInsets.all(4.r),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Icon(Icons.close_rounded, color: Colors.white, size: 14.r),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
