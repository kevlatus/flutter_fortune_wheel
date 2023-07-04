import 'package:go_router/go_router.dart';

import 'pages/pages.dart';

final router = GoRouter(
  routes: [
    GoRoute(
        path: '/',
        builder: (context, state) => FortuneWheelPage(),
        name: FortuneWheelPage.kRouteName),
    GoRoute(
        path: '/bar',
        builder: (context, state) => FortuneBarPage(),
        name: FortuneBarPage.kRouteName),
  ],
);
