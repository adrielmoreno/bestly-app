import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class EjerciciovideoCard extends StatefulWidget {
  final String videoUrl;
  final String username;

  const EjerciciovideoCard({
    super.key,
    required this.videoUrl,
    required this.username,
  });

  @override
  State<EjerciciovideoCard> createState() => _EjerciciovideoCardState();
}

class _EjerciciovideoCardState extends State<EjerciciovideoCard> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
        _controller.setLooping(true);
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        _controller.value.isInitialized
            ? VideoPlayer(_controller)
            : const Center(child: CircularProgressIndicator()),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.black.withOpacity(0.4), Colors.transparent],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),
        ),
        Positioned(
          bottom: 30,
          left: 16,
          right: 80,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '@${widget.username}',
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
              const Text(
                '¡Disfrutando el momento!',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
        const Positioned(
          bottom: 30,
          right: 16,
          child: Column(
            children: [
              Icon(Icons.favorite_border, color: Colors.white, size: 30),
              SizedBox(height: 12),
              Icon(Icons.comment, color: Colors.white, size: 30),
              SizedBox(height: 12),
              Icon(Icons.share, color: Colors.white, size: 30),
            ],
          ),
        ),
      ],
    );
  }
}
