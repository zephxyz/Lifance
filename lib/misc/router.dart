import 'package:go_router/go_router.dart';
import 'package:tg_proj/pages/get_location_page.dart';
import 'package:tg_proj/pages/history_view_page.dart';
import 'package:tg_proj/pages/profile_view_page.dart';
import 'package:tg_proj/pages/home_page.dart';
import 'package:tg_proj/pages/login_register_page.dart';
import 'package:tg_proj/auth.dart';

final router = GoRouter(
  initialLocation: '/auth',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: '/auth',
      builder: (context, state) => const LoginPage(),
      redirect: (context, state) {
        if (Auth.instance.currentUser != null &&
            Auth.instance.isEmailVerified()) {
          return '/getperm';
        } else {
          return null;
        }
      },
    ),
    GoRoute(
        path: '/getperm',
        builder: (context, state) => const GetPermissionPage()),
    GoRoute(
        path: '/profileview',
        builder: (context, state) => const ProfileViewPage()),
    GoRoute(
        path: '/historyviewmap',
        builder: (context, state) => const HistoryViewPageMap()),
    GoRoute(
        path: '/historyviewphotos',
        builder: (context, state) => const HistoryViewPagePhotos())
  ],
);
