import 'package:flutter/material.dart';
import 'package:fortune_wheel_demo/router.gr.dart';
import 'package:fortune_wheel_demo/theme.dart';
import 'util/configure_non_web.dart'
    if (dart.library.html) 'util/configure_web.dart';

void main() {
  configureApp();
  runApp(DemoApp());
}

class DemoApp extends StatefulWidget {
  @override
  _DemoAppState createState() => _DemoAppState();
}

class _DemoAppState extends State<DemoApp> {
  final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return ThemeModeProvider(
      builder: (context, themeMode) {
        return MaterialApp.router(
          title: 'Fortune Wheel Demo',
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: themeMode,
          routerDelegate: _appRouter.delegate(initialRoutes: [
            FortuneWheelRoute(),
          ]),
          routeInformationParser: _appRouter.defaultRouteParser(),
        );
      },
    );
  }
}
