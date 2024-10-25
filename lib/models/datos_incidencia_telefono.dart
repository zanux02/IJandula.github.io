class DatosIncidencia {
  DateTime? fecha;
  String? hora;
  String? profesor;
  String? alumno;
  String incidencia;

  DatosIncidencia({
    this.fecha,
    this.hora,
    this.profesor,
    this.alumno,
    required this.incidencia,
  });
}
