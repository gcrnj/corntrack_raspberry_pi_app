
import 'package:corntrack_raspberry_pi_app/screens/dashboard/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';


/// The route configuration.
final GoRouter _appRouter = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      // redirect: (BuildContext context, GoRouterState state) {
      //   // Check if the user is authenticated
      //   if (FirebaseAuth.instance.currentUser != null) {
      //     return '/home'; // Redirect to '/home' if authenticated
      //   }
      //   return null; // Stay on the welcome page if not authenticated
      // },
      builder: (BuildContext context, GoRouterState state) {
        return const DashboardScreen();
      },
      // routes: <RouteBase>[
      //   GoRoute(
      //     path: 'register',
      //     builder: (BuildContext context, GoRouterState state) {
      //       return const RegisterPage();
      //     },
      //   ),
      // ],
    ),
    // GoRoute(
    //   path: '/home',
    //   builder: (BuildContext context, GoRouterState state) {
    //     return const HomeNavigation();
    //   },
    //
    // ),
  ],
);

final appRouter = _appRouter;