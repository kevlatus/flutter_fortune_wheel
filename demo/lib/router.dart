import 'package:auto_route/auto_route.dart';
import 'package:fortune_wheel_demo/pages/bar.dart';
import 'package:fortune_wheel_demo/pages/wheel.dart';

@CustomAutoRouter(
  replaceInRouteName: 'Page,Route',
  transitionsBuilder: TransitionsBuilders.fadeIn,
  routes: <AutoRoute>[
    AutoRoute(path: '/wheel', page: FortuneWheelPage),
    AutoRoute(path: '/bar', page: FortuneBarPage),
  ],
)
class $AppRouter {}
