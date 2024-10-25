import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:iseneca/models/models.dart';
import 'package:iseneca/providers/providers.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:intl/intl.dart';


class MayoresScreen extends StatefulWidget {
  const MayoresScreen({super.key});


  @override
  _MayoresScreenState createState() => _MayoresScreenState();
}


class _MayoresScreenState extends State<MayoresScreen> {
  DateTime? selectedDate;


  @override
  Widget build(BuildContext context) {
    final mayoresProvider = Provider.of<ConvivenciaProvider>(context);
    final listadoMayores = mayoresProvider.listaMayores;


    final datosAlumnosProvider = Provider.of<AlumnadoProvider>(context);
    final listadoAlumnos = datosAlumnosProvider.listadoAlumnos;


    List<Mayor> listadoMayoresHoy = [];
    List<DatosAlumnos> cogerDatosMayores = [];


    for (int i = 0; i < listadoMayores.length; i++) {
      listadoMayoresHoy.add(listadoMayores[i]);
      listadoMayoresHoy.sort((a, b) => b.fecFin.compareTo(a.fecFin));
    }


    if (selectedDate != null) {
      listadoMayoresHoy = listadoMayoresHoy.where((mayor) {
        DateTime fecInic = DateTime.parse(mayor.fecInic);
        DateTime fecFin = DateTime.parse(mayor.fecFin);
        return selectedDate!.isAtSameMomentAs(fecInic) ||
            selectedDate!.isAtSameMomentAs(fecFin) ||
            (selectedDate!.isAfter(fecInic) && selectedDate!.isBefore(fecFin));
      }).toList();
    }


    for (int i = 0; i < listadoMayoresHoy.length; i++) {
      for (int j = 0; j < listadoAlumnos.length; j++) {
        if (listadoMayoresHoy[i].apellidosNombre == listadoAlumnos[j].nombre) {
          cogerDatosMayores.add(listadoAlumnos[j]);
        }
      }
    }


    return Scaffold(
      appBar: AppBar(
        title: const Text('Mayores'),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              _selectDate(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
            child: Text(
              selectedDate == null
                  ? "Seleccionar Fecha"
                  : DateFormat('dd/MM/yyyy').format(selectedDate!),
              style: const TextStyle(color: Colors.white),
            ),
          ),
          Expanded(
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.9,
                ),
                child: ListView.builder(
                  itemCount: listadoMayoresHoy.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        _mostrarAlert(
                            context, index, cogerDatosMayores, listadoMayoresHoy);
                      },
                      child: Card(
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        margin: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 10),
                        child: ListTile(
                          title: Text(
                            listadoMayoresHoy[index].apellidosNombre,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                listadoMayoresHoy[index].fecInic,
                                style: const TextStyle(color: Colors.blue),
                              ),
                              const Text(" - "),
                              Text(
                                listadoMayoresHoy[index].fecFin,
                                style: const TextStyle(color: Colors.blue),
                              ),
                            ],
                          ),
                          subtitle: Text(listadoMayoresHoy[index].curso),
                          leading: Text(
                            listadoMayoresHoy[index].aula,
                            style: const TextStyle(
                                color: Colors.blue, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }


  Future<void> _selectDate(BuildContext context) async {
    final DateTime now = DateTime.now();
    final DateTime initialDate = selectedDate ?? now;
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: now,
    );


    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }


  void _mostrarAlert(BuildContext context, int index,
      List<DatosAlumnos> cogerDatosMayores, List<Mayor> listadoMayoresHoy) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          TextStyle textStyle = const TextStyle(fontWeight: FontWeight.bold);


          return AlertDialog(
            insetPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            title: Text(listadoMayoresHoy[index].apellidosNombre),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Divider(
                  color: Colors.black,
                  thickness: 1,
                ),
                Row(
                  children: [
                    Text(
                      "Correo: ",
                      style: textStyle,
                    ),
                    Text(cogerDatosMayores[index].email),
                    IconButton(
                        onPressed: () {
                          launchUrlString("mailto:${cogerDatosMayores[index].email}");
                        },
                        icon: const Icon(Icons.mail),
                        color: Colors.blue),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      "Teléfono Alumno: ",
                      style: textStyle,
                    ),
                    Text(cogerDatosMayores[index].telefonoAlumno),
                    IconButton(
                        onPressed: () {
                          launchUrlString(
                              "tel:${cogerDatosMayores[index].telefonoAlumno}");
                        },
                        icon: const Icon(Icons.phone),
                        color: Colors.blue),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      "Teléfono Madre: ",
                      style: textStyle,
                    ),
                    Text(cogerDatosMayores[index].telefonoMadre),
                    IconButton(
                        onPressed: () {
                          launchUrlString(
                              "tel:${cogerDatosMayores[index].telefonoMadre}");
                        },
                        icon: const Icon(Icons.phone),
                        color: Colors.blue),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      "Teléfono Padre: ",
                      style: textStyle,
                    ),
                    Text(cogerDatosMayores[index].telefonoPadre),
                    IconButton(
                        onPressed: () {
                          launchUrlString(
                              "tel:${cogerDatosMayores[index].telefonoPadre}");
                        },
                        icon: const Icon(Icons.phone),
                        color: Colors.blue),
                  ],
                ),
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cerrar")),
            ],
          );
        });
  }
}
