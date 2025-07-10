import 'package:hive_flutter/hive_flutter.dart';
import 'package:client/core/services/username_service.dart';

class UserService {
  static const String _boxName = 'guest';
  static const String _usernameKey = 'username';
  static const String _hasContinuedAsGuestKey = 'hasContinuedAsGuest';

  static Box<String> get _box => Hive.box<String>(_boxName);

  /// Get or generate a username for the user
  static Future<String> getOrGenerateUsername() async {
    String? username = _box.get(_usernameKey);
    
    if (username == null) {
      username = UsernameService.generateFunUsername();
      await _box.put(_usernameKey, username);
    }
    
    return username;
  }

  /// Check if user has continued as guest
  static bool hasContinuedAsGuest() {
    return _box.get(_hasContinuedAsGuestKey) == 'true';
  }

  /// Mark user as having continued as guest
  static Future<void> markContinuedAsGuest() async {
    await _box.put(_hasContinuedAsGuestKey, 'true');
  }

  /// Get the current username (if exists)
  static String? getCurrentUsername() {
    return _box.get(_usernameKey);
  }

  /// Clear all user data
  static Future<void> clearUserData() async {
    await _box.clear();
  }
}
