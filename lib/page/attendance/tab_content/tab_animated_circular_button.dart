import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'dart:math' as m;

import 'package:flutter_screenutil/flutter_screenutil.dart';

class TabAnimatedCircularButton extends StatefulWidget {
  final VoidCallback? onComplete;
  final bool isCheckedIn;
  final String title;
  final Color color;

  const TabAnimatedCircularButton(
      {super.key,
      required this.title,
      required this.color,
      this.onComplete,
      this.isCheckedIn = false});

  @override
  State<TabAnimatedCircularButton> createState() =>
      _AnimatedCircularButtonState();
}

class _AnimatedCircularButtonState extends State<TabAnimatedCircularButton>
    with TickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController controller;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  bool _showHint = false;
  bool _isHolding = false;

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: controller, curve: Curves.easeOut),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          widget.onComplete?.call();
          controller.reset();
          setState(() {
            _isHolding = false;
            _showHint = false;
          });
        }
      });

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _onTap() {
    setState(() => _showHint = true);
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) setState(() => _showHint = false);
    });
  }

  void _onLongPressStart(LongPressStartDetails details) {
    setState(() {
      _isHolding = true;
      _showHint = false;
    });
    controller.reset();
    controller.forward();
  }

  void _onLongPressEnd(LongPressEndDetails details) {
    controller.reset();
    setState(() => _isHolding = false);
  }

  @override
  Widget build(BuildContext context) {
    final radius = 88.r;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: _onTap,
          onLongPressStart: _onLongPressStart,
          onLongPressEnd: _onLongPressEnd,
          child: AnimatedBuilder(
            animation: Listenable.merge([controller, _pulseController]),
            builder: (context, snapshot) {
              final pulseValue = _pulseAnimation.value;
              final glowRadius = _isHolding
                  ? radius + 12.r
                  : radius + 6.r + (pulseValue * 4.r);
              final glowOpacity = _isHolding ? 0.25 : 0.08 + (pulseValue * 0.07);

              return SizedBox(
                width: (radius + 16.r) * 2,
                height: (radius + 16.r) * 2,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: glowRadius * 2,
                      height: glowRadius * 2,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: widget.color.withValues(alpha: glowOpacity),
                            blurRadius: _isHolding ? 24.r : 16.r,
                            spreadRadius: _isHolding ? 4.r : 2.r,
                          ),
                        ],
                      ),
                    ),
                    CustomPaint(
                      size: Size(radius * 2 + 16.r, radius * 2 + 16.r),
                      painter: ArcShapePainter(
                        progress: animation.value,
                        radius: radius,
                        color: widget.color,
                        strokeWidth: 6.0.r,
                        pulseValue: pulseValue,
                        isHolding: _isHolding,
                      ),
                      child: SizedBox(
                        width: radius * 2 + 16.r,
                        height: radius * 2 + 16.r,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AnimatedScale(
                              scale: _isHolding ? 0.8 : 1.0,
                              duration: const Duration(milliseconds: 200),
                              child: Icon(
                                Icons.touch_app_rounded,
                                color: Colors.white,
                                size: 38.r,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Text(
                                widget.title,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14.r,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        SizedBox(height: 8.h),
        AnimatedOpacity(
          opacity: _showHint || _isHolding ? 1.0 : 0.6,
          duration: const Duration(milliseconds: 200),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: _showHint
                  ? widget.color.withValues(alpha: 0.12)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.touch_app_outlined,
                  size: 14.r,
                  color: _showHint ? widget.color : Colors.black38,
                ),
                SizedBox(width: 4.w),
                Text(
                  'hold_to_confirm'.tr(),
                  style: TextStyle(
                    fontSize: 12.r,
                    color: _showHint ? widget.color : Colors.black38,
                    fontWeight: _showHint ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class ArcShapePainter extends CustomPainter {
  final double progress;
  final double radius;
  final Color color;
  final double strokeWidth;
  final double pulseValue;
  final bool isHolding;

  ArcShapePainter({
    required this.color,
    this.progress = 0,
    this.radius = 400,
    this.strokeWidth = 6,
    this.pulseValue = 0,
    this.isHolding = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Offset center = Offset(size.width / 2, size.height / 2);

    // Outer ring
    final outerRingPaint = Paint()
      ..color = color.withValues(alpha: isHolding ? 0.5 : 0.25 + (pulseValue * 0.1))
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    canvas.drawCircle(center, radius, outerRingPaint);

    // Inner filled circle
    final solidPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius - strokeWidth / 2 - 2, solidPaint);

    // Progress arc
    if (progress > 0) {
      final progressAngle = m.pi * 2.0 * progress;
      final progressPaint = Paint()
        ..color = Colors.white.withValues(alpha: 0.9)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth + 2
        ..strokeCap = StrokeCap.round;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -m.pi / 2,
        progressAngle,
        false,
        progressPaint,
      );

      // Leading dot
      final dotAngle = -m.pi / 2 + progressAngle;
      final dotX = center.dx + radius * m.cos(dotAngle);
      final dotY = center.dy + radius * m.sin(dotAngle);
      final dotPaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill;
      canvas.drawCircle(Offset(dotX, dotY), strokeWidth / 2 + 3, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant ArcShapePainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.pulseValue != pulseValue ||
        oldDelegate.isHolding != isHolding;
  }
}
