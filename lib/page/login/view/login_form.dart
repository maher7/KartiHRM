import 'package:core/core.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:formz/formz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta_club_api/meta_club_api.dart';
import 'package:onesthrm/page/forgot_password/view/forget_password.dart';
import 'package:onesthrm/page/onboarding/view/onboarding_page.dart';
import 'package:onesthrm/res/nav_utail.dart';
import '../../../res/dialogs/custom_dialogs.dart';
import '../bloc/login_bloc.dart';
import '../models/email.dart';
import '../models/password.dart';

class LoginForm extends StatelessWidget {
  final Company? selectedCompany;

  const LoginForm({super.key, this.selectedCompany});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: context.read<LoginBloc>().formKey,
      child: Center(
        child: BlocListener<LoginBloc, LoginState>(
          listenWhen: (oldState, newState) => oldState.loginAction == LoginAction.login,
          listener: (context, state) {
            if (state.status.isFailure) {
              // Defensive: state.failure can briefly be null when status flips
              // to failure from an unrelated code path. Fall back to a generic
              // message instead of crashing the login screen.
              final failure = state.failure;
              showLoginDialog(
                  context: context,
                  isSuccess: false,
                  message: failure?.isSuccess == true
                      ? 'Authentication Successful'.tr()
                      : 'Authentication failed\n${failure?.meaningfulMessage ?? 'Please try again'}');
            }
            if (state.status.isCanceled) {
              showLoginDialog(context: context, isSuccess: false, message: '${state.user?.user?.name}');
            }
            if (state.status.isSuccess) {
              showLoginDialog(
                  context: context,
                  isSuccess: true,
                  message: '${state.user?.user?.name}',
                  body: 'Authentication Successful',
                  autoDismiss: true);
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: SingleChildScrollView(
              reverse: true,
              child: Column(
                children: [
                  SizedBox(height: 40.h),
                  selectedCompany?.companyLogo != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.network(selectedCompany!.companyLogo!, height: 100, width: 100),
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.asset("assets/images/company_logo.png", height: 100.0, width: 100.0),
                        ),
                  SizedBox(height: 16.h),
                  if (selectedCompany != null)
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                      decoration: BoxDecoration(
                        color: Branding.colors.primaryLight.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(12.0),
                        border: Border.all(color: Branding.colors.primaryLight.withValues(alpha: 0.2)),
                      ),
                      child: Text(
                        selectedCompany?.companyName ?? "",
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                          color: Branding.colors.primaryLight,
                        ),
                      ),
                    ),
                  SizedBox(height: 24.h),
                  Text(
                    'login_your_account'.tr(),
                    style: TextStyle(fontSize: 20.r, fontWeight: FontWeight.w700, color: Colors.black87),
                  ),
                  SizedBox(height: 24.h),
                  const _EmailInput(),
                  SizedBox(height: 16.h),
                  const _PasswordInput(),
                  SizedBox(height: 4.h),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        NavUtil.navigateScreen(context, const ForgetPasswordScreen());
                      },
                      child: Text(
                        tr("forgot_password"),
                        style: TextStyle(
                          color: Branding.colors.primaryLight,
                          fontSize: 13.r,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  const _LoginButton(),
                  SizedBox(height: 16.h),
                  if (isSAAS == true) const _SelectCompanyButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _EmailInput extends StatelessWidget {
  const _EmailInput();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        return TextFormField(
          key: const Key('email_text_field'),
          onChanged: (phone) => context.read<LoginBloc>().add(LoginEmailChange(email: phone)),
          validator: (value) => state.email.validator(value ?? '')?.text(),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          style: TextStyle(fontSize: 14.r),
          decoration: InputDecoration(
            labelText: 'email'.tr(),
            labelStyle: TextStyle(fontSize: 13.r, color: Colors.black45),
            fillColor: Colors.grey.shade50,
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide(color: Branding.colors.primaryLight, width: 1.5),
            ),
            prefixIcon: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Icon(Icons.email_outlined, color: Branding.colors.primaryLight, size: 20),
            ),
            errorText: state.email.displayError != null ? 'invalid_email'.tr() : null,
          ),
        );
      },
    );
  }
}

class _PasswordInput extends StatelessWidget {
  const _PasswordInput();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        return TextFormField(
          key: const Key('password_text_field'),
          onChanged: (password) => context.read<LoginBloc>().add(LoginPasswordChange(password: password)),
          validator: (value) => state.password.validator(value ?? '')?.text(),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          obscureText: state.isObscure,
          style: TextStyle(fontSize: 14.r),
          decoration: InputDecoration(
            labelText: 'password'.tr(),
            labelStyle: TextStyle(fontSize: 13.r, color: Colors.black45),
            fillColor: Colors.grey.shade50,
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide(color: Branding.colors.primaryLight, width: 1.5),
            ),
            suffixIcon: IconButton(
              icon: Icon(
                state.isObscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                color: Colors.black38,
                size: 20,
              ),
              onPressed: () {
                context.read<LoginBloc>().add(const OnObscureEvent());
              },
            ),
            prefixIcon: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Icon(Icons.lock_outlined, color: Branding.colors.primaryLight, size: 20),
            ),
            errorText: state.password.displayError != null ? 'invalid_password'.tr() : null,
          ),
        );
      },
    );
  }
}

class _LoginButton extends StatelessWidget {
  const _LoginButton();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        return state.status.isInProgress
            ? const CircularProgressIndicator()
            : SizedBox(
                width: double.infinity,
                height: 48.0.r,
                child: ElevatedButton(
                  onPressed: () {
                    if (context.read<LoginBloc>().formKey.currentState?.validate() == true) {
                      context.read<LoginBloc>().add(const LoginSubmit());
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Branding.colors.primaryLight,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  child: Text(
                    'login'.tr(),
                    style: TextStyle(color: Colors.white, fontSize: 15.r, fontWeight: FontWeight.w600),
                  ),
                ),
              );
      },
    );
  }
}

class _SelectCompanyButton extends StatelessWidget {
  const _SelectCompanyButton();

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: () {
        NavUtil.pushAndRemoveUntil(context, const OnboardingPage());
      },
      icon: Icon(Icons.arrow_back_rounded, size: 16.r, color: Colors.black45),
      label: Text(
        'back'.tr(),
        style: TextStyle(fontSize: 13.r, color: Colors.black45),
      ),
    );
  }
}

extension on PhoneValidationError {
  String text() {
    switch (this) {
      case PhoneValidationError.empty:
        return 'Please enter your email';
    }
  }
}

extension on PasswordValidationError {
  String text() {
    switch (this) {
      case PasswordValidationError.empty:
        return 'Please enter your password';
    }
  }
}
