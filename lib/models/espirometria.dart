class Espirometria {
  final String id;
  final String pacienteId;
  final DateTime fechaPrueba;
  final double fvc;
  final double fev1;
  final double pef;
  final String diagnostico;

  Espirometria({
    required this.id,
    required this.pacienteId,
    required this.fechaPrueba,
    required this.fvc,
    required this.fev1,
    required this.pef,
    required this.diagnostico,
  });

  double get fev1Fvc => (fev1 / fvc) * 100;

  String get interpretacion => diagnostico;
}