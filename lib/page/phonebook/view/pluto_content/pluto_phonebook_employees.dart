import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:onesthrm/page/phonebook/phonebook.dart';
import 'package:onesthrm/page/phonebook/view/pluto_content/pluto_phonebook_details.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class PlutoPhoneBookEmployees extends StatelessWidget {
  const PlutoPhoneBookEmployees({super.key});

  @override
  Widget build(BuildContext context) {
    RefreshController refreshController = RefreshController(initialRefresh: false);

    return BlocListener<PhoneBookBloc, PhoneBookState>(
      listenWhen: (oldState, newState) => oldState != newState,
      listener: (context, state) {
        if (state.refreshStatus == PullStatus.loaded) {
          refreshController.refreshCompleted();
        }
      },
      child: BlocBuilder<PhoneBookBloc, PhoneBookState>(
          buildWhen: (oldState, newState) => oldState != newState,
          builder: (context, state) {
            if (state.phoneBookUsers != null) {
              return state.phoneBookUsers?.isEmpty == true
                  ? const NoDataFoundWidget()
                  : SmartRefresher(
                      enablePullDown: true,
                      enablePullUp: true,
                      header: const WaterDropHeader(),
                      footer: CustomFooter(builder: (context, mode) {
                        Widget body;
                        if (mode == LoadStatus.idle) {
                          body = const Text("Pull up load");
                        } else if (mode == LoadStatus.loading) {
                          body = const CupertinoActivityIndicator();
                        } else if (mode == LoadStatus.failed) {
                          body = const Text("Load Failed!Click retry!");
                        } else if (mode == LoadStatus.canLoading) {
                          body = const Text("release to load more");
                        } else {
                          body = const Text("No more Data");
                        }
                        return SizedBox(height: 55.0, child: Center(child: body));
                      }),
                      controller: refreshController,
                      onLoading: () {
                        context.read<PhoneBookBloc>().add(PhoneBookLoadMore());
                        refreshController.loadComplete();
                      },
                      onRefresh: () {
                        context.read<PhoneBookBloc>().add(PhoneBookLoadRefresh());
                      },
                      child: ListView.builder(
                        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                        itemCount: state.phoneBookUsers?.length ?? 0,
                        itemBuilder: (BuildContext context, int index) {
                          final employee = state.phoneBookUsers![index];
                          return Container(
                            margin: EdgeInsets.only(bottom: 8.h),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 6, offset: const Offset(0, 2)),
                              ],
                            ),
                            child: Material(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(12),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(12),
                                onTap: () async {
                                  Navigator.push(context, PlutoPhoneBookDetailsScreen.route(homeBloc: context.read<PhoneBookBloc>(), userId: '${employee.id}'));
                                },
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                                  child: Row(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(color: Branding.colors.primaryLight.withValues(alpha: 0.3), width: 2),
                                        ),
                                        child: ClipOval(
                                          child: Builder(
                                            builder: (context) {
                                              final avatarUrl = "${employee.avatar}";
                                              final hasValidUrl = avatarUrl.isNotEmpty && Uri.tryParse(avatarUrl)?.hasScheme == true;
                                              return hasValidUrl
                                                  ? CachedNetworkImage(
                                                      height: 44.r, width: 44.r, fit: BoxFit.cover,
                                                      imageUrl: avatarUrl,
                                                      placeholder: (context, url) => Center(child: Image.asset("assets/images/placeholder_image.png")),
                                                      errorWidget: (context, url, error) => const Icon(Icons.error),
                                                    )
                                                  : Image.asset("assets/images/placeholder_image.png");
                                            },
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 12.w),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              employee.name ?? "",
                                              style: TextStyle(fontSize: 14.r, fontWeight: FontWeight.w600, color: Colors.black87),
                                            ),
                                            SizedBox(height: 2.h),
                                            Text(
                                              employee.designation ?? "",
                                              style: TextStyle(fontSize: 12.r, color: Colors.grey.shade600),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Material(
                                        color: Branding.colors.primaryLight.withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(10),
                                        child: InkWell(
                                          borderRadius: BorderRadius.circular(10),
                                          onTap: () {
                                            context.read<PhoneBookBloc>().add(DirectPhoneCall(employee.phone ?? ''));
                                          },
                                          child: Padding(
                                            padding: EdgeInsets.all(10.r),
                                            child: Icon(CupertinoIcons.phone, size: 20.r, color: Branding.colors.primaryLight),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ));
            } else {
              return Center(child: CircularProgressIndicator(color: Branding.colors.primaryLight));
            }
          }),
    );
  }
}
