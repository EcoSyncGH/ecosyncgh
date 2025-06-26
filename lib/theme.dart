import 'package:flutter/material.dart';

final ThemeData ecoSyncTheme = ThemeData(
  primaryColor: const Color(0xFF678E35), // Cor principal (botões)
  scaffoldBackgroundColor: const Color(0xFFC7DEA6), // Tela inicial
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: const Color(0xFFEEFFDD), // Campos de texto
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: BorderSide.none,
    ),
    contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
  ),
  textTheme: const TextTheme(
    titleLarge: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
    bodyMedium: TextStyle(
      fontSize: 16,
      color: Colors.white,
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF678E35), // Botões padrão
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    ),
  ),
);
