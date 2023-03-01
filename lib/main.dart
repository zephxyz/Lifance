import 'package:flutter/material.dart';
import 'package:tg_proj/pages/home_page.dart';
import 'package:tg_proj/pages/login_register_page.dart';
import 'package:tg_proj/pages/widget_tree.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tg_proj/misc/color_to_material_color.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:tg_proj/pages/getLocPage.dart';
import 'package:tg_proj/auth.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final _router = GoRouter(
    initialLocation: '/auth',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: '/auth',
        builder: (context, state) => const WidgetTree(),
      )
    ],
  );

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp.router(
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: buildMaterialColor(const Color(0xff725ac1)),
        primaryColor: buildMaterialColor(const Color(0xff725ac1)),
      ),
    );
  }
}
