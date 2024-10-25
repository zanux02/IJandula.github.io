import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AlumnadoScreen extends StatelessWidget {
  const AlumnadoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.blue,
        title: const Text(
          "ALUMNADO",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: ListView(
        children: [
          GestureDetector(
            onTap: () =>
                Navigator.pushNamed(context, "contacto_alumnado_screen"),
            child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: const ListTile(
                leading: FaIcon(
                  FontAwesomeIcons.peopleCarry,
                  color: Color.fromARGB(255, 96, 153, 199),
                ),
                title: Text(
                  'Mail/Teléfono',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                trailing: Icon(Icons.arrow_forward_ios, color: Colors.blue),
              ),
            ),
          ),
          GestureDetector(
            onTap: () =>
                Navigator.pushNamed(context, "localizacion_alumnado_screen"),
            child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: const ListTile(
                leading: FaIcon(
                  FontAwesomeIcons.peopleCarry,
                  color: Color.fromARGB(255, 96, 153, 199),
                ),
                title: Text(
                  'Localización',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                trailing: Icon(Icons.arrow_forward_ios, color: Colors.blue),
              ),
            ),
          ),
          GestureDetector(
            onTap: () =>
                Navigator.pushNamed(context, "horario_alumnado_screen"),
            child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: const ListTile(
                leading: FaIcon(
                  FontAwesomeIcons.peopleCarry,
                  color: Color.fromARGB(255, 96, 153, 199),
                ),
                title: Text(
                  'Horario',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                trailing: Icon(Icons.arrow_forward_ios, color: Colors.blue),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
