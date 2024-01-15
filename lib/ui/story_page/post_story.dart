import 'package:flutter/material.dart';

class PostStory extends StatefulWidget {
  final BottomNavigationBar bottomNavigationBar;

  const PostStory({super.key, required this.bottomNavigationBar});

  @override
  State<PostStory> createState() => _PostStoryState();
}

class _PostStoryState extends State<PostStory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text('Post Story'),
      bottomNavigationBar: widget.bottomNavigationBar,
    );
  }
}
