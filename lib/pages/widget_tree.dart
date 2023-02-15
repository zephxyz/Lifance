import 'package:flutter/material.dart';
import 'package:tg_auth/auth.dart';
import 'package:tg_auth/pages/home_page.dart';
import 'package:tg_auth/pages/login_register_page.dart';


class WidgetTree extends StatelessWidget {
  const WidgetTree({super.key});
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Auth.instance.authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (Auth.instance.isEmailVerified()) {
            return const HomePage();
          } else {
            return const LoginPage();
          }
        } else {
          return const LoginPage();
        }
      },
    );
  }
}
