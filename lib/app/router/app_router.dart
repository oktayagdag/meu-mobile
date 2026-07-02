import 'package:go_router/go_router.dart';
import 'package:meu_mobile/features/home/presentation/pages/home_page.dart';

final class AppRouter {
  const AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const HomePage(),
      ),
    ],
  );
}