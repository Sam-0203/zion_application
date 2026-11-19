import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app/models/bible/bible_books_model.dart';
import 'package:flutter_app/models/bible/chapter_verses_model.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_app/core/constants/api_urls.dart';
import 'package:flutter_app/core/utils/user%20data%20storing/user_data_storing.dart';
import 'package:flutter_app/models/bible/languages_model.dart';
import 'package:flutter_app/models/bible/wordOfGod_model.dart';

// For languages
class LanguagesApiServices {
  Future<AppLanguages> fetchSupportedLanguages() async {
    try {
      final response = await http.get(Uri.parse(APIsurls.languagesList));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonMap = json.decode(response.body);
        return AppLanguages.fromJson(jsonMap);
      } else {
        throw Exception(
          'Failed to load languages (${response.statusCode}): ${response.body}',
        );
      }
    } catch (e) {
      throw Exception('Error fetching languages: $e');
    }
  }
}

// Bible
class BibleApiServices {
  // GET Verses of the Day ----------------------------------->
  Future<GodVerseoftheday> getVersesData() async {
    try {
      String? token;
      try {
        token = await TokenStorage.getAccessToken();
      } catch (e) {
        debugPrint("Could not retrieve token: $e");
        token = null;
      }
      final headers = {
        'Content-Type': 'application/json',
        if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
      };

      final response = await http.get(
        Uri.parse(APIsurls.dailyDevotional),
        headers: headers,
      );

      if (response.statusCode == 200) {
        print(response.body);
        return godVerseofthedayFromJson(response.body);
      } else {
        throw Exception(
          'Failed to load verse (${response.statusCode}): ${response.body}',
        );
      }
    } catch (e) {
      // You can log this error or show a snackbar/toast
      debugPrint('Error fetching verses: $e');
      rethrow; // keeps the error for FutureBuilder or caller
    }
  }

  // Selecting Bible Books by Language ----------------------------------->
  Future<LanguagedBibleList> getBibleBooksData(String languageCode) async {
    try {
      final String url = APIsurls.bibleBooks.replaceFirst(
        '<str:language_code>',
        languageCode,
      );

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        return languagedBibleListFromJson(response.body);
      } else {
        throw Exception(
          'Failed to load books. Status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      debugPrint('Error fetching books: $e');
      rethrow;
    }
  }

  // Getting Verses by Book ID ----------------------------------->
  Future<BibleVersesResponse> getBibleVersesData(int bookId) async {
    try {
      final String url = APIsurls.bibleVerses.replaceFirst(
        '<int:book_id>',
        bookId.toString(),
      );

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        return bibleVersesResponseFromJson(response.body); // ✅ parse FULL model
      } else {
        throw Exception(
          'Failed to load verses. Status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      debugPrint('Error fetching verses: $e');
      rethrow;
    }
  }

  //   // Getting search result by the query ----------------------------------->
  //   Future<BibleSearchResponse> getSearchResultData(String query) async {
  //     try {
  //       final response = await http.get(
  //         Uri.parse('${APIsurls.bibleSearch}$query'),
  //       );
  //       if (response.statusCode == 200) {
  //         return bibleSearchResponseFromJson(response.body);
  //       } else {
  //         throw Exception(
  //           'Failed to search verses. Status code: ${response.statusCode}',
  //         );
  //       }
  //     } catch (e) {
  //       debugPrint('Error searching verses: $e');
  //       rethrow;
  //     }
  //   }
} // Placeholder for future Bible API services implementation
