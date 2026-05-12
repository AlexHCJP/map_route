import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:map_route/map_route.dart';

class ScreenAlpha extends StatelessWidget {
  const ScreenAlpha({super.key});
  @override
  Widget build(BuildContext context) => const SizedBox();
}

class ScreenBeta extends StatelessWidget {
  const ScreenBeta({super.key});
  @override
  Widget build(BuildContext context) => const SizedBox();
}

class ScreenGamma extends StatelessWidget {
  const ScreenGamma({super.key});
  @override
  Widget build(BuildContext context) => const SizedBox();
}

void main() {
  late MRouteItem<void, ScreenAlpha> routeA;
  late MRouteItem<void, ScreenBeta> routeB;
  late MRouteItem<void, ScreenGamma> routeC;

  setUp(() {
    routeA = MRouteItem.page(page: const ScreenAlpha());
    routeB = MRouteItem.page(page: const ScreenBeta());
    routeC = MRouteItem.page(page: const ScreenGamma());
  });

  group('MRouteEdge', () {
    test('constructor stores from and to', () {
      final edge = MRouteEdge(routeA, routeB);
      expect(edge.from, same(routeA));
      expect(edge.to, same(routeB));
    });

    test('edgesFrom creates edges with correct from and all destinations', () {
      final edges = MRouteEdge.edgesFrom(routeA, [routeB, routeC]);
      expect(edges.length, 2);
      expect(edges.every((e) => e.from == routeA), isTrue);
      expect(edges.map((e) => e.to), containsAll([routeB, routeC]));
    });

    test('edgesTo creates edges with correct to and all sources', () {
      final edges = MRouteEdge.edgesTo([routeA, routeB], routeC);
      expect(edges.length, 2);
      expect(edges.every((e) => e.to == routeC), isTrue);
      expect(edges.map((e) => e.from), containsAll([routeA, routeB]));
    });

    test('edgesFrom with empty toList returns empty', () {
      expect(MRouteEdge.edgesFrom(routeA, []), isEmpty);
    });

    test('edgesTo with empty fromList returns empty', () {
      expect(MRouteEdge.edgesTo([], routeC), isEmpty);
    });
  });
}
