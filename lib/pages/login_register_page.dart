import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../misc/auth.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? errorMessage = '';
  bool isLogin = true;

  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final TextEditingController _controllerConfirmPassword =
      TextEditingController();

  Future<void> signInWithEmailAndPassword() async {
    _controllerEmail.text = _controllerEmail.text.trim();
    _controllerPassword.text = _controllerPassword.text.trim();
    try {
      await Auth.instance.signInWithEmailAndPassword(
          email: _controllerEmail.text, password: _controllerPassword.text);
      goToGetPermPage();
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  void goToGetPermPage() {
    context.go('/getperm');
  }

  Future<void> createUserWithEmailAndPassword() async {
    _controllerEmail.text = _controllerEmail.text.trim();
    _controllerPassword.text = _controllerPassword.text.trim();
    _controllerConfirmPassword.text = _controllerConfirmPassword.text.trim();
    try {
      await Auth.instance.createUserWithEmailAndPassword(
          email: _controllerEmail.text,
          password: _controllerPassword.text,
          confirmPassword: _controllerConfirmPassword.text);
    } on FirebaseAuthException catch (e) {
      setState(() {
        if (e.code == 'auth/verifyreg') {
          isLogin = !isLogin;
        }
        errorMessage = e.message;
        errorMessage = e.message == 'Given String is empty or null'
            ? 'Email or password field empty'
            : errorMessage;
        _controllerPassword.text = '';
        _controllerConfirmPassword.text = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: IconButton(
            onPressed: () => context.go('/auth'),
            icon: const Icon(Icons.arrow_back, color: Colors.white),
          ),
        ),
        body: Form(
            child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(children: [
            Container(
                alignment: Alignment.topCenter,
                padding: const EdgeInsets.all(10),
                child: SvgPicture.asset(
                  'assets/img/logo_koso1.svg',
                  height: 200,
                  width: 200,
                )),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  "Sign in with email",
                  style: TextStyle(fontSize: 24),
                ),
                const SizedBox(height: 8,),
                TextFormField(
                  controller: _controllerEmail,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                  ),
                  obscureText: false,
                ),
                TextFormField(
                  controller: _controllerPassword,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                  ),
                  obscureText: true,
                ),
                isLogin
                    ? Container()
                    : TextFormField(
                        controller: _controllerConfirmPassword,
                        decoration: const InputDecoration(
                          labelText: 'Confirm password',
                        ),
                        obscureText: true,
                      ),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: Text(errorMessage == '' ? '' : '$errorMessage'),
                ),
                ElevatedButton(
                  onPressed: isLogin
                      ? signInWithEmailAndPassword
                      : createUserWithEmailAndPassword,
                  child: Text(isLogin ? 'Login' : 'Register'),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      isLogin = !isLogin;
                    });
                  },
                  child: Text(isLogin ? 'Sign Up instead' : 'Sign In instead'),
                ),
              ],
            )
          ]),
        )));
  }
}
