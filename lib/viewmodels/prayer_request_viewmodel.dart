import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../core/utils/minimum_loader_duration.dart';

import '../models/prayer request/all_prayer_request_model.dart';
import '../models/prayer request/prayer_word_model.dart';
import '../models/prayer request/prayer_request_detail_model.dart';
import '../services/prayer_request_service.dart';

class PrayerRequestAndWordOfGodViewModel extends GetxController {
  final PrayerAndWordOfGodAPIService _apiService =
      PrayerAndWordOfGodAPIService();

  // Home
  bool isHomeLoading = false;
  PrayerRequestsAndGodVerseoftheday? homeData;
  String? homeError;

  // All prayer request
  bool isAllPrayerRequest = false;
  PrayerRequestsreponses? allPrayerrequestData;
  String? allPrayerRequestsError;

  // Prayer details
  bool isPrayerDetailsLoading = false;
  PrayerRequestsDetailsReponses? prayerDetails;
  String? prayerDetailsError;
  bool hasLoadedPrayerDetails = false;

  @override
  void onInit() {
    super.onInit();

    // If you want Home API on ViewModel creation
    getHomeData();
  }

  // getHomeData
  Future<void> getHomeData() async {
    final startedAt = DateTime.now();
    try {
      isHomeLoading = true;
      homeError = null;
      update();

      final response = await _apiService.getHomeData();

      homeData = response;
      homeError = null;

      debugPrint('Home data loaded successfully');
    } catch (e) {
      homeError = e.toString();
      debugPrint('Home API Error: $e');
    } finally {
      await waitForMinimumLoaderDuration(startedAt);
      isHomeLoading = false;
      update();
    }
  }

  // getAllPrayerRequest
  Future<void> getAllPrayerRequests() async {
    final startedAt = DateTime.now();
    try {
      isAllPrayerRequest = true;
      allPrayerRequestsError = null;
      update();

      final response = await _apiService.getAllPrayerRequests();
      allPrayerrequestData = response;
      allPrayerRequestsError = null;
      debugPrint(
        'allPrayerrequestData loaded successfully $allPrayerrequestData',
      );
    } catch (e) {
      allPrayerRequestsError = e.toString();
      debugPrint('getAllPrayerRequests API Error: $e');
    } finally {
      await waitForMinimumLoaderDuration(startedAt);
      isAllPrayerRequest = false;
      update();
    }
  }

  // getPrayerDetails
  Future<void> getPrayerDetails(int prayerId) async {
    final startedAt = DateTime.now();
    try {
      isPrayerDetailsLoading = true;
      prayerDetails = null;
      prayerDetailsError = null;
      hasLoadedPrayerDetails = false;
      update();

      debugPrint('Calling prayer details API for ID: $prayerId');

      final response = await _apiService.getPrayerDetails(prayerId);

      prayerDetails = response;
      prayerDetailsError = null;

      debugPrint('Prayer details loaded successfully');

      debugPrint('Prayer name: ${response.data.name}');

      debugPrint('Prayer: ${response.data.prayer}');

      debugPrint('Is me: ${response.data.isMe}');

      debugPrint('Views: ${response.data.viewCount}');
    } catch (e) {
      prayerDetailsError = e.toString();
      debugPrint('Prayer Details ViewModel Error: $e');
    } finally {
      await waitForMinimumLoaderDuration(startedAt);
      isPrayerDetailsLoading = false;
      hasLoadedPrayerDetails = true;
      update();
    }
  }
}
