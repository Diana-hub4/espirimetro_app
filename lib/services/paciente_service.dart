import '../models/paciente.dart';
import 'dart:math';

class PacienteService {
  static final List<Paciente> _pacientes = [];

  static List<Paciente> obtenerPacientes() {
    return _pacientes;
  }

  static void agregarPaciente(Paciente paciente) {
    _pacientes.add(paciente);
  }

  static void actualizarPaciente(Paciente pacienteActualizado) {
    int index = _pacientes.indexWhere((p) => p.id == pacienteActualizado.id);
    if (index != -1) {
      _pacientes[index] = pacienteActualizado;
    }
  }

  static String generarId() {
    return Random().nextInt(999999).toString();
  }

  static Paciente? obtenerPorId(String id) {
    try {
      return _pacientes.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }
}