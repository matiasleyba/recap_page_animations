import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recap_app/recap/recap.dart';
import 'package:recap_app/theme/theme.dart';

class FirstRecap extends StatefulWidget {
  const FirstRecap({super.key});

  @override
  State<FirstRecap> createState() => _FirstRecapState();
}

class _FirstRecapState extends State<FirstRecap> with TickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<Offset> _firstAnimation;
  late final Animation<double> _secondAnimation;

  static const Duration _animationDuration = Duration(milliseconds: 3600);

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: _animationDuration,
    );
    _firstAnimation =
        Tween<Offset>(begin: const Offset(-1, 0), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: const Interval(0, 0.4, curve: Curves.ease),
          ),
        );
    _secondAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.4, 1, curve: Curves.ease),
      ),
    );
    _animationController
      ..forward()
      ..addListener(() {
        if (mounted) {
          setState(() {});
        }
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          context.read<RecapPageCubit>().onPageChanged(1);
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.green,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          SlideTransition(
            position: _firstAnimation,
            child: SafeArea(
              child: Container(
                margin: const EdgeInsets.only(right: 40, top: 16),
                color: AppColors.lightBlue,
              ),
            ),
          ),
          SafeArea(
            maintainBottomViewPadding: true,
            child: Container(
              margin: const EdgeInsets.symmetric(
                vertical: 30,
              ).copyWith(right: 0),
              child: ClipPath(
                clipper: SemicircleClipper(
                  animationValue: _secondAnimation.value,
                ),
                child: Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(left: 24),
                  color: AppColors.yellow,
                  child: FadeTransition(
                    opacity: _secondAnimation,
                    child: const _Text(),
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

class _Text extends StatelessWidget {
  const _Text();

  @override
  Widget build(BuildContext context) => RichText(
    text: const TextSpan(
      style: TextStyle(color: Colors.black, fontSize: 58),
      children: [
        TextSpan(
          text: 'Etsy \n',
          style: TextStyle(fontWeight: FontWeight.w400),
        ),
        TextSpan(
          text: '2024 \n',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        TextSpan(
          text: 'Year in\nReview',
          style: TextStyle(fontWeight: FontWeight.w100),
        ),
      ],
    ),
  );
}

class SemicircleClipper extends CustomClipper<Path> {
  SemicircleClipper({required this.animationValue});

  final double animationValue;

  @override
  Path getClip(Size size) {
    final path = Path();
    final maxRadius = size.height / 2;
    final animatedRadius = maxRadius * animationValue;
    final centerY = size.height / 2;

    path
      ..moveTo(0, centerY - animatedRadius)
      ..arcTo(
        Rect.fromCircle(center: Offset(0, centerY), radius: animatedRadius),
        -math.pi / 2, // Start angle (top)
        math.pi, // Sweep angle (180 degrees)
        false,
      )
      ..close();
    return path;
  }

  @override
  bool shouldReclip(covariant SemicircleClipper oldClipper) =>
      oldClipper.animationValue != animationValue;
}
