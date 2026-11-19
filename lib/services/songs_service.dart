import 'package:flutter/material.dart';
import 'package:flutter_app/models/songs/song_search_result_model.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_app/core/constants/api_urls.dart';
import 'package:flutter_app/models/songs/song_detail_page_model.dart';
import 'package:flutter_app/models/songs/songs_list_model.dart';

class SongsApiService {
  // For songs list
  Future<SongsListResponses> fetchSongsList() async {
    try {
      final response = await http.get(Uri.parse(APIsurls.songsList));

      if (response.statusCode == 200) {
        debugPrint('SongsApiService Songs list: ${response.body}');
        return songsListResponsesFromJson(response.body);
      } else {
        throw Exception(
          'Failed to load verse (${response.statusCode}): ${response.body}',
        );
      }
    } catch (e) {
      // You can log this error or show a snackbar/toast
      debugPrint('Error fetching verses: $e');
      rethrow;
    }
  }

  // Single Songs Detail
  Future<SingleSongsDetailResponses> fetchSingleSong(int songId) async {
    try {
      debugPrint('Calling Song Detail API for ID: $songId');
      final response = await http.get(Uri.parse(APIsurls.songDetail(songId)));

      debugPrint('Song Detail Status: ${response.statusCode}');
      debugPrint('Song Detail Response: ${response.body}');

      if (response.statusCode == 200) {
        return singleSongsDetailResponsesFromJson(response.body);
      }

      throw Exception(
        'Failed to load song details '
        '(${response.statusCode}): ${response.body}',
      );
    } catch (e) {
      debugPrint('Error fetching song details: $e');
      rethrow;
    }
  }

  // Search songs by name or song number
  Future<SearchResultResponseModel> searchSongs(String query) async {
    try {
      final songSearchUri = Uri.parse(APIsurls.songSearch);
      final uri = songSearchUri.replace(
        queryParameters: {...songSearchUri.queryParameters, 'q': query},
      );
      debugPrint('Searching songs: $uri');
      final response = await http.get(uri);

      // The search endpoint uses 404 with an empty `data` list when no songs
      // match. Treat that response as a valid empty search result.
      if (response.statusCode == 200 || response.statusCode == 404) {
        return searchResultResponseModelFromJson(response.body);
      }

      throw Exception(
        'Song search failed (${response.statusCode}): '
        '${response.body}',
      );
    } catch (e) {
      debugPrint('Song search error: $e');
      rethrow;
    }
  }
}
