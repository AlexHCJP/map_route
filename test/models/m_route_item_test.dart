import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:map_route/map_route.dart';

class SourceScreen extends StatelessWidget {
  const SourceScreen({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold(body: Text('source'));
}

class TargetScreen extends StatelessWidget {
  const TargetScreen({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold(body: Text('target'));
}

Widget _buildHome<T, W extends Widget>(MRouteItem<T, W> item) => MaterialApp(
  home: Builder(
    builder: (context) => ElevatedButton(
      onPressed: () => item.onTap(context),
      child: const Text('go'),
    ),
  ),
);

void main() {
  group('MRouteItem', () {
    test('screenType returns the widget Type', () {
      final item = MRouteItem<void, SourceScreen>.page(page: const SourceScreen());
      expect(item.screenType, SourceScreen);
    });

    test('.page factory sets category', () {
      final item = MRouteItem<void, SourceScreen>.page(
        page: const SourceScreen(),
        category: 'Auth',
      );
      expect(item.category, 'Auth');
    });

    test('.page factory allows null category', () {
      final item = MRouteItem<void, SourceScreen>.page(page: const SourceScreen());
      expect(item.category, isNull);
    });

    testWidgets('onTap without createArguments navigates to screen',
        (tester) async {
      final item = MRouteItem<void, TargetScreen>.page(page: const TargetScreen());
      await tester.pumpWidget(_buildHome(item));
      await tester.tap(find.text('go'));
      await tester.pumpAndSettle();
      expect(find.text('target'), findsOneWidget);
    });

    testWidgets('onTap with MRouteGo navigates to screen', (tester) async {
      final item = MRouteItem<int, TargetScreen>(
        builder: (_, __) => const TargetScreen(),
        createArguments: (_) async => MRouteGo(1),
      );
      await tester.pumpWidget(_buildHome(item));
      await tester.tap(find.text('go'));
      await tester.pumpAndSettle();
      expect(find.text('target'), findsOneWidget);
    });

    testWidgets('onTap with MRouteBack does not navigate', (tester) async {
      final item = MRouteItem<int, TargetScreen>(
        builder: (_, __) => const TargetScreen(),
        createArguments: (_) async => MRouteBack(),
      );
      await tester.pumpWidget(_buildHome(item));
      await tester.tap(find.text('go'));
      await tester.pumpAndSettle();
      expect(find.text('target'), findsNothing);
    });

    testWidgets('onTap with null createArguments result does not navigate',
        (tester) async {
      final item = MRouteItem<int, TargetScreen>(
        builder: (_, __) => const TargetScreen(),
        createArguments: (_) async => null,
      );
      await tester.pumpWidget(_buildHome(item));
      await tester.tap(find.text('go'));
      await tester.pumpAndSettle();
      expect(find.text('target'), findsNothing);
    });
  });
}
