import 'package:get/get.dart';
import 'package:flutter_app/models/bible/wordOfGod_model.dart';
import 'package:flutter_app/core/utils/minimum_loader_duration.dart';
import 'package:flutter_app/services/bible_servce.dart';

class VersesOfTheDayViewModel extends GetxController {
  final BibleApiServices _bibleApiServices = BibleApiServices();
  GodVerseoftheday? verse;
  bool isLoading = false;
  bool hasFetched = false;
  String? error;

  // GET Verses List
  Future<void> fetchVersesOfTheDay() async {
    final startedAt = DateTime.now();
    isLoading = true;
    hasFetched = false;
    error = null;
    update();

    try {
      verse = await _bibleApiServices.getVersesData();
      error = null;
    } catch (e) {
      error = e.toString();
    } finally {
      await waitForMinimumLoaderDuration(startedAt);
      isLoading = false;
      hasFetched = true;
      update();
    }
  }
}
