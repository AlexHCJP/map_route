import 'dart:async';

import 'package:flutter/material.dart';

import 'package:map_route/src/models/m_route_result.dart';

/// A registered screen entry in the route map.
///
/// [T] is the arguments type passed to the screen builder.
/// [W] is the concrete [Widget] type, used to identify the screen by its [screenType].
///
/// For screens that require no arguments use the convenience factory [MRouteItem.page]:
/// ```dart
/// final homeRoute = MRouteItem<void, HomeScreen>.page(
///   page: const HomeScreen(),
///   category: 'Main',
/// );
/// ```
///
/// For screens that require arguments, provide [createArguments]:
/// ```dart
/// final detailRoute = MRouteItem<int, DetailScreen>(
///   category: 'Main',
///   builder: (context, id) => DetailScreen(id: id),
///   createArguments: (context) async {
///     final id = await pickId(context);
///     return id == null ? MRouteBack() : MRouteGo(id);
///   },
/// );
/// ```
class MRouteItem<T, W extends Widget> {
  /// Creates a route item with a [builder] and optional [category] and [createArguments].
  MRouteItem({required this.builder, this.category, this.createArguments});

  /// Creates a route item for a screen that requires no runtime arguments.
  factory MRouteItem.page({required W page, String? category}) =>
      MRouteItem(category: category, builder: (context, arguments) => page);

  /// Optional label used to group this screen in [MapRouteScreen].
  final String? category;

  /// Builds the screen widget given a [BuildContext] and resolved [arguments].
  final W Function(BuildContext context, T arguments) builder;

  /// Called before navigation to resolve arguments.
  ///
  /// Return [MRouteGo] to proceed or [MRouteBack] (or `null`) to cancel.
  /// When `null`, the screen is navigated to immediately with no arguments.
  final FutureOr<MRouteResult<T>?> Function(BuildContext context)?
  createArguments;

  void _navigate(BuildContext context, T arguments) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => builder(context, arguments),
      ),
    );
  }

  /// The [Type] of the screen widget [W], used as its identifier in the route map.
  Type get screenType => W;

  /// Navigates to this screen, calling [createArguments] first if provided.
  Future<void> onTap(BuildContext context) async {
    if (createArguments != null) {
      final result = await createArguments!(context);
      if (!context.mounted) return;
      switch (result) {
        case null:
        case MRouteBack():
          return;
        case MRouteGo(:final arguments):
          _navigate(context, arguments);
      }
    } else {
      _navigate(context, null as T);
    }
  }
}
