import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meu_mobile/app/shell/app_shell.dart';
import 'package:meu_mobile/features/academic_calendar/presentation/pages/academic_calendar_page.dart';
import 'package:meu_mobile/features/announcements/presentation/pages/announcement_detail_page.dart';
import 'package:meu_mobile/features/announcements/presentation/pages/announcements_page.dart';
import 'package:meu_mobile/features/campus_map/presentation/pages/campus_map_page.dart';
import 'package:meu_mobile/features/clubs/presentation/pages/club_detail_page.dart';
import 'package:meu_mobile/features/clubs/presentation/pages/clubs_page.dart';
import 'package:meu_mobile/features/developer/presentation/pages/widget_catalog_page.dart';
import 'package:meu_mobile/features/events/presentation/pages/event_detail_page.dart';
import 'package:meu_mobile/features/events/presentation/pages/events_page.dart';
import 'package:meu_mobile/features/food/presentation/pages/food_page.dart';
import 'package:meu_mobile/features/home/presentation/pages/home_page.dart';
import 'package:meu_mobile/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:meu_mobile/features/ring/presentation/pages/ring_page.dart';
import 'package:meu_mobile/features/settings/presentation/pages/settings_page.dart';
import 'package:meu_mobile/features/splash/presentation/pages/splash_page.dart';
import 'package:meu_mobile/features/notifications/pages/notifications_page.dart';

final class AppRouter {
  const AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: '/splash',
    overridePlatformDefaultLocation: true,
    routes: [
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (context, state) {
          return const SplashPage();
        },
      ),
      GoRoute(
        path: '/onboarding',
        name: 'onboarding',
        pageBuilder: (context, state) {
          return CustomTransitionPage<void>(
            key: state.pageKey,
            transitionDuration: const Duration(milliseconds: 420),
            reverseTransitionDuration: const Duration(milliseconds: 260),
            child: const OnboardingPage(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  final curvedAnimation = CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeOutCubic,
                  );

                  return FadeTransition(
                    opacity: curvedAnimation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 0.025),
                        end: Offset.zero,
                      ).animate(curvedAnimation),
                      child: child,
                    ),
                  );
                },
          );
        },
      ),
      GoRoute(
        path: '/dev/catalog',
        name: 'widget-catalog',
        builder: (context, state) {
          return const WidgetCatalogPage();
        },
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return AppShell(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/',
                name: 'home',
                builder: (context, state) {
                  return const HomePage();
                },
                routes: [
                  GoRoute(
                    path: '/notifications',
                    name: 'notifications',
                    builder: (context, state) => const NotificationsPage(),
                  ),
                  GoRoute(
                    path: 'food',
                    name: 'food',
                    builder: (context, state) {
                      return const FoodPage();
                    },
                  ),
                  GoRoute(
                    path: 'ring',
                    name: 'ring',
                    builder: (context, state) {
                      return const RingPage();
                    },
                  ),
                  GoRoute(
                    path: '/academic-calendar',
                    name: 'academic-calendar',
                    builder: (context, state) {
                      return const AcademicCalendarPage();
                    },
                  ),
                  GoRoute(
                    path: '/campus-map',
                    name: 'campus-map',
                    builder: (context, state) {
                      return const CampusMapPage();
                    },
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/announcements',
                name: 'announcements',
                builder: (context, state) {
                  return const AnnouncementsPage();
                },
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
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/events',
                name: 'events',
                builder: (context, state) {
                  return const EventsPage();
                },
                routes: [
                  GoRoute(
                    path: ':eventId',
                    name: 'event-detail',
                    builder: (context, state) {
                      final eventId = state.pathParameters['eventId'] ?? '';

                      return EventDetailPage(eventId: eventId);
                    },
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/clubs',
                name: 'clubs',
                builder: (context, state) {
                  return const ClubsPage();
                },
                routes: [
                  GoRoute(
                    path: ':clubId',
                    name: 'club-detail',
                    builder: (context, state) {
                      final clubId = state.pathParameters['clubId'] ?? '';

                      return ClubDetailPage(clubId: clubId);
                    },
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/settings',
                name: 'settings',
                builder: (context, state) {
                  return const SettingsPage();
                },
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
