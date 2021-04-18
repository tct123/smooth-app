import 'package:flutter/material.dart';
import 'package:smooth_app/data_models/home_page_widget_model.dart';
import 'package:smooth_ui_library/buttons/smooth_simple_button.dart';

class HomeReorderPage extends StatefulWidget {
  const HomeReorderPage({this.body});
  final HomePageWidgetList body;

  @override
  _HomeReorderPageState createState() => _HomeReorderPageState();
}

class _HomeReorderPageState extends State<HomeReorderPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reorder')),
      body: ListView.builder(
        itemCount:
            widget.body.activated.length + widget.body.deactivated.length,
        itemBuilder: (BuildContext context, int index) {
          if (index < widget.body.activated.length) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
              child: widget.body.activated
                  .singleWhere(
                      (HomePageWidgetModel element) => element.index == index)
                  .getWidget(context, true, activated: true),
            );
          } else {
            return Container(
              color: Colors.grey,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                child: widget.body.deactivated
                    .singleWhere(
                        (HomePageWidgetModel element) => element.index == index)
                    .getWidget(context, true, activated: false),
              ),
            );
          }
        },
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
