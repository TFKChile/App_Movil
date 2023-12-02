import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ReservePage extends StatefulWidget {
  final String jwt;

  const ReservePage({Key? key, required this.jwt}) : super(key: key);

  @override
  _ReservePageState createState() => _ReservePageState();
}

class _ReservePageState extends State<ReservePage> {
  final TextEditingController roomCodeController = TextEditingController();
  final TextEditingController bookingTokenController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  List<Map<String, dynamic>> reservas = [];

  Future<void> realizarPostRequest() async {
    var url = Uri.parse('https://api.sebastian.cl/booking/v1/reserve/search');
    try {
      String? jwt =
          'eyJhbGciOiJSUzI1NiIsImtpZCI6ImU0YWRmYjQzNmI5ZTE5N2UyZTExMDZhZjJjODQyMjg0ZTQ5ODZhZmYiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJodHRwczovL2FjY291bnRzLmdvb2dsZS5jb20iLCJhenAiOiIyMTIyNjc2ODY2MDQtMGo0a3M5c25pa2plMHNzdGpqbW10Mm1tZTJvZHYyZnUuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJhdWQiOiIyMTIyNjc2ODY2MDQtMGo0a3M5c25pa2plMHNzdGpqbW10Mm1tZTJvZHYyZnUuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJzdWIiOiIxMTUyNTc2MzkzMzE0NTk1MzM3NDEiLCJoZCI6InV0ZW0uY2wiLCJlbWFpbCI6Implc2NvYmFydkB1dGVtLmNsIiwiZW1haWxfdmVyaWZpZWQiOnRydWUsImF0X2hhc2giOiJ6V2Y0YjYyMVdtdVZiWlJUTEZaNURRIiwiaWF0IjoxNzAxNTA5OTU2LCJleHAiOjE3MDE1MTM1NTZ9.R6LskdfZtI8vCEQupbXyU8XT-TzxJYVE6f3H3yJZ5d4--IQiLJlrNO44QvfS4_d61YU8XmY2ID_voKzmGVfR4Q867eyGDCMzgDqvVGWZps5ywDuV_fLX9Po8V-NgHKVjlSnqTGegBQx0uOK6xbZcmHBIUimsLGuc97MPNNBRna6x3TMusGigC43D3R7kRj2ntSONRtfOf3zu3vfKHfpKWm0bKJs1ONVcUWkIKTjSM_VKjly449qfcOYI7G4JuPhboEOLXOVu-KlstlLmw7AaUGXUpdpM0QMe518L1h7JwG0Eyr24SgnpAPwVwIZ5k2qwXaKTeEKQpyGy744U_GNWjQ';
      var response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${jwt}',
        },
        body: json.encode({
          'roomCode': roomCodeController.text.isNotEmpty
              ? roomCodeController.text
              : null,
          'bookingToken': bookingTokenController.text.isNotEmpty
              ? bookingTokenController.text
              : null,
          'date': dateController.text.isNotEmpty ? dateController.text : null,
        }),
      );

      if (response.statusCode == 200) {
        setState(() {
          reservas =
              List<Map<String, dynamic>>.from(json.decode(response.body));
        });
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
        title: Text('Reservar Sala'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: roomCodeController,
                decoration: InputDecoration(
                  labelText: 'Código de Sala',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: bookingTokenController,
                decoration: InputDecoration(
                  labelText: 'Token de Reserva',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: dateController,
                decoration: InputDecoration(
                  labelText: 'Fecha',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: realizarPostRequest,
              child: Text('Buscar Reservas'),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('Token')),
                    DataColumn(label: Text('Email del Usuario')),
                    DataColumn(label: Text('Código de Sala')),
                    DataColumn(label: Text('Inicio')),
                    DataColumn(label: Text('Fin')),
                  ],
                  rows: reservas
                      .map((reserva) => DataRow(cells: [
                            DataCell(Text(reserva['token'] ?? '')),
                            DataCell(Text(reserva['userEmail'] ?? '')),
                            DataCell(Text(reserva['roomCode'] ?? '')),
                            DataCell(Text(reserva['start'] ?? '')),
                            DataCell(Text(reserva['end'] ?? '')),
                          ]))
                      .toList(),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
