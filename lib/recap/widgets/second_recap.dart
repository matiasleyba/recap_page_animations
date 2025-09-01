import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recap_app/recap/recap.dart';
import 'package:recap_app/theme/theme.dart';

class SecondRecap extends StatefulWidget {
  const SecondRecap({super.key});

  @override
  State<SecondRecap> createState() => _SecondRecapState();
}

class _SecondRecapState extends State<SecondRecap>
    with TickerProviderStateMixin {
  late final AnimationController _animationController;
  late final AnimationController _yellowSectionAnimationController;

  late final Animation<Offset> _greenSectionAnimation;
  late final Animation<double> _greenSectionTextAnimation;
  late Animation<Offset> _yellowSectionFirstAnimation;
  late Animation<double> _circleAnimation;
  late Animation<Alignment> _circleAlignmentAnimation;
  late Animation<double> _textAnimation;
  late Animation<Alignment> _textAlignmentAnimation;

  final _animationDuration = const Duration(milliseconds: 2000);

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: _animationDuration,
    );

    _yellowSectionAnimationController = AnimationController(
      vsync: this,
      duration: _animationDuration,
    );

    _greenSectionAnimation =
        Tween<Offset>(begin: const Offset(0, 0.95), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: const Interval(0.1, 0.4, curve: Curves.easeIn),
          ),
        );
    _yellowSectionFirstAnimation =
        Tween<Offset>(
          begin: const Offset(0, 1),
          end: const Offset(0, 0.85),
        ).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: const Interval(0.6, 0.8, curve: Curves.ease),
          ),
        );

    _circleAnimation = Tween<double>(begin: 0.45, end: 1).animate(
      CurvedAnimation(
        parent: _yellowSectionAnimationController,
        curve: const Interval(0, 0.3, curve: Curves.ease),
      ),
    );
    _circleAlignmentAnimation =
        Tween<Alignment>(
          begin: Alignment.topCenter,
          end: Alignment.center,
        ).animate(
          CurvedAnimation(
            parent: _yellowSectionAnimationController,
            curve: const Interval(0.2, 1, curve: Curves.ease),
          ),
        );

    _greenSectionTextAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.1, 0.4, curve: Curves.easeIn),
      ),
    );

    _textAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _yellowSectionAnimationController,
        curve: const Interval(0.6, 1, curve: Curves.ease),
      ),
    );

    _textAlignmentAnimation =
        Tween<Alignment>(
          begin: const Alignment(-1, 0.2),
          end: Alignment.centerLeft,
        ).animate(
          CurvedAnimation(
            parent: _yellowSectionAnimationController,
            curve: const Interval(0.6, 1, curve: Curves.ease),
          ),
        );

    Future.delayed(
      RecapPageCubit.transitionDuration,
      () {
        _animationController.forward().whenComplete(() {
          _yellowSectionAnimationController.forward();

          _yellowSectionFirstAnimation =
              Tween<Offset>(
                begin: const Offset(0, 0.85),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(
                  parent: _yellowSectionAnimationController,
                  curve: const Interval(0, 0.4, curve: Curves.ease),
                ),
              );
        });

        _animationController.addListener(() {
          if (mounted) {
            setState(() {});
          }
        });
        _yellowSectionAnimationController
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              context.read<RecapPageCubit>().onPageChanged(2);
            }
          })
          ..addListener(() {
            if (mounted) {
              setState(() {});
            }
          });
      },
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    final width = MediaQuery.sizeOf(context).width;

    final fullCircleSize = (width < height ? height : width);
    final circleSize = fullCircleSize * 0.95;

    return Scaffold(
      backgroundColor: Colors.lightBlue.shade100,

      body: Stack(
        children: [
          Positioned.fill(
            child: SlideTransition(
              position: _greenSectionAnimation,
              child: Container(color: AppColors.green),
            ),
          ),
          ClipPath(
            clipper: TextClipper(
              animationValue: _greenSectionTextAnimation.value,
            ),
            child: Container(
              alignment: const Alignment(0, -0.5),
              padding: const EdgeInsets.all(48),
              child: const Text(
                // ignore: lines_longer_than_80_chars
                'See how your creativity, passion, and personal touch stood out in 2024...',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: SlideTransition(
              position: _yellowSectionFirstAnimation,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Positioned.fill(child: Container(color: AppColors.yellow)),
                  AlignTransition(
                    alignment: _circleAlignmentAnimation,
                    child: ClipRect(
                      child: ScaleTransition(
                        scale: _circleAnimation,
                        alignment: _circleAlignmentAnimation.value,
                        child: OverflowBox(
                          maxHeight: circleSize,
                          maxWidth: circleSize,
                          child: SafeArea(
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppColors.lightBlue,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  AlignTransition(
                    alignment: _textAlignmentAnimation,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 32),
                      child: FadeTransition(
                        opacity: _textAnimation,
                        child: const Text(
                          // ignore: lines_longer_than_80_chars
                          "It's time to \ncelebrate the\nrole you play in\nLeeping\nCommerce\nHuman!",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 38,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
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
  }
}

class TextClipper extends CustomClipper<Path> {
  TextClipper({required this.animationValue});

  final double animationValue;

  @override
  Path getClip(Size size) {
    final path = Path();
    final animatedHeight = size.height * animationValue;

    path
      ..moveTo(0, size.height - animatedHeight)
      ..lineTo(size.width, size.height - animatedHeight)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    return path;
  }

  @override
  bool shouldReclip(covariant TextClipper oldClipper) =>
      oldClipper.animationValue != animationValue;
}
