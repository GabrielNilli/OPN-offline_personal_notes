// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';

// import '../pages/home_page.dart';
// import '../pages/add_page.dart';
// import '../pages/notes_page.dart';
// import '../pages/graphs_page.dart';
// import '../pages/settings_page.dart';

// final GoRouter appRouter = GoRouter(
//   initialLocation: '/home',
//   routes: [
//     ShellRoute(
//       builder: (context, state, child) {
//         return HomePage(child: child);
//       },
//       routes: [
//         GoRoute(
//           path: '/home',
//           builder: (context, state) => HomePage(child: Container()),
//         ),
//         // GoRoute(
//         //   path: '/notes',
//         //   builder: (context, state) => const NotesScreen(),
//         // ),
//         // GoRoute(
//         //   path: '/stats',
//         //   builder: (context, state) => const StatsScreen(),
//         // ),
//         GoRoute(
//           path: '/settings',
//           builder: (context, state) => const SettingsPage(),
//         ),
//       ],
//     ),
//   ],
// );
