import 'package:go_router/go_router.dart';
import 'package:meu_mobile/features/developer/presentation/pages/widget_catalog_page.dart';
import 'package:meu_mobile/features/home/presentation/pages/home_page.dart';

final class AppRouter {
  const AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: '/dev/catalog',
    routes: [
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: '/dev/catalog',
        name: 'widget-catalog',
        builder: (context, state) => const WidgetCatalogPage(),
      ),
    ],
  );
}