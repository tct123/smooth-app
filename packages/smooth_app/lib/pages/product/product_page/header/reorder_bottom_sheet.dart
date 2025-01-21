import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smooth_app/generic_lib/bottom_sheets/smooth_bottom_sheet.dart';
import 'package:smooth_app/generic_lib/design_constants.dart';
import 'package:smooth_app/resources/app_icons.dart' as icons;
import 'package:smooth_app/themes/smooth_theme_colors.dart';

class ReorderBottomSheet<T> extends StatelessWidget {
  const ReorderBottomSheet({
    required this.items,
    required this.onReorder,
    required this.labelBuilder,
    this.onVisibilityToggle,
    required this.title,
  });

  final List<ReorderableItem<T>> items;
  final ValueChanged<List<ReorderableItem<T>>> onReorder;
  final LabelBuilder<T> labelBuilder;
  final ValueChanged<ReorderableItem<T>>? onVisibilityToggle;
  final String title;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ReorderBottomSheetProvider<T>>(
      create: (_) => ReorderBottomSheetProvider<T>(items),
      child: Consumer<ReorderBottomSheetProvider<T>>(
        builder:
            (BuildContext context, ReorderBottomSheetProvider<T> provider, _) {
          return DraggableScrollableSheet(
            expand: false,
            initialChildSize: 0.6,
            maxChildSize: 0.9,
            minChildSize: 0.4,
            builder: (_, ScrollController scrollController) {
              return ClipRRect(
                borderRadius: const BorderRadius.vertical(top: ROUNDED_RADIUS),
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).canvasColor,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const SmoothModalSheetHeader(
                        title: 'Reorder tabs',
                      ),
                      Expanded(
                        child: ReorderableListView.builder(
                          scrollController: scrollController,
                          padding: const EdgeInsets.all(MEDIUM_SPACE),
                          proxyDecorator: (
                            Widget child,
                            int index,
                            Animation<double> animation,
                          ) =>
                              Transform.scale(
                            scale: 1.0 + (0.05 * animation.value),
                            child: Opacity(
                              opacity: 0.8,
                              child: child,
                            ),
                          ),
                          itemBuilder: (BuildContext context, int index) {
                            final ReorderableItem<T> item =
                                provider.items[index];
                            return Container(
                              key: ValueKey<T>(item.data),
                              margin:
                                  const EdgeInsets.only(bottom: MEDIUM_SPACE),
                              padding: const EdgeInsets.all(12.0),
                              decoration: BoxDecoration(
                                color: item.visible
                                    ? SmoothColorsThemeExtension.defaultValues()
                                        .primaryMedium
                                    : SmoothColorsThemeExtension.defaultValues()
                                        .primaryLight,
                                borderRadius: ROUNDED_BORDER_RADIUS,
                              ),
                              child: Row(
                                children: <Widget>[
                                  if (onVisibilityToggle != null)
                                    Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: SmoothColorsThemeExtension
                                                .defaultValues()
                                            .primarySemiDark,
                                      ),
                                      child: IconButton(
                                        visualDensity: VisualDensity.compact,
                                        iconSize: 16.0,
                                        icon: const icons.Eye.visible(
                                          color: Colors.white,
                                        ),
                                        onPressed: () =>
                                            onVisibilityToggle?.call(item),
                                      ),
                                    ),
                                  if (onVisibilityToggle != null)
                                    const SizedBox(width: MEDIUM_SPACE),
                                  labelBuilder(context, item, index),
                                  const Spacer(),
                                  Icon(
                                    Icons.drag_handle,
                                    color: SmoothColorsThemeExtension
                                            .defaultValues()
                                        .primaryDark,
                                  ),
                                ],
                              ),
                            );
                          },
                          itemCount: provider.items.length,
                          onReorder: (int oldIndex, int newIndex) {
                            provider.reorder(oldIndex, newIndex);
                            onReorder(provider.items);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class ReorderableItem<T> {
  ReorderableItem({required this.data, this.visible = true});

  final T data;
  bool visible;

  ReorderableItem<T> copyWith({bool? visible}) {
    return ReorderableItem<T>(
      data: data,
      visible: visible ?? this.visible,
    );
  }
}

class ReorderBottomSheetProvider<T> extends ChangeNotifier {
  ReorderBottomSheetProvider(this.items);

  List<ReorderableItem<T>> items;

  void reorder(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    final ReorderableItem<T> item = items.removeAt(oldIndex);
    items.insert(newIndex, item);
    notifyListeners();
  }

  void toggleVisibility(ReorderableItem<T> item) {
    final int index = items.indexOf(item);
    if (index != -1) {
      items[index] = item.copyWith(visible: !item.visible);
      notifyListeners();
    }
  }
}

typedef LabelBuilder<T> = Widget Function(
  BuildContext context,
  ReorderableItem<T> item,
  int index,
);

void showSmoothReorderBottomSheet<T>(
  BuildContext context, {
  required List<ReorderableItem<T>> items,
  required ValueChanged<List<ReorderableItem<T>>> onReorder,
  required LabelBuilder<T> labelBuilder,
  String title = 'Reorder Items',
}) {
  showSmoothModalSheet(
    context: context,
    minHeight: 0.6,
    builder: (_) => ReorderBottomSheet<T>(
      items: items,
      onReorder: onReorder,
      labelBuilder: labelBuilder,
      title: title,
    ),
  );
}
