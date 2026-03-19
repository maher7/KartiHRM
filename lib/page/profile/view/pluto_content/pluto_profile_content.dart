import 'package:core/core.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meta_club_api/meta_club_api.dart';
import 'package:onesthrm/page/authentication/bloc/authentication_bloc.dart';
import 'package:onesthrm/page/password_change/view/pluto_password_change_page.dart';
import 'package:onesthrm/page/profile/bloc/profile/profile_bloc.dart';
import 'package:onesthrm/page/profile/view/pluto_content/pluto_emergency_profile_content.dart';
import 'package:onesthrm/page/profile/view/pluto_content/pluto_finalcial_profile_content.dart';
import 'package:onesthrm/page/profile/view/pluto_content/pluto_official_profile_content.dart';
import 'package:onesthrm/page/profile/view/pluto_content/pluto_personal_profile_content.dart';
import 'package:onesthrm/page/profile/view/pluto_content/pluto_profile_header.dart';
import 'package:onesthrm/res/nav_utail.dart';

class PlutoProfileContent extends StatelessWidget {
  final Settings? settings;

  const PlutoProfileContent({super.key, required this.settings});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(builder: (context, state) {
      if (state.status == NetworkStatus.loading) {
        return Center(child: CircularProgressIndicator(color: Branding.colors.primaryLight));
      }
      if (state.status == NetworkStatus.success) {
        if (state.profile != null) {
          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              children: [
                PlutoProfileHeader(state: state),
                SizedBox(height: 8.h),
                _buildProfileTile(
                  context: context,
                  icon: Icons.business_rounded,
                  iconColor: const Color(0xFF1976D2),
                  title: "Official Information",
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (_) => BlocProvider.value(value: context.read<ProfileBloc>(),
                          child: PlutoOfficialProfileContent(profile: state.profile!, settings: settings, state: state))));
                  },
                ),
                SizedBox(height: 8.h),
                _buildProfileTile(
                  context: context,
                  icon: Icons.person_rounded,
                  iconColor: const Color(0xFF7B1FA2),
                  title: "Personal Information",
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (_) => BlocProvider.value(value: context.read<ProfileBloc>(),
                          child: PlutoPersonalProfileContent(profile: state.profile!, settings: settings, state: state))));
                  },
                ),
                SizedBox(height: 8.h),
                _buildProfileTile(
                  context: context,
                  icon: Icons.account_balance_wallet_rounded,
                  iconColor: const Color(0xFF388E3C),
                  title: "Financial Information",
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (_) => BlocProvider.value(value: context.read<ProfileBloc>(),
                          child: PlutoFinancialProfileContent(profile: state.profile!, settings: settings, state: state))));
                  },
                ),
                SizedBox(height: 8.h),
                _buildProfileTile(
                  context: context,
                  icon: Icons.emergency_rounded,
                  iconColor: const Color(0xFFE53935),
                  title: "Emergency Information",
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (_) => BlocProvider.value(value: context.read<ProfileBloc>(),
                          child: PlutoEmergencyProfileContent(profile: state.profile!, settings: settings, state: state))));
                  },
                ),
                SizedBox(height: 8.h),
                _buildProfileTile(
                  context: context,
                  icon: Icons.lock_rounded,
                  iconColor: const Color(0xFFF57C00),
                  title: "Change Password",
                  onTap: () {
                    NavUtil.navigateScreen(context, const PlutoPasswordChangePage());
                  },
                ),
                SizedBox(height: 8.h),
                _buildProfileTile(
                  context: context,
                  icon: Icons.logout_rounded,
                  iconColor: Colors.grey,
                  title: "Logout",
                  onTap: () {
                    BlocProvider.of<ProfileBloc>(context).add(ProfileDeleteRequest());
                    BlocProvider.of<AuthenticationBloc>(context).add(AuthenticationLogoutRequest());
                    Navigator.of(context).pop();
                  },
                ),
                SizedBox(height: 24.h),
                BlocBuilder<AuthenticationBloc, AuthenticationState>(builder: (context, state) {
                  return TextButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          content: Text('Are_you_sure_,_you_want_to_delete_the_account'.tr()),
                          actions: [
                            TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('No')),
                            TextButton(
                                onPressed: () {
                                  BlocProvider.of<ProfileBloc>(context).add(ProfileDeleteRequest());
                                  BlocProvider.of<AuthenticationBloc>(context).add(AuthenticationLogoutRequest());
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Yes', style: TextStyle(color: Colors.red))),
                          ],
                        ),
                      );
                    },
                    child: Text(
                      "Delete Account",
                      style: TextStyle(color: Colors.red.shade400, fontWeight: FontWeight.w500, fontSize: 13.r),
                    ),
                  );
                }),
                SizedBox(height: 30.h),
              ],
            ),
          );
        }
      }
      if (state.status == NetworkStatus.failure) {
        return Center(child: Text('failed_to_load_profile'.tr()));
      }
      return const SizedBox();
    });
  }

  Widget _buildProfileTile({
    required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required String title,
    required VoidCallback onTap,
  }) {
    return Container(
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
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8.r),
                  decoration: BoxDecoration(
                    color: iconColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, size: 22.r, color: iconColor),
                ),
                SizedBox(width: 14.w),
                Expanded(
                  child: Text(title, style: TextStyle(fontSize: 14.r, fontWeight: FontWeight.w500, color: Colors.black87)),
                ),
                Icon(Icons.chevron_right_rounded, size: 22.r, color: Colors.grey.shade400),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
