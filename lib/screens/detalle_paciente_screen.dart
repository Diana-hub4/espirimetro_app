import 'package:flutter/material.dart';
import '../models/paciente.dart';
import '../services/consentimiento_service.dart';
import '../services/espirometria_service.dart';
import '../services/pdf_service.dart';

import 'registro_espirometria_screen.dart';
import 'consentimiento_screen.dart';
import 'grafica_paciente_screen.dart';

class DetallePacienteScreen extends StatelessWidget {
  final Paciente paciente;

  const DetallePacienteScreen({
    super.key,
    required this.paciente,
  });

  @override
  Widget build(BuildContext context) {
    final historial =
        EspirometriaService.obtenerPorPaciente(paciente.id);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Detalle del Paciente"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [

            /// ===============================
            /// 🔹 INFORMACIÓN GENERAL
            /// ===============================

            Text(
              "${paciente.nombres} ${paciente.apellidos}",
              style: Theme.of(context).textTheme.titleLarge,
            ),

            const SizedBox(height: 15),

            Text("Documento: ${paciente.tipoDocumento} ${paciente.numeroDocumento}"),
            Text("Edad: ${paciente.edad} años"),
            Text("Sexo: ${paciente.sexoBiologico}"),
            Text("Talla: ${paciente.talla} cm"),
            Text("Peso: ${paciente.peso ?? "No registrado"} kg"),
            Text("Etnia: ${paciente.etnia ?? "No especificada"}"),

            const SizedBox(height: 30),
            const Divider(),

            /// ===============================
            /// 🔹 ACCIONES CLÍNICAS
            /// ===============================

            const SizedBox(height: 15),

            const SizedBox(height: 12),

            /// 🔹 NUEVA ESPIROMETRÍA
            ElevatedButton(
              onPressed: () {
                bool tieneConsentimiento =
                    ConsentimientoService.tieneConsentimiento(paciente.id);

                if (!tieneConsentimiento) {
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text("Consentimiento requerido"),
                      content: const Text(
                          "Debe registrar el consentimiento informado antes de realizar la prueba."),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("Cerrar"),
                        ),
                      ],
                    ),
                  );
                  return;
                }

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        RegistroEspirometriaScreen(
                          pacienteId: paciente.id,
                        ),
                  ),
                );
              },
              child: const Text("Nueva Espirometría"),
            ),

            const SizedBox(height: 12),

            /// 🔹 CONSENTIMIENTO
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        ConsentimientoScreen(
                          pacienteId: paciente.id,
                        ),
                  ),
                );
              },
              child: const Text("Consentimiento Informado"),
            ),

            const SizedBox(height: 12),

            /// 🔹 VER GRÁFICA
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        GraficaPacienteScreen(
                          pacienteId: paciente.id,
                        ),
                  ),
                );
              },
              child: const Text("Ver Gráfica de la Prueba"),
            ),

            const SizedBox(height: 30),
            const Divider(),

            /// ===============================
            /// 🔹 HISTORIAL
            /// ===============================

            const SizedBox(height: 10),

            Text(
              "Historial de Espirometrías",
              style: Theme.of(context).textTheme.titleMedium,
            ),

            const SizedBox(height: 15),

            if (historial.isEmpty)
              const Text("No hay pruebas registradas"),

            ...historial.map(
              (e) => Card(
                elevation: 2,
                child: ListTile(
                  title: Text(
                    "Fecha: ${e.fechaPrueba.toLocal().toString().split(' ')[0]}",
                  ),
                  subtitle: Text(
                    "FEV1/FVC: ${e.fev1Fvc.toStringAsFixed(1)}%",
                  ),
                  trailing: Text(
                    e.diagnostico,
                    style: TextStyle(
                      color: e.diagnostico.contains("normal")
                          ? Colors.green
                          : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}