import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story_app_flutter_intermediate/api/api_services.dart';
import 'package:story_app_flutter_intermediate/common/styles.dart';
import 'package:story_app_flutter_intermediate/provider/api_enum.dart';
import 'package:story_app_flutter_intermediate/provider/list_story_provider.dart';
import 'package:story_app_flutter_intermediate/ui/story_page/gridview_story.dart';
import 'package:story_app_flutter_intermediate/ui/story_page/listview_story.dart';

class ListStoryPage extends StatefulWidget {
  final BottomNavigationBar bottomNavigationBar;

  const ListStoryPage({super.key, required this.bottomNavigationBar});

  @override
  State<ListStoryPage> createState() => _ListStoryPageState();
}

class _ListStoryPageState extends State<ListStoryPage> {
  final ListStoryProvider _listStoryProvider = ListStoryProvider(
    apiServices: ApiServices(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Story',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: Styles.primaryColor,
      ),
      body: ChangeNotifierProvider<ListStoryProvider>(
        create: (_) => _listStoryProvider,
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 16),
              Consumer<ListStoryProvider>(
                builder: (context, provider, child) {
                  return provider.state == ResultState.hasData
                      ? const Text(
                          'All Story For You',
                          style: TextStyle(
                            color: Styles.primaryColor,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        )
                      : Container();
                },
              ),
              const SizedBox(height: 8),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    if (constraints.maxWidth < 600) {
                      return const ListViewStory();
                    } else if (constraints.maxWidth < 900) {
                      return const GridViewStory(gridCount: 2);
                    } else {
                      return const GridViewStory(gridCount: 4);
                    }
                  },
                ),
              ),
              Consumer<ListStoryProvider>(
                builder: (context, provider, child) {
                  return provider.state == ResultState.hasData
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            if (provider.page != 1)
                              TextButton(
                                onPressed: () {
                                  provider.prevoiusPage();
                                },
                                child: const Row(
                                  children: [
                                    Icon(
                                      Icons.keyboard_double_arrow_left_rounded,
                                      color: Styles.primaryColor,
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      'Previous',
                                      style:
                                          TextStyle(color: Styles.primaryColor),
                                    )
                                  ],
                                ),
                              ),
                            if (provider.listStory.length >= provider.size)
                              TextButton(
                                onPressed: () {
                                  provider.nextPage();
                                },
                                child: const Row(
                                  children: [
                                    Text(
                                      'Next',
                                      style:
                                          TextStyle(color: Styles.primaryColor),
                                    ),
                                    SizedBox(width: 4),
                                    Icon(
                                      Icons.keyboard_double_arrow_right_rounded,
                                      color: Styles.primaryColor,
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        )
                      : Container();
                },
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: widget.bottomNavigationBar,
    );
  }
}
