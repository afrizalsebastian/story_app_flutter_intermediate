import 'package:flutter/material.dart';
import 'package:story_app_flutter_intermediate/common/styles.dart';

class DetailStoryPage extends StatelessWidget {
  final String storyId;
  const DetailStoryPage({super.key, required this.storyId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Detail Story',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: Styles.primaryColor,
      ),
      body: Center(
        child: Text(storyId),
      ),
    );
  }
}
