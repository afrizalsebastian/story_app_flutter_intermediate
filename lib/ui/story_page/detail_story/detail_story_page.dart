import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:story_app_flutter_intermediate/common/styles.dart';
import 'package:story_app_flutter_intermediate/model/story.dart';
import 'package:story_app_flutter_intermediate/provider/api_enum.dart';
import 'package:story_app_flutter_intermediate/provider/detail_story_provider.dart';

class DetailStoryPage extends StatelessWidget {
  final String storyId;
  const DetailStoryPage({super.key, required this.storyId});

  Widget _createBody(BuildContext context, Story story) {
    return Container(
      padding: const EdgeInsets.all(12),
      child: ListView(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  offset: Offset(0, 4),
                  blurRadius: 4,
                ),
              ],
            ),
            height: 250,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                story.photoUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 32),
          Text(
            story.name,
            style: const TextStyle(
              color: Styles.primaryColor,
              fontWeight: FontWeight.w700,
              fontSize: 28,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Text(
            DateFormat('dd MMMM yyyy').format(story.createdAt),
            style: const TextStyle(
              color: Styles.textColor,
              fontSize: 20,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          const Text(
            "Description",
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                style: BorderStyle.solid,
                color: Colors.black26,
              ),
            ),
            padding: const EdgeInsets.all(16),
            height: 150,
            child: SingleChildScrollView(
              child: Text(
                story.description,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Location (${story.lat ?? 'not have latitude'}, ${story.lon ?? 'not have longitude'})",
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _consumerDetail(BuildContext context) {
    final detailWatch = context.watch<DetailStoryProvider>();
    final detailRead = context.read<DetailStoryProvider>();

    if (detailWatch.state == ResultState.loading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else if (detailWatch.state == ResultState.hasData) {
      final Story story = detailRead.story;

      return _createBody(context, story);
    } else if (detailWatch.state == ResultState.error) {
      return Center(
        child: Material(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(detailRead.message),
            ],
          ),
        ),
      );
    } else {
      return const Center(
        child: Material(
          child: Text(''),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Detail Story',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        leading: null,
        backgroundColor: Styles.primaryColor,
      ),
      body: _consumerDetail(context),
    );
  }
}
