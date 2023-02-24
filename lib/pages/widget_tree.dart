import 'package:flutter/material.dart';
import 'package:tg_proj/auth.dart';
import 'package:tg_proj/pages/getLocPage.dart';
import 'package:tg_proj/pages/home_page.dart';
import 'package:tg_proj/pages/login_register_page.dart';

class WidgetTree extends StatelessWidget {
  const WidgetTree({super.key});
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Auth.instance.authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (Auth.instance.isEmailVerified()) {
            return const GetPermissionPage();
          }
        }
        return const LoginPage();
      },
    );
  }
}
// no new stuff here