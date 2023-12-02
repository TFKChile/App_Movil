import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class SchedulePage extends StatefulWidget {
  @override
  _SchedulePageState createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  final TextEditingController roomCodeController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  
  // JWT ingresado manualmente (reemplaza esto con el JWT real)
  final String jwt = 'eyJhbGciOiJSUzI1NiIsImtpZCI6ImU0YWRmYjQzNmI5ZTE5N2UyZTExMDZhZjJjODQyMjg0ZTQ5ODZhZmYiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJodHRwczovL2FjY291bnRzLmdvb2dsZS5jb20iLCJhenAiOiIyMTIyNjc2ODY2MDQtMGo0a3M5c25pa2plMHNzdGpqbW10Mm1tZTJvZHYyZnUuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJhdWQiOiIyMTIyNjc2ODY2MDQtMGo0a3M5c25pa2plMHNzdGpqbW10Mm1tZTJvZHYyZnUuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJzdWIiOiIxMTUyNTc2MzkzMzE0NTk1MzM3NDEiLCJoZCI6InV0ZW0uY2wiLCJlbWFpbCI6Implc2NvYmFydkB1dGVtLmNsIiwiZW1haWxfdmVyaWZpZWQiOnRydWUsImF0X2hhc2giOiJfTTNEMHBYa1ZBTVFzcVZrckJub3NBIiwiaWF0IjoxNzAxNTA3MDU4LCJleHAiOjE3MDE1MTA2NTh9.L7zwQrTRCNlN8boofsUXHXNkABB-vcS5AU9HSceJVOVorLZgcw4IW53rXGQEoKyjqTg_a5c5VN7-ndhTLQF13I959saDe9AS99CfH8zeHleq0IHYkn_VZDwyipr2ju5uXsckgoLR5KzwU6IfNM_FISCAwNqjztlnM6FyLskui5MRWexGmQyJydJYbiuH85T8RdmpZCikiUZowcPBiX2as6XD_av8vj-JEb99how6cLTwgGEnQSdlI51ma75eIw4XkxF6_h_EGQKM3a_RqfYjZd6vdDklcpyyv3F5mp1ymSfSFr7qj5C-NLl45xmbnpaOyzQlCF7qkSUbx4ez4CW-BQ';

  Future<void> fetchSchedule() async {
    String roomCode = roomCodeController.text;
    String isoDate = dateController.text;
    var url = Uri.parse('https://api.sebastian.cl/booking/v1/$roomCode/schedule/$isoDate');

    try {
      var response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $jwt',
        },
      );

      if (response.statusCode == 200) {
        // Procesa los datos de la respuesta aquí
        print('Datos de agenda: ${response.body}');
      } else {
        print('Error en la solicitud: ${response.statusCode}');
      }
    } catch (e) {
      print('Error al enviar la solicitud: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Consultar Agenda de Sala'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: roomCodeController,
              decoration: InputDecoration(
                labelText: 'Código de Sala',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: dateController,
              decoration: InputDecoration(
                labelText: 'Fecha (ISO Format: YYYY-MM-DD)',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: fetchSchedule,
              child: Text('Consultar Agenda'),
            ),
          ],
        ),
      ),
    );
  }
}
