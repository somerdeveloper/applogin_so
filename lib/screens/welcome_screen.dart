import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  final String email;
  const WelcomeScreen({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bienvenida')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo_inacap.png',
              height: 120,
            ), // Image.asset
            const SizedBox(height: 20),
            const Text(
              'Bienvenido alumno Inacap',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            Text('Tu correo: $email', style: const TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
