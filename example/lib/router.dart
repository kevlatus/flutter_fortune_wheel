import 'package:auto_route/auto_route.dart';
import 'package:flutter_fortune_wheel_example/pages/pages.dart';

@CustomAutoRouter(
  replaceInRouteName: 'Page,Route',
  transitionsBuilder: TransitionsBuilders.fadeIn,
  routes: <AutoRoute>[
    AutoRoute(path: '/', page: FortuneWheelPage),
    AutoRoute(path: '/bar', page: FortuneBarPage),
  ],
)
class $AppRouter {}
