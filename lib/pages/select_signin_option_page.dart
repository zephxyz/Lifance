import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lifance/misc/auth.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SelectSignInOptionPage extends StatefulWidget {
  const SelectSignInOptionPage({super.key});

  @override
  State<SelectSignInOptionPage> createState() => _SelectSignInOptionPageState();
}

class _SelectSignInOptionPageState extends State<SelectSignInOptionPage> {
  void goToGetPermPage() {
    context.go("/getperm");
  }

  String? errorMessage = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Sign in')),
        body: 
           Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                alignment: Alignment.topCenter,
                child: SvgPicture.asset(
                      'assets/img/logo_koso1.svg',
                      height: 200,
                      width: 200,
                    ),
              ),
              const SizedBox(height: 48,),
              Center(
                child: SignInButton(Buttons.Email,
                    onPressed: () => context.go('/auth/email')),
              ),
              Center(
                child: SignInButton(Buttons.GoogleDark, onPressed: () async {
                  try {
                    if (await Auth.instance.signInViaGoogle()) {
                      goToGetPermPage();
                    }
                  } on FirebaseAuthException catch (e) {
                    setState(() {
                      errorMessage = e.message;
                    });
                  }
                }),
              ),
              const SizedBox(
                height: 8,
              ),
              Center(child: Text(errorMessage ?? "", style: const TextStyle(fontSize: 16),)),
            ],
          ),
        );
  }
}
