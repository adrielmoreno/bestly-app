import 'package:flutter/material.dart';

import 'post_card.dart';
import 'story_section.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  static const String route = '/home';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Image.asset('assets/img/bestly.png', height: 60),
        automaticallyImplyLeading: false,
        actions: const [
          CircleAvatar(
            backgroundColor: Colors.grey,
            child: Icon(Icons.search, color: Colors.white),
          ),
          SizedBox(width: 10),
          CircleAvatar(
            backgroundColor: Colors.grey,
            child: Icon(Icons.notifications, color: Colors.white),
          ),
          SizedBox(width: 10),
          CircleAvatar(
            backgroundColor: Colors.grey,
            child: Icon(Icons.message_rounded, color: Colors.white),
          ),
          SizedBox(width: 10),
        ],
      ),
      body: const SingleChildScrollView(
        child: Column(
          children: [
            Divider(height: 8),
            StorySection(),
            Divider(height: 8),
            PostCard(
              username: 'Adriel Moreno',
              userImage: 'https://i.pravatar.cc/150?img=3',
              postImage: 'https://picsum.photos/400/300',
              caption: '¡Qué gran día en la playa!',
            ),
            PostCard(
              username: 'Humberto Vargas',
              userImage: 'https://i.pravatar.cc/150?img=8',
              postImage: 'https://picsum.photos/400/301',
              caption: 'Amo este atardecer',
            ),
          ],
        ),
      ),
    );
  }
}
