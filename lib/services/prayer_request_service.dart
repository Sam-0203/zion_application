import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_app/core/constants/api_urls.dart';
import 'package:flutter_app/core/utils/user%20data%20storing/user_data_storing.dart';
import 'package:flutter_app/models/prayer%20request/prayer_word_model.dart';

import '../models/prayer request/prayer_request_detail_model.dart';
import '../models/prayer request/all_prayer_request_model.dart';

class PrayerAndWordOfGodAPIService {
  // Getting all PrayerRequestsAndGodVerseoftheday
  Future<PrayerRequestsAndGodVerseoftheday> getHomeData() async {
    try {
      String? token;

      try {
        token = await TokenStorage.getAccessToken();
      } catch (e) {
        debugPrint('Could not retrieve token: $e');
        token = null;
      }

      final headers = {
        'Content-Type': 'application/json',
        if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
      };

      final response = await http.get(
        Uri.parse(APIsurls.home),
        headers: headers,
      );

      debugPrint('Home API Status: ${response.statusCode}');
      debugPrint('Home API Response: ${response.body}');

      if (response.statusCode == 200) {
        return prayerRequestsAndGodVerseofthedayFromJson(response.body);
      }

      throw Exception(
        'Failed to load home data '
        '(${response.statusCode}): ${response.body}',
      );
    } catch (e) {
      debugPrint('Error fetching home data: $e');
      rethrow;
    }
  }

  // Get all prayer requests based on the token
  Future<PrayerRequestsreponses> getAllPrayerRequests() async {
    try {
      String? token;

      try {
        token = await TokenStorage.getAccessToken();
      } catch (e) {
        debugPrint('Could not retrieve token: $e');
        token = null;
      }

      final headers = {
        'Content-Type': 'application/json',
        if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
      };

      final response = await http.get(
        Uri.parse(APIsurls.prayerRequests),
        headers: headers,
      );

      if (response.statusCode == 200) {
        return prayerRequestsreponsesFromJson(response.body);
      }

      throw Exception(
        'Failed to load prayer details '
        '(${response.statusCode}): ${response.body}',
      );
    } catch (e) {
      debugPrint('Error fetching prayer details: $e');
      rethrow;
    }
  }

  // Get detail of the single prayer request details based on the token
  Future<PrayerRequestsDetailsReponses> getPrayerDetails(int prayerId) async {
    try {
      String? token;

      try {
        token = await TokenStorage.getAccessToken();
      } catch (e) {
        debugPrint('Could not retrieve token: $e');
        token = null;
      }

      final headers = {
        'Content-Type': 'application/json',
        if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
      };

      final response = await http.get(
        Uri.parse(APIsurls.prayerRequestsDetails(prayerId)),
        headers: headers,
      );

      debugPrint('Prayer Details Status: ${response.statusCode}');
      debugPrint('Prayer Details Response: ${response.body}');

      if (response.statusCode == 200) {
        return prayerRequestsDetailsReponsesFromJson(response.body);
      }

      throw Exception(
        'Failed to load prayer details '
        '(${response.statusCode}): ${response.body}',
      );
    } catch (e) {
      debugPrint('Error fetching prayer details: $e');
      rethrow;
    }
  }
}
