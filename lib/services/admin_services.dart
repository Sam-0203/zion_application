import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_app/core/constants/api_urls.dart';
import 'package:flutter_app/core/utils/user%20data%20storing/user_data_storing.dart';
import 'package:flutter_app/models/user/admin_responses_model.dart';

class AdminLoginService {
  Future<AdminLoginResponse> adminLogin({
    required String username,
    required String password,
  }) async {
    try {
      // API REQUEST

      final response = await http.post(
        Uri.parse(APIsurls.adminLogin),

        headers: {"Content-Type": "application/json"},

        body: jsonEncode({"username": username, "password": password}),
      );

      // DECODE RESPONSE
      final Map<String, dynamic> decodedData = jsonDecode(response.body);

      // SUCCESS
      if (response.statusCode == 200) {
        final loginResponse = AdminLoginResponse.fromJson(decodedData);

        debugPrint("=================================");
        debugPrint("✅ ADMIN LOGIN SUCCESS");
        debugPrint("Status Code: ${response.statusCode}");
        debugPrint("Message: ${loginResponse.message}");
        debugPrint("=================================");

        // SAVE TOKENS
        await TokenStorage.saveToken(loginResponse.token);
        await TokenStorage.saveAccessToken(loginResponse.accessToken);

        // SAVE USER NAME
        await TokenStorage.saveUserName(
          loginResponse.data.personalInformation.name,
        );

        // SAVE USER EMAIL
        final gmail = loginResponse.data.accountInformation.gmail;

        if (gmail != null && gmail.isNotEmpty) {
          await TokenStorage.saveUserEmail(gmail);
        }

        // SAVE USER PHOTO
        await TokenStorage.saveUserPhoto(
          loginResponse.data.accountInformation.profile.image,
        );

        // SAVE USER INITIALS
        await TokenStorage.saveUserInitials(
          loginResponse.data.accountInformation.profile.initials,
        );

        // SAVE USER ROLE
        await TokenStorage.saveUserRole(
          loginResponse.data.accountInformation.role,
        );

        // SAVE LOGIN STATUS
        await TokenStorage.saveIsLoggedIn(true);

        // DEBUG
        debugPrint("✅ Token saved");
        debugPrint("✅ Access Token saved");
        debugPrint("✅ Session Token saved");
        debugPrint("✅ User Name saved");
        debugPrint("✅ Gmail saved");
        debugPrint("✅ Profile Image saved");
        debugPrint("✅ Initials saved");
        debugPrint("✅ Role saved");
        debugPrint("✅ Login Status saved");

        return loginResponse;
      }
      // LOGIN FAILED
      else {
        debugPrint("=================================");
        debugPrint("❌ ADMIN LOGIN FAILED");
        debugPrint("Status Code: ${response.statusCode}");
        debugPrint("Response: ${response.body}");
        debugPrint("=================================");

        return AdminLoginResponse.fromJson(decodedData);
      }
    }
    // EXCEPTION
    catch (e) {
      debugPrint("❌ Admin Login Error: $e");

      throw Exception("Admin Login Error : $e");
    }
  }
}
