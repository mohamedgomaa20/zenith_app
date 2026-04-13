import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../models/user_data_class.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> login(UserDataClass user) async {
    await _auth.signInWithEmailAndPassword(
      email: user.email.trim(),
      password: user.password.trim(),
    );
  }

  Future<void> register(UserDataClass user) async {
    await _auth.createUserWithEmailAndPassword(
      email: user.email.trim(),
      password: user.password.trim(),
    );
  }

  Future<void> forgotPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email.trim());
  }

  Future<void> loginWithGoogle() async {
    await GoogleSignIn.instance.initialize(
      serverClientId:
          '127376482692-d3bbvmud3o6k9k9vqbjdfvj9vtp6uai7.apps.googleusercontent.com',
    );

    final GoogleSignInAccount googleUser = await GoogleSignIn.instance
        .authenticate();

    final GoogleSignInAuthentication googleAuth = googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
    );

    await _auth.signInWithCredential(credential);
  }

  Future<void> logout() async {
    await _auth.signOut();
  }
}
