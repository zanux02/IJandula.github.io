import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:iseneca/models/credenciales_response.dart';
import 'package:provider/provider.dart';
import 'package:iseneca/providers/centro_provider.dart';
import 'package:iseneca/models/horario_response.dart';

class HorarioProfesoresDetallesScreen extends StatefulWidget {
  @override
  _HorarioProfesoresDetallesScreenState createState() =>
      _HorarioProfesoresDetallesScreenState();
}

class _HorarioProfesoresDetallesScreenState
    extends State<HorarioProfesoresDetallesScreen> {
  late Credenciales profesor;
  late CentroProvider centroProvider;
  late Future<void> _horarioFuture;
  List<HorarioResult> horarioProfesor = [];
  Set<String> asignaturasProfesor = {};

  @override
  void initState() {
    super.initState();
    final credenciales =
        ModalRoute.of(context)!.settings.arguments as Credenciales;
    profesor = credenciales;
    centroProvider = Provider.of<CentroProvider>(context, listen: false);
    _horarioFuture = _fetchHorario(centroProvider, profesor);
  }

  Future<void> _fetchHorario(
    CentroProvider horarioProvider,
    Credenciales profesor,
  ) async {
    await horarioProvider.getHorario();
    final horarios = horarioProvider.listaHorariosProfesores.result;
    setState(() {
      horarioProfesor =
          obtenerHorarioDelProfesor(profesor.nombre, profesor.apellidos, horarios);
      asignaturasProfesor = _obtenerAsignaturasUnicas(horarioProfesor);
    });
  }

  List<HorarioResult> obtenerHorarioDelProfesor(
      String nombre, String apellido, List<HorarioResult> horarios) {
    return horarios
        .where((horario) =>
            horario.nombreProfesor == nombre &&
            horario.apellidoProfesor == apellido)
        .toList();
  }

  Set<String> _obtenerAsignaturasUnicas(List<HorarioResult> horarios) {
    return horarios.map((horario) => horario.asignatura).toSet();
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text(
        "Horario de ${profesor.nombre} ${profesor.apellidos}",
        style: const TextStyle(color: Colors.white),
      ),
      centerTitle: true,
      backgroundColor: Colors.blue,
    ),
    body: FutureBuilder<void>(
      future: _horarioFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        List<String> diasOrdenados = ["L", "M", "X", "J", "V"];
        List<String> diasNombres = [
          "Lunes",
          "Martes",
          "Miércoles",
          "Jueves",
          "Viernes"
        ];

        Set<String> horasUnicas =
            horarioProfesor.map((horario) => horario.hora).toSet();
        List<String> horasOrdenadas = horasUnicas.toList()
          ..sort((a, b) =>
              int.parse(a.split(":")[0]).compareTo(int.parse(b.split(":")[0])));

        return SingleChildScrollView(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Centrar verticalmente
            children: [
             SizedBox(height: MediaQuery.of(context).size.height * 0.02), // Espacio adaptable
              Center( // Centro el horario
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Table(
                    border: TableBorder.all(color: Colors.blueAccent, width: 2),
                    defaultColumnWidth: const FixedColumnWidth(100.0),
                    children: [
                      _buildDiasSemana(diasNombres),
                      for (int i = 0; i < horasOrdenadas.length; i++)
                        _buildHorarioRow(i, diasOrdenados, horasOrdenadas),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center( // Centro el contenedor de asignaturas
                child: _buildAsignaturasContainer(),
              ),
            ],
          ),
        );
      },
    ),
  );
}


  TableRow _buildDiasSemana(List<String> diasNombres) {
    return TableRow(
      children: [
        _buildTableHeaderCell('Hora'),
        for (var dia in diasNombres) _buildTableHeaderCell(dia),
      ],
    );
  }

  TableRow _buildHorarioRow(int horaDia, List<String> diasOrdenados, List<String> horasOrdenadas) {
    String horaInicio = horasOrdenadas[horaDia];
    String horaFinal = _calcularHoraFinal(horaInicio);

    return TableRow(
      children: [
        _buildTableCell('$horaInicio - $horaFinal', isHeader: true),
        for (var dia in diasOrdenados) 
          _buildHorarioCell(dia, horasOrdenadas[horaDia]),
      ],
    );
  }

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
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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

  Widget _buildHorarioCell(String dia, String hora) {
    String asignatura = '';
    String aula = '';

    for (var horario in horarioProfesor) {
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

  Widget _buildAsignaturasContainer() {
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
            asignaturasProfesor.map((asignatura) {
              final abreviatura = obtenerTresPrimerasLetras(asignatura);
              return '$abreviatura - $asignatura';
            }).join('\n'),
            style: const TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }

  String obtenerTresPrimerasLetras(String asignatura) {
    return asignatura.length > 3
        ? asignatura.substring(0, 3).toUpperCase()
        : asignatura.toUpperCase();
  }
}
