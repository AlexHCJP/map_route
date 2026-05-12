import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:map_route/map_route.dart';

class ScreenAlpha extends StatelessWidget {
  const ScreenAlpha({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Text('Screen Alpha'));
}

class ScreenBeta extends StatelessWidget {
  const ScreenBeta({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Text('Screen Beta'));
}

final _routeAlpha = MRouteItem<void, ScreenAlpha>.page(
  page: const ScreenAlpha(),
  category: 'Auth',
);
final _routeBeta = MRouteItem<void, ScreenBeta>.page(
  page: const ScreenBeta(),
  category: 'Main',
);

class _StubRegistry implements MRouteRegistry {
  @override
  List<MRouteItem<dynamic, Widget>> get routes => [_routeAlpha, _routeBeta];
  @override
  List<MRouteEdge> get edges => [MRouteEdge(_routeAlpha, _routeBeta)];
}

Widget _wrap(Widget child) => MaterialApp(home: child);

void main() {
  group('MapRouteScreen', () {
    testWidgets('renders AppBar with "Map Route" title', (tester) async {
      await tester.pumpWidget(_wrap(MapRouteScreen(registry: _StubRegistry())));
      expect(find.text('Map Route'), findsOneWidget);
    });

    testWidgets('SegmentedButton shows all view types by default', (
      tester,
    ) async {
      await tester.pumpWidget(_wrap(MapRouteScreen(registry: _StubRegistry())));
      // MViewType.toString() returns 'Groups', 'List', 'Graph'
      expect(find.text('Groups'), findsOneWidget);
      expect(find.text('List'), findsOneWidget);
      expect(find.text('Graph'), findsOneWidget);
    });

    testWidgets('restricted to one view shows only that segment', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          MapRouteScreen(
            registry: _StubRegistry(),
            views: const [MViewType.list],
          ),
        ),
      );
      expect(find.text('List'), findsOneWidget);
      expect(find.text('Groups'), findsNothing);
      expect(find.text('Graph'), findsNothing);
    });

    testWidgets('tapping between group and list segments does not crash', (
      tester,
    ) async {
      // Graph view is excluded: GraphifyView uses webview_flutter which requires
      // platform registration unavailable in the flutter_test environment.
      await tester.pumpWidget(
        _wrap(
          MapRouteScreen(
            registry: _StubRegistry(),
            views: const [MViewType.group, MViewType.list],
          ),
        ),
      );
      await tester.tap(find.text('List'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Groups'));
      await tester.pumpAndSettle();
      expect(find.text('Map Route'), findsOneWidget);
    });

    testWidgets('search in ListPage filters routes by screen name', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          MapRouteScreen(
            registry: _StubRegistry(),
            views: const [MViewType.list],
          ),
        ),
      );
      await tester.enterText(find.byType(TextField), 'ScreenAlpha');
      await tester.pumpAndSettle();
      // Use ListTile descendant to avoid matching the TextField's own EditableText
      expect(
        find.descendant(
          of: find.byType(ListTile),
          matching: find.text('ScreenAlpha'),
        ),
        findsOneWidget,
      );
      expect(
        find.descendant(
          of: find.byType(ListTile),
          matching: find.text('ScreenBeta'),
        ),
        findsNothing,
      );
    });

    testWidgets('search in GroupedListPage filters categories by screen name', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          MapRouteScreen(
            registry: _StubRegistry(),
            views: const [MViewType.group],
          ),
        ),
      );
      await tester.enterText(find.byType(TextField), 'ScreenAlpha');
      await tester.pumpAndSettle();
      // 'Auth' category (contains ScreenAlpha) remains; 'Main' is filtered out
      expect(find.text('Auth'), findsOneWidget);
      expect(find.text('Main'), findsNothing);
      expect(find.text('ScreenBeta'), findsNothing);
    });

    testWidgets('tapping route tile in ListPage navigates to screen', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          MapRouteScreen(
            registry: _StubRegistry(),
            views: const [MViewType.list],
          ),
        ),
      );
      await tester.tap(find.text('ScreenAlpha'));
      await tester.pumpAndSettle();
      expect(find.text('Screen Alpha'), findsOneWidget);
    });
  });
}
