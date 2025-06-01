// SupabaseAuthService is deprecated and should be removed.
import 'package:flutter/foundation.dart';

class SupabaseAuthService {
  final _supabase = Supabase.instance.client;

  Future<bool> checkEmailExists(String email) async {
    try {
      debugPrint('🔍 Checking if email exists: $email');
      await _supabase.auth.signInWithOtp(
        email: email,
        shouldCreateUser: false,
      );
      debugPrint('✅ Email exists');
      return true;
    } catch (e) {
      if (e.toString().contains('Email not confirmed')) {
        debugPrint('✅ Email exists but not confirmed');
        return true;
      }
      debugPrint('❌ Email does not exist: $e');
      return false;
    }
  }

  Future<void> sendSignUpOtp(String email) async {
    try {
      debugPrint('📧 Sending sign up OTP to: $email');
      // Send OTP without creating user
      await _supabase.auth.signInWithOtp(
        email: email,
        shouldCreateUser: false,
      );
      debugPrint('✅ Sign up OTP sent successfully');
    } catch (e) {
      debugPrint('❌ Failed to send sign up OTP: $e');
      rethrow;
    }
  }

  Future<void> verifyOtp({
    required String email,
    required String otp,
  }) async {
    try {
      debugPrint('🔐 Verifying OTP for: $email');
      await _supabase.auth.verifyOTP(
        email: email,
        token: otp,
        type: OtpType.signup,
      );
      debugPrint('✅ OTP verified successfully');
    } catch (e) {
      debugPrint('❌ OTP verification failed: $e');
      rethrow;
    }
  }

  Future<AuthResponse> createPassword({
    required String email,
    required String password,
  }) async {
    try {
      debugPrint('🔑 Creating password for: $email');
      
      // Create user with email and password
      debugPrint('👤 Creating user account');
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
      );
      debugPrint('✅ User account created successfully');

      return response;
    } catch (e) {
      debugPrint('❌ Password creation failed: $e');
      rethrow;
    }
  }

  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    try {
      debugPrint('🔑 Signing in: $email');
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      debugPrint('✅ Sign in successful');
      return response;
    } catch (e) {
      debugPrint('❌ Sign in failed: $e');
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      debugPrint('🚪 Signing out');
      await _supabase.auth.signOut();
      debugPrint('✅ Sign out successful');
    } catch (e) {
      debugPrint('❌ Sign out failed: $e');
      rethrow;
    }
  }

  User? get currentUser => _supabase.auth.currentUser;
  
  Stream<AuthState> get authStateChanges => _supabase.auth.onAuthStateChange;
} 