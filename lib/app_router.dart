
import 'package:corntrack_raspberry_pi_app/screens/dashboard/dashboard_screen.dart';
import 'package:corntrack_raspberry_pi_app/screens/hourly_temperature/hourly_temperature.dart';
import 'package:corntrack_raspberry_pi_app/screens/register/register_screen.dart';
import 'package:corntrack_raspberry_pi_app/screens/soil_moisture_report/soil_moisture_report.dart';
import 'package:corntrack_raspberry_pi_app/screens/water_distribution/water_distribution_screen.dart';
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
        return const RegisterScreen();
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
    GoRoute(
      path: '/dashboard',
      builder: (BuildContext context, GoRouterState state) {
        return const DashboardScreen();
      },
      routes: [
        GoRoute(
          path: '/hourly_temperature',
          builder: (BuildContext context, GoRouterState state) {
            return HourlyTemperature();
          },
        ),
        GoRoute(
          path: '/soil_moisture_report',
          builder: (BuildContext context, GoRouterState state) {
            final selectedCornPots = (state.extra as List<Pots>?) ?? List.empty(); // Adjust type accordingly
            return SoilMoistureReport(selectedCornPots: selectedCornPots);
          },
        ),
        GoRoute(
          path: '/water_distribution',
          builder: (BuildContext context, GoRouterState state) {
            final selectedCornPots = (state.extra as List<Pots>?) ?? List.empty(); // Adjust type accordingly
            return WaterDistributionReport(selectedCornPots: selectedCornPots);
          },
        ),
      ]

    ),
  ],
);

final appRouter = _appRouter;