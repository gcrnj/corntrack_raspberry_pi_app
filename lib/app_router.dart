import 'package:corntrack_raspberry_pi_app/api/qr_code.dart';
import 'package:corntrack_raspberry_pi_app/data/failed_upload_data.dart';
import 'package:corntrack_raspberry_pi_app/screens/captured_photos/captured_photos.dart';
import 'package:corntrack_raspberry_pi_app/screens/graph_screen.dart';
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
              final selectedCornPots = (state.extra as List<Pots>?) ??
                  List.empty(); // Adjust type accordingly
              return HourlyTemperature(
                selectedPots: selectedCornPots,
              );
            },
          ),
          GoRoute(
            path: '/soil_moisture_report',
            builder: (BuildContext context, GoRouterState state) {
              final selectedCornPots = (state.extra as List<Pots>?) ??
                  List.empty(); // Adjust type accordingly
              return SoilMoistureReport(selectedCornPots: selectedCornPots);
            },
          ),
          GoRoute(
            path: '/water_distribution',
            builder: (BuildContext context, GoRouterState state) {
              final selectedCornPots = (state.extra as List<Pots>?) ??
                  List.empty(); // Adjust type accordingly
              return WaterDistributionReport(
                  selectedCornPots: selectedCornPots);
            },
          ),
          GoRoute(
            path: '/manual_upload',
            builder: (BuildContext context, GoRouterState state) {
              final failedUploads = (state.extra as List<FailedUploadData>?) ??
                  List.empty(); // Adjust type accordingly
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
                // return CapturedPhotos(url: "https://storage.googleapis.com/project-corntrack.firebasestorage.app/gallery.png?Expires=1741585390&GoogleAccessId=firebase-adminsdk-fbsvc%40project-corntrack.iam.gserviceaccount.com&Signature=YXXfzgxIL6R0BSq5F0c4CDj42GZbqlXE1ISoLzSYf%2B2r0tKUCzaQgAqglrpSd%2FVTe39mIT6nDtwx8cUyt2puD0WWB3gnJkuOqdF4yESHMia3gQeKhtGmjtfV8F546y6%2BNxZoAk8N1cbZWAgybSLC2ljy8nRCyMrnFFSXC4%2Faa4x7hKCLDjIkqxzOt9hRLl4YweVx57af4TUdVSVznVV%2FwTzXNTuILgm644rTbfUG0zJr5w0ujFpCXW7Wuhku%2BvOq%2Fwnlbm%2FBCpSwG%2FR8IeDsVgMHD8EOQiriTrBZeT7c3mEcTo%2BeN4USlQAGLbKvQzfBz6l8lBDmWAN1Q8c80WxmnQ%3D%3D");
                return CapturedPhotos(url: state.extra as String?);
              },
              routes: [
                GoRoute(
                  path: '/photo_details',
                  builder: (BuildContext context, GoRouterState state) {
                    final url = (state.extra as String?) ??
                        ''; // Adjust type accordingly
                    return CapturedPhotos(url: url);
                  },
                ),
              ]),
          GoRoute(
            path: '/connection',
            builder: (BuildContext context, GoRouterState state) {
              return WifiConnect();
            },
          ),
          GoRoute(
            path: '/qrcode',
            builder: (BuildContext context, GoRouterState state) {
              final deviceId = (state.extra as String?) ?? '';
              return QRCodeScreen(deviceId: deviceId);
            },
          ),
          GoRoute(
            path: '/smart-farming',
            builder: (BuildContext context, GoRouterState state) {
              final selectedCornPots = (state.extra as List<Pots>?) ??
                  List.empty(); // Adjust type accordingly
              return GraphScreen(
                  moistureIds: selectedCornPots
                      .map((element) => element.getMoistureId())
                      .toList());
            },
          ),
        ]),
  ],
);

final appRouter = _appRouter;
