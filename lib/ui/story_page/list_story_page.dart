import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListStoryPage extends StatelessWidget {
  const ListStoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(children: [
          Text('LIST STORY PAGE'),
          ElevatedButton(
              onPressed: () async {
                final preferences = await SharedPreferences.getInstance();
                final token = preferences.getString("authToken") ?? "";

                print(token);
              },
              child: Text('Test'))
        ]),
      ),
    );
  }
}
