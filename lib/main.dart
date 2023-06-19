import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:lifance/misc/color_to_material_color.dart';
import 'package:flutter/services.dart';
import 'package:lifance/misc/router.dart';
import 'package:lifance/misc/geolocation.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Geolocation.instance.getPermission();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp.router(
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: buildMaterialColor(const Color(0xff725ac1)),
        primaryColor: buildMaterialColor(const Color(0xff725ac1)),
    
      ),
    );
  }
}
