import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:story_app_flutter_intermediate/common/styles.dart';
import 'package:story_app_flutter_intermediate/model/story.dart';
import 'package:story_app_flutter_intermediate/provider/api_enum.dart';
import 'package:story_app_flutter_intermediate/provider/detail_story_provider.dart';
import 'package:story_app_flutter_intermediate/provider/list_story_provider.dart';

class GridViewStory extends StatefulWidget {
  final int gridCount;
  final Function(String) onTap;
  const GridViewStory(
      {super.key, required this.gridCount, required this.onTap});

  @override
  State<GridViewStory> createState() => _GridViewStoryState();
}

class _GridViewStoryState extends State<GridViewStory> {
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    final listRead = context.read<ListStoryProvider>();

    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent) {
        if (listRead.page != null) {
          listRead.nextList();
        }
      }
    });

    Future.microtask(() async => listRead.nextList());
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  List<Widget> _createGrid(BuildContext context, List<Story> stories) {
    return List<Widget>.from(
      stories.map(
        (story) {
          return GestureDetector(
            onTap: () {
              final detailRead = context.read<DetailStoryProvider>();
              detailRead.upadteStoryId(story.id);
              widget.onTap(story.id);
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

  Widget _buildGrid(BuildContext context) {
    final listWatch = context.watch<ListStoryProvider>();
    final listRead = context.read<ListStoryProvider>();

    if (listWatch.state == ResultState.loading && listWatch.page == 1) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else if (listWatch.state == ResultState.hasData) {
      final List<Story> listStory = listRead.listStory;

      List<Widget> allGrid = _createGrid(context, listStory);

      if (listRead.page != null) {
        allGrid.add(
          const Center(
            child: CircularProgressIndicator(),
          ),
        );
      }

      return GridView.count(
        controller: scrollController,
        crossAxisCount: 2,
        shrinkWrap: true,
        childAspectRatio: 1.5,
        children: allGrid,
      );
    } else if (listWatch.state == ResultState.error) {
      return Center(
        child: Material(
          child: Text(listRead.message),
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
    return _buildGrid(context);
  }

  @override
  Widget build(BuildContext context) {
    return _consumerGrid(context);
  }
}
