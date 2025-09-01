import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:recap_app/theme/theme.dart';

class ThirdPage extends StatefulWidget {
  const ThirdPage({super.key});

  @override
  State<ThirdPage> createState() => _ThirdPageState();
}

class _ThirdPageState extends State<ThirdPage> with TickerProviderStateMixin {
  late final AnimationController _animationController;
  late final AnimationController _circleAnimationController;

  late Animation<Offset> _circleOffSetanimation;
  late final Animation<double> _circleScaleAnimation;
  late final Animation<double> _circleClipAnimation;
  final _animationDuration = const Duration(milliseconds: 1200);

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: _animationDuration,
    );
    _circleAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _circleOffSetanimation =
        Tween<Offset>(
          begin: const Offset(0, 0.5),
          end: const Offset(0, -0.4),
        ).animate(
          CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
        );

    _circleScaleAnimation = Tween<double>(begin: 0.7, end: 1.8).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.8, 1, curve: Curves.easeIn),
      ),
    );

    _circleClipAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _circleAnimationController,
        curve: Curves.easeOut,
      ),
    );

    _animationController
      ..forward()
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _circleAnimationController.forward();
        }
      })
      ..addListener(() {
        if (mounted) {
          setState(() {});
        }
      });

    _circleAnimationController.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: AppColors.green,
      body: Stack(
        children: [
          Positioned.fill(
            child: ClipRect(
              child: SlideTransition(
                position: _circleOffSetanimation,
                child: ScaleTransition(
                  scale: _circleScaleAnimation,
                  child: CustomPaint(
                    painter: TwoCirclesPainter(
                      progress: _circleClipAnimation.value,
                      screenWidth: screenWidth,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TwoCirclesPainter extends CustomPainter {
  TwoCirclesPainter({
    required this.progress,
    required this.screenWidth,
  });

  final double progress;
  final double screenWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.lightBlue
      ..style = PaintingStyle.fill;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final cornerRadius = lerpDouble(radius, 0, progress)!;
    final rectWidth = radius * 2;
    final rectHeight = radius * 2;

    final rect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: center,
        width: rectWidth,
        height: rectHeight,
      ),
      Radius.circular(cornerRadius),
    );

    final path = Path()..addRRect(rect);

    final curveDepth = lerpDouble(0, size.height * 0.06, progress)! * progress;

    canvas.drawPath(path, paint);

    final redPaint = Paint()
      ..color = AppColors.green
      ..style = PaintingStyle.fill
      ..strokeWidth = 1;

    final curvePath = Path();
    final figureWidth = screenWidth / 1.6;
    final figureLeft = center.dx - figureWidth / 2;
    final figureRight = center.dx + figureWidth / 2;

    curvePath
      ..moveTo(figureLeft, rect.bottom)
      ..quadraticBezierTo(
        center.dx,
        rect.bottom - curveDepth,
        figureRight,
        rect.bottom,
      );
    canvas.drawPath(curvePath, redPaint);
  }

  @override
  bool shouldRepaint(covariant TwoCirclesPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
