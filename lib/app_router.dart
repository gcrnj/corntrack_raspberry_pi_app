
import 'package:corntrack_raspberry_pi_app/data/failed_upload_data.dart';
import 'package:corntrack_raspberry_pi_app/screens/captured_photos/captured_photos.dart';
import 'package:corntrack_raspberry_pi_app/screens/wifi_connect/wifi_connect.dart';
import 'package:corntrack_raspberry_pi_app/screens/dashboard/dashboard_screen.dart';
import 'package:corntrack_raspberry_pi_app/screens/health_status/health_status.dart';
import 'package:corntrack_raspberry_pi_app/screens/hourly_temperature/hourly_temperature.dart';
import 'package:corntrack_raspberry_pi_app/screens/manual_upload/manual_upload.dart';
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
        GoRoute(
          path: '/manual_upload',
          builder: (BuildContext context, GoRouterState state) {
            final failedUploads = (state.extra as List<FailedUploadData>?) ?? List.empty(); // Adjust type accordingly
            return ManualUploadScreen(failedUploads: failedUploads);
          },
        ),
        GoRoute(
          path: '/health_status',
          builder: (BuildContext context, GoRouterState state) {
            return HealthStatus();
          },
        ),
        GoRoute(
          path: '/captured_photos',
          builder: (BuildContext context, GoRouterState state) {
            return CapturedPhotos();
          },
        ),
        GoRoute(
          path: '/connection',
          builder: (BuildContext context, GoRouterState state) {
            return WifiConnect();
          },
        ),
      ]

    ),
  ],
);

final appRouter = _appRouter;