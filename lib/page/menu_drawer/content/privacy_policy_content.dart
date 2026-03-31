import 'package:core/core.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meta_club_api/meta_club_api.dart';
import 'package:onesthrm/page/expense/content/expense_list_shimmer.dart';
import 'package:onesthrm/page/menu_drawer/bloc/menu_drawer_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class PolicyContentScreen extends StatelessWidget {
  final String? appBarName;
  final String? apiSlug;
  const PolicyContentScreen({super.key, this.appBarName, this.apiSlug});

  static Route route(String? appBarName, String? apiSlug) => MaterialPageRoute(
      builder: (_) => PolicyContentScreen(
            apiSlug: apiSlug,
            appBarName: appBarName,
          ));

  IconData _iconForSlug(String? slug) {
    switch (slug) {
      case 'privacy-policy':
        return Icons.shield_outlined;
      case 'terms-of-use':
        return Icons.description_outlined;
      case 'support-24-7':
        return Icons.support_agent_outlined;
      default:
        return Icons.article_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MenuDrawerBloc(
          metaClubApiClient: MetaClubApiClient(httpService: instance()))
        ..add(MenuDrawerLoadData(context: context, slug: apiSlug)),
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Branding.colors.primaryDark,
          foregroundColor: Colors.white,
          title: Text(
            appBarName ?? '',
            style: TextStyle(fontSize: 18.r, fontWeight: FontWeight.w600),
          ).tr(),
        ),
        body: BlocBuilder<MenuDrawerBloc, MenuDrawerState>(
          builder: (context, state) {
            final content =
                state.responseAllContents?.data?.contents?.isNotEmpty == true
                    ? state.responseAllContents!.data!.contents!.first
                    : null;

            if (content == null) {
              return const Padding(
                padding: EdgeInsets.all(10.0),
                child: ExpenseListShimmer(),
              );
            }

            return SingleChildScrollView(
              child: Column(
                children: [
                  // Header card
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Branding.colors.primaryDark,
                          Branding.colors.primaryLight,
                        ],
                      ),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(24),
                        bottomRight: Radius.circular(24),
                      ),
                    ),
                    padding: EdgeInsets.fromLTRB(24.w, 8.h, 24.w, 28.h),
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(16.r),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            _iconForSlug(apiSlug),
                            color: Colors.white,
                            size: 36.r,
                          ),
                        ),
                        SizedBox(height: 12.h),
                        if (content.metaTitle != null)
                          Text(
                            content.metaTitle!,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.8),
                              fontSize: 13.r,
                            ),
                          ),
                      ],
                    ),
                  ),
                  // Content card
                  Padding(
                    padding: EdgeInsets.all(16.w),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      padding: EdgeInsets.all(20.w),
                      child: Html(
                        data: content.content,
                        shrinkWrap: true,
                        style: {
                          "body": Style(
                            fontSize: FontSize(14.r),
                            lineHeight: const LineHeight(1.6),
                            color: Colors.black87,
                          ),
                          "h2": Style(
                            fontSize: FontSize(16.r),
                            fontWeight: FontWeight.w700,
                            color: Branding.colors.primaryDark,
                            margin: Margins(top: Margin(16.h), bottom: Margin(8.h)),
                          ),
                          "h3": Style(
                            fontSize: FontSize(15.r),
                            fontWeight: FontWeight.w600,
                            color: Branding.colors.primaryDark,
                          ),
                          "strong": Style(
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                          "hr": Style(
                            margin: Margins(top: Margin(16.h), bottom: Margin(16.h)),
                          ),
                        },
                        onLinkTap: (url, _, __) {
                          if (url != null) launchUrl(Uri.parse(url));
                        },
                      ),
                    ),
                  ),
                  // Last updated
                  if (content.updatedAt != null)
                    Padding(
                      padding: EdgeInsets.only(bottom: 24.h),
                      child: Text(
                        'Last updated: ${content.updatedAt!.day}/${content.updatedAt!.month}/${content.updatedAt!.year}',
                        style: TextStyle(
                          fontSize: 12.r,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
