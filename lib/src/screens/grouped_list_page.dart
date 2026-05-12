import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:map_route/src/models/m_route_item.dart';

@internal
class GroupedListPage extends StatefulWidget {
  const GroupedListPage({
    required this.groupedRoutes,
    required this.sortedCategories,
    super.key,
  });
  final Map<String, List<MRouteItem<Object?, Object?>>> groupedRoutes;
  final List<String> sortedCategories;

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
    final colorScheme = Theme.of(context).colorScheme;
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
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
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

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: ExpansionTile(
                    initiallyExpanded: query.isNotEmpty,
                    collapsedBackgroundColor:
                        colorScheme.surfaceContainerHighest,
                    backgroundColor: colorScheme.surfaceContainerHighest,
                    title: Text(
                      category,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.primary,
                      ),
                    ),
                    children: [
                      for (final route in categoryRoutes)
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          child: ListTile(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            tileColor: colorScheme.surfaceContainer,
                            title: Text(route.screenType.toString()),
                            trailing: Icon(
                              Icons.arrow_forward_ios,
                              size: 14,
                              color: colorScheme.onSurfaceVariant,
                            ),
                            onTap: () => route.onTap(context),
                          ),
                        ),
                      const SizedBox(height: 4),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
