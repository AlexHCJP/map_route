import 'package:flutter/material.dart';
import 'package:map_route/src/models/m_route_item.dart';

class ListPage extends StatefulWidget {
  const ListPage({required this.routes, super.key});
  
  final List<MRouteItem<dynamic, Widget>> routes;

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
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
          ),
        ),
        Expanded(
          child: ValueListenableBuilder(
            valueListenable: _searchController,
            builder: (context, value, child) {
              final query = value.text.toLowerCase();
              final filtered = widget.routes.where((route) {
                if (route.screenType.toString().toLowerCase().contains(query)) {
                  return true;
                }
                if (route.category?.toLowerCase().contains(query) ?? false) {
                  return true;
                }
                return false;
              }).toList();
              return ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                itemCount: filtered.length,
                itemBuilder: (context, index) {
                  final route = filtered[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: ListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      tileColor: colorScheme.surfaceContainer,
                      title: Text(route.screenType.toString()),
                      subtitle: route.category != null
                          ? Align(
                              alignment: Alignment.centerLeft,
                              child: Chip(
                                label: Text(
                                  route.category!,
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: colorScheme.onSecondaryContainer,
                                  ),
                                ),
                                backgroundColor:
                                    colorScheme.secondaryContainer,
                                padding: EdgeInsets.zero,
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                                visualDensity: VisualDensity.compact,
                              ),
                            )
                          : null,
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        size: 14,
                        color: colorScheme.onSurfaceVariant,
                      ),
                      onTap: () => route.onTap(context),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
