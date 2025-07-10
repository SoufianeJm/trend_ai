import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;

class AppwriteUserService {
  final Account _account;

  AppwriteUserService(Client client) : _account = Account(client);

  /// Fetches the current Appwrite user. Returns null if not authenticated.
  Future<models.User?> getCurrentUser() async {
    try {
      return await _account.get();
    } catch (_) {
      return null;
    }
  }
} 