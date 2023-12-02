import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class CancelReservationPage extends StatefulWidget {
  @override
  _CancelReservationPageState createState() => _CancelReservationPageState();
}

class _CancelReservationPageState extends State<CancelReservationPage> {
  final TextEditingController tokenController = TextEditingController();
  
  final String jwt = 'eyJhbGciOiJSUzI1NiIsImtpZCI6ImU0YWRmYjQzNmI5ZTE5N2UyZTExMDZhZjJjODQyMjg0ZTQ5ODZhZmYiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJodHRwczovL2FjY291bnRzLmdvb2dsZS5jb20iLCJhenAiOiIyMTIyNjc2ODY2MDQtMGo0a3M5c25pa2plMHNzdGpqbW10Mm1tZTJvZHYyZnUuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJhdWQiOiIyMTIyNjc2ODY2MDQtMGo0a3M5c25pa2plMHNzdGpqbW10Mm1tZTJvZHYyZnUuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJzdWIiOiIxMTUyNTc2MzkzMzE0NTk1MzM3NDEiLCJoZCI6InV0ZW0uY2wiLCJlbWFpbCI6Implc2NvYmFydkB1dGVtLmNsIiwiZW1haWxfdmVyaWZpZWQiOnRydWUsImF0X2hhc2giOiJ6V2Y0YjYyMVdtdVZiWlJUTEZaNURRIiwiaWF0IjoxNzAxNTA5OTU2LCJleHAiOjE3MDE1MTM1NTZ9.R6LskdfZtI8vCEQupbXyU8XT-TzxJYVE6f3H3yJZ5d4--IQiLJlrNO44QvfS4_d61YU8XmY2ID_voKzmGVfR4Q867eyGDCMzgDqvVGWZps5ywDuV_fLX9Po8V-NgHKVjlSnqTGegBQx0uOK6xbZcmHBIUimsLGuc97MPNNBRna6x3TMusGigC43D3R7kRj2ntSONRtfOf3zu3vfKHfpKWm0bKJs1ONVcUWkIKTjSM_VKjly449qfcOYI7G4JuPhboEOLXOVu-KlstlLmw7AaUGXUpdpM0QMe518L1h7JwG0Eyr24SgnpAPwVwIZ5k2qwXaKTeEKQpyGy744U_GNWjQ'; // Reemplaza esto con tu JWT real
  String responseMessage = ''; // Mensaje para mostrar el resultado de la solicitud

  Future<void> cancelReservation() async {
    String token = tokenController.text;
    var url = Uri.parse('https://api.sebastian.cl/booking/v1/reserve/$token/cancel');
    
    try {
      var response = await http.delete(
        url,
        headers: {
          'Authorization': 'Bearer $jwt',
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          responseMessage = 'Reserva cancelada con Ã©xito.';
        });
      } else {
        setState(() {
          responseMessage = 'Error en la solicitud: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        responseMessage = 'Error al enviar la solicitud: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cancelar Reserva'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: tokenController,
              decoration: InputDecoration(
                labelText: 'Token de Reserva',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: cancelReservation,
              child: Text('Cancelar Reserva'),
            ),
            SizedBox(height: 20),
            Text(responseMessage),
          ],
        ),
      ),
    );
  }
}