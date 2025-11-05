import 'package:flutter/material.dart';
import 'package:zion_final/pages/profile/my_account.dart';
import 'package:zion_final/pages/songs/songs_list_view.dart';

import 'pages/bible/bible_view.dart';
import 'pages/chats/user_chat.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int myCurrentIndex = 0;

  final List<Widget> _pages = [
    const Chats(),
    const BibleView(),
    const SongsListView(),
    const MyAccount(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      myCurrentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Zion App',
          style: TextStyle(color: Colors.white, fontSize: 35),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.note_alt_rounded,
                color: Colors.white70, size: 30),
          ),
          IconButton(
            onPressed: showNotificationDialog,
            icon: const Icon(Icons.notifications,
                color: Colors.white70, size: 30),
          ),
        ],
      ),
      body: _pages[myCurrentIndex],
      bottomNavigationBar: bottomNavigationBarSetting(),
    );
  }

  void showNotificationDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          height: MediaQuery.of(context).size.height * 0.4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Notifications (2)',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView(
                  children: const [
                    ListTile(
                      leading: Icon(Icons.notifications_active),
                      title: Text('New message from John'),
                    ),
                    ListTile(
                      leading: Icon(Icons.shopping_cart),
                      title: Text('Your order has been shipped'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget bottomNavigationBarSetting() => SafeArea(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.orange, width: 0.6),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BottomNavigationBar(
              currentIndex: myCurrentIndex,
              onTap: _onItemTapped,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.chat_bubble_outline_outlined),
                  activeIcon: Icon(Icons.chat_outlined, size: 35),
                  label: 'Chats',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.church_outlined),
                  activeIcon: Icon(Icons.church, size: 35),
                  label: 'Bible',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.music_note_outlined),
                  activeIcon: Icon(Icons.music_note),
                  label: 'Songs',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person_outlined),
                  activeIcon: Icon(Icons.person),
                  label: 'Me',
                ),
              ],
              type: BottomNavigationBarType.fixed,
              selectedFontSize: 14,
              unselectedFontSize: 12,
              iconSize: 30,
            ),
          ),
        ),
      );
}
