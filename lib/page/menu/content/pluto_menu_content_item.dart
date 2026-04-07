import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meta_club_api/meta_club_api.dart';
import 'package:onesthrm/res/widgets/dynamic_image_viewer.dart';

class PlutoMenuContentItem extends StatelessWidget {
  final Function() onPressed;
  final Menu menu;
  final AnimationController animationController;
  final Animation animation;
  final int badgeCount;

  const PlutoMenuContentItem(
      {super.key,
      required this.onPressed,
      required this.menu,
      required this.animationController,
      required this.animation,
      this.badgeCount = 0});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: animationController,
        builder: (_, __) {
          return FadeTransition(
            opacity: kAlwaysCompleteAnimation,
            child: Transform(
              transform: Matrix4.translationValues(0.0, 50.0 * (1.0 - animation.value), 0.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12).r,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(12).r,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12).r,
                    onTap: onPressed,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 8.h),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Stack(
                            clipBehavior: Clip.none,
                            children: [
                              DynamicImageViewer(
                                image: menu.icon ?? "",
                              ),
                              if (badgeCount > 0)
                                Positioned(
                                  top: -4,
                                  right: -8,
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
                          SizedBox(height: 6.h),
                          Text(
                            menu.name ?? '',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 11.r, color: Colors.black87, fontWeight: FontWeight.w500),
                          ).tr(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }
}
