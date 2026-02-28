import '../models/consentimiento.dart';

class ConsentimientoService {
  static final List<Consentimiento> _consentimientos = [];

  static void guardarConsentimiento(Consentimiento consentimiento) {
    _consentimientos.removeWhere(
        (c) => c.pacienteId == consentimiento.pacienteId);
    _consentimientos.add(consentimiento);
  }

  static bool tieneConsentimiento(String pacienteId) {
    return _consentimientos
        .any((c) => c.pacienteId == pacienteId && c.aceptado);
  }
}