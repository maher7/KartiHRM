import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:onesthrm/page/profile/bloc/profile/profile_bloc.dart';
import 'package:onesthrm/page/upload_file/view/upload_content.dart';
import 'package:meta_club_api/meta_club_api.dart';

class PlutoProfileHeader extends StatelessWidget {
  final ProfileState? state;
  const PlutoProfileHeader({super.key, this.state});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 16.h),
        Center(
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Branding.colors.primaryLight.withValues(alpha: 0.3), width: 3),
            ),
            child: UploadContent(
              onFileUploaded: (FileUpload? data) {
                context.read<ProfileBloc>().add(ProfileAvatarUpdate(avatarId: data?.fileId));
              },
              initialAvatar: state?.profile?.personal?.avatar,
            ),
          ),
        ),
        SizedBox(height: 12.h),
        Text(
          state?.profile?.personal?.name ?? "No Name Found",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.r, color: Colors.black87),
        ),
        SizedBox(height: 4.h),
        Text(
          state?.profile?.official?.email ?? "No Email address Found",
          style: TextStyle(fontWeight: FontWeight.normal, fontSize: 13.r, color: Colors.grey.shade500),
        ),
        SizedBox(height: 16.h),
      ],
    );
  }
}
