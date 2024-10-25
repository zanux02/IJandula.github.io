import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:iseneca/providers/alumnado_provider.dart';
import 'package:iseneca/models/horario_response.dart';

class HorarioDetallesAlumnadoScreen extends StatelessWidget {
  const HorarioDetallesAlumnadoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final index = ModalRoute.of(context)!.settings.arguments as int;
    final alumnadoProvider = Provider.of<AlumnadoProvider>(context);
    final listadoAlumnos = alumnadoProvider.listadoAlumnos;
    final listadoHorarios = alumnadoProvider.listadoHorarios;

    Set<String> diasUnicos =
        listadoHorarios.map((horario) => horario.dia.substring(0, 1)).toSet();

    List<String> diasOrdenados = ["L", "M", "X", "J", "V"]
        .where((dia) => diasUnicos.contains(dia))
        .map((dia) {
      switch (dia) {
        case "L":
          return "Lunes";
        case "M":
          return "Martes";
        case "X":
          return "Miércoles";
        case "J":
          return "Jueves";
        case "V":
          return "Viernes";
        default:
          return dia;
      }
    }).toList();

    Set<String> horasUnicas =
        listadoHorarios.map((horario) => horario.hora).toSet();
    List<String> horasOrdenadas = horasUnicas.toList()
      ..sort((a, b) =>
          int.parse(a.split(":")[0]).compareTo(int.parse(b.split(":")[0])));

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Horario de ${listadoAlumnos[index].curso}", // Nombre del curso del alumno
          style: const TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Table(
                  border: TableBorder.all(color: Colors.blueAccent, width: 2),
                  defaultColumnWidth: const FixedColumnWidth(100.0),
                  children: [
                    _buildDiasSemana(diasOrdenados),
                    for (int i = 0; i < horasOrdenadas.length; i++)
                      _buildHorarioRow(context, index, listadoHorarios, i,
                          diasOrdenados, horasOrdenadas),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              _buildAsignaturasContainer(context, index),
            ],
          ),
        ),
      ),
    );
  }

  TableRow _buildDiasSemana(List<String> diasOrdenados) {
    return TableRow(
      children: [
        _buildTableHeaderCell('Hora'),
        for (var dia in diasOrdenados) _buildTableHeaderCell(dia),
      ],
    );
  }

 TableRow _buildHorarioRow(
    BuildContext context,
    int index,
    List<HorarioResult> listadoHorarios,
    int horaDia,
    List<String> diasOrdenados,
    List<String> horasOrdenadas) {
  final alumnadoProvider = Provider.of<AlumnadoProvider>(context);
  final listadoAlumnos = alumnadoProvider.listadoAlumnos;
  List<HorarioResult> cursoHorarios = listadoHorarios
      .where((horario) => horario.curso == listadoAlumnos[index].curso)
      .toList();

  // Obtener la hora inicial y calcular la hora final sumando 1 hora
  String horaInicio = horasOrdenadas[horaDia];
  String horaFinal = _calcularHoraFinal(horaInicio);

  return TableRow(
    children: [
      _buildTableCell('$horaInicio - $horaFinal', isHeader: true), // Mostrar el rango de horas
      for (var dia in diasOrdenados)
        _buildHorarioCell(cursoHorarios, dia, horasOrdenadas[horaDia]),
    ],
  );
}

// Función para sumar 1 hora a la hora de inicio
String _calcularHoraFinal(String horaInicio) {
  final formatoHora = DateFormat("HH:mm");
  DateTime horaInicial = formatoHora.parse(horaInicio);
  DateTime horaFinal = horaInicial.add(Duration(hours: 1));
  return formatoHora.format(horaFinal);
}


  Widget _buildTableHeaderCell(String text) {
    return Container(
      color: Colors.blueAccent,
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Text(
          text,
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

 Widget _buildTableCell(String text, {bool isHeader = false}) {
  return Container(
    padding: const EdgeInsets.all(8.0),
    color: Colors.white,
    child: Center(
      child: Text(
        text,
        style: TextStyle(
          color: isHeader ? Colors.black : Colors.black,
          fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    ),
  );
}

  Widget _buildHorarioCell(
      List<HorarioResult> cursoHorarios, String dia, String hora) {
    String asignatura = '';
    String aula = '';

    for (var horario in cursoHorarios) {
      if (horario.dia.startsWith(dia.substring(0, 1)) && horario.hora == hora) {
        asignatura = horario.asignatura;
        aula = horario.aulas;
        break;
      }
    }

    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: asignatura.isNotEmpty
            ? const Color.fromARGB(255, 151, 202, 226)
            : Colors.white,
        border: Border.all(color: Colors.blueAccent, width: 1),
      ),
      child: Center(
        child: Column(
          children: [
            Text(
              asignatura.isNotEmpty
                  ? asignatura.substring(0, 3).toUpperCase()
                  : '',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            Text(
              aula,
              style: const TextStyle(fontSize: 12, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }

  // Widget que muestra las asignaturas dinámicamente según el horario del alumno
  Widget _buildAsignaturasContainer(BuildContext context, int index) {
    final alumnadoProvider = Provider.of<AlumnadoProvider>(context);
    final listadoHorarios = alumnadoProvider.listadoHorarios;
    final listadoAlumnos = alumnadoProvider.listadoAlumnos;

    // Obtener las asignaturas únicas del horario del alumno
    List<HorarioResult> cursoHorarios = listadoHorarios
        .where((horario) => horario.curso == listadoAlumnos[index].curso)
        .toList();
    Set<String> asignaturasUnicas =
        cursoHorarios.map((horario) => horario.asignatura).toSet();

    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.symmetric(vertical: 20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.blueAccent),
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'ASIGNATURAS',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 10),
          Text(
            asignaturasUnicas.map((asignatura) {
              final abreviatura = obtenerTresPrimerasLetras(asignatura);
              return '$abreviatura - $asignatura';
            }).join('\n'),
            style: const TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }

  // Método para obtener las primeras tres letras de una asignatura
  String obtenerTresPrimerasLetras(String asignatura) {
    return asignatura.length > 3
        ? asignatura.substring(0, 3).toUpperCase()
        : asignatura.toUpperCase();
  }
}
