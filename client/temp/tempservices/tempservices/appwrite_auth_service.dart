import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;
import 'package:client/services/appwrite_client.dart';
import 'dart:convert';

class AppwriteAuthService {
  final Account account = AppwriteClient.account;
  final Functions functions = Functions(AppwriteClient.client);
  models.User? loggedInUser;

  /// Sends an OTP (magic link) to the given email. Returns the userId for use in verification.
  Future<String> sendEmailOtp(String email) async {
    try {
      final response = await account.createEmailToken(
        userId: ID.unique(),
        email: email,
      );
      return response.userId;
    } catch (e) {
      throw Exception('Failed to send OTP: $e');
    }
  }

  /// Verifies the OTP using userId and secret (code from email). Logs in the user if successful.
  Future<void> verifyEmailOtp({
    required String userId,
    required String secret,
  }) async {
    try {
      await account.createSession(
        userId: userId,
        secret: secret,
      );
      loggedInUser = await account.get();
    } catch (e) {
      throw Exception('Failed to verify OTP: $e');
    }
  }

  /// Creates a user account with email, password, and stores full name.
  Future<void> createAccount({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  }) async {
    try {
      final fullName = '$firstName $lastName';

      await account.create(
        userId: ID.unique(),
        email: email,
        password: password,
        name: fullName,
      );

      // Optional: log in after creation
      await login(email, password);
    } catch (e) {
      throw Exception('Failed to create account: $e');
    }
  }

  /// Calls Appwrite cloud function to check if email exists.
  Future<bool> checkEmailExists(String email) async {
    try {
      final result = await functions.createExecution(
        functionId: '683b5726001907c7d55f', // Replace with your function ID
        body: jsonEncode({'email': email}),
      );

      final responseData = jsonDecode(result.stdout);
      return responseData['exists'] == true;
    } catch (e) {
      print('Cloud function error: $e');
      return false;
    }
  }

  /// Sends Appwrite's built-in email verification (currently unused)
  Future<void> createEmailVerification(String email) async {
    try {
      await account.createVerification(
        url: 'trendai://auth/verify',
      );
    } catch (e) {
      throw Exception('Failed to send verification email: $e');
    }
  }

  /// Verifies Appwrite email verification (currently unused)
  Future<void> verifyEmail(String userId, String secret) async {
    try {
      await account.updateVerification(
        userId: userId,
        secret: secret,
      );
    } catch (e) {
      throw Exception('Failed to verify email: $e');
    }
  }

  /// Logs in with email + password
  Future<void> login(String email, String password) async {
    try {
      await account.createEmailPasswordSession(
        email: email,
        password: password,
      );
      loggedInUser = await account.get();
    } catch (e) {
      throw Exception('Failed to sign in: $e');
    }
  }

  /// Logs out the current user
  Future<void> logout() async {
    try {
      await account.deleteSession(sessionId: 'current');
      loggedInUser = null;
    } catch (e) {
      throw Exception('Failed to logout: $e');
    }
  }
}
