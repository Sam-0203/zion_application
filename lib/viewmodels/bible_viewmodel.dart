import 'package:flutter_app/models/bible/bible_books_model.dart';
import 'package:flutter_app/models/bible/chapter_verses_model.dart';
import 'package:flutter_app/models/bible/languages_model.dart';
import 'package:flutter_app/core/utils/minimum_loader_duration.dart';
import 'package:get/get.dart';
import 'package:flutter_app/services/bible_servce.dart';

class BibleViewModel extends GetxController {
  final LanguagesApiServices _languageApiServices = LanguagesApiServices();

  final BibleApiServices _bibleApiServices = BibleApiServices();

  // Bible Languages
  AppLanguages? allLanguages;
  bool isLanguageLoading = false;
  String? allLanguagesError;

  // Bible Books
  LanguagedBibleList? allBibleBook;
  bool isBibleBookLoading = false;
  String? allBibleBookError;

  // Bible Verses
  BibleVersesResponse? allBibleVerses;
  bool isBibleVersesLoading = false;
  String? allBibleVersesError;

  // GET Bible Languages
  Future<void> fetchBibleLanguages() async {
    final startedAt = DateTime.now();
    isLanguageLoading = true;
    allLanguagesError = null;
    update();

    try {
      allLanguages = await _languageApiServices.fetchSupportedLanguages();
      allLanguagesError = null;
    } catch (e) {
      allLanguagesError = e.toString();
    } finally {
      await waitForMinimumLoaderDuration(startedAt);
      isLanguageLoading = false;
      update();
    }
  }

  // GET Bible Books by Language Code
  Future<void> fetchBibleBooks(String languageCode) async {
    final startedAt = DateTime.now();
    isBibleBookLoading = true;
    allBibleBook = null;
    allBibleBookError = null;
    update();

    try {
      allBibleBook = await _bibleApiServices.getBibleBooksData(languageCode);
      allBibleBookError = null;
    } catch (e) {
      allBibleBookError = e.toString();
    } finally {
      await waitForMinimumLoaderDuration(startedAt);
      isBibleBookLoading = false;
      update();
    }
  }

  // GET Bible Verses by Book ID
  Future<void> fetchBibleVerses(int bookId) async {
    final startedAt = DateTime.now();
    isBibleVersesLoading = true;
    allBibleVersesError = null;
    update();

    try {
      allBibleVerses = await _bibleApiServices.getBibleVersesData(bookId);
      allBibleVersesError = null;
    } catch (e) {
      allBibleVersesError = e.toString();
    } finally {
      await waitForMinimumLoaderDuration(startedAt);
      isBibleVersesLoading = false;
      update();
    }
  }
}
