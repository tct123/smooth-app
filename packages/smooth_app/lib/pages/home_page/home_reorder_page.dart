import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:smooth_app/data_models/home_page_widget_model.dart';
import 'package:smooth_ui_library/buttons/smooth_simple_button.dart';

class HomeReorderPage extends StatefulWidget {
  const HomeReorderPage({@required this.body});
  final HomePageWidgetList body;

  @override
  _HomeReorderPageState createState() => _HomeReorderPageState();
}

class _HomeReorderPageState extends State<HomeReorderPage> {
  Future<void> showSheet() async {
    for (final HomePageWidgetModel i in widget.body.deactivated) {
      print(i.tag);
    }
    return showMaterialModalBottomSheet(
      context: context,
      builder: (BuildContext context) => ListView.builder(
        controller: ModalScrollController.of(context),
        itemCount:
            widget.body.activated.length + widget.body.deactivated.length,
        itemBuilder: (BuildContext context, int index) {
          HomePageWidgetModel item;
          if (index < widget.body.activated.length) {
            item = widget.body.activated.singleWhere(
                (HomePageWidgetModel element) => element.index == index);
          } else {
            item = widget.body.deactivated.singleWhere(
                (HomePageWidgetModel element) => element.index == index);
          }
          return ListTile(
            title: Text(item.tag),
            trailing: Checkbox(
              value: widget.body.activated.contains(item),
              onChanged: (bool value) {
                setState(() {
                  if (widget.body.activated.contains(item)) {
                    widget.body.activated.remove(item);
                    widget.body.deactivated.insert(0, item);
                  } else {
                    widget.body.deactivated.remove(item);
                    widget.body.activated.insert(0, item);
                  }
                });
              },
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reorder')),
      body: ReorderableListView.builder(
        itemCount: widget.body.activated.length,
        onReorder: (int oldIndex, int newIndex) {
          setState(() {
            if (newIndex > oldIndex) {
              newIndex = newIndex - 1;
            }
          });
        },
        itemBuilder: (BuildContext context, int index) {
          return widget.body.activated
              .singleWhere(
                  (HomePageWidgetModel element) => element.index == index)
              .getWidget(
                context: context,
                editMode: true,
                activated: true,
              );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              SmoothSimpleButton(
                height: 30,
                text: 'Manage',
                onPressed: showSheet,
              ),
              SmoothSimpleButton(
                height: 30,
                text: 'Save',
                onPressed: () => Navigator.pop(context, widget.body),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
