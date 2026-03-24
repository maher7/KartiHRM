import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../authentication/bloc/authentication_bloc.dart';

class MenuProfile extends StatelessWidget {
  const MenuProfile({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthenticationBloc>().state.data;
    final avatar = user?.user?.avatar;
    final hasAvatar = avatar != null && avatar.isNotEmpty && Uri.tryParse(avatar)?.hasScheme == true;
    return ClipOval(
      child: hasAvatar
          ? CachedNetworkImage(height: 50.r, width: 50.r, fit: BoxFit.cover, imageUrl: avatar,
              placeholder: (context, url) => Image.asset("assets/images/placeholder_image.png", height: 50.r, width: 50.r, fit: BoxFit.cover),
              errorWidget: (context, url, error) => Image.asset("assets/images/placeholder_image.png", height: 50.r, width: 50.r, fit: BoxFit.cover),
            )
          : Image.asset("assets/images/placeholder_image.png", height: 50.r, width: 50.r, fit: BoxFit.cover),
    );
  }
}
