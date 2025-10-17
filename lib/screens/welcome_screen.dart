// lib/screens/welcome_screen.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'evaluaciones_screen.dart';

class WelcomeScreen extends StatefulWidget {
  final String email;
  const WelcomeScreen({super.key, required this.email});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  void initState() {
    super.initState();
    // Inicia un temporizador para navegar después de 2.5 segundos
    Timer(const Duration(milliseconds: 2500), () {
      if (mounted) {
        // Buena práctica: verificar que el widget aún existe
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const EvaluacionesScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/logo_inacap.png', height: 120),
            const SizedBox(height: 30),
            Text(
              '¡Bienvenido!',
              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(widget.email, style: Theme.of(context).textTheme.titleLarge),
          ],
        ),
      ),
    );
  }
}
