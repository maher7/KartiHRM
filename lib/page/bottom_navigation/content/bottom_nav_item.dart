import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:onesthrm/page/bottom_navigation/bloc/bottom_nav_cubit.dart';

class BottomNavItem extends StatelessWidget {
  final String icon;
  final String label;
  final bool isSelected;
  final BottomNavTab tab;
  final int badgeCount;

  const BottomNavItem(
      {super.key,
      required this.icon,
      required this.isSelected,
      required this.tab,
      this.label = '',
      this.badgeCount = 0});

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? Branding.colors.primaryDark : const Color(0xFF999999);
    return InkWell(
      onTap: () => context.read<BottomNavCubit>().setTab(tab),
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                SvgPicture.asset(
                  icon,
                  height: 18.h,
                  colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
                ),
                if (badgeCount > 0)
                  Positioned(
                    right: -8,
                    top: -6,
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      decoration: const BoxDecoration(
                        color: Color(0xFFE53935),
                        shape: BoxShape.circle,
                      ),
                      constraints: BoxConstraints(minWidth: 16.r, minHeight: 16.r),
                      child: Center(
                        child: Text(
                          badgeCount > 99 ? '99+' : '$badgeCount',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 8.r,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 2.h),
            Text(
              label,
              style: TextStyle(
                fontSize: 9.r,
                color: color,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
