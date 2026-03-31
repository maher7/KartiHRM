import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meta_club_api/meta_club_api.dart';
import 'package:onesthrm/page/break/break_route.dart';
import 'package:onesthrm/page/language/bloc/language_bloc.dart';
import 'package:user_repository/user_repository.dart';
import 'package:core/core.dart';

class PlutoBreakCard extends StatelessWidget {
  final Settings? settings;
  final LoginData? user;
  final DashboardModel? dashboardModel;

  const PlutoBreakCard(
      {super.key,
      required this.settings,
      required this.user,
      required this.dashboardModel});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageBloc, LanguageState>(
      builder: (context, _) {
        final inBreak = globalState.get(isBreak) == true;
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: inBreak
                  ? [const Color(0xFFE65100), const Color(0xFFFF8F00)]
                  : [Branding.colors.primaryLight, Branding.colors.primaryDark],
            ),
            borderRadius: BorderRadius.circular(16.0),
            boxShadow: [
              BoxShadow(
                color: Branding.colors.primaryLight.withValues(alpha: 0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(16.0),
            child: InkWell(
              borderRadius: BorderRadius.circular(16.0),
              onTap: () {
                BreakRoute.breakOrQrCompanyRoute(
                    context: context, inBreak: inBreak);
              },
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 12.w),
                child: Row(
                  children: [
                    Icon(
                      inBreak
                          ? Icons.coffee_rounded
                          : Icons.free_breakfast_rounded,
                      color: Colors.white,
                      size: 20.r,
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            inBreak
                                ? "you're_in_break".tr()
                                : "take_coffee".tr(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.8),
                              fontSize: 10.r,
                            ),
                          ),
                          Text(
                            inBreak
                                ? dashboardModel?.data?.config?.breakStatus
                                        ?.breakTime ??
                                    ''
                                : 'break'.tr(),
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 13.r,
                                fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
