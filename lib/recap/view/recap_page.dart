import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recap_app/recap/recap.dart';

class RecapPage extends StatelessWidget {
  const RecapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RecapPageCubit(),
      child: const RecapPageView(),
    );
  }
}

class RecapPageView extends StatefulWidget {
  const RecapPageView({super.key});

  @override
  State<RecapPageView> createState() => _RecapPageViewState();
}

class _RecapPageViewState extends State<RecapPageView> {
  int page = 0;

  @override
  void initState() {
    super.initState();
    context.read<RecapPageCubit>().pageController.addListener(() {
      setState(() {
        page = context.read<RecapPageCubit>().pageController.page?.toInt() ?? 0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final pageController = context.select<RecapPageCubit, PageController>(
      (cubit) => cubit.pageController,
    );
    const pages = [
      FirstRecap(),
      SecondRecap(),
      ThirdPage(),
    ];
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(
            child: PageView(
              controller: pageController,
              children: pages,
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: SafeArea(
              maintainBottomViewPadding: true,
              child: Padding(
                padding: const EdgeInsets.only(left: 12, top: 24),
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.arrow_back_rounded,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              maintainBottomViewPadding: true,
              child: Padding(
                padding: const EdgeInsets.only(top: 8),
                // TODO(matiasleyba): replace with https://pub.dev/packages/story_view or similar
                child: DotsIndicator(
                  dotsCount: pages.length,
                  position: page.toDouble(),
                  onTap: (index) {},
                  animate: true,
                  decorator: const DotsDecorator(
                    size: Size(18, 2),
                    activeSize: Size(18, 2),
                    activeColor: Colors.white,
                    color: Color.fromARGB(144, 158, 158, 158),
                    spacing: EdgeInsets.symmetric(horizontal: 2),
                    shape: RoundedRectangleBorder(),
                    activeShape: RoundedRectangleBorder(),
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
