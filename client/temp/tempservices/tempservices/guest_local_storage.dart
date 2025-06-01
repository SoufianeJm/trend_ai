import 'package:hive_flutter/hive_flutter.dart';

class GuestLocalStorage {
  static const String _boxName = 'guest';
  static const String _usernameKey = 'username';
  static const String _avatarUrlKey = 'avatarUrl';

  late final Box<String> _box;

  GuestLocalStorage() {
    _box = Hive.box<String>(_boxName);
  }

  Future<void> saveGuestData({
    required String username,
    required String avatarUrl,
  }) async {
    await _box.put(_usernameKey, username);
    await _box.put(_avatarUrlKey, avatarUrl);
  }

  String? get username => _box.get(_usernameKey);
  String? get avatarUrl => _box.get(_avatarUrlKey);

  bool get hasData => username != null && avatarUrl != null;

  Future<void> clear() async {
    await _box.clear();
  }
} 