import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/rendering.dart';

import '../models/espirometria.dart';
import '../models/paciente.dart';
import '../services/espirometria_service.dart';
import '../services/paciente_service.dart';
import '../services/pdf_service.dart';

class GraficaPacienteScreen extends StatefulWidget {
  final String pacienteId;

  const GraficaPacienteScreen({
    super.key,
    required this.pacienteId,
  });

  @override
  State<GraficaPacienteScreen> createState() =>
      _GraficaPacienteScreenState();
}

class _GraficaPacienteScreenState
    extends State<GraficaPacienteScreen> {

  final GlobalKey volumenKey = GlobalKey();
  final GlobalKey flujoKey = GlobalKey();

  Future<Uint8List> capturar(GlobalKey key) async {
    final boundary =
        key.currentContext!.findRenderObject()
            as RenderRepaintBoundary;

    final image = await boundary.toImage(pixelRatio: 3);

    final byteData =
        await image.toByteData(format: ImageByteFormat.png);

    return byteData!.buffer.asUint8List();
  }

  @override
  Widget build(BuildContext context) {
    final List<Espirometria> historial =
        EspirometriaService.obtenerPorPaciente(
            widget.pacienteId);

    final Paciente paciente =
        PacienteService.obtenerPorId(widget.pacienteId)!;

    if (historial.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text("Gráficas")),
        body: const Center(
          child: Text("No hay datos para graficar"),
        ),
      );
    }

    final ultimaPrueba = historial.last;

    /// Generación simulada fisiológica simple
    final volumenSpots = List.generate(
      20,
      (i) => FlSpot(
        i.toDouble(),
        (ultimaPrueba.fvc / 20) * i,
      ),
    );

    final flujoSpots = List.generate(
      20,
      (i) => FlSpot(
        i.toDouble(),
        ultimaPrueba.pef * (1 - i / 20),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("Gráficas Espirometría"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [

            /// ==========================
            /// CURVA VOLUMEN - TIEMPO
            /// ==========================

            const Text(
              "Curva Volumen - Tiempo",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 15),

            RepaintBoundary(
              key: volumenKey,
              child: SizedBox(
                height: 250,
                child: LineChart(
                  LineChartData(
                    borderData:
                        FlBorderData(show: true),
                    titlesData:
                        FlTitlesData(show: true),
                    lineBarsData: [
                      LineChartBarData(
                        spots: volumenSpots,
                        isCurved: true,
                        barWidth: 3,
                        dotData:
                            FlDotData(show: false),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),

            /// ==========================
            /// CURVA FLUJO - TIEMPO
            /// ==========================

            const Text(
              "Curva Flujo - Tiempo",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 15),

            RepaintBoundary(
              key: flujoKey,
              child: SizedBox(
                height: 250,
                child: LineChart(
                  LineChartData(
                    borderData:
                        FlBorderData(show: true),
                    titlesData:
                        FlTitlesData(show: true),
                    lineBarsData: [
                      LineChartBarData(
                        spots: flujoSpots,
                        isCurved: true,
                        barWidth: 3,
                        dotData:
                            FlDotData(show: false),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),

            /// ==========================
            /// BOTÓN EXPORTAR PDF
            /// ==========================

            ElevatedButton(
              onPressed: () async {
                final imgVol =
                    await capturar(volumenKey);
                final imgFlu =
                    await capturar(flujoKey);

                await PdfService.generarYCompartir(
                  paciente,
                  ultimaPrueba,
                  imgVol,
                  imgFlu,
                );
              },
              child:
                  const Text("Exportar PDF Clínico"),
            ),
          ],
        ),
      ),
    );
  }
}