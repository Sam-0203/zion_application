import 'package:flutter/material.dart';
import 'dart:math';

import 'package:zion_final/models/songs_model.dart';
import 'package:zion_final/services/API_services.dart';


class SongsListView extends StatefulWidget {
  const SongsListView({super.key});

  @override
  State<SongsListView> createState() => _SongsListViewState();
}

class _SongsListViewState extends State<SongsListView> {
  LanguageList? languageList; // Changed to single LanguageList
  bool isLoaded = false; // Renamed for clarity, using camelCase

  // Function to generate a random color
  Color getRandomColor() {
    final Random random = Random();
    return Color.fromRGBO(
      random.nextInt(256), // Red value (0-255)
      random.nextInt(256), // Green value (0-255)
      random.nextInt(256), // Blue value (0-255)
      1.0, // Opacity
    );
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    try {
      final fetchedData = await FetchingLanguagesServices().getLaguages();
      if (fetchedData != null) {
        setState(() {
          languageList = fetchedData;
          isLoaded = true;
        });
      } else {
        setState(() {
          isLoaded = true; // Still show UI even if data is null
        });
      }
    } catch (e) {
      print('Error fetching languages: $e');
      setState(() {
        isLoaded = true; // Show UI to allow retry or error display
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: isLoaded
            ? (languageList == null || languageList!.data.isEmpty)
                  ? const Center(
                      child: Text(
                        'No languages available',
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  : GridView.builder(
                      padding: const EdgeInsets.all(16.0),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 16.0,
                            mainAxisSpacing: 16.0,
                            childAspectRatio: 1.0,
                          ),
                      itemCount:
                          languageList!.data.length, // Dynamic item count
                      itemBuilder: (context, index) {
                        final language = languageList!.data[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SongDetailPage(
                                  itemIndex: index,
                                  languageCode: language.languageCode,
                                  language: language.languages,
                                ),
                              ),
                            );
                          },
                          child: Card(
                            elevation: 2,
                            color: getRandomColor(), // Added random color
                            child: Center(
                              child: Text(
                                language
                                    .languages, // Display actual language name
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        );
                      },
                    )
            : const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

class SongDetailPage extends StatelessWidget {
  final int itemIndex;
  final String languageCode;
  final String language;

  const SongDetailPage({
    super.key,
    required this.itemIndex,
    required this.languageCode,
    required this.language,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Row(
              children: [
                Icon(
                  Icons.arrow_back_ios_new,
                  color: Theme.of(
                    context,
                  ).colorScheme.onPrimary, // Theme-based color
                ),
                const SizedBox(width: 8),
                Text(
                  language, // Use language name
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Center(
        child: Text(
          'Details for $language',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}
