import 'package:ecom_app/core/constrants/app_images.dart';
import 'package:ecom_app/core/constrants/app_strings.dart';
import 'package:ecom_app/features/onboarding/data/models/onboarding_model.dart';

class OnboardingData {
  static List<OnboardingModel> items = [
    OnboardingModel(
      image: AppImages.onboarding1,
      title: AppStrings.onboardingTitle1,
      description: AppStrings.onboardingDescription1,
    ),
    OnboardingModel(
      image: AppImages.onboarding2,
      title: AppStrings.onboardingTitle2,
      description: AppStrings.onboardingDescription2,
    ),
    OnboardingModel(
      image: AppImages.onboarding3,
      title: AppStrings.onboardingTitle3,
      description: AppStrings.onboardingDescription3,
    ),
    OnboardingModel(
      image: AppImages.onboarding4,
      title: AppStrings.onboardingTitle4,
      description: AppStrings.onboardingDescription4,
    ),
  ];
}
