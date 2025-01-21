import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:openfoodfacts/openfoodfacts.dart';
import 'package:provider/provider.dart';
import 'package:smooth_app/data_models/preferences/user_preferences.dart';
import 'package:smooth_app/generic_lib/buttons/smooth_simple_button.dart';
import 'package:smooth_app/knowledge_panel/knowledge_panels_builder.dart';
import 'package:smooth_app/pages/folksonomy/folksonomy_card.dart';
import 'package:smooth_app/pages/preferences/user_preferences_dev_mode.dart';
import 'package:smooth_app/pages/prices/prices_card.dart';
import 'package:smooth_app/pages/product/product_page/header/reorder_bottom_sheet.dart';
import 'package:smooth_app/pages/product/website_card.dart';
import 'package:smooth_app/themes/smooth_theme.dart';
import 'package:smooth_app/themes/smooth_theme_colors.dart';

class ProductTab {
  ProductTab({
    required this.labelBuilder,
    required this.builder,
  });

  final Widget Function(BuildContext) labelBuilder;
  final Widget Function(Product) builder;
}

class ProductTabBar extends StatelessWidget {
  const ProductTabBar({
    required this.tabController,
    required this.tabs,
  });

  final TabController tabController;
  final List<ProductTab> tabs;

  @override
  Widget build(BuildContext context) {
    final SmoothColorsThemeExtension themeExtension =
        context.extension<SmoothColorsThemeExtension>();

    return SliverPersistentHeader(
      delegate: TabBarDelegate(
        TabBar(
          controller: tabController,
          isScrollable: true,
          tabs: tabs
              .map((ProductTab tab) => Tab(
                    child: tab.labelBuilder(context),
                  ))
              .toList(growable: false),
          labelColor: Theme.of(context).primaryColor,
          labelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15.0,
          ),
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15.0,
          ),
          overlayColor: WidgetStateProperty.all(
            themeExtension.primaryLight,
          ),
          dividerColor: themeExtension.primaryNormal,
          automaticIndicatorColorAdjustment: false,
          indicatorSize: TabBarIndicatorSize.tab,
          indicator: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Theme.of(context).primaryColor,
                width: 3.0,
              ),
            ),
            color: themeExtension.primaryLight,
          ),
          tabAlignment: TabAlignment.start,
        ),
      ),
      pinned: true,
    );
  }

  static List<ProductTab> extractTabsFromProduct({
    required BuildContext context,
    required Product product,
  }) {
    final List<ProductTab> tabs = <ProductTab>[];

    final List<KnowledgePanelElement> roots =
        KnowledgePanelsBuilder.getRootPanelElements(product);
    for (final KnowledgePanelElement root in roots) {
      final List<Widget> children = KnowledgePanelsBuilder.getChildren(
        context,
        panelElement: root,
        product: product,
        onboardingMode: false,
      );

      tabs.add(
        ProductTab(
          labelBuilder: (BuildContext c) =>
              Text((children.first as KnowledgePanelTitle).title),
          builder: (Product p) => ListView(
            padding: EdgeInsets.zero,
            children: KnowledgePanelsBuilder.getChildren(
              context,
              panelElement: root,
              product: p,
              onboardingMode: false,
            ).sublist(1),
          ),
        ),
      );
    }

    return _addHardCodedTabs(context, product, tabs);
  }

  static List<ProductTab> _addHardCodedTabs(
    BuildContext context,
    Product product,
    List<ProductTab> tabs,
  ) {
    tabs.insert(
      0,
      ProductTab(
        labelBuilder: (BuildContext c) =>
            Text(AppLocalizations.of(context).for_me),
        builder: (Product p) => Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SmoothSimpleButton(
              onPressed: () {
                showSmoothReorderBottomSheet<ProductTab>(
                  context,
                  items: tabs.map((ProductTab tab) {
                    return ReorderableItem<ProductTab>(data: tab);
                  }).toList(),
                  onReorder:
                      (List<ReorderableItem<ProductTab>> reorderedItems) {
                    tabs.clear();
                    tabs.addAll(
                      reorderedItems.map((ReorderableItem<ProductTab> item) {
                        return item.data;
                      }).toList(),
                    );
                  },
                  labelBuilder: (
                    BuildContext context,
                    ReorderableItem<ProductTab> item,
                    int index,
                  ) {
                    return DefaultTextStyle.merge(
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                      child: item.data.labelBuilder(context),
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
    if (product.website != null && product.website!.trim().isNotEmpty) {
      tabs.add(
        ProductTab(
          labelBuilder: (BuildContext c) =>
              Text(AppLocalizations.of(context).website),
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
      ProductTab(
        labelBuilder: (BuildContext c) =>
            Text(AppLocalizations.of(context).prices),
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
        ProductTab(
          labelBuilder: (BuildContext c) =>
              Text(AppLocalizations.of(context).folksonomy),
          builder: (Product p) => ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[FolksonomyCard(p)],
          ),
        ),
      );
    }

    return tabs;
  }
}

class TabBarDelegate extends SliverPersistentHeaderDelegate {
  TabBarDelegate(this.tabBar);

  final TabBar tabBar;

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  double get maxExtent => tabBar.preferredSize.height;

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
  bool shouldRebuild(covariant TabBarDelegate oldDelegate) {
    return tabBar != oldDelegate.tabBar;
  }
}
