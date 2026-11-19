import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_app/core/constants/api_urls.dart';
import 'package:flutter_app/core/constants/texts.dart';
import 'package:flutter_app/core/utils/user%20data%20storing/user_data_storing.dart';
import 'package:http/http.dart' as http;

/// Sends the provider identity to the app API and persists its app session.
class UserLoginService {
  Future<void> loginWithGmail({
    required String gmail,
    String? name,
    String? photoUrl,
  }) async {
    await _login(
      fields: {
        'gmail': gmail.trim(),
        if (name != null && name.trim().isNotEmpty) 'name': name.trim(),
        'auth_type': 'GMAIL',
      },
      fallbackImageUrl: photoUrl,
    );
  }

  Future<void> loginWithFacebook({required String facebookId}) async {
    await _login(fields: {'facebook_id': facebookId, 'auth_type': 'FACEBOOK'});
  }

  Future<void> _login({
    required Map<String, String> fields,
    String? fallbackImageUrl,
  }) async {
    final authType = fields['auth_type'];
    final request = http.MultipartRequest('POST', Uri.parse(APIsurls.userLogin))
      ..fields.addAll(fields);

    if (fallbackImageUrl != null && fallbackImageUrl.trim().isNotEmpty) {
      final imageUrl = fallbackImageUrl.trim();
      // Some saveuser implementations persist the provider URL directly,
      // while ImageField-based implementations consume the multipart file.
      request.fields['image_url'] = imageUrl;
      await _attachProfileImage(request, imageUrl, authType);
    } else {
      debugPrint('[social login API] $authType has no provider photo URL.');
    }

    debugPrint('[social login API] Sending $authType request.');
    final streamedResponse = await request.send().timeout(
      const Duration(seconds: 30),
    );
    final response = await http.Response.fromStream(streamedResponse);
    debugPrint(
      '[social login API] $authType response status: ${response.statusCode}.',
    );

    Map<String, dynamic> body;
    try {
      final decoded = jsonDecode(response.body);
      if (decoded is! Map<String, dynamic>) {
        throw const FormatException('Unexpected login response.');
      }
      body = decoded;
    } on FormatException {
      throw Exception(CustomStrings.loginResponseInvalid);
    }

    final success = body['success'];
    if (response.statusCode < 200 ||
        response.statusCode >= 300 ||
        success == false) {
      final message = body['message']?.toString();
      debugPrint('[social login API] $authType request was rejected.');
      throw Exception(
        message?.isNotEmpty == true ? message! : CustomStrings.loginTryAgain,
      );
    }

    final data = _asMap(body['data']);
    final account = _asMap(data['account_information']);
    final personal = _asMap(data['personal_information']);
    final profile = _asMap(account['Profile'] ?? account['profile']);

    final accessToken = _firstString([
      body['access_token'],
      body['token'],
      data['access_token'],
      data['token'],
    ]);
    if (accessToken == null) {
      throw Exception(CustomStrings.loginResponseMissingToken);
    }

    final token = _firstString([body['token'], data['token']]) ?? accessToken;
    final sessionToken = _firstString([
      body['session_token'],
      data['session_token'],
    ]);

    await TokenStorage.saveToken(token);
    await TokenStorage.saveAccessToken(accessToken);
    if (sessionToken != null) {
      await TokenStorage.saveSessionToken(sessionToken);
    }

    final name = _firstString([personal['name'], account['name']]);
    final email = _firstString([account['gmail'], fields['gmail']]);
    final image = _firstString([
      profile['image'],
      profile['image_url'],
      fallbackImageUrl,
    ]);
    final initials = _firstString([profile['initials']]);
    final role = _firstString([account['role']]);

    if (name != null) await TokenStorage.saveUserName(name);
    if (email != null) await TokenStorage.saveUserEmail(email);
    if (image != null) await TokenStorage.saveUserPhoto(image);
    if (initials != null) await TokenStorage.saveUserInitials(initials);
    if (role != null) await TokenStorage.saveUserRole(role);
    await TokenStorage.saveIsLoggedIn(true);
    debugPrint('[social login API] $authType login data saved securely.');
  }

  Future<void> _attachProfileImage(
    http.MultipartRequest request,
    String imageUrl,
    String? authType,
  ) async {
    try {
      final imageResponse = await http
          .get(Uri.parse(imageUrl))
          .timeout(const Duration(seconds: 15));
      if (imageResponse.statusCode < 200 ||
          imageResponse.statusCode >= 300 ||
          imageResponse.bodyBytes.isEmpty) {
        debugPrint(
          '[social login API] $authType profile image could not be downloaded.',
        );
        return;
      }

      final imageBytes = imageResponse.bodyBytes;
      request.files
        ..add(
          http.MultipartFile.fromBytes(
            'Profile',
            imageBytes,
            filename: 'google_profile.jpg',
          ),
        )
        ..add(
          http.MultipartFile.fromBytes(
            'image',
            imageBytes,
            filename: 'google_profile.jpg',
          ),
        );
      debugPrint(
        '[social login API] $authType profile image attached as Profile and image.',
      );
    } catch (error) {
      // A missing provider avatar should not prevent account sign-in.
      debugPrint(
        '[social login API] $authType profile image unavailable: $error',
      );
    }
  }

  Map<String, dynamic> _asMap(dynamic value) =>
      value is Map<String, dynamic> ? value : const {};

  String? _firstString(List<dynamic> values) {
    for (final value in values) {
      if (value is String && value.trim().isNotEmpty) return value.trim();
    }
    return null;
  }
}

// User logged out
class UserLogoutService {
  Future<void> logout() async {
    final token = await TokenStorage.getToken();

    if (token == null || token.isEmpty) {
      // No token locally, just clear session.
      await TokenStorage.clearAll();
      return;
    }

    debugPrint('[logout] Calling logout API...');

    final response = await http
        .post(
          Uri.parse(APIsurls.userLogout),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        )
        .timeout(const Duration(seconds: 30));

    debugPrint('[logout] Status: ${response.statusCode}');
    debugPrint('[logout] Response: ${response.body}');

    Map<String, dynamic> body = {};

    try {
      final decoded = jsonDecode(response.body);
      if (decoded is Map<String, dynamic>) {
        body = decoded;
      }
    } catch (_) {
      debugPrint('[logout] Invalid JSON response');
    }

    final isSuccess =
        response.statusCode >= 200 &&
        response.statusCode < 300 &&
        (body['code'] == 1 || body['status'] == 200);

    if (!isSuccess) {
      final message = body['message']?.toString();

      throw Exception(
        message?.isNotEmpty == true
            ? message!
            : CustomStrings.somethingWentWrong,
      );
    }

    debugPrint('[logout] Logout API successful.');

    // Clear local session only after API success.
    await TokenStorage.clearAll();
    debugPrint('[logout] Local session cleared.');
  }
}
