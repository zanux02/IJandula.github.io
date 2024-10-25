import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:iseneca/models/alumnos_response.dart';
import 'package:iseneca/providers/providers.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ContactoDetallesAlumnadoScreen extends StatefulWidget {
  const ContactoDetallesAlumnadoScreen({Key? key}) : super(key: key);

  @override
  _ContactoDetallesAlumnadoScreenState createState() =>
      _ContactoDetallesAlumnadoScreenState();
}

class _ContactoDetallesAlumnadoScreenState
    extends State<ContactoDetallesAlumnadoScreen> {
  List<DatosAlumnos> listaAlumnos = [];
  List<DatosAlumnos> alumnosFiltrados = [];
  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final alumnadoProvider =
          Provider.of<AlumnadoProvider>(context, listen: false);
      final listadoAlumnos = alumnadoProvider.listadoAlumnos;
      final nombreCurso = ModalRoute.of(context)!.settings.arguments;

      // Filtrar alumnos por curso
      setState(() {
        listaAlumnos = listadoAlumnos
            .where((alumno) => alumno.curso == nombreCurso)
            .toList();
        alumnosFiltrados = List.from(
            listaAlumnos); // Inicialmente, todos los alumnos están visibles
      });
    });
  }

  void filterSearchResults(String query) {
    setState(() {
      if (query.isEmpty) {
        alumnosFiltrados = List.from(listaAlumnos);
      } else {
        alumnosFiltrados = listaAlumnos
            .where((alumno) =>
                alumno.nombre.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'ALUMNOS',
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
      body: alumnosFiltrados.isEmpty
          ? const Center(child: Text("No se encontraron alumnos"))
          : ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: alumnosFiltrados.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    _mostrarAlert(context, index, alumnosFiltrados);
                  },
                  child: Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.blue,
                        child: Text(
                          alumnosFiltrados[index].nombre[0],
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      title: Text(
                        alumnosFiltrados[index].nombre,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 8, 8, 8),
                        ),
                      ),
                      trailing: const Icon(
                        Icons.arrow_forward,
                        color: Colors.blueAccent,
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }

  void _mostrarAlert(
      BuildContext context, int index, List<DatosAlumnos> listaAlumnos) {
    DatosAlumnos alumno = listaAlumnos[index];

    String telefonoAlumno = alumno.telefonoAlumno;
    String telefonoPadre = alumno.telefonoPadre;
    String telefonoMadre = alumno.telefonoMadre;
    String mailAlumno = alumno.email;

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          title: Text(alumno.nombre),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Divider(color: Colors.black, thickness: 1),
              _buildContactInfoRow(Icons.mail, "Correo: $mailAlumno",
                  () => launchUrlString("mailto:$mailAlumno")),
              _buildContactInfoRow(
                  Icons.phone,
                  "Teléfono Alumno: $telefonoAlumno",
                  () => launchUrlString("tel:$telefonoAlumno")),
              _buildContactInfoRow(
                  Icons.phone,
                  "Teléfono Padre: $telefonoPadre",
                  () => launchUrlString("tel:$telefonoPadre")),
              _buildContactInfoRow(
                  Icons.phone,
                  "Teléfono Madre: $telefonoMadre",
                  () => launchUrlString("tel:$telefonoMadre")),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cerrar"),
            ),
          ],
        );
      },
    );
  }

  Widget _buildContactInfoRow(
      IconData icon, String text, VoidCallback onPressed) {
    return Row(
      children: [
        Icon(icon, color: Colors.blueAccent),
        const SizedBox(width: 10),
        Expanded(
          child: GestureDetector(
            onTap: onPressed,
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
