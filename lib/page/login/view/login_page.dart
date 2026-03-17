import 'package:chat/chat.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hrm_framework/hrm_framework.dart';
import 'package:meta_club_api/meta_club_api.dart';
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
    return Scaffold(
      backgroundColor: Colors.white,
      // bottomNavigationBar: PoweredByWidget(),
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
    );
  }
}
