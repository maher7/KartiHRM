import 'package:core/core.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meta_club_api/meta_club_api.dart';
import 'package:onesthrm/page/profile/view/content/emergency_profile_content.dart';
import 'package:onesthrm/page/profile/view/content/finalcial_profile_content.dart';
import 'package:onesthrm/page/profile/view/content/personal_profile_content.dart';
import '../../../authentication/bloc/authentication_bloc.dart';
import '../../../upload_file/view/upload_content.dart';
import '../../bloc/profile/profile_bloc.dart';
import 'official_profile_content.dart';

class ProfileContent extends StatelessWidget {
  final Settings? settings;

  const ProfileContent({super.key, required this.settings});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(builder: (context, state) {
      if (state.status == NetworkStatus.loading) {
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 12),
              Text('loading'.tr(), style: TextStyle(fontSize: 13.r, color: Colors.black54)),
            ],
          ),
        );
      }
      if (state.status == NetworkStatus.success) {
        if (state.profile != null) {
          return Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              Center(
                child: UploadContent(
                  onFileUploaded: (FileUpload? data) {
                    context
                        .read<ProfileBloc>()
                        .add(ProfileAvatarUpdate(avatarId: data?.fileId));
                  },
                  initialAvatar: state.profile?.personal?.avatar,
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    state.profile?.official != null
                        ? OfficialProfileContent(
                            profile: state.profile!,
                            settings: settings,
                          )
                        : const SizedBox.shrink(),
                    state.profile?.personal != null
                        ? PersonalProfileContent(
                            profile: state.profile!,
                            settings: settings,
                          )
                        : const SizedBox.shrink(),
                    state.profile?.financial != null
                        ? FinancialProfileContent(
                            profile: state.profile!,
                            settings: settings,
                          )
                        : const SizedBox.shrink(),
                    state.profile?.emergency != null
                        ? EmergencyProfileContent(
                            profile: state.profile!,
                            settings: settings,
                          )
                        : const SizedBox.shrink(),
                  ],
                ),
              ),
              const SizedBox(
                height: 16.0,
              ),
              BlocBuilder<AuthenticationBloc, AuthenticationState>(
                  builder: (context, state) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: SizedBox(
                    width: double.infinity,
                    height: 40.0.h,
                    child: ElevatedButton(
                      onPressed: () => showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: Row(
                            children: [
                              const Icon(Icons.warning_amber_rounded, color: Colors.red, size: 28),
                              const SizedBox(width: 8),
                              Text('delete_account'.tr(), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            ],
                          ),
                          content: Text(
                              'Are_you_sure_,_you_want_to_delete_the_account'
                                  .tr()),
                          actions: [
                            TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: Text('cancel'.tr(), style: const TextStyle(fontWeight: FontWeight.w600))),
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                                onPressed: () {
                                  BlocProvider.of<ProfileBloc>(context)
                                      .add(ProfileDeleteRequest());
                                  BlocProvider.of<AuthenticationBloc>(context)
                                      .add(AuthenticationLogoutRequest());
                                  Navigator.of(context).pop();
                                },
                                child: Text('delete'.tr(), style: const TextStyle(color: Colors.white))),
                          ],
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          )),
                      child: Text('delete_account'.tr(),
                          style:
                              TextStyle(fontSize: 14.r, color: Colors.white)),
                    ),
                  ),
                );
              })
            ],
          );
        }
      }
      if (state.status == NetworkStatus.failure) {
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline, size: 48, color: Colors.red.shade300),
              const SizedBox(height: 12),
              Text('failed_to_load_profile'.tr(), style: TextStyle(fontSize: 14.r)),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: () => context.read<ProfileBloc>().add(ProfileLoadRequest()),
                icon: const Icon(Icons.refresh, size: 18),
                label: Text('retry'.tr()),
                style: ElevatedButton.styleFrom(backgroundColor: Branding.colors.primaryLight, foregroundColor: Colors.white),
              ),
            ],
          ),
        );
      }
      return const SizedBox();
    });
  }
}
