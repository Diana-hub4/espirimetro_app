import 'package:flutter/material.dart';
import '../services/espirometria_service.dart';
import '../models/espirometria.dart';

class ReportesScreen extends StatelessWidget {
  const ReportesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Espirometria> pruebas =
        EspirometriaService.obtenerTodas();

    int total = pruebas.length;

    int normales = pruebas
        .where((e) => e.diagnostico.contains("normal"))
        .length;

    int epoc = pruebas
        .where((e) => e.diagnostico.contains("EPOC"))
        .length;

    int obstructivos = pruebas
        .where((e) => e.diagnostico.contains("obstructivo"))
        .length;

    int restrictivos = pruebas
        .where((e) => e.diagnostico.contains("restrictivo"))
        .length;

    return Scaffold(
      appBar: AppBar(title: const Text("Reportes Generales")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: total == 0
            ? const Center(
                child: Text("No hay pruebas registradas"),
              )
            : ListView(
                children: [
                  _buildCard("Total Pruebas", total.toString()),
                  _buildCard("Normales", normales.toString(),
                      color: Colors.green),
                  _buildCard("EPOC", epoc.toString(),
                      color: Colors.red),
                  _buildCard("Obstructivos",
                      obstructivos.toString(),
                      color: Colors.orange),
                  _buildCard("Restrictivos",
                      restrictivos.toString(),
                      color: Colors.deepPurple),
                ],
              ),
      ),
    );
  }

  Widget _buildCard(String titulo, String valor,
      {Color color = Colors.blue}) {
    return Card(
      child: ListTile(
        title: Text(titulo),
        trailing: Text(
          valor,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ),
    );
  }
}