import 'package:flutter/material.dart';
import 'package:iseneca/models/horario_response.dart';
import 'package:iseneca/utils/utilidades.dart';
import 'package:iseneca/utils/google_sheets.dart';

class CentroProvider extends ChangeNotifier {
  
  late HorarioResponse listaHorariosProfesores;
 

  CentroProvider() {
    debugPrint("Centro Provider inicializado");

    getHorario();
  }

  getHorario() async {
    const url =
        GoogleSheets.horarios;
    String jsonData = await Utilidades.getJsonData(url);
    jsonData = '{"results":$jsonData}';
    listaHorariosProfesores = HorarioResponse.fromJson(jsonData);

    notifyListeners();
  }
}
