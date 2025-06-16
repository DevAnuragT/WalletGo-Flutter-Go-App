import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  bool isLoading = false;
  String? _verificationId;

  final String backendUrl = "http://localhost:8080"; // update in prod

  String uid = '';
  String name = '';
  String email = '';
  String phone = '';

  // 🔹 GET CURRENT USER
  User? get currentUser => _auth.currentUser;
  // 🔹 GET VERIFICATION ID
  String? get verificationId => _verificationId;
  // 🔹 IS USER LOGGED IN
  bool get isLoggedIn => _auth.currentUser != null;
  // 🔹 IS LOADING
  bool get isLoadingState => isLoading;
  
  // 🔹 USER DATA MAP
  Map<String, String> get userData => {
    'uid': uid.isNotEmpty ? uid : 'Not logged in',
    'name': name.isNotEmpty ? name : 'Guest',
    'email': email.isNotEmpty ? email : 'Not provided',
    'phone': phone.isNotEmpty ? phone : 'Not set',
  };

  // 🔹 GOOGLE SIGN-IN
  Future<bool> signInWithGoogle() async {
    try {
      isLoading = true;
      notifyListeners();

      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        isLoading = false;
        notifyListeners();
        return false;
      }

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCred = await _auth.signInWithCredential(credential);
      final user = userCred.user;

      uid = user?.uid ?? '';
      name = user?.displayName ?? '';
      email = user?.email ?? '';

      isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // 🔹 CHECK BACKEND FOR USER
  Future<bool> checkUserExistsInBackend() async {
    try {
      final res = await http.get(Uri.parse('$backendUrl/users/exists?uid=$uid'));
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        return data['exists'] ?? false;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  // 🔹 OTP SENDER
  void sendOtp(String phone) async {
    isLoading = true;
    notifyListeners();

    await _auth.verifyPhoneNumber(
      phoneNumber: '+91$phone',
      verificationCompleted: (_) {},
      verificationFailed: (e) {
        isLoading = false;
        notifyListeners();
      },
      codeSent: (verificationId, _) {
        _verificationId = verificationId;
        isLoading = false;
        notifyListeners();
      },
      codeAutoRetrievalTimeout: (verificationId) {
        _verificationId = verificationId;
      },
    );
  }

  // 🔹 VERIFY OTP
  Future<bool> verifyOtp(String phone, String otp, bool isLogin) async {
    if (_verificationId == null) return false;

    isLoading = true;
    notifyListeners();

    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: otp,
      );

      final userCred = await _auth.signInWithCredential(credential);
      this.phone = phone;
      uid = userCred.user?.uid ?? '';

      if (!isLogin) {
        final success = await _registerUser(phone);
        if (!success) {
          isLoading = false;
          notifyListeners();
          return false;
        }
      }

      isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // 🔹 REGISTER NEW USER TO BACKEND
  Future<bool> _registerUser(String phone) async {
    try {
      final res = await http.post(
        Uri.parse('$backendUrl/users/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'uid': uid,
          'name': name,
          'email': email,
          'phone': phone,
        }),
      );

      return res.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
  // 🔹 LOGOUT
  Future<void> logout() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
    uid = '';
    name = '';
    email = '';
    phone = '';
    _verificationId = null;
    isLoading = false;
    notifyListeners();
  }
  
}
