import 'package:flutter/material.dart';
import 'splash_screen.dart';
import 'onboarding_screen1.dart';
import 'screens/user_type_selection_screen.dart';
import 'screens/collector_signup_screen.dart';
import 'screens/recycle_items_screen.dart';
import 'screens/all_set_screen.dart';
import 'screens/collector_signing_screen.dart'; // <-- The class and file name match!

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recycle App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const SplashScreen(),
      routes: {
        '/onboarding': (context) => const OnboardingScreen(),
        '/user_selection': (context) => const UserTypeSelectionScreen(),
        '/collector_signup': (context) => const CollectorSignUpScreen(),
        '/recycle_items': (context) => const RecycleItemsScreen(),
        '/all_set': (context) => const AllSetScreen(),
        '/collector_signing': (context) => const CollectorSigningScreen(), // <-- Use this class name!
      },
    );
  }
}
