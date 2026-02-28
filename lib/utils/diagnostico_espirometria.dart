class DiagnosticoEspirometria {

  static String evaluar({
    required double fev1,
    required double fvc,
    required bool fumador,
    required int edad,
  }) {

    double relacion = (fev1 / fvc) * 100;

    // OBSTRUCTIVO
    if (relacion < 70) {

      // Clasificación GOLD basada en % FEV1 estimado simplificado
      double fev1Porcentaje = fev1 * 20; // simplificación demo

      String severidad = "";

      if (fev1Porcentaje >= 80) severidad = "GOLD 1 (Leve)";
      else if (fev1Porcentaje >= 50) severidad = "GOLD 2 (Moderado)";
      else if (fev1Porcentaje >= 30) severidad = "GOLD 3 (Severo)";
      else severidad = "GOLD 4 (Muy severo)";

      if (fumador && edad > 40) {
        return "EPOC $severidad";
      }

      return "Patrón obstructivo compatible con Asma";
    }

    // RESTRICTIVO
    if (relacion >= 70 && fvc < 80) {
      return "Patrón restrictivo - posible enfermedad intersticial o falla respiratoria";
    }

    return "Espirometría dentro de parámetros normales";
  }
}