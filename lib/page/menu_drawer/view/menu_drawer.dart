import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:onesthrm/page/authentication/bloc/authentication_bloc.dart';
import 'package:onesthrm/page/home/bloc/bloc.dart';
import 'package:onesthrm/page/language/bloc/language_bloc.dart';
import 'package:onesthrm/page/menu/bloc/menu_bloc.dart';
import 'package:onesthrm/page/menu_drawer/content/menu_settings_content.dart';
import 'package:onesthrm/page/menu_drawer/content/support_content.dart';
import 'package:core/core.dart';

class MenuDrawer extends StatelessWidget {
  const MenuDrawer({super.key, this.provider});
  final MenuBloc? provider;

  Widget _buildAvatar(String? avatarUrl) {
    final hasAvatar = avatarUrl != null && avatarUrl.isNotEmpty && Uri.tryParse(avatarUrl)?.hasScheme == true;
    if (hasAvatar) {
      return CachedNetworkImage(
        height: 80, width: 80, fit: BoxFit.cover,
        imageUrl: avatarUrl,
        placeholder: (context, url) => Image.asset("assets/images/placeholder_image.png", height: 80, width: 80, fit: BoxFit.cover),
        errorWidget: (context, url, error) => Image.asset("assets/images/placeholder_image.png", height: 80, width: 80, fit: BoxFit.cover),
      );
    }
    return Image.asset("assets/images/placeholder_image.png", height: 80, width: 80, fit: BoxFit.cover);
  }

  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthenticationBloc>().state.data;
    return BlocBuilder<LanguageBloc, LanguageState>(
      builder: (context, _) {
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
                    child: _buildAvatar(user?.user?.avatar),
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
          // Logout + version pinned at bottom
          Container(
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: Colors.grey.shade200)),
            ),
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: SafeArea(
              top: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    onTap: () => showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        content: const Text('are_you_sure_you_want_to_logout').tr(),
                        actions: [
                          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('no').tr()),
                          TextButton(
                              onPressed: () {
                                BlocProvider.of<AuthenticationBloc>(context).add(AuthenticationLogoutRequest());
                                context.read<HomeBloc>().add(OnResetEvent());
                                Navigator.of(ctx).pop();
                              },
                              child: const Text('yes').tr()),
                        ],
                      ),
                    ),
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    horizontalTitleGap: 8,
                    leading: const Icon(Icons.logout_rounded, color: Colors.red, size: 22),
                    title: Text('logout', style: TextStyle(fontSize: 14.r, color: Colors.red)).tr(),
                  ),
                  BlocBuilder<MenuBloc, MenuState>(builder: (context, menuState) {
                    return Text(
                      menuState.appVersion != null ? '${menuState.appName ?? ''} v${menuState.appVersion}' : '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 11.r, color: Colors.black26),
                    );
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
    },
    );
  }
}
