import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

import 'screens/login_screen.dart';
import 'screens/user_type_selection_screen.dart';
import 'screens/collector_signup_screen.dart';
import 'screens/dashboards/recycler_dashboard.dart';
import 'screens/dashboards/compounder_dashboard.dart';
import 'screens/dashboards/industry_dashboard.dart';
import 'services/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  await Firebase.initializeApp();
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      title: 'Eco Trade',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(useMaterial3: true),
      darkTheme: ThemeData.dark(useMaterial3: true),
      themeMode: themeProvider.currentTheme,
      home: const EntryPoint(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/signup/collector': (context) => const CollectorSignUpScreen(),
        '/dashboard/recycler': (context) => const RecyclerDashboard(),
        '/dashboard/compounder': (context) => const CompounderDashboard(),
        '/dashboard/industry': (context) => const IndustryDashboard(),
      },
    );
  }
}

class EntryPoint extends StatelessWidget {
  const EntryPoint({super.key});

  Future<Widget> _getStartScreen() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const LoginScreen();
    }

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      final role = snapshot.data()?['role'];

      if (role == 'recycler') return const RecyclerDashboard();
      if (role == 'compounder') return const CompounderDashboard();
      if (role == 'industry') return const IndustryDashboard();
    } catch (e) {
      print("Auto-login error: $e");
    }

    return const RoleSelectionScreen(email: '', password: '');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      future: _getStartScreen(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return snapshot.data ?? const LoginScreen();
      },
    );
  }
}
