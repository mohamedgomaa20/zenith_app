import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_profile_model.dart';

class ProfileService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<UserProfileModel> getUserProfile() async {
    final user = _auth.currentUser;
    if (user == null) throw Exception("User not found");
    final doc = await _db.collection('users').doc(user.uid).get();
    return UserProfileModel.fromMap(doc.data()!, user.uid);
  }

  Future<void> updateUserData(String? name, String? photoUrl) async {
    final user = _auth.currentUser;
    if (name != null) {
      await user?.updateDisplayName(name);
      await _db.collection('users').doc(user!.uid).update({'name': name});
    }
    if (photoUrl != null) {
      await user?.updatePhotoURL(photoUrl);
      await _db.collection('users').doc(user!.uid).update({
        'photoUrl': photoUrl,
      });
    }
  }

  Future<void> updatePassword(String newPassword) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception("User not logged in");

    try {
      await user.updatePassword(newPassword);
    } on FirebaseAuthException catch (e) {
      throw e;
    }
  }

  Future<void> reAuthenticate(String oldPassword) async {
    final user = _auth.currentUser;
    if (user == null || user.email == null) throw Exception("User not found");

    AuthCredential credential = EmailAuthProvider.credential(
      email: user.email!,
      password: oldPassword,
    );

    await user.reauthenticateWithCredential(credential);
  }
}
