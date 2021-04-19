import 'package:flutter/material.dart';
import 'package:smooth_app/pages/home_page/home_reorder_page.dart';

class HomePageWidgetList {
  HomePageWidgetList({
    @required this.activated,
    @required this.deactivated,
    this.indexList,
  });
  final List<HomePageWidgetModel> activated;
  final List<HomePageWidgetModel> deactivated;
  final List<Map<String, int>> indexList;
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

  Widget getWidget({
    @required BuildContext context,
    @required bool editMode,
    bool activated,
    HomePageWidgetList body,
  }) {
    return Hero(
      tag: tag,
      key: ValueKey<String>(tag),
      child: Container(
        padding: editMode
            ? const EdgeInsets.fromLTRB(10, 5, 10, 5)
            : const EdgeInsets.all(0),
        color: activated ?? true ? Colors.transparent : Colors.grey,
        child: Stack(
          alignment: Alignment.topRight,
          children: <Widget>[
            IgnorePointer(
              ignoring: editMode,
              child: GestureDetector(
                //ToDo: switch to on lang tap
                onDoubleTap: () async => await Navigator.push(
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
      ),
    );
  }
}
