import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  static const _storage = FlutterSecureStorage();
  static const _installationChannel = MethodChannel('flutter_app/installation');

  // ============================================================
  // STORAGE KEYS
  // ============================================================

  static const _tokenKey = 'token';
  static const _accessTokenKey = 'access_token';
  static const _sessionTokenKey = 'session_token';

  static const _userNameKey = 'name';
  static const _userEmailKey = 'gmail';
  static const _userPhotoKey = 'image';
  static const _userInitialsKey = 'initials';
  static const _userRoleKey = 'role';

  static const _wordOfGodLanguageIdKey = 'wordOfGodLanguageId';
  static const _wordOfGodLanguageCodeKey = 'wordOfGodLanguageCode';
  static const _wordOfGodLanguageNameKey = 'wordOfGodLanguageName';
  static const _appLanguageCodeKey = 'appLanguageCode';
  static const _appLanguageNameKey = 'appLanguageName';

  static const _isLoggedInKey = 'isLoggedIn';

  // ============================================================
  // SAVE TOKENS
  // ============================================================

  static Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  static Future<void> saveAccessToken(String token) async {
    await _storage.write(key: _accessTokenKey, value: token);
  }

  static Future<void> saveSessionToken(String sessionToken) async {
    await _storage.write(key: _sessionTokenKey, value: sessionToken);
  }

  // ============================================================
  // GET TOKENS
  // ============================================================

  static Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  static Future<String?> getAccessToken() async {
    return await _storage.read(key: _accessTokenKey);
  }

  static Future<String?> getSessionToken() async {
    return await _storage.read(key: _sessionTokenKey);
  }

  // ============================================================
  // DELETE TOKENS
  // ============================================================

  static Future<void> deleteToken() async {
    await _storage.delete(key: _tokenKey);
  }

  static Future<void> deleteAccessToken() async {
    await _storage.delete(key: _accessTokenKey);
  }

  static Future<void> deleteSessionToken() async {
    await _storage.delete(key: _sessionTokenKey);
  }

  // ============================================================
  // SAVE USER NAME
  // ============================================================

  static Future<void> saveUserName(String name) async {
    await _storage.write(key: _userNameKey, value: name);
  }

  // ============================================================
  // GET USER NAME
  // ============================================================

  static Future<String?> getUserName() async {
    return await _storage.read(key: _userNameKey);
  }

  // ============================================================
  // SAVE USER EMAIL
  // ============================================================

  static Future<void> saveUserEmail(String email) async {
    await _storage.write(key: _userEmailKey, value: email);
  }

  // ============================================================
  // GET USER EMAIL
  // ============================================================

  static Future<String?> getUserEmail() async {
    return await _storage.read(key: _userEmailKey);
  }

  // ============================================================
  // SAVE USER PHOTO
  // ============================================================

  static Future<void> saveUserPhoto(String photoUrl) async {
    await _storage.write(key: _userPhotoKey, value: photoUrl);
  }

  // ============================================================
  // GET USER PHOTO
  // ============================================================

  static Future<String?> getUserPhoto() async {
    return await _storage.read(key: _userPhotoKey);
  }

  // ============================================================
  // SAVE USER INITIALS
  // ============================================================

  static Future<void> saveUserInitials(String initials) async {
    await _storage.write(key: _userInitialsKey, value: initials);
  }

  // ============================================================
  // GET USER INITIALS
  // ============================================================

  static Future<String?> getUserInitials() async {
    return await _storage.read(key: _userInitialsKey);
  }

  // ============================================================
  // SAVE USER ROLE
  // ============================================================

  static Future<void> saveUserRole(String role) async {
    await _storage.write(key: _userRoleKey, value: role);
  }

  // ============================================================
  // GET USER ROLE
  // ============================================================

  static Future<String?> getUserRole() async {
    return await _storage.read(key: _userRoleKey);
  }

  static Future<void> saveWordOfGodLanguage({
    required int id,
    required String code,
    required String name,
  }) async {
    await _storage.write(key: _wordOfGodLanguageIdKey, value: id.toString());
    await _storage.write(key: _wordOfGodLanguageCodeKey, value: code);
    await _storage.write(key: _wordOfGodLanguageNameKey, value: name);
  }

  static Future<int?> getWordOfGodLanguageId() async {
    final value = await _storage.read(key: _wordOfGodLanguageIdKey);
    return value == null ? null : int.tryParse(value);
  }

  static Future<String?> getWordOfGodLanguageCode() async {
    return await _storage.read(key: _wordOfGodLanguageCodeKey);
  }

  static Future<String?> getWordOfGodLanguageName() async {
    return await _storage.read(key: _wordOfGodLanguageNameKey);
  }

  static Future<void> saveAppLanguage({
    required String code,
    required String name,
  }) async {
    await _storage.write(key: _appLanguageCodeKey, value: code);
    await _storage.write(key: _appLanguageNameKey, value: name);
  }

  static Future<String?> getAppLanguageCode() async {
    return await _storage.read(key: _appLanguageCodeKey);
  }

  static Future<String?> getAppLanguageName() async {
    return await _storage.read(key: _appLanguageNameKey);
  }

  // ============================================================
  // SAVE LOGIN STATUS
  // ============================================================

  static Future<void> saveIsLoggedIn(bool isLoggedIn) async {
    await _storage.write(key: _isLoggedInKey, value: isLoggedIn.toString());
  }

  // ============================================================
  // GET LOGIN STATUS
  // ============================================================

  static Future<bool> getIsLoggedIn() async {
    final value = await _storage.read(key: _isLoggedInKey);

    return value == 'true';
  }

  // ============================================================
  // CLEAR ALL USER DATA
  // ============================================================

  static Future<void> clearAll() async {
    await _storage.deleteAll();
  }

  /// iOS Keychain values can survive uninstalling the app. UserDefaults does
  /// not, so use a native first-launch marker to clear any stale session.
  /// Android is handled by disabling app backup in AndroidManifest.xml.
  static Future<void> clearUserSessionOnFreshInstall() async {
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.iOS) return;

    final isFreshInstall =
        await _installationChannel.invokeMethod<bool>('isFreshInstall') ??
        false;
    if (!isFreshInstall) return;

    await Future.wait([
      _storage.delete(key: _tokenKey),
      _storage.delete(key: _accessTokenKey),
      _storage.delete(key: _sessionTokenKey),
      _storage.delete(key: _userNameKey),
      _storage.delete(key: _userEmailKey),
      _storage.delete(key: _userPhotoKey),
      _storage.delete(key: _userInitialsKey),
      _storage.delete(key: _userRoleKey),
      _storage.delete(key: _isLoggedInKey),
    ]);
  }
}
