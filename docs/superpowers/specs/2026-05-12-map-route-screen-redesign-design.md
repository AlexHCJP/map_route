# MapRouteScreen Redesign

## Goal
Improve the visual design of `MapRouteScreen` with adaptive dark/light theming and Material 3 polish.

## Approach
SegmentedButton tab switcher + themed tiles. All colors from `Theme.of(context).colorScheme` — no hardcoded values.

## Changes

### `map_route_screen.dart`
- Replace `ElevatedButton` row with `SegmentedButton<MViewType>`
- Track selected view with `_selectedView` state; drive `PageController` from it
- AppBar: `backgroundColor: colorScheme.surface`, `elevation: 0`, thin bottom divider

### `grouped_list_page.dart`
- `ExpansionTile` header: `collapsedBackgroundColor` + `backgroundColor` → `colorScheme.surfaceContainerHighest`
- Category title: `colorScheme.primary` + `FontWeight.bold`
- Route `ListTile`: `tileColor: colorScheme.surfaceContainer`, rounded `shape`

### `list_page.dart`
- Route `ListTile`: `tileColor: colorScheme.surfaceContainer`, rounded `shape`
- Category subtitle: replace plain `Text` with a small `Chip` using `colorScheme.secondaryContainer`

## Constraints
- No hardcoded colors
- Public API of `MapRouteScreen` stays unchanged
- `MViewType` enum stays unchanged
