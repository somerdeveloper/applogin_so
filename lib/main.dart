// lib/main.dart

import 'package:flutter/material.dart';
import 'screens/login_screen.dart'; // Asegúrate de que la ruta a tu login screen es correcta

// Esta es la función principal y obligatoria que inicia toda la aplicación.
void main() {
  runApp(const GestorEvaluacionesApp());
}

// Este es el widget raíz de tu aplicación.
class GestorEvaluacionesApp extends StatelessWidget {
  const GestorEvaluacionesApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Definimos el color corporativo para usarlo en el tema.
    const Color inacapRed = Color(0xFFED1C24);

    return MaterialApp(
      title: 'Gestor de Evaluaciones',
      debugShowCheckedModeBanner: false,

      // Aquí definimos el tema global para toda la app, cumpliendo con la rúbrica.
      theme: ThemeData(
        primaryColor: inacapRed,
        scaffoldBackgroundColor: Colors
            .grey[50], // Un fondo ligeramente gris para que las tarjetas resalten
        // Tema para la barra de navegación superior (AppBar)
        appBarTheme: const AppBarTheme(
          backgroundColor: inacapRed,
          foregroundColor: Colors.white, // Texto e iconos en blanco
          elevation: 2,
        ),

        // Tema para los botones elevados
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: inacapRed,
            foregroundColor: Colors.white, // Texto en blanco
            minimumSize: const Size(
              double.infinity,
              48,
            ), // Ancho completo y altura fija
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),

        // Tema para el botón de acción flotante
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: inacapRed,
          foregroundColor: Colors.white,
        ),

        // Usar Material 3 le da un look más moderno
        useMaterial3: true,
      ),

      // La pantalla inicial de la aplicación.
      home: const LoginScreen(),
    );
  }
}
