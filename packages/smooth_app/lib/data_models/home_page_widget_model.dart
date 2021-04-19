import 'package:flutter/material.dart';

class HomePageWidgetModel {
  HomePageWidgetModel({
    @required this.tag,
    @required this.child,
    this.activated = true,
  });

  final String tag;
  final Widget child;
  bool activated;

  Widget getWidget({
    @required BuildContext context,
    @required bool editMode,
    List<HomePageWidgetModel> body,
    Function navigationFunction,
  }) {
    return Hero(
      tag: tag,
      key: ValueKey<String>(tag),
      child: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Container(
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
                    onLongPress: navigationFunction,
                    child: child,
                  ),
                ),
                if (editMode)
                  Container(
                    width: MediaQuery.of(context).size.width / 20,
                    height: MediaQuery.of(context).size.width / 20,
                    alignment: Alignment.center,
                    child: GestureDetector(
                      onTap: () {
                        activated = !activated;
                        setState(() {});
                      },
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
        },
      ),
    );
  }
}
