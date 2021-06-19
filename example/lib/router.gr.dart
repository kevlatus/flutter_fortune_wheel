// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

import 'package:auto_route/auto_route.dart' as _i1;
import 'package:flutter/material.dart' as _i2;

import 'pages/pages.dart' as _i3;

class AppRouter extends _i1.RootStackRouter {
  AppRouter([_i2.GlobalKey<_i2.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i1.PageFactory> pagesMap = {
    FortuneWheelRoute.name: (routeData) => _i1.CustomPage<dynamic>(
        routeData: routeData,
        builder: (_) {
          return _i3.FortuneWheelPage();
        },
        transitionsBuilder: _i1.TransitionsBuilders.fadeIn,
        opaque: true,
        barrierDismissible: false),
    FortuneBarRoute.name: (routeData) => _i1.CustomPage<dynamic>(
        routeData: routeData,
        builder: (_) {
          return _i3.FortuneBarPage();
        },
        transitionsBuilder: _i1.TransitionsBuilders.fadeIn,
        opaque: true,
        barrierDismissible: false)
  };

  @override
  List<_i1.RouteConfig> get routes => [
        _i1.RouteConfig(FortuneWheelRoute.name, path: '/'),
        _i1.RouteConfig(FortuneBarRoute.name, path: '/bar')
      ];
}

class FortuneWheelRoute extends _i1.PageRouteInfo {
  const FortuneWheelRoute() : super(name, path: '/');

  static const String name = 'FortuneWheelRoute';
}

class FortuneBarRoute extends _i1.PageRouteInfo {
  const FortuneBarRoute() : super(name, path: '/bar');

  static const String name = 'FortuneBarRoute';
}
