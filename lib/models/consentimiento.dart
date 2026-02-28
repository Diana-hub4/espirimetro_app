class Consentimiento {
  final String pacienteId;
  final DateTime fecha;
  final bool aceptado;

  Consentimiento({
    required this.pacienteId,
    required this.fecha,
    required this.aceptado,
  });
}