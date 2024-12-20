import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story_app_flutter_intermediate/common/styles.dart';
import 'package:story_app_flutter_intermediate/provider/api_enum.dart';
import 'package:story_app_flutter_intermediate/provider/auth_provider.dart';
import 'package:story_app_flutter_intermediate/provider/list_story_provider.dart';
import 'package:story_app_flutter_intermediate/ui/story_page/list_story/gridview_story.dart';
import 'package:story_app_flutter_intermediate/ui/story_page/list_story/listview_story.dart';

class ListStoryPage extends StatefulWidget {
  final Function() onLogout;
  final Function(String) onTap;
  final BottomNavigationBar bottomNavigationBar;

  const ListStoryPage({
    super.key,
    required this.onLogout,
    required this.onTap,
    required this.bottomNavigationBar,
  });

  @override
  State<ListStoryPage> createState() => _ListStoryPageState();
}

class _ListStoryPageState extends State<ListStoryPage> {
  @override
  Widget build(BuildContext context) {
    final listWatch = context.watch<ListStoryProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Story',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () async {
              final authRead = context.read<AuthProvider>();
              final result = await authRead.logout();

              if (result) widget.onLogout();
            },
            child: context.watch<AuthProvider>().isLoadingLogout
                ? const Padding(
                    padding: EdgeInsets.only(right: 4),
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  )
                : const Icon(
                    Icons.logout,
                    color: Colors.white,
                  ),
          ),
        ],
        backgroundColor: Styles.primaryColor,
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 16),
            listWatch.state == ResultState.hasData
                ? const Text(
                    'All Story For You',
                    style: TextStyle(
                      color: Styles.primaryColor,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                : Container(),
            const SizedBox(height: 8),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth < 600) {
                    return ListViewStory(
                      onTap: widget.onTap,
                    );
                  } else if (constraints.maxWidth < 900) {
                    return GridViewStory(
                      gridCount: 2,
                      onTap: widget.onTap,
                    );
                  } else {
                    return GridViewStory(
                      gridCount: 4,
                      onTap: widget.onTap,
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: widget.bottomNavigationBar,
    );
  }
}
