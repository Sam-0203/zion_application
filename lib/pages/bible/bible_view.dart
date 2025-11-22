import 'package:flutter/material.dart';

class BibleView extends StatefulWidget {
  const BibleView({super.key});

  @override
  State<BibleView> createState() => _BibleViewState();
}

class _BibleViewState extends State<BibleView> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GridView.builder(
        padding: const EdgeInsets.all(16.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Number of columns
          crossAxisSpacing: 16.0, // Horizontal spacing between items
          mainAxisSpacing: 16.0, // Vertical spacing between items
          childAspectRatio: 1.0, // Aspect ratio of each grid item (width/height)
        ),
        itemCount: 20, // Example item count, replace with your data length
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VerseDetailPage(itemIndex: index),
                ),
              );
            },
            child: Card(
              elevation: 2,
              child: Center(
                child: Text(
                  'Item $index',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// New page to display details of the selected item
class VerseDetailPage extends StatelessWidget {
  final int itemIndex;

  const VerseDetailPage({super.key, required this.itemIndex});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Verse $itemIndex'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Details for Item $itemIndex',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
      ),
    );
  }
}