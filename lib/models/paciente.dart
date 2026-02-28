import 'package:flutter/foundation.dart';

class Paciente {
  // 🔐 Internos
  String id;
  DateTime fechaCreacion;
  bool sincronizado;
  String versionApp;

  // 👤 Datos clínicos
  String tipoDocumento;
  String numeroDocumento;
  String nombres;
  String apellidos;
  DateTime fechaNacimiento;
  String sexoBiologico;
  double talla;
  double? peso;
  String? etnia;

  // 🧪 Factores de riesgo
  bool fumador;
  bool alcohol;
  bool sustancias;

  // 👨‍👩‍👦 Acudiente
  String? nombreAcudiente;
  String? telefonoAcudiente;

  Paciente({
    required this.id,
    required this.fechaCreacion,
    required this.sincronizado,
    required this.versionApp,
    required this.tipoDocumento,
    required this.numeroDocumento,
    required this.nombres,
    required this.apellidos,
    required this.fechaNacimiento,
    required this.sexoBiologico,
    required this.talla,
    this.peso,
    this.etnia,
    required this.fumador,
    required this.alcohol,
    required this.sustancias,
    this.nombreAcudiente,
    this.telefonoAcudiente,
  });

  int get edad {
    final hoy = DateTime.now();
    int edad = hoy.year - fechaNacimiento.year;
    if (hoy.month < fechaNacimiento.month ||
        (hoy.month == fechaNacimiento.month &&
            hoy.day < fechaNacimiento.day)) {
      edad--;
    }
    return edad;
  }
}