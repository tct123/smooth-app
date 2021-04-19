import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:smooth_app/data_models/home_page_widget_model.dart';
import 'package:smooth_ui_library/buttons/smooth_simple_button.dart';

class HomeReorderPage extends StatefulWidget {
  const HomeReorderPage({@required this.body});
  final List<HomePageWidgetModel> body;

  @override
  _HomeReorderPageState createState() => _HomeReorderPageState();
}

class _HomeReorderPageState extends State<HomeReorderPage> {
  Future<void> showSheet() async {
    return showMaterialModalBottomSheet(
      context: context,
      builder: (BuildContext context) => ListView.builder(
        controller: ModalScrollController.of(context),
        itemCount: widget.body.length,
        itemBuilder: (BuildContext context, int index) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return CheckboxListTile(
                title: Text(widget.body[index].tag),
                value: widget.body[index].activated,
                controlAffinity: ListTileControlAffinity.trailing,
                onChanged: (bool value) {
                  setState(() {
                    print(value);
                    widget.body[index].activated = value;
                  });
                },
              );
            },
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
        itemCount: widget.body.length,
        onReorder: (int oldIndex, int newIndex) {
          setState(() {
            if (newIndex > oldIndex) {
              newIndex = newIndex - 1;
            }

            final HomePageWidgetModel item = widget.body.removeAt(oldIndex);
            widget.body.insert(newIndex, item);
          });
        },
        itemBuilder: (BuildContext context, int index) {
          return widget.body[index].getWidget(context: context, editMode: true);
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
