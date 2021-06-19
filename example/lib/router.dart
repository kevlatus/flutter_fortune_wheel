import 'package:auto_route/auto_route.dart';

import 'pages/pages.dart';

@CustomAutoRouter(
  replaceInRouteName: 'Page,Route',
  transitionsBuilder: TransitionsBuilders.fadeIn,
  routes: <AutoRoute>[
    AutoRoute(path: '/', page: FortuneWheelPage),
    AutoRoute(path: '/bar', page: FortuneBarPage),
  ],
)
class $AppRouter {}
