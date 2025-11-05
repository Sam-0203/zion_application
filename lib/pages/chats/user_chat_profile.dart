import 'package:flutter/material.dart';

class UserChatProfile extends StatelessWidget {
  final String username;
  final String imagePath;
  final bool isGroup;
  final String bio;
  final List<String> members;

  const UserChatProfile({
    super.key,
    required this.username,
    required this.imagePath,
    required this.isGroup,
    required this.bio,
    this.members = const [],
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false, // Allow AppBar to extend under status bar
        child: Column(
          children: [
            AppBar(
              titleSpacing: 0,
              automaticallyImplyLeading: false,
              title: Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: const Row(
                    children: [
                      Icon(Icons.arrow_back_ios_new, color: Colors.white),
                      SizedBox(width: 8),
                      Text(
                        'Profile',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView( // ✅ scrollable content
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 60,
                            backgroundImage: AssetImage(imagePath),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            username,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Last seen today at 5:30 PM',
                            style: TextStyle(color: Colors.white70),
                          ),
                          const SizedBox(height: 30),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton.icon(
                                onPressed: () {},
                                icon: const Icon(Icons.call, color: Colors.white),
                                label: const Text(
                                  'Call',
                                  style: TextStyle(color: Colors.white),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF4B91F1),
                                ),
                              ),
                              const SizedBox(width: 20),
                              ElevatedButton.icon(
                                onPressed: () => Navigator.pop(context),
                                icon: const Icon(Icons.chat, color: Colors.white),
                                label: const Text(
                                  'Message',
                                  style: TextStyle(color: Colors.white),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF4B91F1),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Bio Section
                    const Text(
                      'Bio',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      bio,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),

                    // Group Members Preview Section
                    if (isGroup) ...[
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Group Members',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          if (members.length > 3)
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => GroupMembersPage(
                                      members: members,
                                      groupName: username,
                                    ),
                                  ),
                                );
                              },
                              child: const Text(
                                'See All',
                                style: TextStyle(color: Colors.blueAccent),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      ...members.take(3).map((member) {
                        return ListTile(
                          leading: const CircleAvatar(
                            backgroundImage:
                                AssetImage('assets/default_user.png'),
                          ),
                          title: Text(
                            member,
                            style: const TextStyle(color: Colors.white),
                          ),
                        );
                      }),
                    ],

                    // Only for individual users
                    if (!isGroup) ...[
                      const SizedBox(height: 40),
                      Center(
                        child: Column(
                          children: [
                            TextButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.block, color: Colors.redAccent),
                              label: Text(
                                'Block $username',
                                style: const TextStyle(color: Colors.redAccent),
                              ),
                            ),
                            TextButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.delete, color: Colors.redAccent),
                              label: Text(
                                'Delete $username',
                                style: const TextStyle(color: Colors.redAccent),
                              ),
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GroupMembersPage extends StatelessWidget {
  final List<String> members;
  final String groupName;

  const GroupMembersPage({
    super.key,
    required this.members,
    required this.groupName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            AppBar(
              titleSpacing: 0,
              automaticallyImplyLeading: false,
              title: Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Row(
                    children: [
                      const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                      const SizedBox(width: 8),
                      Text(
                        '$groupName Members',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                itemCount: members.length,
                itemBuilder: (context, index) {
                  final member = members[index];
                  return ListTile(
                    leading: const CircleAvatar(
                      backgroundImage: AssetImage('assets/default_user.png'),
                    ),
                    title: Text(
                      member,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    subtitle: const Text(
                      'Member',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Tapped on $member')),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
