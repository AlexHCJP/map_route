# MapRouteScreen Redesign Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Improve `MapRouteScreen` visual design with adaptive dark/light theming and Material 3 polish.

**Architecture:** Three files get pure UI changes — no business logic touched. All colors come from `Theme.of(context).colorScheme` so the widget adapts to the host app's theme automatically.

**Tech Stack:** Flutter, Material 3 (`SegmentedButton`, `colorScheme`, `ExpansionTile`, `Chip`)

---

### Task 1: SegmentedButton + AppBar in `map_route_screen.dart`

**Files:**
- Modify: `lib/src/screens/map_route_screen.dart`

Replace the `ElevatedButton` row with `SegmentedButton<MViewType>` and theme the `AppBar`.

- [ ] **Step 1: Replace the state and build method**

Replace the entire `_MapRouteScreenState` class with:

```dart
class _MapRouteScreenState extends State<MapRouteScreen> {
  late final PageController _pageController;
  late MViewType _selectedView;
  static const _unknownCategory = 'unknown screen';

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    _selectedView = widget.views.first;
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  List<MViewType> get views => widget.views;

  // pageByViewType stays UNCHANGED — do not touch it

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: const Text('Map Route'),
        backgroundColor: colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(height: 1, color: colorScheme.outlineVariant),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: SegmentedButton<MViewType>(
              expandedInsets: EdgeInsets.zero,
              segments: views
                  .map(
                    (v) => ButtonSegment<MViewType>(
                      value: v,
                      label: Text(v.name),
                    ),
                  )
                  .toList(),
              selected: {_selectedView},
              onSelectionChanged: (selection) {
                final next = selection.first;
                final index = views.indexOf(next);
                setState(() => _selectedView = next);
                _pageController.jumpToPage(index);
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
```

- [ ] **Step 2: Run analyze**

```bash
cd /Users/aleksandrbangert/projects/client-app/packages/map_route
flutter analyze
```

Expected: `No issues found!`

- [ ] **Step 3: Commit**

```bash
git add lib/src/screens/map_route_screen.dart
git commit -m "design: replace ElevatedButton row with SegmentedButton, theme AppBar"
```

---

### Task 2: Theme `grouped_list_page.dart`

**Files:**
- Modify: `lib/src/screens/grouped_list_page.dart`

Apply `colorScheme` to `ExpansionTile` and route `ListTile`s.

- [ ] **Step 1: Replace the `build` method body**

Replace the `build` method in `_GroupedListPageState` with:

```dart
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
                  collapsedBackgroundColor: colorScheme.surfaceContainerHighest,
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
```

- [ ] **Step 2: Run analyze**

```bash
flutter analyze
```

Expected: `No issues found!`

- [ ] **Step 3: Commit**

```bash
git add lib/src/screens/grouped_list_page.dart
git commit -m "design: theme GroupedListPage with colorScheme and rounded tiles"
```

---

### Task 3: Theme `list_page.dart`

**Files:**
- Modify: `lib/src/screens/list_page.dart`

Apply `colorScheme` to `ListTile`s; replace plain category `Text` with a `Chip`.

- [ ] **Step 1: Replace the `build` method body**

Replace the `build` method in `_ListPageState` with:

```dart
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
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
                              backgroundColor: colorScheme.secondaryContainer,
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
```

- [ ] **Step 2: Run analyze**

```bash
flutter analyze
```

Expected: `No issues found!`

- [ ] **Step 3: Commit**

```bash
git add lib/src/screens/list_page.dart
git commit -m "design: theme ListPage with colorScheme, rounded tiles, category Chip"
```
