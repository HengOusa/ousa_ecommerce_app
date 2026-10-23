import 'package:ecom_app/features/onboarding/data/models/onboarding_model.dart';
import 'package:ecom_app/features/onboarding/data/onboarding_data.dart';
import 'package:flutter/material.dart';

class OnboardingProvider extends ChangeNotifier {
  final PageController pageController = PageController();
  int _currentPage = 0;

  final int totalPages;
  OnboardingProvider({required this.totalPages});

  List<OnboardingModel> get onboardingItems => OnboardingData.items;

  int get currentPage => _currentPage;

  bool get isLastPage => _currentPage == totalPages - 1;

  void onPageChanged(int page) {
    _currentPage = page;
    notifyListeners();
  }

  Future<bool> nextPage() async {
    if (isLastPage) {
      return true;
    }

    await pageController.nextPage(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );

    return false;
  }

  Future<void> skip() async {
    await pageController.animateToPage(
      onboardingItems.length - 1,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
}
