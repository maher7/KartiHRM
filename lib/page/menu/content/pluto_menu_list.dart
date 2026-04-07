import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meta_club_api/meta_club_api.dart';
import 'package:core/core.dart';
import 'package:onesthrm/page/menu/content/pluto_menu_content_item.dart';

import '../../home/bloc/home_bloc.dart';
import '../bloc/menu_bloc.dart';

/// Groups: each entry is a header label + the slugs in that group.
/// Items from the DB that don't appear here go into an "other" group at the end.
const _groups = <String, List<String>>{
  'work': ['attendance', 'break', 'task'],
  'calendar': ['meeting', 'appointments', 'visit'],
  'hr_admin': ['notice', 'payroll', 'expense'],
  'communication': ['phonebook', 'support', 'chat'],
};

class PlutoMenuList extends StatelessWidget {
  final AnimationController? animationController;

  const PlutoMenuList({super.key, this.animationController});

  @override
  Widget build(BuildContext context) {
    final homeData = context.watch<HomeBloc>().state.dashboardModel;
    final rawMenus = homeData?.data?.menus ?? [];
    final badges = homeData?.data?.badges;

    // Index menus by slug for fast lookup
    final menuBySlug = <String, Menu>{};
    for (final m in rawMenus) {
      if (m.slug != null) menuBySlug[m.slug!] = m;
    }

    // Build grouped sections from _groups definition
    final sections = <MapEntry<String, List<Menu>>>[];
    final used = <String>{};

    for (final entry in _groups.entries) {
      final items = <Menu>[];
      for (final slug in entry.value) {
        final menu = menuBySlug[slug];
        if (menu != null) {
          items.add(menu);
          used.add(slug);
        }
      }
      if (items.isNotEmpty) {
        sections.add(MapEntry(entry.key, items));
      }
    }

    // Collect any remaining items not in any group
    final extras = rawMenus.where((m) => m.slug != null && !used.contains(m.slug)).toList();
    if (extras.isNotEmpty) {
      sections.add(MapEntry('other', extras));
    }

    final totalItems = sections.fold<int>(0, (sum, s) => sum + s.value.length);
    int globalIndex = 0;

    return ListView(
      padding: const EdgeInsets.only(bottom: 100.0).r,
      children: sections.expand((entry) {
        final header = _SectionHeader(label: entry.key);
        final itemWidth = (MediaQuery.of(context).size.width - 40.w) / 3;
        final grid = Wrap(
          spacing: 4.w,
          runSpacing: 4.h,
          children: entry.value.map((menu) {
            final i = globalIndex++;
            final animation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
                parent: animationController!,
                curve: Interval((1 / totalItems) * i, 1.0, curve: Curves.fastOutSlowIn)));
            animationController?.forward();
            final badgeCount = (menu.slug != null && badges != null) ? (badges[menu.slug] ?? 0) : 0;
            return SizedBox(
              width: itemWidth,
              height: itemWidth * 0.9,
              child: PlutoMenuContentItem(
                  menu: menu,
                  animation: animation,
                  animationController: animationController!,
                  badgeCount: badgeCount,
                  onPressed: () {
                    context.read<MenuBloc>().add(RouteSlug(context: context, slugName: menu.slug));
                  }),
            );
          }).toList(),
        );
        return [
          header,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: grid,
          ),
        ];
      }).toList(),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 10.h, bottom: 4.h),
      child: Row(
        children: [
          Container(
            width: 3,
            height: 14.h,
            decoration: BoxDecoration(
              color: Branding.colors.primaryLight,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(width: 8.w),
          Text(
            label.tr(),
            style: TextStyle(
              fontSize: 12.r,
              fontWeight: FontWeight.w700,
              color: Colors.grey.shade600,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }
}
