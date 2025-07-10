import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/scan/presentation/pages/scan_page.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'scan',
        builder: (context, state) => const ScanPage(),
      ),
      GoRoute(
        path: '/history',
        name: 'history',
        builder: (context, state) => const Scaffold(
          body: Center(
            child: Text('Scan History - Coming Soon'),
          ),
        ),
      ),
      GoRoute(
        path: '/shops',
        name: 'shops',
        builder: (context, state) => const Scaffold(
          body: Center(
            child: Text('Nearby Shops - Coming Soon'),
          ),
        ),
      ),
    ],
  );
}