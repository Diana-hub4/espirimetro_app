import '../models/espirometria.dart';

class EspirometriaService {
  static final List<Espirometria> _espirometrias = [];

  static void guardar(Espirometria espirometria) {
    _espirometrias.add(espirometria);
  }

  static List<Espirometria> obtenerPorPaciente(String pacienteId) {
    return _espirometrias
        .where((e) => e.pacienteId == pacienteId)
        .toList();
  }

  static List<Espirometria> obtenerTodas() {
    return _espirometrias;
  }
}