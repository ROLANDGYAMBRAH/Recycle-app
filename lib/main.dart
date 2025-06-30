import 'package:flutter/material.dart';

/* ─── Firebase core + App Check ─────────────────────────────── */
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'firebase_options.dart'; // ✅ correct location

/* ─── Screens ─────────────── */
import 'splash_screen.dart';
import 'onboarding_screen1.dart';
import 'screens/user_type_selection_screen.dart';
import 'screens/collector_signup_screen.dart';
import 'screens/collector_signing_screen.dart';
import 'screens/profile_location_screen.dart';
import 'screens/recycle_items_screen.dart';
import 'screens/all_set_screen.dart';
import 'screens/topup_wallet_screen.dart';
import 'screens/deposit_mobile_money_screen.dart';
import 'screens/materials_collection_screen.dart';
import 'screens/business_info_screen.dart';
import 'screens/confirm_deposit_screen.dart';
import 'screens/complete_payment_screen.dart';
import 'screens/company_signup_screen.dart';
import 'screens/collector_home_screen.dart';
import 'screens/material_category_screen.dart';
import 'screens/material_list_screen.dart';
import 'screens/filter_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    debugPrint('Firebase initialized successfully');
  } catch (e) {
    if (!e.toString().contains('already exists')) {
      debugPrint('Firebase initialization error: $e');
      rethrow;
    }
    debugPrint('Firebase already initialized');
  }

  try {
    await FirebaseAppCheck.instance.activate(
      androidProvider: AndroidProvider.debug,
      appleProvider: AppleProvider.debug,
    );
    debugPrint('Firebase App Check activated');
  } catch (e) {
    debugPrint('Firebase App Check activation error: $e');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Recycle App',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primarySwatch: Colors.green,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    ),
    home: const SplashScreen(),
    routes: {
      '/onboarding': (_) => const OnboardingScreen(),
      '/user_selection': (_) => const UserTypeSelectionScreen(),
      '/collector_signup': (_) => const CollectorSignUpScreen(),
      '/collector_login': (_) => const CollectorSigningScreen(),
      '/signup/profile': (_) => const ProfileLocationScreen(),
      '/recycle_items': (_) => const RecycleItemsScreen(),
      '/all_set': (_) => const AllSetScreen(),
      '/collector_signing': (_) => const CollectorSigningScreen(),
      '/collector_dashboard': (_) => const CollectorHomeScreen(),
      '/topUpWallet': (_) => const TopUpWalletScreen(),
      '/depositMobileMoney': (_) => const DepositMobileMoneyScreen(),
      '/materialsCollection': (_) => const MaterialsCollectionScreen(),
      '/businessInfo': (_) => const BusinessInfoScreen(),
      '/confirmDeposit': (_) => const ConfirmDepositScreen(
        mobileNumber: 'MTN – 055 *** 1234',
        mobileProvider: 'MTN',
        amount: 200,
        commission: 0.0,
      ),
      '/completePayment': (_) => const CompletePaymentScreen(),
      '/company_signup': (_) => const CompanySignUpScreen(),
      '/home': (_) => const HomeScreen(),
      '/materials': (_) => const MaterialCategoryScreen(),
      '/material_list': (_) =>
      const MaterialListScreen(materialName: 'Plastic'),

      // ✅ Filter screen (no const unless your ctor is const)
      '/filters': (_) => FilterScreen(),
    },
    onUnknownRoute: (settings) => MaterialPageRoute(
      builder: (ctx) => Scaffold(
        appBar: AppBar(title: const Text('Page Not Found')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Page not found'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => Navigator.pushNamedAndRemoveUntil(
                  ctx,
                  '/home',
                      (route) => false,
                ),
                child: const Text('Go to Home'),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Home')),
    body: const Center(child: Text('Welcome to Home Screen')),
  );
}
