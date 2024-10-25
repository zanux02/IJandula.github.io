import 'dart:convert';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:iseneca/models/Student.dart';

class ProviderAlumno extends ChangeNotifier {
  List<Student> _students = [];
  final String baseUrl =
      'https://script.google.com/macros/s/AKfycbww17NqHZU5opz9SkMtUASKZOg1Hg6KsExRSvlqAMyrx4i0Ax9P5I7IQtKRcnsMKVivdw/exec';
  List<Student> get students => _students;


  Future<void> fetchData(BuildContext context) async {
    final Uri url = Uri.parse(
        'https://script.google.com/macros/s/AKfycbyPsB_koj3MwkmRFn8IJU-k4sOP8nRfnHHKNNt9xov9INZ1VEsQbu96gDR8Seiz0oDGOQ/exec?spreadsheetId=11Y4M52bYFMCIa5uU52vKll2-OY0VtFiGK2PhMWShngg&sheet=Datos_Alumnado');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body) as List<dynamic>;
        _students = data.map((json) => Student.fromJson(json)).toList();
        _showSnackbar(context, 'Datos cargados correctamente');
      } else {
        print('Error en la solicitud: ${response.statusCode}');
        throw Exception('Error en la solicitud: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
      _showSnackbar(context, 'Error al cargar datos: $e');
      throw Exception('Error: $e');
    }
  }

  void _showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  String _convertIsoToUtf8(String isoString) {
    // Convertir la cadena a bytes en ISO-8859-1
    List<int> isoBytes = latin1.encode(isoString);
    // Decodificar los bytes a UTF-8
    return utf8.decode(isoBytes);
  }
}
