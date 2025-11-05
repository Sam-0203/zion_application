import 'package:flutter/material.dart';
import 'inner_chat.dart';

class Chats extends StatefulWidget {
  const Chats({super.key});

  @override
  State<Chats> createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  @override
  Widget build(BuildContext context) {
    // Create a list of user data with index and isActive status
    List<Map<String, dynamic>> users = List.generate(10, (index) {
      return {
        'index': index,
        'isActive': index % 2 == 0, // Even indices are active
      };
    });

    // Sort users: active users come first
    users.sort((a, b) => a['isActive'] == b['isActive']
        ? 0
        : a['isActive']
            ? -1
            : 1);

    return Scaffold(
      body: Column(
        children: [
          // Horizontally scrollable list of users
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: 70,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: users.map((user) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Stack(
                        children: [
                          const CircleAvatar(
                            radius: 30,
                            backgroundImage:
                                AssetImage('assets/images/user.png'),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              width: 14,
                              height: 14,
                              decoration: BoxDecoration(
                                color: user['isActive']
                                    ? Colors.green
                                    : Colors.red,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
          // Groups buttons
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Default Groups',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildGroupButton(
                        label: 'Youth',
                        image: 'assets/images/youth.png',
                        lastSeen: 'Last seen today at 5:30 PM',
                      ),
                      const SizedBox(width: 8),
                      _buildGroupButton(
                        label: 'Children\'s Group',
                        image: 'assets/images/children.png',
                        lastSeen: 'Last seen today at 4:00 PM',
                      ),
                      const SizedBox(width: 8),
                      _buildGroupButton(
                        label: 'Families Prayer Request',
                        image: 'assets/images/family.png',
                        lastSeen: 'Last seen yesterday at 8:00 PM',
                      ),
                      const SizedBox(width: 8),
                      _buildGroupButton(
                        label: 'Prayer Request',
                        image: 'assets/images/prayer.png',
                        lastSeen: 'Online',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Chat content
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: List.generate(
                  15,
                  (index) => ListTile(
                    leading: const CircleAvatar(
                      backgroundImage: AssetImage('assets/images/user.png'),
                      radius: 24,
                    ),
                    title: Text(
                      'User $index',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Text(
                      'Latest message from user $index',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => InnerChat(
                            username: 'User $index',
                            imagePath: 'assets/images/user.png',
                            lastSeen: '',
                            isGroup: false,
                            members: const [],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),

      // Floating button for creating custom group
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () {
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(builder: (context) => const CreateGroupPage()),
          // );
        },
        child: const Icon(Icons.group_add, color: Colors.white),
      ),
    );
  }

  // Helper: Group button
  Widget _buildGroupButton({
    required String label,
    required String image,
    required String lastSeen,
  }) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => InnerChat(
              username: label,
              imagePath: image,
              lastSeen: lastSeen,
              isGroup: true,
              members: const [
                'John Doe',
                'Mary Jane',
                'Michael Smith',
                'Emily Davis',
              ],
            ),
          ),
        );
      },
      child: Text(
        label,
        style: const TextStyle(color: Colors.black, fontSize: 16),
      ),
    );
  }
}

