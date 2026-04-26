import 'dart:async';

import 'package:flutter/material.dart';

import 'm_route_result.dart';

class MRouteItem<T, W extends Widget> {
  MRouteItem({this.category, required this.builder, this.createArguments});

  factory MRouteItem.page({String? category, required W page}) {
    return MRouteItem(
      category: category,
      builder: (context, arguments) => page,
    );
  }

  final String? category;
  final W Function(BuildContext context, T arguments) builder;
  final FutureOr<MRouteResult<T>?> Function(BuildContext context)?
  createArguments;

  void _navigate(BuildContext context, T arguments) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => builder(context, arguments)),
    );
  }

  Type get screenType => W;

  void onTap(BuildContext context) async {
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
