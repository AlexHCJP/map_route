import 'package:flutter_test/flutter_test.dart';
import 'package:map_route/map_route.dart';

void main() {
  group('MRouteResult', () {
    test('MRouteGo stores arguments', () {
      final result = MRouteGo(42);
      expect(result.arguments, 42);
    });

    test('MRouteBack is a subtype of MRouteResult', () {
      final MRouteResult<int> result = MRouteBack<int>();
      expect(result, isA<MRouteBack<int>>());
    });

    test('MRouteGo is a subtype of MRouteResult', () {
      final MRouteResult<int> result = MRouteGo(42);
      expect(result, isA<MRouteGo<int>>());
    });
  });
}
