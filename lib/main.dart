import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story_app_flutter_intermediate/api/api_services.dart';
import 'package:story_app_flutter_intermediate/db/auth_repository.dart';
import 'package:story_app_flutter_intermediate/provider/auth_provider.dart';
import 'package:story_app_flutter_intermediate/provider/detail_story_provider.dart';
import 'package:story_app_flutter_intermediate/provider/list_story_provider.dart';
import 'package:story_app_flutter_intermediate/provider/post_story_provider.dart';
import 'package:story_app_flutter_intermediate/provider/upload_provider.dart';
import 'package:story_app_flutter_intermediate/routes/router_delegate.dart';

void main() {
  runApp(const StoryApp());
}

class StoryApp extends StatefulWidget {
  const StoryApp({super.key});

  @override
  State<StoryApp> createState() => _StoryAppState();
}

class _StoryAppState extends State<StoryApp> {
  late StoryRouterDelegate storyRouterDelegate;
  late AuthProvider authProvider;

  @override
  void initState() {
    super.initState();
    final authRepository = AuthRepository();
    authProvider = AuthProvider(
      authRepository,
      ApiServices(),
    );
    storyRouterDelegate = StoryRouterDelegate(authRepository);
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => authProvider),
        ChangeNotifierProvider(
          create: (context) => ListStoryProvider(
            apiServices: ApiServices(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) =>
              DetailStoryProvider(apiServices: ApiServices(), storyId: ''),
        ),
        ChangeNotifierProvider(create: (context) => PostStoryProvider()),
        ChangeNotifierProvider(
          create: (context) => UploadProvider(
            apiService: ApiServices(),
          ),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Router(
          routerDelegate: storyRouterDelegate,
          backButtonDispatcher: RootBackButtonDispatcher(),
        ),
      ),
    );
  }
}
