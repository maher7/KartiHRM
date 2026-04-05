import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Reusable branded header for main tab screens (Leave, Schedule, Alerts, etc).
///
/// Shows the app logo, screen title, subtitle, optional action icons, and an
/// optional [bottom] slot (for toggles, filters, date pickers).
///
/// - Auto-shows a back arrow when [Navigator.canPop] is true (unless [showBack] overrides it)
/// - Supports LTR and RTL via AlignmentDirectional
/// - Uses the brand primary-dark → primary-light gradient
class ScreenHeader extends StatelessWidget {
  const ScreenHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.actions = const [],
    this.bottom,
    this.showLogo = true,
    this.showBack,
    this.logoAsset = 'assets/images/FavLogo.png',
    this.badgeText,
  });

  /// Primary screen title (e.g. "Leaves & Requests")
  final String title;

  /// Secondary line below the title (e.g. user role, date range, unread count)
  final String? subtitle;

  /// Trailing icon buttons (notifications, search, etc)
  final List<Widget> actions;

  /// Widget rendered below the title row (toggle segmented control, filters, etc)
  final Widget? bottom;

  /// Whether to show the brand logo on the leading side
  final bool showLogo;

  /// Force-show or force-hide the back arrow. If null, auto-detects via
  /// Navigator.canPop.
  final bool? showBack;

  /// Path to the logo asset shown on the leading side
  final String logoAsset;

  /// Optional small badge pill below the header (e.g. store/branch name)
  final String? badgeText;

  @override
  Widget build(BuildContext context) {
    final bool canPop = showBack ?? Navigator.of(context).canPop();

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: AlignmentDirectional.topStart,
          end: AlignmentDirectional.bottomEnd,
          colors: [
            Branding.colors.primaryDark,
            Branding.colors.primaryLight,
          ],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Branding.colors.primaryDark.withValues(alpha: 0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 14.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (canPop)
                    _HeaderIconButton(
                      icon: Icons.arrow_back_ios_new_rounded,
                      onTap: () => Navigator.of(context).maybePop(),
                    )
                  else if (showLogo)
                    _HeaderLogo(asset: logoAsset),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 17.r,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            letterSpacing: 0.2,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (subtitle != null && subtitle!.isNotEmpty) ...[
                          SizedBox(height: 2.h),
                          Text(
                            subtitle!,
                            style: TextStyle(
                              fontSize: 12.r,
                              fontWeight: FontWeight.w400,
                              color: Colors.white.withValues(alpha: 0.85),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (badgeText != null && badgeText!.isNotEmpty)
                    Container(
                      margin: EdgeInsetsDirectional.only(start: 8.w),
                      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                      child: Text(
                        badgeText!,
                        style: TextStyle(
                          fontSize: 11.r,
                          fontWeight: FontWeight.w600,
                          color: Branding.colors.primaryDark,
                        ),
                      ),
                    ),
                  ...actions,
                ],
              ),
              if (bottom != null) ...[
                SizedBox(height: 12.h),
                bottom!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _HeaderLogo extends StatelessWidget {
  const _HeaderLogo({required this.asset});
  final String asset;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 38.r,
      width: 38.r,
      padding: EdgeInsets.all(6.r),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Image.asset(asset, color: Colors.white),
    );
  }
}

class _HeaderIconButton extends StatelessWidget {
  const _HeaderIconButton({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10.r),
      onTap: onTap,
      child: Container(
        height: 38.r,
        width: 38.r,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.18),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Icon(icon, color: Colors.white, size: 18.r),
      ),
    );
  }
}

/// Optional trailing action button for [ScreenHeader.actions].
class ScreenHeaderAction extends StatelessWidget {
  const ScreenHeaderAction({
    super.key,
    required this.icon,
    required this.onTap,
    this.badgeCount,
  });

  final IconData icon;
  final VoidCallback onTap;
  final int? badgeCount;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.only(start: 6.w),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          _HeaderIconButton(icon: icon, onTap: onTap),
          if (badgeCount != null && badgeCount! > 0)
            PositionedDirectional(
              top: -2,
              end: -2,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: Colors.redAccent,
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(color: Colors.white, width: 1.5),
                ),
                child: Text(
                  badgeCount! > 99 ? '99+' : '$badgeCount',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 9.r,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
