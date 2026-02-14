import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Estación de Espirometría'),
      ),
      body: const Center(
        child: Text(
          'Sistema en configuración...',
          style: TextStyle(fontSize: 22),
        ),
      ),
    );
  }
}
