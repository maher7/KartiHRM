import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late final AnimationController _circuitController;
  late final AnimationController _pulseController;

  late final Animation<double> _circuitProgress;
  late final Animation<double> _pulseScale;
  late final Animation<double> _pulseOpacity;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    _circuitController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1500));
    _circuitProgress = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _circuitController, curve: Curves.easeInOut),
    );

    _pulseController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200));
    _pulseScale = Tween<double>(begin: 0.8, end: 1.6).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeOut),
    );
    _pulseOpacity = Tween<double>(begin: 0.6, end: 0.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeOut),
    );

    _startSequence();
  }

  Future<void> _startSequence() async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (!mounted) return;
    _circuitController.forward();
    _pulseController.forward();
    _pulseController.addStatusListener((status) {
      if (status == AnimationStatus.completed && mounted) {
        _pulseController.reset();
        _pulseController.forward();
      }
    });
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    _circuitController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthenticationBloc>().state.data;
    final size = MediaQuery.of(context).size;
    final center = Offset(size.width / 2, size.height * 0.33);

    return BlocProvider(
      create: (context) => SplashBloc(context: context, data: user),
      child: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            // Background: full splash image
            Image.asset(
              'assets/images/karti_splash_screen.png',
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
              alignment: Alignment.center,
            ),

            // Circuit lines overlay
            AnimatedBuilder(
              animation: _circuitProgress,
              builder: (context, _) {
                return CustomPaint(
                  size: size,
                  painter: _CircuitPainter(
                    progress: _circuitProgress.value,
                    center: center,
                  ),
                );
              },
            ),

            // Pulse ring
            Positioned(
              left: center.dx - 80,
              top: center.dy - 80,
              child: AnimatedBuilder(
                animation: _pulseController,
                builder: (context, _) {
                  return Opacity(
                    opacity: _pulseOpacity.value,
                    child: Transform.scale(
                      scale: _pulseScale.value,
                      child: Container(
                        width: 160,
                        height: 160,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.4),
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Fingerprint arcs overlay
            Positioned(
              left: center.dx - 90,
              top: center.dy - 90,
              child: AnimatedBuilder(
                animation: _circuitProgress,
                builder: (context, _) {
                  return Opacity(
                    opacity: (_circuitProgress.value * 0.35).clamp(0.0, 0.35),
                    child: CustomPaint(
                      size: const Size(180, 180),
                      painter: _FingerprintPainter(progress: _circuitProgress.value),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Draws circuit/tech lines radiating from center
class _CircuitPainter extends CustomPainter {
  final double progress;
  final Offset center;

  _CircuitPainter({required this.progress, required this.center});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final rng = Random(42);

    for (int i = 0; i < 16; i++) {
      final angle = (i / 16) * 2 * pi + 0.2;
      final startRadius = 85.0 + rng.nextDouble() * 10;
      final length = 60.0 + rng.nextDouble() * 120;
      final hasNode = rng.nextBool();
      final hasBranch = rng.nextDouble() > 0.5;
      final branchAngle = angle + (rng.nextBool() ? 0.3 : -0.3);
      final branchLength = 20 + rng.nextDouble() * 40;

      final startX = center.dx + cos(angle) * startRadius;
      final startY = center.dy + sin(angle) * startRadius;
      final endX = center.dx + cos(angle) * (startRadius + length * progress);
      final endY = center.dy + sin(angle) * (startRadius + length * progress);

      final opacity = (progress * 0.5).clamp(0.0, 0.5);
      paint.color = Colors.white.withValues(alpha: opacity);

      canvas.drawLine(Offset(startX, startY), Offset(endX, endY), paint);

      // Node dots
      if (hasNode && progress > 0.5) {
        final nodePaint = Paint()
          ..color = Colors.white.withValues(alpha: (progress - 0.5) * 1.0)
          ..style = PaintingStyle.fill;
        canvas.drawCircle(Offset(endX, endY), 2.5, nodePaint);
      }

      // Branch lines
      if (hasBranch && progress > 0.4) {
        final branchProgress = ((progress - 0.4) / 0.6).clamp(0.0, 1.0);
        final branchEndX = endX + cos(branchAngle) * branchLength * branchProgress;
        final branchEndY = endY + sin(branchAngle) * branchLength * branchProgress;

        paint.color = Colors.white.withValues(alpha: opacity * 0.5);
        canvas.drawLine(Offset(endX, endY), Offset(branchEndX, branchEndY), paint);

        if (branchProgress > 0.8) {
          final dotPaint = Paint()
            ..color = Colors.white.withValues(alpha: (branchProgress - 0.8) * 2)
            ..style = PaintingStyle.fill;
          canvas.drawCircle(Offset(branchEndX, branchEndY), 2, dotPaint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(_CircuitPainter old) => old.progress != progress;
}

/// Draws concentric fingerprint-like arcs
class _FingerprintPainter extends CustomPainter {
  final double progress;

  _FingerprintPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..strokeCap = StrokeCap.round;

    final rng = Random(7);

    for (int i = 0; i < 8; i++) {
      final radius = 65.0 + i * 9.0;
      final startAngle = rng.nextDouble() * pi;
      final sweepAngle = (0.8 + rng.nextDouble() * 1.2) * progress;
      final opacity = (0.2 + (i % 3) * 0.05).clamp(0.0, 0.3);

      paint.color = Colors.white.withValues(alpha: opacity);

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        paint,
      );

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle + pi,
        sweepAngle * 0.8,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_FingerprintPainter old) => old.progress != progress;
}
