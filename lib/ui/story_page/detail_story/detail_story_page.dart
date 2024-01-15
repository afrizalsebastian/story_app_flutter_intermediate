import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:story_app_flutter_intermediate/api/api_services.dart';
import 'package:story_app_flutter_intermediate/common/styles.dart';
import 'package:story_app_flutter_intermediate/model/detail_story.dart';
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
      body: ChangeNotifierProvider<DetailStoryProvider>(
        create: (_) => DetailStoryProvider(
          apiServices: ApiServices(),
          storyId: storyId,
        ),
        child: Consumer<DetailStoryProvider>(
          builder: (context, provider, child) {
            if (provider.state == ResultState.loading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (provider.state == ResultState.hasData) {
              final Story story = provider.story;

              return _createBody(context, story);
            } else if (provider.state == ResultState.error) {
              return Center(
                child: Material(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(provider.message),
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
          },
        ),
      ),
    );
  }
}
