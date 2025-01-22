import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:openfoodfacts/openfoodfacts.dart';
import 'package:provider/provider.dart';
import 'package:smooth_app/data_models/preferences/user_preferences.dart';
import 'package:smooth_app/generic_lib/bottom_sheets/smooth_bottom_sheet.dart';
import 'package:smooth_app/generic_lib/buttons/smooth_simple_button.dart';
import 'package:smooth_app/knowledge_panel/knowledge_panels_builder.dart';
import 'package:smooth_app/pages/folksonomy/folksonomy_card.dart';
import 'package:smooth_app/pages/preferences/user_preferences_dev_mode.dart';
import 'package:smooth_app/pages/prices/prices_card.dart';
import 'package:smooth_app/pages/product/product_page/header/reorder_bottom_sheet.dart';
import 'package:smooth_app/pages/product/website_card.dart';
import 'package:smooth_app/widgets/smooth_tabbar.dart';

class ProductPageTab {
  const ProductPageTab({
    required this.labelBuilder,
    required this.builder,
  });

  final String Function(BuildContext) labelBuilder;
  final Widget Function(Product) builder;
}

class ProductPageTabBar extends StatelessWidget {
  const ProductPageTabBar({
    required this.tabController,
    required this.tabs,
  });

  final TabController tabController;
  final List<ProductPageTab> tabs;

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      delegate: _TabBarDelegate(
        PreferredSize(
            preferredSize: const Size.fromHeight(SmoothTabBar.TAB_BAR_HEIGHT),
            child: SmoothTabBar<ProductPageTab>(
              tabController: tabController,
              items: tabs.map((ProductPageTab tab) {
                return SmoothTabBarItem<ProductPageTab>(
                  label: tab.labelBuilder(context),
                  value: tab,
                );
              }).toList(),
              onTabChanged: (ProductPageTab tab) {},
            )),
      ),
      pinned: true,
    );
  }

  static List<ProductPageTab> extractTabsFromProduct({
    required BuildContext context,
    required Product product,
  }) {
    final List<ProductPageTab> tabs = <ProductPageTab>[];

    final List<KnowledgePanelElement> roots =
        KnowledgePanelsBuilder.getRootPanelElements(product);
    for (final KnowledgePanelElement root in roots) {
      List<Widget> children = KnowledgePanelsBuilder.getChildren(
        context,
        panelElement: root,
        product: product,
        onboardingMode: false,
      );

      final KnowledgePanelTitle knowledgePanelTitle =
          children.first as KnowledgePanelTitle;

      children = children.sublist(1);

      tabs.add(
        ProductPageTab(
          labelBuilder: (BuildContext c) => knowledgePanelTitle.title,
          builder: (Product p) => ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: children.length - 1,
            itemBuilder: (BuildContext context, int index) => children[index],
          ),
        ),
      );
    }

    return _addHardCodedTabs(context, product, tabs);
  }

  static List<ProductPageTab> _addHardCodedTabs(
    BuildContext context,
    Product product,
    List<ProductPageTab> tabs,
  ) {
    tabs.insert(
      0,
      ProductPageTab(
        labelBuilder: (BuildContext c) =>
            AppLocalizations.of(c).product_page_tab_for_me,
        builder: (Product p) => Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SmoothSimpleButton(
              onPressed: () {
                showSmoothReorderBottomSheet<ProductPageTab>(
                  context,
                  items: tabs.map((ProductPageTab tab) {
                    return tab;
                  }).toList(),
                  onReorder: (List<ProductPageTab> reorderedItems) {
                    tabs.clear();
                    tabs.addAll(reorderedItems);
                  },
                  labelBuilder: (
                    BuildContext context,
                    ProductPageTab item,
                    int index,
                  ) {
                    return DefaultTextStyle.merge(
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                      child: Text(item.labelBuilder(context)),
                    );
                  },
                );
              },
              child: const Text('Reorder tabs'),
            ),
          ],
        ),
      ),
    );
    if (product.website?.trim().isNotEmpty == true) {
      tabs.add(
        ProductPageTab(
          labelBuilder: (BuildContext c) =>
              AppLocalizations.of(c).product_page_tab_website,
          builder: (Product p) => ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              WebsiteCard(p.website!),
            ],
          ),
        ),
      );
    }
    tabs.add(
      ProductPageTab(
        labelBuilder: (BuildContext c) =>
            AppLocalizations.of(c).product_page_tab_prices,
        builder: (Product p) => ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            PricesCard(p),
          ],
        ),
      ),
    );

    if (context.read<UserPreferences>().getFlag(
            UserPreferencesDevMode.userPreferencesFlagHideFolksonomy) ==
        false) {
      tabs.add(
        ProductPageTab(
          labelBuilder: (BuildContext c) =>
              AppLocalizations.of(c).product_page_tab_folksonomy,
          builder: (Product p) => ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[FolksonomyCard(p)],
          ),
        ),
      );
    }

    return tabs;
  }

  static void showSmoothReorderBottomSheet<T>(
    BuildContext context, {
    required List<T> items,
    required ValueChanged<List<T>> onReorder,
    ValueChanged<T>? onVisibilityToggle,
    required LabelBuilder<T> labelBuilder,
    String title = 'Reorder Items',
  }) {
    showSmoothModalSheet(
      context: context,
      minHeight: 0.6,
      builder: (_) => ReorderBottomSheet<T>(
        items: items,
        onReorder: onReorder,
        onVisibilityToggle: onVisibilityToggle,
        labelBuilder: labelBuilder,
        title: title,
      ),
    );
  }
}

class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  _TabBarDelegate(this.tabBar);

  final PreferredSizeWidget tabBar;

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  double get maxExtent => minExtent;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(covariant _TabBarDelegate oldDelegate) {
    return tabBar != oldDelegate.tabBar;
  }
}
