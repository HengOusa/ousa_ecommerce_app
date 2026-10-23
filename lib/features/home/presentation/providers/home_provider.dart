import 'package:flutter/cupertino.dart';

class HomeProvider extends ChangeNotifier {
  final PageController bannerController = PageController();

  int currentBanner = 0;
  bool isFavorite = false;

  void activeFavorite() {
    isFavorite = !isFavorite;
    notifyListeners();
  }

  void changeBanner(int index) {
    currentBanner = index;
    notifyListeners();
  }

  void nextBanner(int totalBanners) {
    if (!bannerController.hasClients) return;

    int nextIndex = currentBanner + 1;

    if (nextIndex >= totalBanners) {
      nextIndex = 0;
    }

    bannerController.animateToPage(
      nextIndex,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    bannerController.dispose();
    super.dispose();
  }
}
