import 'dart:async';
import 'package:core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:user_repository/user_repository.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc extends HydratedBloc<AuthenticationEvent, AuthenticationState> {
  final AuthenticationRepository _authenticationRepository;
  late StreamSubscription<AuthenticationStatus> _authenticationStatusSubscription;
  late StreamSubscription<LoginData> _loginDataSubscription;

  AuthenticationBloc({required AuthenticationRepository authenticationRepository})
      : _authenticationRepository = authenticationRepository,
        super(const AuthenticationState.unknown()) {

    on<AuthenticationStatusChanged>(_onAuthenticationStatusChanged);
    on<AuthenticationUserChanged>(_onAuthenticationUserChanged);
    on<AuthenticationLogoutRequest>(_onAuthenticationLogoutRequest);

    _authenticationStatusSubscription = _authenticationRepository.status.listen((status) => add(AuthenticationStatusChanged(status)));
    _loginDataSubscription = _authenticationRepository.loginData.listen((userData) => add(AuthenticationUserChanged(userData)));
  }

  _onAuthenticationStatusChanged(AuthenticationStatusChanged event,Emitter<AuthenticationState> emit) async {
    switch(event.status){
      case AuthenticationStatus.unauthenticated:
        return emit(const AuthenticationState.unauthenticated());
      default:
        return emit(const AuthenticationState.unknown());
    }
  }

  _onAuthenticationUserChanged(AuthenticationUserChanged event,Emitter<AuthenticationState> emit) async {
    // SECURITY: if the incoming user/company differs from what's currently
    // authenticated, wipe all persisted bloc state before emitting the new
    // auth state — prevents tenant data leaking across account switches.
    final newUserId = event.data.user?.id;
    final newCompanyId = event.data.user?.companyId;
    final currentUser = state.data?.user;
    final isTenantSwitch = currentUser != null &&
        newUserId != null &&
        (currentUser.id != newUserId || currentUser.companyId != newCompanyId);
    if (isTenantSwitch) {
      try {
        await HydratedBloc.storage.clear();
      } catch (_) {}
      // SECURITY: also clear user-specific SharedPreferences values on tenant
      // switch. Keeps a tiny whitelist of device-level prefs (language, onboarding).
      try {
        await _clearUserScopedPreferences();
      } catch (_) {}
    }
    globalState.set(authToken,event.data.user?.token);
    globalState.set(keyUserId, event.data.user?.id?.toString());
    if(event.data.user != null){
      return emit(AuthenticationState.authenticated(event.data));
    }
    return emit(const AuthenticationState.unauthenticated());
  }

  _onAuthenticationLogoutRequest(AuthenticationLogoutRequest event,Emitter<AuthenticationState> emit) async {
    await _authenticationRepository.logout();
    // SECURITY: wipe all persisted bloc state so tenant data doesn't leak
    // across user/company switches on the next login.
    try {
      await HydratedBloc.storage.clear();
    } catch (_) {}
    try {
      await _clearUserScopedPreferences();
    } catch (_) {}
    emit(const AuthenticationState.unauthenticated());
  }

  /// Removes all user-specific SharedPreferences values, preserving only a
  /// small whitelist of device-level settings (language, onboarding flag)
  /// that are safe to keep across account switches.
  Future<void> _clearUserScopedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    // Whitelist: these keys are device-level (not tied to a specific user/tenant)
    // and should persist across logout/switch so the user doesn't have to
    // re-pick their language on each login.
    const keepKeys = <String>{
      keySelectLanguage,   // selected UI language (int index)
      'hasSeenOnboarding', // typical onboarding flag if present
    };
    final allKeys = prefs.getKeys();
    for (final key in allKeys) {
      if (keepKeys.contains(key)) continue;
      await prefs.remove(key);
    }
  }

  @override
  Future<void> close() {
    _authenticationStatusSubscription.cancel();
    _loginDataSubscription.cancel();
    _authenticationRepository.dispose();
    return super.close();
  }

  @override
  AuthenticationState fromJson(Map<String, dynamic> json) {

    final status = json['status'];
    final userJson = json['user'];

    if(status == AuthenticationStatus.authenticated.name && userJson != null) {
      final user = LoginData.fromJson(userJson);
      if(user.user != null){
        globalState.set(authToken,user.user!.token);
        globalState.set(keyUserId, user.user!.id?.toString());
      }
      _authenticationRepository.updateAuthenticationStatus(AuthenticationStatus.authenticated);
      _authenticationRepository.updateUserData(user);
      return AuthenticationState.authenticated(user);
    }
    return const AuthenticationState.unauthenticated();
  }

  @override
  Map<String, dynamic> toJson(AuthenticationState state) {
    return <String,dynamic>{'status' : state.status.name,'user':state.data?.toJson()};
  }

}
