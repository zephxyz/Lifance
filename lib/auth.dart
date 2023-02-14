import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User? get currentUser => _firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    if (!isEmailVerified()) {
      await signOut();
      throw FirebaseAuthException(
          code: 'auth/notverified',
          message:
              'Email verification is required to access the app. Verify your email.');
    }
  }

  Future<void> createUserWithEmailAndPassword({
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    if (password != confirmPassword) {
      throw FirebaseAuthException(
          message: "Passwords do not match.", code: "auth/conferr");
    }
    await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    await sendVerificationEmail();
    await signOut();
    throw FirebaseAuthException(
        message:
            "An email has been sent to your inbox. Verify it to access the app.",
        code: "auth/verifyreg");
  }

  bool isEmailVerified() {
    User? user = _firebaseAuth.currentUser;
    if (user != null) {
      user.reload();
      return user.emailVerified;
    }
    return false;
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<void> sendVerificationEmail() async {
    User? user = _firebaseAuth.currentUser;
    if (user != null) {
      await user.sendEmailVerification();
    }
  }
}
