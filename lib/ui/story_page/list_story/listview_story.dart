import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:story_app_flutter_intermediate/common/styles.dart';
import 'package:story_app_flutter_intermediate/model/story.dart';
import 'package:story_app_flutter_intermediate/provider/api_enum.dart';
import 'package:story_app_flutter_intermediate/provider/detail_story_provider.dart';
import 'package:story_app_flutter_intermediate/provider/list_story_provider.dart';

class ListViewStory extends StatelessWidget {
  final Function(String) onTap;
  const ListViewStory({super.key, required this.onTap});

  Widget _createItemList(BuildContext context, Story story) {
    return GestureDetector(
      onTap: () {
        final detailRead = context.read<DetailStoryProvider>();
        detailRead.upadteStoryId(story.id);
        onTap(story.id);
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
    );
  }

  Widget _buildList(BuildContext context) {
    final listWatch = context.watch<ListStoryProvider>();
    final listRead = context.read<ListStoryProvider>();

    if (listWatch.state == ResultState.loading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else if (listWatch.state == ResultState.hasData) {
      final List<Story> listStory = listRead.listStory;

      return ListView.builder(
        itemCount: listStory.length,
        itemBuilder: (context, index) {
          return _createItemList(context, listStory[index]);
        },
      );
    } else if (listWatch.state == ResultState.error) {
      return Center(
        child: Material(
          child: Text(listRead.message),
        ),
      );
    } else {
      return Center(
        child: Material(
          child: Text(listRead.message),
        ),
      );
    }
  }

  Widget _consumerList(BuildContext context) {
    return _buildList(context);
  }

  @override
  Widget build(BuildContext context) {
    return _consumerList(context);
  }
}
