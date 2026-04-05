import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:onesthrm/res/widgets/user_avatar.dart';

import '../../authentication/bloc/authentication_bloc.dart';

class MenuProfile extends StatelessWidget {
  const MenuProfile({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthenticationBloc>().state.data;
    return UserAvatar(
      imageUrl: user?.user?.avatar,
      name: user?.user?.name,
      size: 50.r,
    );
  }
}
