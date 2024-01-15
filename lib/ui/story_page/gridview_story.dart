import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:story_app_flutter_intermediate/common/styles.dart';
import 'package:story_app_flutter_intermediate/model/list_story.dart';
import 'package:story_app_flutter_intermediate/provider/api_enum.dart';
import 'package:story_app_flutter_intermediate/provider/list_story_provider.dart';

class GridViewStory extends StatelessWidget {
  final int gridCount;
  const GridViewStory({super.key, required this.gridCount});

  List<Widget> _createGrid(BuildContext context, List<ListStory> stories) {
    return List<Widget>.from(
      stories.map(
        (story) {
          return GestureDetector(
            onTap: () {
              print(story.id);
            },
            child: Container(
              height: 250,
              padding: const EdgeInsets.all(8),
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    offset: Offset(0, 4),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 175,
                      width: double.infinity,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          story.photoUrl,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          story.name,
                          style: const TextStyle(
                            color: Styles.primaryColor,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          DateFormat('dd MMMM yyyy').format(story.createdAt),
                          style: const TextStyle(
                            color: Styles.textColor,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildGrid(BuildContext context, ListStoryProvider provider) {
    if (provider.state == ResultState.loading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else if (provider.state == ResultState.hasData) {
      final List<ListStory> listStory = provider.listStory;

      return GridView.count(
        crossAxisCount: gridCount,
        shrinkWrap: true,
        childAspectRatio: 1.5,
        children: _createGrid(context, listStory),
      );
    } else if (provider.state == ResultState.error) {
      return Center(
        child: Material(
          child: Text(provider.message),
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

  Widget _consumerGrid(BuildContext context) {
    return Consumer<ListStoryProvider>(
      builder: (context, provider, _) {
        return _buildGrid(context, provider);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return _consumerGrid(context);
  }
}
