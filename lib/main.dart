import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

void main() => runApp(const IotLoginApp());

// COLORES CORPORATIVOS
const Color inacapRed = Color(0xFFED1C24);

class IotLoginApp extends StatelessWidget {
  const IotLoginApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IoT Login',
      theme: ThemeData(
        primaryColor: inacapRed,
        appBarTheme: const AppBarTheme(
          backgroundColor: inacapRed,
          foregroundColor: Colors.white, // Texto blanco sobre rojo
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: inacapRed, // Botón rojo
            foregroundColor: Colors.white, // Texto blanco
            minimumSize: const Size(
              double.infinity,
              48,
            ), // Botones anchos y consistentes
          ),
        ),
      ),
      home: const LoginScreen(),
    );
  }
}
