
  Future<void> Function(String verificationId)? onCodeSent;
  Future<void> Function(PhoneAuthCredential credential)? onVerificationCompleted;
  Future<void> Function(FirebaseAuthException e)? onVerificationFailed;
  Future<void> Function(String verificationId)? onCodeAutoRetrievalTimeout;

  // Start phone number verification
  Future<void> verifyPhoneNumber({
    required String phoneNumber,
    required Future<void> Function(String verificationId) onCodeSent,
    required Future<void> Function(PhoneAuthCredential credential) onVerificationCompleted,
    required Future<void> Function(FirebaseAuthException e) onVerificationFailed,
    required Future<void> Function(String verificationId) onCodeAutoRetrievalTimeout,
  }) async {
    this.onCodeSent = onCodeSent;
    this.onVerificationCompleted = onVerificationCompleted;
    this.onVerificationFailed = onVerificationFailed;
    this.onCodeAutoRetrievalTimeout = onCodeAutoRetrievalTimeout;

    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        if (onVerificationCompleted != null) {
          await onVerificationCompleted(credential);
        }
      },
      verificationFailed: (FirebaseAuthException e) async {
        if (onVerificationFailed != null) {
          await onVerificationFailed(e);
        }
      },
      codeSent: (String verificationId, int? resendToken) async {
        if (onCodeSent != null) {
          await onCodeSent(verificationId);
        }
      },
      codeAutoRetrievalTimeout: (String verificationId) async {
        if (onCodeAutoRetrievalTimeout != null) {
          await onCodeAutoRetrievalTimeout(verificationId);
        }
      },
      timeout: const Duration(seconds: 60),
    );
  }

  // Sign in with OTP
  Future<UserCredential> signInWithOtp({
    required String verificationId,
    required String otp,
  }) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otp,
      );

      return await _auth.signInWithCredential(credential);
    } catch (e) {
      throw FirebaseAuthException(
        code: 'invalid-otp',
        message: 'Invalid OTP provided',
      );
    }
  }

  // Store user data in Firestore
  Future<void> storeUserData({
    required String firstName,
    required String lastName,
    required String phone,
    required String password,
  }) async {
    try {
      final User? user = _auth.currentUser;
      if (user == null) throw Exception('No authenticated user found');

      await _firestore.collection('users').doc(user.uid).set({
        'uid': user.uid,
        'firstName': firstName,
        'lastName': lastName,
        'phone': phone,
        'password': password, // Note: In production, this should be hashed
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to store user data: $e');
    }
  }

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }
} 