import 'package:auto_route/auto_route.dart';
import 'package:fortune_wheel_demo/pages/bar.dart';
import 'package:fortune_wheel_demo/pages/home.dart';
import 'package:fortune_wheel_demo/pages/wheel.dart';

@MaterialAutoRouter(
  replaceInRouteName: 'Page,Route',
  routes: <AutoRoute>[
    AutoRoute(
      path: '/',
      page: HomePage,
      usesTabsRouter: true,
      children: [
        AutoRoute(path: 'wheel', page: FortuneWheelPage),
        AutoRoute(path: 'bar', page: FortuneBarPage),
      ],
      initial: true,
    ),
  ],
)
class $AppRouter {}
