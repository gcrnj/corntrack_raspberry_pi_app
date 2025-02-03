import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:corntrack_raspberry_pi_app/app_router.dart';
import 'package:corntrack_utils/utils/colors_utility.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(ProviderScope(child: const MyApp()));
}

// Future<void> fetchUsers() async {
//   QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('users').get();
//
//   for (var doc in snapshot.docs) {
//     print("User: ${doc.data()}");
//   }
// }


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    fetchUsers();
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
