import 'package:flutter/material.dart';
import 'package:story_app_flutter_intermediate/db/auth_repository.dart';
import 'package:story_app_flutter_intermediate/ui/auth/login_page.dart';
import 'package:story_app_flutter_intermediate/ui/splash_screen/splash_screen.dart';
import 'package:story_app_flutter_intermediate/ui/story_page/list_story_page.dart';

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

  List<Page> get _loggedOutStack => const [
        MaterialPage(
          key: ValueKey('LoginPage'),
          child: LoginPage(),
        ),
      ];

  List<Page> get _loggedInStack => const [
        MaterialPage(
          key: ValueKey('ListStoryPage'),
          child: ListStoryPage(),
        ),
      ];
}
