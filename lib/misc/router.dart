import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:tg_proj/pages/get_permission_page.dart';
import 'package:tg_proj/pages/history_view_page.dart';
import 'package:tg_proj/pages/profile_view_page.dart';
import 'package:tg_proj/pages/home_page.dart';
import 'package:tg_proj/pages/login_register_page.dart';
import 'package:tg_proj/misc/auth.dart';
import 'package:tg_proj/misc/geolocation.dart';
import 'package:tg_proj/pages/photo_page.dart';

final router = GoRouter(
  initialLocation: '/auth',
  routes: [
    GoRoute(
      path: '/',
      pageBuilder: (context, state) =>
          const NoTransitionPage(child: HomePage()),
    ),
    GoRoute(
      path: '/auth',
      pageBuilder: (context, state) =>
          const NoTransitionPage(child: LoginPage()),
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
      pageBuilder: (context, state) =>
          const NoTransitionPage(child: GetPermissionPage()),
      redirect: (context, state) {
        if (Geolocation.instance.locPerm == LocationPermission.always ||
            Geolocation.instance.locPerm == LocationPermission.whileInUse) {
          return '/';
        } else {
          return null;
        }
      },
    ),
    GoRoute(
      path: '/profileview',
      pageBuilder: (context, state) =>
          const NoTransitionPage(child: ProfileViewPage()),
    ),
    GoRoute(
      path: '/historyviewmap',
      pageBuilder: (context, state) =>
          const NoTransitionPage(child: HistoryViewPageMap()),
    ),
    GoRoute(
      path: '/historyviewphotos',
      pageBuilder: (context, state) =>
          const NoTransitionPage(child: HistoryViewPagePhotos()),
    ),
    GoRoute(
      path: '/photopage',
      pageBuilder: (context, state) =>
          const NoTransitionPage(child: PhotoPage()),
    )
  ],
);
