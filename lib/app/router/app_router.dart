import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meu_mobile/app/shell/app_shell.dart';
import 'package:meu_mobile/features/developer/presentation/pages/widget_catalog_page.dart';
import 'package:meu_mobile/features/food/presentation/pages/food_page.dart';
import 'package:meu_mobile/features/home/presentation/pages/home_page.dart';
import 'package:meu_mobile/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:meu_mobile/features/ring/presentation/pages/ring_page.dart';
import 'package:meu_mobile/features/splash/presentation/pages/splash_page.dart';
import 'package:meu_mobile/shared/widgets/states/feature_placeholder_page.dart';
import 'package:meu_mobile/features/announcements/presentation/pages/announcements_page.dart';
import 'package:meu_mobile/features/announcements/presentation/pages/announcement_detail_page.dart';

final class AppRouter {
  const AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: '/splash',
    routes: [
      /// Splash - Shell dışında, tam ekran
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (context, state) => const SplashPage(),
      ),

      /// Onboarding - Shell dışında, tam ekran
      GoRoute(
        path: '/onboarding',
        name: 'onboarding',
        builder: (context, state) => const OnboardingPage(),
      ),

      /// Developer Widget Catalog - Shell dışında
      GoRoute(
        path: '/dev/catalog',
        name: 'widget-catalog',
        builder: (context, state) => const WidgetCatalogPage(),
      ),

      /// Main App Shell - Bottom Navigation burada başlar
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return AppShell(navigationShell: navigationShell);
        },
        branches: [
          /// Ana Sayfa branch
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/',
                name: 'home',
                builder: (context, state) => const HomePage(),
                routes: [
                  GoRoute(
                    path: 'food',
                    name: 'food',
                    builder: (context, state) => const FoodPage(),
                  ),
                  GoRoute(
                    path: 'ring',
                    name: 'ring',
                    builder: (context, state) => const RingPage(),
                  ),
                  GoRoute(
                    path: 'calendar',
                    name: 'calendar',
                    builder: (context, state) => const FeaturePlaceholderPage(
                      title: 'Akademik Takvim',
                      description: 'Akademik takvim modülü yakında eklenecek.',
                      icon: Icons.calendar_month_rounded,
                    ),
                  ),
                ],
              ),
            ],
          ),

          /// Duyurular branch
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/announcements',
                name: 'announcements',
                builder: (context, state) => const AnnouncementsPage(),
                routes: [
                  GoRoute(
                    path: ':announcementId',
                    name: 'announcement-detail',
                    builder: (context, state) {
                      final announcementId =
                          state.pathParameters['announcementId'] ?? '';

                      return AnnouncementDetailPage(
                        announcementId: announcementId,
                      );
                    },
                  ),
                ],
              ),
            ],
          ),

          /// Etkinlikler branch
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/events',
                name: 'events',
                builder: (context, state) => const FeaturePlaceholderPage(
                  title: 'Etkinlikler',
                  description: 'Yaklaşan etkinlikler burada listelenecek.',
                  icon: Icons.event_rounded,
                ),
              ),
            ],
          ),

          /// Topluluklar branch
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/clubs',
                name: 'clubs',
                builder: (context, state) => const FeaturePlaceholderPage(
                  title: 'Topluluklar',
                  description: 'Öğrenci toplulukları burada listelenecek.',
                  icon: Icons.groups_rounded,
                ),
              ),
            ],
          ),

          /// Profil branch
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                name: 'profile',
                builder: (context, state) => const FeaturePlaceholderPage(
                  title: 'Profil',
                  description: 'Profil ve kişisel ayarlar burada yer alacak.',
                  icon: Icons.person_rounded,
                ),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
