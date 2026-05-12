import 'package:map_route/src/models/m_route_item.dart';

/// A directed navigation connection between two registered screens.
class MRouteEdge {
  /// Creates an edge from [from] to [to].
  MRouteEdge(this.from, this.to);

  /// The source screen of this navigation edge.
  final MRouteItem<Object?, Object?> from;

  /// The destination screen of this navigation edge.
  final MRouteItem<Object?, Object?> to;

  /// Creates edges from one [from] screen to each screen in [toList].
  static List<MRouteEdge> edgesFrom(
    MRouteItem<Object?, Object?> from,
    List<MRouteItem<Object?, Object?>> toList,
  ) => toList.map((to) => MRouteEdge(from, to)).toList();

  /// Creates edges from each screen in [fromList] to one [to] screen.
  static List<MRouteEdge> edgesTo(
    List<MRouteItem<Object?, Object?>> fromList,
    MRouteItem<Object?, Object?> to,
  ) => fromList.map((from) => MRouteEdge(from, to)).toList();
}
