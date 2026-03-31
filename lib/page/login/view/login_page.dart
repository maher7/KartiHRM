import 'package:chat/chat.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hrm_framework/hrm_framework.dart';
import 'package:meta_club_api/meta_club_api.dart';
import 'package:onesthrm/page/onboarding/view/onboarding_page.dart';
import 'package:onesthrm/res/nav_utail.dart';
import '../bloc/login_bloc.dart';
import 'login_form.dart';

class LoginPage extends StatelessWidget {
  final Company? selectedCompany;

  const LoginPage({super.key, this.selectedCompany});

  static Route route() {
    return MaterialPageRoute(builder: (_) => const LoginPage());
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) {
          NavUtil.pushAndRemoveUntil(context, const OnboardingPage());
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: BlocProvider(
            create: (context) => LoginBloc(
                chatService: ChatService(),
                getDeviceIdUseCase: instance.get<GetDeviceIdUseCase>(),
                getDeviceNameUseCase: instance.get<GetDeviceNameUseCase>(),
                loginWIthEmailPasswordUseCase: instance()),
            child: LoginForm(selectedCompany: selectedCompany),
          ),
        ),
      ),
    );
  }
}
