import 'package:flutter/material.dart';
import 'user_chat_profile.dart';

class InnerChat extends StatefulWidget {
  final String username;
  final String imagePath;
  final String lastSeen;
  final bool isGroup;
  final List<String> members;

  const InnerChat({
    super.key,
    required this.username,
    required this.imagePath,
    required this.lastSeen,
    required this.isGroup, 
    required this.members,
  });

  @override
  State<InnerChat> createState() => _InnerChatState();
}

class _InnerChatState extends State<InnerChat> {
  final TextEditingController _controller = TextEditingController();

  final List<Map<String, dynamic>> messages = [
    {'text': 'Hey there!', 'isMe': false},
    {'text': 'Hi, how are you?', 'isMe': true},
    {'text': 'I’m good. You?', 'isMe': false},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Row(
          children: [
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => UserChatProfile(
                      username: widget.username,
                      imagePath: widget.imagePath,
                      isGroup: widget.isGroup,
                      bio:
                          'This group is for youth members to stay connected and share updates.',
                      members: widget.members,
                    ),
                  ),
                );
              },
              child: CircleAvatar(
                backgroundImage: AssetImage(widget.imagePath),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.username,
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white)),
                  Text(widget.lastSeen,
                      style:
                          const TextStyle(fontSize: 12, color: Colors.white70)),
                ],
              ),
            ),
            if (!widget.isGroup)
              IconButton(
                icon: const Icon(Icons.call, color: Colors.white),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Calling user...')),
                  );
                },
              ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                return Align(
                  alignment: msg['isMe']
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: msg['isMe']
                          ? const Color(0xFF4B91F1)
                          : const Color(0xFF3A3A49),
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(16),
                        topRight: const Radius.circular(16),
                        bottomLeft: msg['isMe']
                            ? const Radius.circular(16)
                            : Radius.zero,
                        bottomRight: msg['isMe']
                            ? Radius.zero
                            : const Radius.circular(16),
                      ),
                    ),
                    child: Text(msg['text'],
                        style: const TextStyle(color: Colors.white)),
                  ),
                );
              },
            ),
          ),
          SafeArea(
            child: Container(
              color: const Color(0xFF2A2D3E),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Type a message',
                        hintStyle: const TextStyle(color: Colors.white54),
                        filled: true,
                        fillColor: const Color(0xFF3A3A49),
                        contentPadding: const EdgeInsets.all(10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    backgroundColor: const Color(0xFF4B91F1),
                    child: IconButton(
                      icon: const Icon(Icons.send, color: Colors.white),
                      onPressed: () {
                        final text = _controller.text.trim();
                        if (text.isNotEmpty) {
                          setState(() {
                            messages.add({'text': text, 'isMe': true});
                          });
                          _controller.clear();
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
