import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../models/m_route_item.dart';

@internal
class GroupedListPage extends StatefulWidget {
  final Map<String, List<MRouteItem>> groupedRoutes;
  final List<String> sortedCategories;

  const GroupedListPage({
    super.key,
    required this.groupedRoutes,
    required this.sortedCategories,
  });

  @override
  State<GroupedListPage> createState() => _GroupedListPageState();
}

class _GroupedListPageState extends State<GroupedListPage> {
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final query = _query.toLowerCase();

    final filteredCategories = widget.sortedCategories.where((category) {
      if (category.toLowerCase().contains(query)) return true;
      return widget.groupedRoutes[category]!.any(
        (r) => r.screenType.toString().toLowerCase().contains(query),
      );
    }).toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: TextField(
            controller: _searchController,
            decoration: const InputDecoration(
              hintText: 'Search by title or category...',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
              isDense: true,
            ),
            onChanged: (value) => setState(() => _query = value),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: filteredCategories.length,
            itemBuilder: (context, index) {
              final category = filteredCategories[index];
              final categoryRoutes = widget.groupedRoutes[category]!
                  .where(
                    (r) =>
                        query.isEmpty ||
                        r.screenType.toString().toLowerCase().contains(query) ||
                        category.toLowerCase().contains(query),
                  )
                  .toList();

              return ExpansionTile(
                initiallyExpanded: query.isNotEmpty,
                title: Text(
                  category,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                children: [
                  for (final route in categoryRoutes)
                    ListTile(
                      title: Text(route.screenType.toString()),
                      onTap: () => route.onTap(context),
                    ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
