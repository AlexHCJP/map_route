import 'package:flutter/widgets.dart';
import 'package:map_route/map_route.dart';

/// Provides the full list of routes and navigation edges for [MapRouteScreen].
///
/// Implement this class in your app to describe the screen graph:
/// ```dart
/// class AppRegistry implements MRouteRegistry {
///   @override
///   List<MRouteItem<dynamic, Widget>> get routes => [...];
///   @override
///   List<MRouteEdge> get edges => [...];
/// }
/// ```
abstract class MRouteRegistry {
  /// All screens registered in the route map.
  List<MRouteItem<dynamic, Widget>> get routes;

  /// Directed navigation connections between registered screens.
  List<MRouteEdge> get edges;
}
