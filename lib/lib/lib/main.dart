import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';import 'package:flutter_dotenv/flutter_dotenv.dart';import 'screens/chatbot/chatbot_screen.dart';
import 'screens/analytics/analytics_dashboard.dart';
import 'screens/admin/admin_dashboard.dart';import 'screens/maps/map_screen.dart';import 'screens/chat/chat_screen.dart';import 'screens/chat/chat_screen.dart';import 'package:provider/provider.dart';
        '/admin': (context) => const AdminDashboard(),        '/map': (context) => const MapScreen(),
        '/admin': (context) => const AdminDashboard(),import 'services/theme_provider.dart';
import 'screens/user_type_selection_screen.dart';
import 'screens/dashboards/recycler_dashboard.dart';
import 'screens/dashboards/compounder_dashboard.dart';
import 'screens/dashboards/industry_dashboard.dart';
import 'screens/login_screen.dart'; // Make sure this exists

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
        '/chatbot': (context) => const ChatbotScreen(),
        '/analytics': (context) => const AnalyticsDashboard(),
        '/chat': (context) => const ChatScreen(chatId: 'defaultChat'),        '/dashboard/recycler': (context) => const RecyclerDashboard(),
        '/map': (context) => const MapScreen(),        '/dashboard/compounder': (context) => const CompounderDashboard(),
        '/admin': (context) => const AdminDashboard(),        '/dashboard/industry': (context) => const IndustryDashboard(),
        '/chat': (context) => const ChatScreen(),        '/chat': (context) => const ChatScreen(),      },
        '/map': (context) => const MapScreen(),    );
        '/admin': (context) => const AdminDashboard(),  }
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
