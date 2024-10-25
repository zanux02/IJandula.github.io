import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/models.dart';
import '../../providers/alumnado_provider.dart';

class LocalizacionAlumnadoScreen extends StatefulWidget {
  const LocalizacionAlumnadoScreen({Key? key}) : super(key: key);

  @override
  State<LocalizacionAlumnadoScreen> createState() =>
      _LocalizacionAlumnadoScreenState();
}

class _LocalizacionAlumnadoScreenState
    extends State<LocalizacionAlumnadoScreen> {
  List<DatosAlumnos> alumnosFiltrados = [];
  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    final alumnadoProvider =
        Provider.of<AlumnadoProvider>(context, listen: false);
    alumnosFiltrados = List.from(alumnadoProvider.listadoAlumnos);
  }

  void filterSearchResults(String query) {
    final alumnadoProvider =
        Provider.of<AlumnadoProvider>(context, listen: false);
    if (query.isNotEmpty) {
      setState(() {
        alumnosFiltrados = alumnadoProvider.listadoAlumnos
            .where((alumno) =>
                alumno.nombre.toLowerCase().contains(query.toLowerCase()))
            .toList();
      });
    } else {
      setState(() {
        alumnosFiltrados = List.from(alumnadoProvider.listadoAlumnos);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final alumnadoProvider = Provider.of<AlumnadoProvider>(context);
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'LOCALIZACIÓN',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(
              width: screenWidth * 0.3,
              margin: const EdgeInsets.only(left: 20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.grey),
              ),
              child: Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.search, color: Colors.white),
                  ),
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      onChanged: (value) {
                        filterSearchResults(value);
                      },
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        hintText: 'Buscar',
                        hintStyle: TextStyle(color: Colors.white54),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView.builder(
        itemCount: alumnosFiltrados.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              _mostrarAlert(context, index, alumnosFiltrados[index],
                  alumnadoProvider.listadoHorarios);
            },
            child: Card(
              elevation: 5,
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                leading: const Icon(
                  Icons.school,
                  color: Colors.blue,
                  size: 30,
                ),
                title: Text(
                  alumnosFiltrados[index].nombre,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.blue,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
void _mostrarAlert(BuildContext context, int index, DatosAlumnos alumno,
    List<HorarioResult> listadoHorarios) {
  DateTime ahora = DateTime.now();
  int horaActual = ahora.hour;
  int minutoActual = ahora.minute;
  String diaActual = obtenerDiaSemana(ahora.weekday);

  // Filtrar los horarios del alumno actual para el día actual
  List<HorarioResult> horariosAlumno = listadoHorarios
      .where((horario) =>
          horario.curso == alumno.curso && horario.dia.startsWith(diaActual))
      .toList();

  String asignatura = "";
  String aula = "";
  String hora = "";

  // Iterar sobre los horarios del alumno actual
  for (int i = 0; i < horariosAlumno.length; i++) {
    String horaInicio = horariosAlumno[i].hora;
    String horaFin = sumarHora(horaInicio);

    // Convertir horas a enteros para la comparación
    int horaInicioInt = int.parse(horaInicio.split(":")[0]);
    int minutoInicioInt = int.parse(horaInicio.split(":")[1]);
    int horaFinInt = int.parse(horaFin.split(":")[0]);
    int minutoFinInt = int.parse(horaFin.split(":")[1]);

    // Verificar si la hora actual está dentro del rango de la clase
    if ((horaActual > horaInicioInt ||
            (horaActual == horaInicioInt &&
                minutoActual >= minutoInicioInt)) &&
        (horaActual < horaFinInt ||
            (horaActual == horaFinInt && minutoActual < minutoFinInt))) {
      asignatura = horariosAlumno[i].asignatura;
      aula = horariosAlumno[i].aulas;
      hora = horariosAlumno[i].hora;
      break; // Se encontró la clase, salir del bucle
    }
  }

  // Si no se encuentra la asignatura o el aula
  if (aula.isEmpty || asignatura.isEmpty) {
    _mostrarDialogInformacionNoDisponible(context);
  } else {
    _mostrarDialog(context, alumno, aula, hora, asignatura);
  }
}

void _mostrarDialog(BuildContext context, DatosAlumnos alumno, String aula, String hora, String asignatura) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        backgroundColor: Colors.white,
        title: Row(
          children: [
            const Icon(
              Icons.info,
              color: Colors.green,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Horario Actual de ${alumno.nombre}',
                style: const TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Row(
                children: [
                  const Icon(Icons.school, color: Colors.blue),
                  const SizedBox(width: 10),
                  Text(
                    'Curso: ${alumno.curso}',
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(Icons.access_time, color: Colors.blue),
                  const SizedBox(width: 10),
                  Text(
                    'Hora: $hora',
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(Icons.book, color: Colors.blue),
                  const SizedBox(width: 10),
                  Text(
                    'Asignatura: $asignatura',
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(Icons.location_on, color: Colors.blue),
                  const SizedBox(width: 10),
                  Text(
                    'Aula en la que se encuentra: $aula',
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            child: const Text(
              'Cerrar',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

void _mostrarDialogInformacionNoDisponible(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        backgroundColor: Colors.white,
        title: Row(
          children: [
            const Icon(
              Icons.error,
              color: Colors.red,
            ),
            const SizedBox(width: 10),
            const Expanded(
              child: Text(
                'Información No Disponible',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        ),
        content: const Text(
          'El alumno seleccionado no tiene clase en la hora actual.',
          style: TextStyle(color: Colors.black),
        ),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            child: const Text(
              'Cerrar',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}


  // Función para sumar una hora a la hora inicial
  String sumarHora(String hora) {
    int horas = int.parse(hora.split(":")[0]) + 1;
    int minutos = int.parse(hora.split(":")[1]);

    // Formatear los minutos a dos dígitos
    String minutosString = minutos.toString().padLeft(2, '0');

    return "$horas:$minutosString";
  }

  // Función para obtener el día de la semana en formato 'L', 'M', etc.
  String obtenerDiaSemana(int weekday) {
    switch (weekday) {
      case DateTime.monday:
        return 'L';
      case DateTime.tuesday:
        return 'M';
      case DateTime.wednesday:
        return 'X';
      case DateTime.thursday:
        return 'J';
      case DateTime.friday:
        return 'V';
      case DateTime.saturday:
        return 'S';
      case DateTime.sunday:
        return 'D';
      default:
        return '';
    }
  }
}
