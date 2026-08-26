import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:meu_mobile/app/theme/app_spacing.dart';
import 'package:meu_mobile/features/settings/application/providers/settings_provider.dart';
import 'package:meu_mobile/features/settings/application/services/settings_actions_service.dart';
import 'package:meu_mobile/features/settings/domain/entities/app_settings.dart';
import 'package:meu_mobile/features/settings/presentation/widgets/settings_section.dart';
import 'package:meu_mobile/features/settings/presentation/widgets/settings_tile.dart';
import 'package:meu_mobile/features/settings/presentation/widgets/theme_mode_selector.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  static const _navy = Color(0xFF182958);
  static const _orange = Color(0xFFF1743A);
  static const _green = Color(0xFF2E9D57);
  static const _purple = Color(0xFF7C64D5);
  static const _teal = Color(0xFF008C95);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(appSettingsProvider);
    final packageInfoAsync = ref.watch(packageInfoProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ayarlar'),
      ),
      body: settingsAsync.when(
        loading: () {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
        error: (error, stackTrace) {
          return _SettingsLoadError(
            onRetry: () {
              ref.invalidate(appSettingsProvider);
            },
          );
        },
        data: (settings) {
          return ListView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              AppSpacing.sm,
              AppSpacing.md,
              AppSpacing.xl,
            ),
            children: [
              const _SettingsHero(),
              const Gap(AppSpacing.lg),
              SettingsSection(
                title: 'Görünüm',
                description:
                    'Uygulamanın görünümünü kullanım alışkanlığına göre ayarla.',
                children: [
                  ThemeModeSelector(
                    value: settings.themePreference,
                    onChanged: (preference) {
                      _updateSetting(
                        context,
                        () => ref
                            .read(appSettingsProvider.notifier)
                            .setTheme(preference),
                      );
                    },
                  ),
                ],
              ),
              const Gap(AppSpacing.lg),
              SettingsSection(
                title: 'Bildirimler',
                description:
                    'Yalnızca ilgilendiğin gelişmeler için bildirim al.',
                children: [
                  SettingsSwitchTile(
                    icon: Icons.notifications_rounded,
                    title: 'Genel Bildirimler',
                    description:
                        'Uygulamadaki tüm bildirimleri aç veya kapat',
                    iconColor: _orange,
                    value: settings.generalNotifications,
                    onChanged: (value) {
                      _updateSetting(
                        context,
                        () => ref
                            .read(appSettingsProvider.notifier)
                            .setGeneralNotifications(value),
                      );
                    },
                  ),
                  SettingsSwitchTile(
                    icon: Icons.campaign_rounded,
                    title: 'Duyuru Bildirimleri',
                    description:
                        'Yeni üniversite duyurularından haberdar ol',
                    iconColor: _purple,
                    value: settings.announcementNotifications,
                    enabled: settings.generalNotifications,
                    onChanged: (value) {
                      _updateSetting(
                        context,
                        () => ref
                            .read(appSettingsProvider.notifier)
                            .setAnnouncementNotifications(value),
                      );
                    },
                  ),
                  SettingsSwitchTile(
                    icon: Icons.event_available_rounded,
                    title: 'Etkinlik Bildirimleri',
                    description:
                        'Yaklaşan kampüs etkinliklerini kaçırma',
                    iconColor: _teal,
                    value: settings.eventNotifications,
                    enabled: settings.generalNotifications,
                    onChanged: (value) {
                      _updateSetting(
                        context,
                        () => ref
                            .read(appSettingsProvider.notifier)
                            .setEventNotifications(value),
                      );
                    },
                  ),
                  SettingsSwitchTile(
                    icon: Icons.restaurant_menu_rounded,
                    title: 'Yemekhane Hatırlatıcısı',
                    description:
                        'Günlük menü için seçtiğin saatte hatırlatma al',
                    iconColor: _green,
                    value: settings.cafeteriaReminder,
                    enabled: settings.generalNotifications,
                    onChanged: (value) {
                      _updateSetting(
                        context,
                        () => ref
                            .read(appSettingsProvider.notifier)
                            .setCafeteriaReminder(value),
                        successMessage: value
                            ? 'Yemekhane hatırlatıcısı açıldı.'
                            : 'Yemekhane hatırlatıcısı kapatıldı.',
                      );
                    },
                  ),
                  if (settings.generalNotifications &&
                      settings.cafeteriaReminder)
                    SettingsTile(
                      icon: Icons.schedule_rounded,
                      title: 'Hatırlatma Saati',
                      description:
                          'Her gün ${_formatTime(context, settings.cafeteriaReminderTime)}',
                      iconColor: _green,
                      trailing: const Icon(
                        Icons.edit_rounded,
                        color: _green,
                        size: 19,
                      ),
                      onTap: () {
                        _selectReminderTime(
                          context,
                          ref,
                          settings,
                        );
                      },
                    ),
                ],
              ),
              const Gap(AppSpacing.lg),
              SettingsSection(
                title: 'Uygulama',
                description:
                    'MEUMOBİL deneyimini yönet ve bize görüşünü ilet.',
                children: [
                  SettingsTile(
                    icon: Icons.auto_awesome_rounded,
                    title: 'Karşılama Ekranlarını Göster',
                    description:
                        'Modern tanıtım sayfalarını yeniden görüntüle',
                    iconColor: _purple,
                    onTap: () {
                      _showOnboardingConfirmation(
                        context,
                      );
                    },
                  ),
                  SettingsTile(
                    icon: Icons.rate_review_rounded,
                    title: 'Geri Bildirim Gönder',
                    description:
                        'Görüş, öneri veya sorununu e-posta ile paylaş',
                    iconColor: _teal,
                    onTap: () {
                      _sendFeedback(
                        context,
                        packageInfoAsync,
                      );
                    },
                  ),
                  SettingsTile(
                    icon: Icons.star_rounded,
                    title: 'Google Play’de Değerlendir',
                    description:
                        'Uygulamayı mağazada puanla ve yorum yap',
                    iconColor: _orange,
                    onTap: () {
                      _rateApp(context);
                    },
                  ),
                  SettingsTile(
                    icon: Icons.cleaning_services_rounded,
                    title: 'Önbelleği Temizle',
                    description:
                        'Kaydedilmiş API verilerini cihazdan kaldır',
                    iconColor: _green,
                    onTap: () {
                      _showClearCacheConfirmation(
                        context,
                      );
                    },
                  ),
                ],
              ),
              const Gap(AppSpacing.lg),
              SettingsSection(
                title: 'Hakkında',
                children: [
                  SettingsTile(
                    icon: Icons.info_outline_rounded,
                    title: 'MEUMOBİL',
                    description: packageInfoAsync.when(
                      data: (info) {
                        return 'Sürüm ${info.version} '
                            '(${info.buildNumber})';
                      },
                      loading: () =>
                          'Sürüm bilgisi yükleniyor',
                      error: (_, _) =>
                          'Sürüm bilgisi alınamadı',
                    ),
                    iconColor: _navy,
                    trailing: const SizedBox.shrink(),
                  ),
                ],
              ),
              const Gap(AppSpacing.md),
              Text(
                'Mersin Üniversitesi kampüs yaşamı için geliştirildi.',
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(
                      color: Theme.of(context).brightness ==
                              Brightness.dark
                          ? Colors.white38
                          : const Color(0xFF98A2B3),
                      fontSize: 10.5,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          );
        },
      ),
    );
  }

  static Future<void> _updateSetting(
    BuildContext context,
    Future<void> Function() action, {
    String? successMessage,
  }) async {
    try {
      await action();

      if (!context.mounted ||
          successMessage == null) {
        return;
      }

      _showMessage(
        context,
        successMessage,
      );
    } catch (error) {
      if (!context.mounted) {
        return;
      }

      final message = error.toString().contains(
            'Bildirim izni verilmedi',
          )
          ? 'Hatırlatıcı için bildirim izni vermen gerekiyor.'
          : 'Ayar kaydedilemedi. Tekrar deneyin.';

      _showMessage(
        context,
        message,
      );
    }
  }

  static Future<void> _selectReminderTime(
    BuildContext context,
    WidgetRef ref,
    AppSettings settings,
  ) async {
    final selectedTime = await showTimePicker(
      context: context,
      initialTime: settings.cafeteriaReminderTime,
      helpText: 'Hatırlatma saatini seç',
      cancelText: 'Vazgeç',
      confirmText: 'Kaydet',
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            timePickerTheme: TimePickerThemeData(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (selectedTime == null ||
        !context.mounted) {
      return;
    }

    await _updateSetting(
      context,
      () => ref
          .read(appSettingsProvider.notifier)
          .setCafeteriaReminderTime(
            hour: selectedTime.hour,
            minute: selectedTime.minute,
          ),
      successMessage:
          'Hatırlatma saati ${_formatTime(context, selectedTime)} olarak ayarlandı.',
    );
  }

  static Future<void> _sendFeedback(
    BuildContext context,
    AsyncValue<PackageInfo> packageInfoAsync,
  ) async {
    final packageInfo = packageInfoAsync.asData?.value;

    if (packageInfo == null) {
      _showMessage(
        context,
        'Uygulama bilgisi henüz hazır değil.',
      );
      return;
    }

    final opened = await SettingsActionsService()
        .sendFeedback(packageInfo);

    if (!opened && context.mounted) {
      _showMessage(
        context,
        'E-posta uygulaması açılamadı.',
      );
    }
  }

  static Future<void> _rateApp(
    BuildContext context,
  ) async {
    final opened = await SettingsActionsService()
        .openStoreListing();

    if (!opened && context.mounted) {
      _showMessage(
        context,
        'Google Play sayfası açılamadı.',
      );
    }
  }

  static Future<void>
      _showOnboardingConfirmation(
    BuildContext context,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(
            'Karşılama ekranları',
          ),
          content: const Text(
            'Tanıtım sayfaları şimdi yeniden açılsın mı?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(false);
              },
              child: const Text('Vazgeç'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
              },
              child: const Text('Göster'),
            ),
          ],
        );
      },
    );

    if (confirmed != true ||
        !context.mounted) {
      return;
    }

    await SettingsActionsService()
        .resetOnboarding();

    if (context.mounted) {
      context.go('/onboarding');
    }
  }

  static Future<void>
      _showClearCacheConfirmation(
    BuildContext context,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Önbelleği temizle'),
          content: const Text(
            'Kaydedilmiş API verileri silinecek. '
            'Güncel veriler yeniden indirilecek.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(false);
              },
              child: const Text('Vazgeç'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
              },
              child: const Text('Temizle'),
            ),
          ],
        );
      },
    );

    if (confirmed != true ||
        !context.mounted) {
      return;
    }

    try {
      await SettingsActionsService().clearApiCache();

      if (context.mounted) {
        _showMessage(
          context,
          'Önbellek temizlendi.',
        );
      }
    } catch (_) {
      if (context.mounted) {
        _showMessage(
          context,
          'Önbellek temizlenemedi.',
        );
      }
    }
  }

  static String _formatTime(
    BuildContext context,
    TimeOfDay time,
  ) {
    return MaterialLocalizations.of(context)
        .formatTimeOfDay(
      time,
      alwaysUse24HourFormat: true,
    );
  }

  static void _showMessage(
    BuildContext context,
    String message,
  ) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
        ),
      );
  }
}

class _SettingsHero extends StatelessWidget {
  const _SettingsHero();

  static const _navy = Color(0xFF182958);
  static const _deepNavy = Color(0xFF0D1735);
  static const _orange = Color(0xFFF1743A);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 128,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            _navy,
            _deepNavy,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: _navy.withValues(alpha: 0.20),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -18,
            top: -32,
            child: Container(
              width: 135,
              height: 135,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _orange.withValues(alpha: 0.10),
              ),
            ),
          ),
          Row(
            children: [
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.17),
                  ),
                ),
                child: const Icon(
                  Icons.tune_rounded,
                  color: Colors.white,
                  size: 27,
                ),
              ),
              const Gap(14),
              const Expanded(
                child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment.center,
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sana göre MEUMOBİL',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Görünümü, bildirimleri ve uygulama davranışlarını yönet.',
                      style: TextStyle(
                        color: Color(0xC9FFFFFF),
                        fontSize: 11.5,
                        height: 1.35,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SettingsLoadError extends StatelessWidget {
  const _SettingsLoadError({
    required this.onRetry,
  });

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(
          AppSpacing.lg,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.settings_backup_restore_rounded,
              size: 44,
              color: Color(0xFFF1743A),
            ),
            const Gap(AppSpacing.md),
            Text(
              'Ayarlar yüklenemedi',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
            ),
            const Gap(AppSpacing.sm),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(
                Icons.refresh_rounded,
              ),
              label: const Text(
                'Tekrar Dene',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
