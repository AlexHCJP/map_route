import 'package:flutter/material.dart';
import 'package:map_route/src/models/m_route_item.dart';

class ListPage extends StatefulWidget {
  final List<MRouteItem<dynamic, Widget>> routes;

  const ListPage({super.key, required this.routes});

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
              final filteredCategories = widget.routes.where((route) {
                if (route.screenType.toString().toLowerCase().contains(query)) {
                  return true;
                }
                if (route.category?.toLowerCase().contains(query) ?? false) {
                  return true;
                }
                return false;
              }).toList();
              return ListView.builder(
                itemCount: filteredCategories.length,
                itemBuilder: (context, index) {
                  final category = filteredCategories[index];

                  return ListTile(
                    title: Text(category.screenType.toString()),
                    subtitle: category.category != null
                        ? Text(category.category!)
                        : null,
                    onTap: () => category.onTap(context),
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
