import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../models/user_data_class.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> _ensureUserExists(User user, {String? name}) async {
    final userDoc = _db.collection('users').doc(user.uid);
    final doc = await userDoc.get();

    if (!doc.exists) {
      await userDoc.set({
        'userId': user.uid,
        'name': name ?? user.displayName ?? 'User',
        'email': user.email,
        'photoUrl': user.photoURL,
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
  }

  Future<void> login(UserDataClass user) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: user.email.trim(),
      password: user.password.trim(),
    );
    await _ensureUserExists(credential.user!);
  }

  Future<void> register(UserDataClass user) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: user.email.trim(),
      password: user.password.trim(),
    );
    if (user.name != null) {
      await credential.user!.updateDisplayName(user.name);
    }
    await _ensureUserExists(credential.user!, name: user.name);
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

    final UserCredential userCredential = await _auth.signInWithCredential(
      credential,
    );
    await _ensureUserExists(userCredential.user!);
  }

  Future<void> logout() async {
    await _auth.signOut();
  }
}
