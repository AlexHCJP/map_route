import 'package:example/screens.dart';
import 'package:flutter/material.dart';
import 'package:map_route/map_route.dart';

// Auth
final loginRoute = MRouteItem<void, LoginScreen>.page(
  page: const LoginScreen(),
  category: 'Auth',
);

final registerRoute = MRouteItem<void, RegisterScreen>.page(
  page: const RegisterScreen(),
  category: 'Auth',
);

// Main
final feedRoute = MRouteItem<void, FeedScreen>.page(
  page: const FeedScreen(),
  category: 'Main',
);

final itemDetailRoute = MRouteItem<int, ItemDetailScreen>(
  category: 'Main',
  builder: (context, itemId) => ItemDetailScreen(itemId: itemId),
  createArguments: (context) async {
    final id = await showDialog<int>(
      context: context,
      builder: (context) => const _ItemPickerDialog(),
    );
    if (id == null) return MRouteBack();
    return MRouteGo(id);
  },
);

// Profile
final profileRoute = MRouteItem<void, ProfileScreen>.page(
  page: const ProfileScreen(),
  category: 'Profile',
);

final settingsRoute = MRouteItem<void, SettingsScreen>.page(
  page: const SettingsScreen(),
  category: 'Profile',
);

// Shopping
final cartRoute = MRouteItem<void, CartScreen>.page(
  page: const CartScreen(),
  category: 'Shopping',
);

final checkoutRoute = MRouteItem<void, CheckoutScreen>.page(
  page: const CheckoutScreen(),
  category: 'Shopping',
);

class AppRegistry implements MRouteRegistry {
  @override
  List<MRouteItem<dynamic, Widget>> get routes => [
    loginRoute,
    registerRoute,
    feedRoute,
    itemDetailRoute,
    profileRoute,
    settingsRoute,
    cartRoute,
    checkoutRoute,
  ];

  @override
  List<MRouteEdge> get edges => [
    // Auth flow
    MRouteEdge(loginRoute, registerRoute),
    MRouteEdge(loginRoute, feedRoute),
    MRouteEdge(registerRoute, feedRoute),
    // Main flow
    MRouteEdge(feedRoute, itemDetailRoute),
    MRouteEdge(feedRoute, profileRoute),
    MRouteEdge(feedRoute, cartRoute),
    MRouteEdge(itemDetailRoute, cartRoute),
    // Profile flow
    MRouteEdge(profileRoute, settingsRoute),
    // Shopping flow
    MRouteEdge(cartRoute, checkoutRoute),
  ];
}

class _ItemPickerDialog extends StatelessWidget {
  const _ItemPickerDialog();

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const Text('Select an item'),
      children: [
        for (final id in [1, 2, 3, 4, 5])
          SimpleDialogOption(
            onPressed: () => Navigator.pop(context, id),
            child: Text('Item #$id'),
          ),
      ],
    );
  }
}
