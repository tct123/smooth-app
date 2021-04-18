import 'package:flutter/material.dart';
import 'package:smooth_app/pages/home_page/home_reorder_page.dart';

class HomePageWidgetList {
  HomePageWidgetList({
    this.activated,
    this.deactivated,
  });
  final List<HomePageWidgetModel> activated;
  final List<HomePageWidgetModel> deactivated;
}

class HomePageWidgetModel {
  HomePageWidgetModel({
    @required this.index,
    @required this.tag,
    @required this.child,
  });

  final int index;
  final String tag;
  final Widget child;

  Widget getWidget(BuildContext context, bool editMode,
      {bool activated, HomePageWidgetList body}) {
    return Hero(
      tag: tag,
      key: ValueKey<String>(tag),
      child: Stack(
        alignment: Alignment.topRight,
        children: <Widget>[
          IgnorePointer(
            ignoring: editMode,
            child: GestureDetector(
              onLongPress: () async => await Navigator.push(
                context,
                PageRouteBuilder<String>(
                  transitionDuration: const Duration(milliseconds: 0),
                  transitionsBuilder: (BuildContext context,
                      Animation<double> animation,
                      Animation<double> secAnimation,
                      Widget child) {
                    return FadeTransition(
                      opacity: animation,
                      child: child,
                    );
                  },
                  pageBuilder: (
                    BuildContext context,
                    Animation<double> animation,
                    Animation<double> secAnimation,
                  ) =>
                      HomeReorderPage(
                    body: body,
                  ),
                ),
              ),
              child: child,
            ),
          ),
          if (editMode)
            Container(
              width: MediaQuery.of(context).size.width / 20,
              height: MediaQuery.of(context).size.width / 20,
              alignment: Alignment.center,
              child: GestureDetector(
                child: CircleAvatar(
                  child: Icon(
                    activated ? Icons.remove : Icons.add,
                    size: MediaQuery.of(context).size.width / 20,
                  ),
                  backgroundColor: activated ? Colors.red : Colors.green,
                ),
              ),
            )
        ],
      ),
    );
  }
}
