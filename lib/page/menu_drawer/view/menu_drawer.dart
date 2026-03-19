import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:onesthrm/page/authentication/bloc/authentication_bloc.dart';
import 'package:onesthrm/page/menu/bloc/menu_bloc.dart';
import 'package:onesthrm/page/menu_drawer/content/menu_settings_content.dart';
import 'package:onesthrm/page/menu_drawer/content/support_content.dart';
import 'package:core/core.dart';

class MenuDrawer extends StatelessWidget {
  const MenuDrawer({super.key, this.provider});
  final MenuBloc? provider;

  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthenticationBloc>().state.data;
    return Drawer(
      width: 280.r,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          bottomLeft: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(20, 60.h, 20, 24.h),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Branding.colors.primaryDark, Branding.colors.primaryLight],
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24),
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white.withValues(alpha: 0.4), width: 2),
                  ),
                  child: ClipOval(
                    child: CachedNetworkImage(
                      height: 80,
                      width: 80,
                      fit: BoxFit.cover,
                      imageUrl: "${user?.user?.avatar}",
                      placeholder: (context, url) => Center(
                        child: Image.asset("assets/images/placeholder_image.png"),
                      ),
                      errorWidget: (context, url, error) => const Icon(Icons.error, color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(height: 12.h),
                Text(
                  user?.user?.name ?? "",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16.r,
                    color: Colors.white,
                  ),
                ),
                if (user?.user?.email != null) ...[
                  SizedBox(height: 4.h),
                  Text(
                    user?.user?.email ?? "",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12.r,
                      color: Colors.white.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ],
            ),
          ),
          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const MenuSettingsContent(),
                  SizedBox(height: 8.h),
                  const SupportContent(),
                ],
              ),
            ),
          ),
          // App version footer
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: BlocBuilder<MenuBloc, MenuState>(builder: (context, menuState) {
              return Text(
                menuState.appVersion != null ? '${menuState.appName ?? ''} v${menuState.appVersion}' : '',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 11.r, color: Colors.black26),
              );
            }),
          ),
        ],
      ),
    );
  }
}
