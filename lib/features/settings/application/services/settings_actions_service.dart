import 'package:hive_flutter/hive_flutter.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:meu_mobile/core/cache/api_cache_service.dart';
import 'package:meu_mobile/core/storage/app_storage_keys.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsActionsService {
  Future<bool> sendFeedback(
    PackageInfo packageInfo,
  ) async {
    final uri = Uri(
      scheme: 'mailto',
      queryParameters: {
        'subject': 'MEUMOBİL Geri Bildirim',
        'body':
            '\n\n'
            '---\n'
            'Uygulama: ${packageInfo.appName}\n'
            'Sürüm: ${packageInfo.version} '
            '(${packageInfo.buildNumber})\n'
            'Paket: ${packageInfo.packageName}',
      },
    );

    return launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );
  }

  Future<bool> openStoreListing() async {
    try {
      await InAppReview.instance.openStoreListing();
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<void> clearApiCache() async {
    if (Hive.isBoxOpen(ApiCacheService.boxName)) {
      await Hive.box<String>(
        ApiCacheService.boxName,
      ).clear();
      return;
    }

    final box = await Hive.openBox<String>(
      ApiCacheService.boxName,
    );

    await box.clear();
  }

  Future<void> resetOnboarding() async {
    final preferences = await SharedPreferences.getInstance();

    await preferences.setBool(
      AppStorageKeys.onboardingCompleted,
      false,
    );
  }
}
