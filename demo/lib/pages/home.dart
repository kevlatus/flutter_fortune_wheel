import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:fortune_wheel_demo/router.gr.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AutoTabsRouter(
      routes: [
        FortuneWheelRoute(),
        FortuneBarRoute(),
      ],
      duration: Duration(milliseconds: 300),
      builder: (context, child, animation) {
        final tabsRouter = context.tabsRouter;

        return Scaffold(
          appBar: AppBar(
            title: Text('Fortune Wheel Demo'),
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: tabsRouter.activeIndex,
            onTap: (index) {
              tabsRouter.setActiveIndex(index);
            },
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.circle),
                label: 'Wheel',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.linear_scale),
                label: 'Bar',
              ),
            ],
          ),
          body: FadeTransition(
            child: child,
            opacity: animation,
          ),
        );
      },
    );
  }
}
