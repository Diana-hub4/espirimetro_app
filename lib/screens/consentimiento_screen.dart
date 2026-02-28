import 'package:flutter/material.dart';
import '../models/consentimiento.dart';
import '../services/consentimiento_service.dart';

class ConsentimientoScreen extends StatefulWidget {
  final String pacienteId;

  const ConsentimientoScreen({super.key, required this.pacienteId});

  @override
  State<ConsentimientoScreen> createState() =>
      _ConsentimientoScreenState();
}

class _ConsentimientoScreenState
    extends State<ConsentimientoScreen> {

  bool aceptado = false;

  void guardar() {
    Consentimiento consentimiento = Consentimiento(
      pacienteId: widget.pacienteId,
      fecha: DateTime.now(),
      aceptado: true,
    );

    ConsentimientoService.guardarConsentimiento(consentimiento);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Consentimiento registrado correctamente"),
      ),
    );

    Future.delayed(const Duration(milliseconds: 800), () {
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Consentimiento Informado"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            const Text(
              "CONSENTIMIENTO INFORMADO PARA ESPIROMETRÍA",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            ),
            const SizedBox(height: 20),
            const Text(
              "Declaro que he sido informado(a) sobre el procedimiento "
              "de espirometría, sus objetivos, posibles molestias y riesgos. "
              "Autorizo voluntariamente la realización de la prueba.",
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 30),

            CheckboxListTile(
              value: aceptado,
              onChanged: (v) {
                setState(() {
                  aceptado = v!;
                });
              },
              title: const Text(
                  "Acepto y autorizo la realización de la prueba"),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: aceptado ? guardar : null,
              child: const Text("Guardar Consentimiento"),
            ),
          ],
        ),
      ),
    );
  }
}