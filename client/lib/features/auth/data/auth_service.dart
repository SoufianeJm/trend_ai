import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Verifies the phone number and sends OTP
  Future<void> verifyPhoneNumber({
    required String phoneNumber,
    required Function(String verificationId) onCodeSent,
    required Function(FirebaseAuthException error) onFailed,
  }) async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          try {
            await _auth.signInWithCredential(credential);
          } catch (e) {
            if (e is FirebaseAuthException) {
              onFailed(e);
            }
          }
        },
        verificationFailed: (FirebaseAuthException error) {
          onFailed(error);
        },
        codeSent: (String verificationId, int? resendToken) {
          onCodeSent(verificationId);
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
        timeout: const Duration(seconds: 60),
      );
    } catch (e) {
      if (e is FirebaseAuthException) {
        onFailed(e);
      } else {
        onFailed(FirebaseAuthException(
          code: 'unknown',
          message: 'An unknown error occurred',
        ));
      }
    }
  }

  /// Signs in the user with OTP
  Future<UserCredential> signInWithOtp({
    required String verificationId,
    required String smsCode,
  }) async {
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );

      return await _auth.signInWithCredential(credential);
    } catch (e) {
      if (e is FirebaseAuthException) {
        rethrow;
      }
      throw FirebaseAuthException(
        code: 'unknown',
        message: 'An unknown error occurred during sign in',
      );
    }
  }

  /// Saves user data to Firestore
  Future<void> saveUserData({
    required String uid,
    required String firstName,
    required String lastName,
    required String phoneNumber,
    required String password,
  }) async {
    try {
      await _firestore.collection('users').doc(uid).set({
        'firstName': firstName,
        'lastName': lastName,
        'phoneNumber': phoneNumber,
        'password': password, // ✅ Password included
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw FirebaseException(
        plugin: 'firestore',
        message: 'Failed to save user data',
      );
    }
  }

  /// Signs out the current user
  Future<void> signOut() async {
    await _auth.signOut();
  }

  /// Gets the current user
  User? get currentUser => _auth.currentUser;
}
