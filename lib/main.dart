import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

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
