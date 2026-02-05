import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:jagoentertainment/src/core/constants/app_colors.dart';
import 'package:jagoentertainment/src/core/local/preferences/preference_manager.dart';
import 'package:jagoentertainment/src/core/local/preferences/preference_manager_impl.dart';
import 'package:jagoentertainment/src/models/auth/user_data.dart';

class AuthService extends GetxService {
  static AuthService get to => Get.find();

  final PreferenceManager _preferenceManager =
  Get.find<PreferenceManagerImpl>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  var isLoggedIn = false.obs;
  var userData = Rxn<UserData>();
  var isAuthReady = false.obs;

  String? accessToken;

  @override
  Future<void> onInit() async {
    super.onInit();
    await checkLoginStatus();
    if (isLoggedIn.value) {
      await loadUserProfile();
    }
    isAuthReady.value = true;
  }

  Future<void> checkLoginStatus() async {
    final token = await _preferenceManager.getString('token');
    if (token.isNotEmpty) {
      accessToken = token;
      isLoggedIn.value = true;
      await loadUserProfile();
    }
  }

  // ───────────────── SIGN UP ─────────────────
  Future<void> signupWithEmail({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = credential.user!.uid;

      await _firestore.collection('users').doc(uid).set({
        'name': name,
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      accessToken = uid;
      await _preferenceManager.setString('token', uid);
      isLoggedIn.value = true;

      await loadUserProfile();
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(
        msg: e.message ?? 'Signup failed',
        backgroundColor: AppColors.red500,
        textColor: AppColors.baseWhite,
      );
      rethrow;
    }
  }

  // ───────────────── LOGIN ─────────────────
  Future<void> loginWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = credential.user!.uid;

      accessToken = uid;
      await _preferenceManager.setString('token', uid);
      isLoggedIn.value = true;

      await loadUserProfile();
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(
        msg: e.message ?? 'Login failed',
        backgroundColor: AppColors.red500,
        textColor: AppColors.baseWhite,
      );
      rethrow;
    }
  }

  // ───────────────── RESET PASSWORD ─────────────────
  Future<void> resetPassword({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      Fluttertoast.showToast(
        msg: 'Password reset email sent',
        backgroundColor: AppColors.baseBlack,
        textColor: AppColors.baseWhite,
      );
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(
        msg: e.message ?? 'Failed to send reset email',
        backgroundColor: AppColors.red500,
        textColor: AppColors.baseWhite,
      );
      rethrow;
    }
  }

  // ───────────────── LOAD PROFILE ─────────────────
  Future<void> loadUserProfile() async {
    if (accessToken == null) return;

    try {
      final doc =
      await _firestore.collection('users').doc(accessToken).get();
      if (doc.exists) {
        final data = doc.data()!;
        userData.value = UserData(
          id: 0,
          name: data['name'] ?? '',
          email: data['email'] ?? '',
          phone: data['phone'] ?? '',
          dateOfBirth: null,
          gender: '',
          country: '',
          language: '',
          isActive: true,
          subscriptionStatus: '',
          lastLoginAt: null,
          lastLoginIp: null,
          avatarUrl: null,
        );
      }
    } catch (e) {
      print('Failed to load Firebase user profile: $e');
    }
  }

  // ───────────────── DELETE ACCOUNT (NEW) ─────────────────
  Future<void> deleteUserAccount({required String password}) async {
    final user = _auth.currentUser;

    if (user == null || user.email == null) {
      throw Exception('No authenticated user');
    }

    try {
      // Re-authentication (required by Firebase)
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: password,
      );

      await user.reauthenticateWithCredential(credential);

      // Delete Firestore user document
      await _firestore.collection('users').doc(user.uid).delete();

      // Delete Firebase Auth account
      await user.delete();

      // Clear local session
      await _preferenceManager.remove('token');
      accessToken = null;
      userData.value = null;
      isLoggedIn.value = false;

      Fluttertoast.showToast(
        msg: 'Account deleted successfully',
        backgroundColor: AppColors.baseBlack,
        textColor: AppColors.baseWhite,
      );
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(
        msg: e.message ?? 'Failed to delete account',
        backgroundColor: AppColors.red500,
        textColor: AppColors.baseWhite,
      );
      rethrow;
    }
  }

  // ───────────────── LOGOUT ─────────────────
  Future<void> logout() async {
    await _auth.signOut();
    accessToken = null;
    userData.value = null;
    isLoggedIn.value = false;
    await _preferenceManager.remove('token');
  }
}
