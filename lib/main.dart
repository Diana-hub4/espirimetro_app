import 'package:flutter/material.dart';

void main() {
  runApp(const EspirometroApp());
}

class EspirometroApp extends StatelessWidget {
  const EspirometroApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Estación de Espirometría',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

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
