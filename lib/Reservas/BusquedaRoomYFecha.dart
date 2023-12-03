import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class SchedulePage extends StatefulWidget {
  @override
  _SchedulePageState createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  final TextEditingController roomCodeController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  
  // JWT ingresado manualmente 
  final String jwt = 'eyJhbGciOiJSUzI1NiIsImtpZCI6ImU0YWRmYjQzNmI5ZTE5N2UyZTExMDZhZjJjODQyMjg0ZTQ5ODZhZmYiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJodHRwczovL2FjY291bnRzLmdvb2dsZS5jb20iLCJhenAiOiIyMTIyNjc2ODY2MDQtMGo0a3M5c25pa2plMHNzdGpqbW10Mm1tZTJvZHYyZnUuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJhdWQiOiIyMTIyNjc2ODY2MDQtMGo0a3M5c25pa2plMHNzdGpqbW10Mm1tZTJvZHYyZnUuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJzdWIiOiIxMTUyNTc2MzkzMzE0NTk1MzM3NDEiLCJoZCI6InV0ZW0uY2wiLCJlbWFpbCI6Implc2NvYmFydkB1dGVtLmNsIiwiZW1haWxfdmVyaWZpZWQiOnRydWUsImF0X2hhc2giOiJOVTAxZFEtQmlndzZQbUR4Vmx5VE9RIiwiaWF0IjoxNzAxNTI5NzYwLCJleHAiOjE3MDE1MzMzNjB9.gWx7otgUa0OHeCtNJ9DR0mW2Wyo2kR9UD03EmqLL2clB5H0Mz275CasTqfs6bvx0pGsGBnMT9dU4xYIpUKZ1fvs66adeHpsBDzmP1z4CrWrU8PQOR59O7736AtfDh7m3q_9O68EgJ8ktIq-jQvmS4iqV901CxzcgpTM0RhkGmDef6vFQYjmBA1-Y7EyNfOPpx7V-ITtIJUpLl0wMWueZb7v78sATtVCMJSy3IjL1osJbUZkE-uLCJaSZR2lA--VAyHDdddFhVqBPk8Y1MR8BmN5aTBAhHIbH_RAj0_esCjrBP68Rp6PUFkmHnSJQZSi5E4wgOBGR90VXAc7A78QdkQ';

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
