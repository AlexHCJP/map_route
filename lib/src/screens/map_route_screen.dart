import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:graphify/graphify.dart';
import 'package:map_route/map_route.dart';
import 'package:map_route/src/screens/grouped_list_page.dart';
import 'list_page.dart';

class MapRouteScreen extends StatefulWidget {
  const MapRouteScreen({
    super.key,
    required this.registry,
    this.views = MViewType.values,
  });

  final MRouteRegistry registry;
  final List<MViewType> views;

  Future<void> view(BuildContext context) async {
    return Navigator.of(
      context,
    ).push<void>(MaterialPageRoute(builder: (context) => this));
  }

  @override
  State<MapRouteScreen> createState() => _MapRouteScreenState();
}

class _MapRouteScreenState extends State<MapRouteScreen> {
  late final PageController _pageController;
  static const _unknownCategory = 'unknown screen';

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  List<MViewType> get views {
    return widget.views;
  }

  Map<MViewType, _ItemPage> get pageByViewType {
    final groupedRoutes = <String, List<MRouteItem>>{};

    for (final route in widget.registry.routes) {
      final category = _normalizedCategory(route.category);
      groupedRoutes.putIfAbsent(category, () => <MRouteItem>[]).add(route);
    }

    final sortedCategories = groupedRoutes.keys.toList()
      ..sort((a, b) {
        if (a == _unknownCategory) return -1;
        if (b == _unknownCategory) return 1;
        return a.compareTo(b);
      });

    final categoryIndexByName = <String, int>{
      for (var i = 0; i < sortedCategories.length; i++) sortedCategories[i]: i,
    };

    final routeIndexByTitle = <String, int>{
      for (final entry in widget.registry.routes.asMap().entries)
        entry.value.screenType.toString(): entry.key,
    };

    final degreeByRoute = <MRouteItem, int>{
      for (final route in widget.registry.routes) route: 0,
    };
    for (final edge in widget.registry.edges) {
      degreeByRoute.update(edge.from, (value) => value + 1, ifAbsent: () => 1);
      degreeByRoute.update(edge.to, (value) => value + 1, ifAbsent: () => 1);
    }

    final graphNodes = widget.registry.routes.asMap().entries.map((entry) {
      final route = entry.value;
      final category = _normalizedCategory(route.category);
      final degree = degreeByRoute[route] ?? 0;

      return <String, Object>{
        'id': entry.key,
        'name': route.screenType.toString(),
        'value': degree + 1,
        'category': categoryIndexByName[category] ?? 0,
        'symbolSize': 26 + (degree * 2),
      };
    }).toList();

    final graphEdges = widget.registry.edges
        .where(
          (edge) =>
              routeIndexByTitle.containsKey(edge.from.screenType.toString()) &&
              routeIndexByTitle.containsKey(edge.to.screenType.toString()),
        )
        .map((edge) {
          return <String, int>{
            'source': routeIndexByTitle[edge.from.screenType.toString()]!,
            'target': routeIndexByTitle[edge.to.screenType.toString()]!,
          };
        })
        .toList();

    if (graphEdges.isEmpty && widget.registry.edges.isNotEmpty) {
      debugPrint(
        'MapRouteScreen: No edges resolved. Found ${widget.registry.edges.length} edges, '
        'but no route title matches. Check edge.from.title and edge.to.title.',
      );
    }

    final graphOptions = {
      'legend': {'data': sortedCategories},
      'tooltip': {'show': true},
      'series': [
        {
          'type': 'graph',
          'layout': 'force',
          'animation': false,
          'roam': true,
          'draggable': true,
          'label': {'position': 'right', 'formatter': '{b}'},
          'categories': [
            for (final category in sortedCategories)
              {'name': category, 'keyword': <String, Object>{}},
          ],
          'force': {'edgeLength': 50, 'repulsion': 180, 'gravity': 0.08},
          'data': graphNodes,
          'edges': graphEdges,
        },
      ],
    };

    return {
      MViewType.groupedList: _ItemPage(
        page: Builder(
          builder: (context) {
            return GroupedListPage(
              groupedRoutes: groupedRoutes,
              sortedCategories: sortedCategories,
            );
          },
        ),
      ),
      MViewType.list: _ItemPage(
        page: Builder(
          builder: (context) {
            return ListPage(routes: widget.registry.routes);
          },
        ),
      ),
      MViewType.graph: _ItemPage(
        page: GraphifyView(
          key: ValueKey('graph_view'),
          initialOptions: graphOptions,
        ),
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Map Route')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListenableBuilder(
              listenable: _pageController,
              builder: (context, child) {
                return Row(
                  spacing: 8,
                  children: [
                    ...views.mapIndexed((index, viewType) {
                      return Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            _pageController.jumpToPage(index);
                          },
                          child: Text(viewType.name),
                        ),
                      );
                    }),
                  ],
                );
              },
            ),
          ),
          Expanded(
            child: PageView.builder(
              itemCount: views.length,
              physics: const NeverScrollableScrollPhysics(),
              controller: _pageController,
              itemBuilder: (context, index) {
                final viewType = views.elementAtOrNull(index);
                if (viewType == null) {
                  return const Center(child: Text('No view available'));
                }
                final page = pageByViewType[viewType]?.page;
                if (page == null) {
                  return const Center(child: Text('No page found for view'));
                }
                return page;
              },
            ),
          ),
        ],
      ),
    );
  }

  String _normalizedCategory(String? category) {
    final normalizedCategory = category?.trim();
    if (normalizedCategory == null) {
      return _unknownCategory;
    }

    final lower = normalizedCategory.toLowerCase();
    if (normalizedCategory.isEmpty ||
        lower == 'null' ||
        lower == 'undefined' ||
        lower == 'none' ||
        lower == 'n/a') {
      return _unknownCategory;
    }

    return normalizedCategory;
  }
}

enum MViewType { groupedList, list, graph }

class _ItemPage {
  final Widget page;

  _ItemPage({required this.page});
}
