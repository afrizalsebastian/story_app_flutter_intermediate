import 'package:flutter/material.dart';
import 'package:story_app_flutter_intermediate/common/styles.dart';
import 'package:story_app_flutter_intermediate/db/auth_repository.dart';
import 'package:story_app_flutter_intermediate/ui/auth/login_page.dart';
import 'package:story_app_flutter_intermediate/ui/auth/register_page.dart';
import 'package:story_app_flutter_intermediate/ui/splash_screen/splash_screen.dart';
import 'package:story_app_flutter_intermediate/ui/story_page/list_story_page.dart';
import 'package:story_app_flutter_intermediate/ui/story_page/post_story.dart';

class StoryRouterDelegate extends RouterDelegate
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  final GlobalKey<NavigatorState> _navigatorKey;
  final AuthRepository authRepository;

  List<Page> historyStack = [];
  bool? isLoggedIn;
  bool isRegister = false;

  StoryRouterDelegate(
    this.authRepository,
  ) : _navigatorKey = GlobalKey<NavigatorState>() {
    _init();
  }

  _init() async {
    isLoggedIn = await authRepository.isLoggedIn();
    notifyListeners();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoggedIn == null) {
      historyStack = _splashStack;
    } else if (isLoggedIn == true) {
      historyStack = _loggedInStack;
    } else {
      historyStack = _loggedOutStack;
    }

    return Navigator(
      key: navigatorKey,
      pages: historyStack,
      onPopPage: (route, result) {
        final didPop = route.didPop(result);
        if (!didPop) {
          return false;
        }

        isRegister = false;
        notifyListeners();

        return true;
      },
    );
  }

  @override
  GlobalKey<NavigatorState>? get navigatorKey => _navigatorKey;

  @override
  Future<void> setNewRoutePath(configuration) async {
    /** DO NOTHING */
    // throw UnimplementedError();
  }

  List<Page> get _splashStack => const [
        MaterialPage(
          key: ValueKey('SplashScreen'),
          child: SplashScreen(),
        ),
      ];

  List<Page> get _loggedOutStack => [
        MaterialPage(
          key: const ValueKey('LoginPage'),
          child: LoginPage(
            onLogin: () {
              isLoggedIn = true;
              notifyListeners();
            },
            onRegister: () {
              isRegister = true;
              notifyListeners();
            },
          ),
        ),
        if (isRegister == true)
          MaterialPage(
            key: const ValueKey('RegisterPage'),
            child: RegisterPage(
              onRegister: () {
                isRegister = false;
                notifyListeners();
              },
              onLogin: () {
                isRegister = false;
                notifyListeners();
              },
            ),
          ),
      ];

  int _bottomNavIndex = 0;
  String? storyId;
  bool onPostStory = false;

  BottomNavigationBar bottomNavigationBar() {
    return BottomNavigationBar(
      selectedItemColor: Styles.primaryColor,
      currentIndex: _bottomNavIndex,
      onTap: (value) {
        _bottomNavIndex = value;
        if (value == 1) {
          onPostStory = true;
          notifyListeners();
        } else {
          onPostStory = false;
          notifyListeners();
        }
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_rounded),
          label: "Home",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.post_add_rounded),
          label: "Post Story",
        )
      ],
    );
  }

  List<Page> get _loggedInStack => [
        MaterialPage(
          key: ValueKey('ListStoryPage'),
          child: ListStoryPage(
            bottomNavigationBar: bottomNavigationBar(),
          ),
        ),
        if (onPostStory == true)
          MaterialPage(
            key: const ValueKey('PostStoryPage'),
            child: PostStory(
              bottomNavigationBar: bottomNavigationBar(),
            ),
          ),
      ];
}
