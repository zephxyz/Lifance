import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:lifance/pages/challenge_completed_page.dart';
import 'package:lifance/pages/get_permission_page.dart';
import 'package:lifance/pages/history_view_page.dart';
import 'package:lifance/pages/profile_view_page.dart';
import 'package:lifance/pages/home_page.dart';
import 'package:lifance/pages/login_register_page.dart';
import 'package:lifance/misc/auth.dart';
import 'package:lifance/misc/geolocation.dart';
import 'package:lifance/pages/photo_page.dart';
import 'package:lifance/pages/select_signin_option_page.dart';

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
          const NoTransitionPage(child: SelectSignInOptionPage()),
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
      path: '/auth/email',
      pageBuilder: (context, state) =>
          const NoTransitionPage(child: LoginPage()),
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
    ),
    GoRoute(
        path: '/challengecompleted',
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: ChallengeCompletedPage())),
  ],
);
