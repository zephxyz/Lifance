
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
      builder: (context, state) => const GetPermissionPage(),
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
        builder: (context, state) => const ProfileViewPage()),
    GoRoute(
        path: '/historyviewmap',
        builder: (context, state) => const HistoryViewPageMap()),
    GoRoute(
        path: '/historyviewphotos',
        builder: (context, state) => const HistoryViewPagePhotos()),
    GoRoute(path: '/photopage', builder: (context, state) => const PhotoPage())
  ],
);
