import 'package:iseneca/models/alumno_servcio.dart';

class DatosVisita {
  AlumnoServcio alumno;
  String horas;
  String dia;
  DatosVisita({required this.alumno, required this.horas, required this.dia});

  factory DatosVisita.fromMap(Map<String, dynamic> mapa) {
    return DatosVisita(
        alumno: AlumnoServcio.fromJson(mapa['alumno']),
        horas: mapa['horas'],
        dia: mapa['dia']);
  }

  Map<String, dynamic> toMap() {
    return {'alumno': alumno.toJson(), 'horas': horas, 'dia': dia};
  }
}
