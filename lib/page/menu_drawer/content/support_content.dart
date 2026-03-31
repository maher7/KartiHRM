import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:onesthrm/page/language/view/language_screen.dart';
import 'package:onesthrm/page/menu_drawer/content/privacy_policy_content.dart';
import 'package:onesthrm/res/nav_utail.dart';

import '../../language/bloc/language_bloc.dart';

class SupportContent extends StatelessWidget {
  const SupportContent({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageBloc, LanguageState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'setting',
              style: TextStyle(color: Colors.grey, fontSize: 14.r),
            ).tr(),
            const Divider(),
            ListTile(
              onTap: () {
                NavUtil.navigateScreen(context, const LanguageScreen());
              },
              dense: true,
              contentPadding: EdgeInsets.zero,
              horizontalTitleGap: 8.r,
              leading: SvgPicture.asset(
                'assets/menu_drawer_icons/language-change.svg',
                height: 20.r,
                width: 20.r,
              ),
              title: Text(
                "language_change",
                style: TextStyle(fontSize: 14.r),
              ).tr(),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              'support',
              style: TextStyle(color: Colors.grey, fontSize: 14.r),
            ).tr(),
            const Divider(),
            ListTile(
              onTap: () {
                NavUtil.navigateScreen(
                    context,
                    const PolicyContentScreen(
                      appBarName: "support_policy",
                      apiSlug: "support-24-7",
                    ));
              },
              dense: true,
              contentPadding: EdgeInsets.zero,
              horizontalTitleGap: 8,
              leading: SvgPicture.asset(
                "assets/menu_drawer_icons/support-policy.svg",
                height: 20.r,
                width: 20.r,
              ),
              title: Text('support_policy', style: TextStyle(fontSize: 14.r)).tr(),
            ),
            const SizedBox(
              height: 10,
            ),
            ListTile(
              onTap: () {
                NavUtil.navigateScreen(
                    context,
                    const PolicyContentScreen(
                      appBarName: "privacy_policy",
                      apiSlug: "privacy-policy",
                    ));
              },
              dense: true,
              contentPadding: EdgeInsets.zero,
              horizontalTitleGap: 8,
              leading: SvgPicture.asset(
                "assets/menu_drawer_icons/privacy-policy.svg",
                height: 20.r,
                width: 20.r,
              ),
              title: Text('privacy_policy', style: TextStyle(fontSize: 14.r)).tr(),
            ),
            const SizedBox(
              height: 10,
            ),
            ListTile(
              onTap: () {
                NavUtil.navigateScreen(
                    context,
                    const PolicyContentScreen(
                      appBarName: "terms_conditions",
                      apiSlug: "terms-of-use",
                    ));
              },
              dense: true,
              contentPadding: EdgeInsets.zero,
              horizontalTitleGap: 8,
              leading: SvgPicture.asset(
                "assets/menu_drawer_icons/terms-condition.svg",
                height: 20.r,
                width: 20.r,
              ),
              title: Text('terms_conditions', style: TextStyle(fontSize: 14.r)).tr(),
            ),
            const SizedBox(
              height: 10,
            ),
            const SizedBox(height: 10)
          ],
        );
      },
    );
  }
}
