import 'package:flutter/material.dart';
import 'theme.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/onboarding_screen.dart';

void main() {
  runApp(const EcoSyncApp());
}

class EcoSyncApp extends StatelessWidget {
  const EcoSyncApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EcoSync',
      debugShowCheckedModeBanner: false,
      theme: ecoSyncTheme,
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const SignupScreen(),
        '/onboarding': (context) => const OnboardingScreen(),
      },
    );
  }
}
