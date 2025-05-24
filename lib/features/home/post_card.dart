import 'package:flutter/material.dart';

class PostCard extends StatelessWidget {
  final String username;
  final String userImage;
  final String postImage;
  final String caption;

  const PostCard({
    super.key,
    required this.username,
    required this.userImage,
    required this.postImage,
    required this.caption,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: CircleAvatar(backgroundImage: NetworkImage(userImage)),
          title: Text(username,
              style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: const Text('Hace 1 hora'),
          trailing: const Icon(Icons.more_horiz),
        ),
        const SizedBox(height: 8),
        Image.network(postImage),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(caption),
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(Icons.thumb_up_off_alt_outlined),
              SizedBox(width: 20),
              Text('12k Comments'),
              SizedBox(width: 20),
              Text('1.2k Shares'),
              SizedBox(width: 20),
            ],
          ),
        ),
        const Divider(height: 10),
      ],
    );
  }
}
