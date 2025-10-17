import 'package:flutter/material.dart';
import 'screens/login_screen.dart'; // Tu pantalla de login
import 'theme/colors.dart'; // Importamos nuestros colores personalizados

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Evaluaciones',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Tema principal de la aplicación
        primarySwatch: Colors.red, // Usa una base de rojo
        scaffoldBackgroundColor:
            inacapLightGrey, // Color de fondo para las pantallas
        // Define el tema para el AppBar
        appBarTheme: const AppBarTheme(
          backgroundColor: inacapRed, // Rojo INACAP para la barra
          foregroundColor: Colors.white, // Texto y iconos en blanco
          elevation: 4.0,
          titleTextStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),

        // Define el tema para los botones elevados (ElevatedButton)
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: inacapRed, // Rojo INACAP para botones
            foregroundColor: Colors.white, // Texto del botón en blanco
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),

        // Define el tema para los FloatingActionButton
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: inacapRed,
          foregroundColor: Colors.white,
        ),

        // Define el tema para los campos de texto
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: inacapRed, width: 2),
          ),
          labelStyle: const TextStyle(color: inacapDarkBlue),
        ),

        // Define el tema para los chips
        chipTheme: ChipThemeData(
          backgroundColor: Colors.grey.shade300,
          selectedColor: inacapRed.withOpacity(0.8),
          labelStyle: const TextStyle(color: inacapDarkBlue),
          secondaryLabelStyle: const TextStyle(color: Colors.white),
          padding: const EdgeInsets.all(8),
        ),
      ),
      home: const LoginScreen(),
    );
  }
}
