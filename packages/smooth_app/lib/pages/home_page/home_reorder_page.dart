import 'package:flutter/material.dart';
import 'package:smooth_app/data_models/home_page_widget_model.dart';
import 'package:smooth_ui_library/buttons/smooth_simple_button.dart';

class HomeReorderPage extends StatefulWidget {
  const HomeReorderPage({@required this.body});
  final HomePageWidgetList body;

  @override
  _HomeReorderPageState createState() => _HomeReorderPageState();
}

class _HomeReorderPageState extends State<HomeReorderPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reorder')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ReorderableListView.builder(
              itemCount: widget.body.activated.length +
                      widget.body.deactivated.length ??
                  0,
              onReorder: (int oldIndex, int newIndex) {
                setState(() {
                  HomePageWidgetModel myItem;
                  if (newIndex > oldIndex) {
                    newIndex = newIndex - 1;
                  }
                  //Remove
                  if (oldIndex < widget.body.activated.length) {
                    myItem = widget.body.activated.removeAt(oldIndex);
                  } else {
                    myItem = widget.body.deactivated
                        .removeAt(oldIndex - widget.body.activated.length);
                  }

                  //Add
                  if (newIndex < widget.body.activated.length) {
                    widget.body.activated.insert(newIndex, myItem);
                  } else {
                    widget.body.deactivated.insert(
                        newIndex - widget.body.activated.length, myItem);
                  }
                });
              },
              itemBuilder: (BuildContext context, int index) {
                if (index < widget.body.activated.length) {
                  return widget.body.activated
                      .singleWhere((HomePageWidgetModel element) =>
                          element.index == index)
                      .getWidget(
                        context: context,
                        editMode: true,
                        activated: true,
                      );
                } else if (index == widget.body.activated.length + 1) {
                  print('devider');
                  return const Divider(
                    color: Colors.grey,
                  );
                } else {
                  return widget.body.deactivated
                      .singleWhere((HomePageWidgetModel element) =>
                          element.index == (index - 1))
                      .getWidget(
                        context: context,
                        editMode: true,
                        activated: false,
                      );
                }
              },
            ),
            ReorderableListView.builder(
                itemBuilder: itemBuilder,
                itemCount: itemCount,
                onReorder: onReorder)
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SmoothSimpleButton(
            height: 30,
            text: 'Save',
            onPressed: () => Navigator.pop(context, widget.body),
          ),
        ),
      ),
    );
  }
}
