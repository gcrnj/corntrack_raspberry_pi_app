import 'package:corntrack_raspberry_pi_app/app_router.dart';
import 'package:corntrack_raspberry_pi_app/services/devices_services.dart';
import 'package:corntrack_utils/utils/colors_utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: lightYellowColor),
          useMaterial3: true,
          filledButtonTheme: FilledButtonThemeData(
              style: FilledButton.styleFrom().copyWith(
                  backgroundColor:
                      WidgetStateProperty.all(Color.fromRGBO(42, 54, 78, 1))))),
      routerConfig: appRouter,
    );
  }
}
