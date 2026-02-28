import 'package:flutter/material.dart';
import '../models/espirometria.dart';
import '../services/paciente_service.dart';
import '../utils/diagnostico_espirometria.dart';
import '../services/espirometria_service.dart';

class RegistroEspirometriaScreen extends StatefulWidget {
  final String pacienteId;

  const RegistroEspirometriaScreen({super.key, required this.pacienteId});

  @override
  State<RegistroEspirometriaScreen> createState() =>
      _RegistroEspirometriaScreenState();
}

class _RegistroEspirometriaScreenState
    extends State<RegistroEspirometriaScreen> {

  final _formKey = GlobalKey<FormState>();

  final fvcController = TextEditingController();
  final fev1Controller = TextEditingController();
  final pefController = TextEditingController();

  Espirometria? resultado;

  void calcular() {
    if (!_formKey.currentState!.validate()) return;

    double fvc = double.parse(fvcController.text);
    double fev1 = double.parse(fev1Controller.text);
    double pef = double.parse(pefController.text);
  
    final paciente =
        PacienteService.obtenerPorId(widget.pacienteId);

    if (paciente == null) {
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
        content: Text("Error: paciente no encontrado"),
        ),
    );
    return;
    }

    String diagnostico =
        DiagnosticoEspirometria.evaluar(
      fev1: fev1,
      fvc: fvc,
      fumador: paciente.fumador,
      edad: paciente.edad,
    );

    final nuevaEspirometria = Espirometria(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        pacienteId: widget.pacienteId,
        fechaPrueba: DateTime.now(),
        fvc: fvc,
        fev1: fev1,
        pef: pef,
        diagnostico: diagnostico,
    );

    EspirometriaService.guardar(nuevaEspirometria);

    setState(() {
      resultado = nuevaEspirometria;
    });

    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Espirometría guardada correctamente"),
        ),
    );
  }

  Color obtenerColorDiagnostico(String texto) {
    if (texto.contains("normal")) return Colors.green;
    if (texto.contains("EPOC")) return Colors.red;
    if (texto.contains("obstructivo")) return Colors.orange;
    if (texto.contains("restrictivo")) return Colors.deepPurple;
    return Colors.black;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: const Text("Nueva Espirometría")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [

              TextFormField(
                controller: fvcController,
                decoration: const InputDecoration(labelText: "FVC (L)"),
                keyboardType: TextInputType.number,
                validator: (v) =>
                    v!.isEmpty ? "Ingrese FVC" : null,
              ),

              TextFormField(
                controller: fev1Controller,
                decoration: const InputDecoration(labelText: "FEV1 (L)"),
                keyboardType: TextInputType.number,
                validator: (v) =>
                    v!.isEmpty ? "Ingrese FEV1" : null,
              ),

              TextFormField(
                controller: pefController,
                decoration: const InputDecoration(labelText: "PEF (L/s)"),
                keyboardType: TextInputType.number,
                validator: (v) =>
                    v!.isEmpty ? "Ingrese PEF" : null,
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: calcular,
                child: const Text("Calcular Resultados"),
              ),

              const SizedBox(height: 30),

              if (resultado != null) ...[

                const Divider(),

                Text(
                  "RESULTADOS",
                  style: Theme.of(context).textTheme.titleLarge,
                ),

                const SizedBox(height: 10),

                Text("FVC: ${resultado!.fvc.toStringAsFixed(2)} L"),
                Text("FEV1: ${resultado!.fev1.toStringAsFixed(2)} L"),
                Text("FEV1/FVC: ${resultado!.fev1Fvc.toStringAsFixed(2)} %"),
                Text("PEF: ${resultado!.pef.toStringAsFixed(2)} L/s"),

                const SizedBox(height: 15),

                Text(
                  "Interpretación:",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 5),

                Text(
                  resultado!.interpretacion,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: obtenerColorDiagnostico(
                        resultado!.interpretacion),
                  ),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}