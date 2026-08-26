import 'package:meu_mobile/core/storage/app_storage_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingLocalDataSource {
  Future<bool> hasCompletedOnboarding() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getBool(AppStorageKeys.onboardingCompleted) ?? false;
  }

  Future<void> setOnboardingCompleted() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool(AppStorageKeys.onboardingCompleted, true);
  }
}
