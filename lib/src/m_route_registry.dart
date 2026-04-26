import 'package:flutter/widgets.dart';
import 'package:map_route/map_route.dart';

abstract class MRouteRegistry {
  List<MRouteItem<dynamic, Widget>> get routes;
  List<MRouteEdge> get edges;
}
