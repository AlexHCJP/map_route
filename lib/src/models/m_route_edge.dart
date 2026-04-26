import 'm_route_item.dart';

class MRouteEdge {
  final MRouteItem from;
  final MRouteItem to;

  MRouteEdge(this.from, this.to);

  static List<MRouteEdge> edgesFrom(MRouteItem from, List<MRouteItem> toList) =>
      toList.map((to) => MRouteEdge(from, to)).toList();

  static List<MRouteEdge> edgesTo(List<MRouteItem> fromList, MRouteItem to) =>
      fromList.map((from) => MRouteEdge(from, to)).toList();
}
