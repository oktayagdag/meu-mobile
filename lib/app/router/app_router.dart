import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meu_mobile/features/developer/presentation/pages/widget_catalog_page.dart';
import 'package:meu_mobile/features/home/presentation/pages/home_page.dart';

final class AppRouter {
  const AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      /// Home
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const HomePage(),
      ),

      /// Developer Widget Catalog
      GoRoute(
        path: '/dev/catalog',
        name: 'widget-catalog',
        builder: (context, state) => const WidgetCatalogPage(),
      ),

      /// Food
      GoRoute(
        path: '/food',
        name: 'food',
        builder: (context, state) =>
            const _PlaceholderPage(title: 'Yemekhane'),
      ),

      /// Ring
      GoRoute(
        path: '/ring',
        name: 'ring',
        builder: (context, state) =>
            const _PlaceholderPage(title: 'Ring Saatleri'),
      ),

      /// Announcements
      GoRoute(
        path: '/announcements',
        name: 'announcements',
        builder: (context, state) =>
            const _PlaceholderPage(title: 'Duyurular'),
      ),

      /// Events
      GoRoute(
        path: '/events',
        name: 'events',
        builder: (context, state) =>
            const _PlaceholderPage(title: 'Etkinlikler'),
      ),

      /// Clubs
      GoRoute(
        path: '/clubs',
        name: 'clubs',
        builder: (context, state) =>
            const _PlaceholderPage(title: 'Topluluklar'),
      ),

      /// Academic Calendar
      GoRoute(
        path: '/calendar',
        name: 'calendar',
        builder: (context, state) =>
            const _PlaceholderPage(title: 'Akademik Takvim'),
      ),
    ],
  );
}

class _PlaceholderPage extends StatelessWidget {
  const _PlaceholderPage({
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Text(
          title,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}