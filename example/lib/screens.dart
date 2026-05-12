import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Login')),
    body: const Center(child: Text('Login Screen')),
  );
}

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Register')),
    body: const Center(child: Text('Register Screen')),
  );
}

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Feed')),
    body: const Center(child: Text('Feed Screen')),
  );
}

class ItemDetailScreen extends StatelessWidget {
  const ItemDetailScreen({required this.itemId, super.key});

  final int itemId;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text('Item #$itemId')),
    body: Center(child: Text('Item Detail Screen — id: $itemId')),
  );
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Profile')),
    body: const Center(child: Text('Profile Screen')),
  );
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Settings')),
    body: const Center(child: Text('Settings Screen')),
  );
}

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Cart')),
    body: const Center(child: Text('Cart Screen')),
  );
}

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Checkout')),
    body: const Center(child: Text('Checkout Screen')),
  );
}
