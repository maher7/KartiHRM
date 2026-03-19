import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onesthrm/page/authentication/bloc/authentication_bloc.dart';
import 'package:onesthrm/page/splash/bloc/splash_bloc.dart';

typedef SplashScreenFactory = SplashScreen Function();

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  static Route route() {
    return MaterialPageRoute(builder: (_) => const SplashScreen());
  }

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) setState(() => _visible = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthenticationBloc>().state.data;

    return BlocProvider(
      create: (context) => SplashBloc(context: context, data: user),
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Branding.colors.primaryDark,
                Branding.colors.primaryLight,
              ],
            ),
          ),
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 500),
            opacity: _visible ? 1 : 0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedScale(
                  scale: _visible ? 1 : 0.85,
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.easeOutBack,
                  child: Image.asset('assets/images/app_icon.png', width: 100),
                ),
                const SizedBox(height: 16),
                AnimatedSlide(
                  offset: _visible ? Offset.zero : const Offset(0, 0.3),
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeOut,
                  child: const Text(
                    'Karti HRM',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                AnimatedSlide(
                  offset: _visible ? Offset.zero : const Offset(0, 0.5),
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.easeOut,
                  child: Text(
                    'Smart Workforce Management',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white.withValues(alpha: 0.7),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
