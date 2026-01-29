import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:jagoentertainment/src/core/base/base_remote_datasource.dart';
import 'package:jagoentertainment/src/models/auth/register_params.dart';
import 'package:jagoentertainment/src/models/auth/user_data.dart';

class FirebaseAuthRemoteDatasource extends BaseRemoteDatasource {
  static FirebaseAuthRemoteDatasource get to => Get.find();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Register a user in Firebase Auth & Firestore
  Future<UserData> registerUser(RegisterParams params) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: params.email,
        password: params.password,
      );
      final firebaseUser = userCredential.user!;
      logger.d("Firebase user created: ${firebaseUser.uid}");

      final docRef = _firestore.collection('users').doc(firebaseUser.uid);
      await docRef.set({
        'name': params.name,
        'phone': params.phone,
        'date_of_birth': params.dateOfBirth?.toIso8601String(),
        'gender': params.gender,
        'country': params.country,
        'language': params.language,
        'avatar_url': '',
        'last_login_at': DateTime.now().toIso8601String(),
      });

      logger.d("User data stored in Firestore for UID: ${firebaseUser.uid}");

      return UserData(
        id: firebaseUser.uid.hashCode,
        name: params.name,
        email: params.email,
        phone: params.phone,
        dateOfBirth: params.dateOfBirth,
        gender: params.gender,
        country: params.country,
        language: params.language,
        isActive: true,
        subscriptionStatus: "",
        lastLoginAt: DateTime.now(),
        lastLoginIp: "",
        avatarUrl: '',
      );
    } catch (e) {
      logger.e("Firebase register error: $e");
      rethrow;
    }
  }

  /// Login a user
  Future<UserData> loginUser(String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final firebaseUser = userCredential.user!;
      logger.d("Firebase user logged in: ${firebaseUser.uid}");

      final doc = await _firestore.collection('users').doc(firebaseUser.uid).get();
      if (!doc.exists) throw Exception("User data not found in Firestore");

      final data = doc.data()!;
      return UserData(
        id: firebaseUser.uid.hashCode,
        name: data['name'] ?? '',
        email: firebaseUser.email ?? '',
        phone: data['phone'] ?? '',
        dateOfBirth: data['date_of_birth'] != null
            ? DateTime.tryParse(data['date_of_birth'])
            : null,
        gender: data['gender'] ?? '',
        country: data['country'] ?? '',
        language: data['language'] ?? '',
        isActive: true,
        subscriptionStatus: "",
        lastLoginAt: DateTime.now(),
        lastLoginIp: '',
        avatarUrl: data['avatar_url'],
      );
    } catch (e) {
      logger.e("Firebase login error: $e");
      rethrow;
    }
  }

  /// Send password reset email
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      logger.d("Password reset email sent to $email");
    } catch (e) {
      logger.e("Firebase reset password error: $e");
      rethrow;
    }
  }

  /// Logout
  Future<void> logout() async {
    try {
      await _auth.signOut();
      logger.d("Firebase user signed out");
    } catch (e) {
      logger.e("Firebase logout error: $e");
      rethrow;
    }
  }
}
