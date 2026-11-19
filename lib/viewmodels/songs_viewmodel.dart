import 'package:flutter/material.dart';
import 'package:flutter_app/core/utils/minimum_loader_duration.dart';
import 'package:flutter_app/models/songs/song_detail_page_model.dart';
import 'package:flutter_app/models/songs/song_search_result_model.dart'
    as song_search;
import 'package:flutter_app/models/songs/songs_list_model.dart';
import 'package:flutter_app/services/songs_service.dart';
import 'package:get/get.dart';

class SongsListViewModel extends GetxController {
  final SongsApiService _songsApiService = SongsApiService();

  // songsList
  SongsListResponses? songsList;
  bool isSongsListLoading = false;
  String? error;

  // songDetails
  SingleSongsDetailResponses? songDetails;
  bool isSongDetailsLoading = false;
  String? songDetailsError;

  // Search
  List<song_search.Datum> searchResults = [];
  bool isSongSearchLoading = false;
  String? songSearchError;
  int _searchRequestId = 0;

  // GET Songs List
  Future<void> fetchAllSongs() async {
    final startedAt = DateTime.now();
    isSongsListLoading = true;
    error = null;
    update();

    try {
      songsList = await _songsApiService.fetchSongsList();
      error = null;
    } catch (e) {
      error = e.toString();
    } finally {
      await waitForMinimumLoaderDuration(startedAt);
      isSongsListLoading = false;
      update();
    }
  }

  // GET Single Song Details
  Future<void> fetchSongDetails(int songId) async {
    final startedAt = DateTime.now();
    isSongDetailsLoading = true;
    songDetailsError = null;
    songDetails = null;
    update();

    try {
      debugPrint('Calling Song Details for ID: $songId');
      final response = await _songsApiService.fetchSingleSong(songId);
      songDetails = response;
      songDetailsError = null;
      debugPrint('Song details loaded successfully');
      debugPrint('Song Name: ${response.data.songName}');
      debugPrint('Song Title: ${response.data.songChorus}');
      debugPrint('Song Lyrics: ${response.data.songLyric}');
    } catch (e) {
      songDetailsError = e.toString();
      debugPrint('Song Details ViewModel Error: $e');
    } finally {
      await waitForMinimumLoaderDuration(startedAt);
      isSongDetailsLoading = false;
      update();
    }
  }

  // Search songs through Django API
  Future<void> searchSongs(String query) async {
    final startedAt = DateTime.now();
    final requestId = ++_searchRequestId;
    final trimmedQuery = query.trim();

    if (trimmedQuery.isEmpty) {
      searchResults = [];
      songSearchError = null;
      isSongSearchLoading = false;
      update();
      return;
    }

    isSongSearchLoading = true;
    songSearchError = null;
    update();

    try {
      final response = await _songsApiService.searchSongs(trimmedQuery);

      // Ignore outdated search responses.
      if (requestId != _searchRequestId) return;

      searchResults = response.data;
      songSearchError = null;
    } catch (e) {
      if (requestId != _searchRequestId) return;

      songSearchError = e.toString();
      searchResults = [];
    } finally {
      if (requestId == _searchRequestId) {
        await waitForMinimumLoaderDuration(startedAt);
      }
      if (requestId == _searchRequestId) {
        isSongSearchLoading = false;
        update();
      }
    }
  }

  // Cancel pending search results when the query is cleared.
  void clearSongSearch() {
    _searchRequestId++;
    searchResults = [];
    songSearchError = null;
    isSongSearchLoading = false;
    update();
  }
}
