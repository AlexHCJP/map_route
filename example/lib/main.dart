import 'package:example/app_registry.dart';
import 'package:flutter/material.dart';
import 'package:map_route/map_route.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  ThemeMode _themeMode = ThemeMode.system;

  void _cycleTheme() {
    setState(() {
      _themeMode = switch (_themeMode) {
        ThemeMode.system => ThemeMode.light,
        ThemeMode.light => ThemeMode.dark,
        ThemeMode.dark => ThemeMode.system,
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(useMaterial3: true),
      darkTheme: ThemeData.dark(useMaterial3: true),
      themeMode: _themeMode,
      home: _ExampleHome(themeMode: _themeMode, onToggleTheme: _cycleTheme),
    );
  }
}

class _ExampleHome extends StatelessWidget {
  const _ExampleHome({required this.themeMode, required this.onToggleTheme});

  final ThemeMode themeMode;
  final VoidCallback onToggleTheme;

  IconData get _themeModeIcon => switch (themeMode) {
    ThemeMode.system => Icons.brightness_auto,
    ThemeMode.light => Icons.light_mode,
    ThemeMode.dark => Icons.dark_mode,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('map_route example'),
        actions: [
          IconButton(
            icon: Icon(_themeModeIcon),
            tooltip: 'Toggle theme (${themeMode.name})',
            onPressed: onToggleTheme,
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 12,
          children: [
            ElevatedButton(
              onPressed: () =>
                  MapRouteScreen(registry: AppRegistry()).view(context),
              child: const Text('Open Route Map'),
            ),
            ElevatedButton(
              onPressed: () => MapRouteScreen(
                registry: AppRegistry(),
                views: [MViewType.group],
              ).view(context),
              child: const Text('Grouped List only'),
            ),
            ElevatedButton(
              onPressed: () => MapRouteScreen(
                registry: AppRegistry(),
                views: [MViewType.graph],
              ).view(context),
              child: const Text('Graph only'),
            ),
          ],
        ),
      ),
    );
  }
}
