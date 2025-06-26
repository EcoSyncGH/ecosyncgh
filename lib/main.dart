import 'package:flutter/material.dart';
import 'theme.dart';
import 'screens/login_screen.dart';

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
      home: const LoginScreen(),
    );
  }
}
