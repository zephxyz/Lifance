
import 'package:flutter/material.dart';
import 'package:tg_auth/pages/widget_tree.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tg_auth/misc/color_to_material_color.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: buildMaterialColor(const Color(0xff725ac1)),
      ),
      home: const WidgetTree()
      
    );
  }
}