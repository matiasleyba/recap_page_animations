import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RecapPageCubit extends Cubit<PageController> {
  RecapPageCubit() : super(PageController());

  PageController get pageController => state;

  static Duration get transitionDuration => const Duration(milliseconds: 600);

  void onPageChanged(int index) {
    state.animateToPage(
      index,
      duration: transitionDuration,
      curve: Curves.ease,
    );
  }
}
