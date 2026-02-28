import 'dart:typed_data';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

import '../models/paciente.dart';
import '../models/espirometria.dart';

class PdfService {
  static Future<void> generarYCompartir(
    Paciente paciente,
    Espirometria prueba,
    Uint8List imagenVolumen,
    Uint8List imagenFlujo,
  ) async {
    final pdf = pw.Document();

    final imgVol = pw.MemoryImage(imagenVolumen);
    final imgFlu = pw.MemoryImage(imagenFlujo);

    pdf.addPage(
      pw.MultiPage(
        build: (context) => [
          pw.Text(
            "REPORTE CLÍNICO DE ESPIROMETRÍA",
            style: pw.TextStyle(
              fontSize: 18,
              fontWeight: pw.FontWeight.bold,
            ),
          ),

          pw.SizedBox(height: 20),

          pw.Text("Nombre: ${paciente.nombres} ${paciente.apellidos}"),
          pw.Text("Documento: ${paciente.numeroDocumento}"),
          pw.Text("Edad: ${paciente.edad} años"),
          pw.Text("Sexo: ${paciente.sexoBiologico}"),

          pw.SizedBox(height: 20),

          pw.Text("FVC: ${prueba.fvc.toStringAsFixed(2)} L"),
          pw.Text("FEV1: ${prueba.fev1.toStringAsFixed(2)} L"),
          pw.Text("FEV1/FVC: ${prueba.fev1Fvc.toStringAsFixed(2)} %"),
          pw.Text("PEF: ${prueba.pef.toStringAsFixed(2)} L/s"),
          pw.Text("Diagnóstico: ${prueba.diagnostico}"),

          pw.SizedBox(height: 30),

          pw.Text("Curva Volumen - Tiempo"),
          pw.SizedBox(height: 10),
          pw.Image(imgVol, height: 200),

          pw.SizedBox(height: 30),

          pw.Text("Curva Flujo - Tiempo"),
          pw.SizedBox(height: 10),
          pw.Image(imgFlu, height: 200),
        ],
      ),
    );

    final bytes = await pdf.save();

    await Printing.sharePdf(
      bytes: bytes,
      filename: "reporte_${paciente.numeroDocumento}.pdf",
    );
  }
}