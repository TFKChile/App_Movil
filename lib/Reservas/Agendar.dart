import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class BookingPage extends StatefulWidget {
  final String? name;
  final String? location;
  final int? capacity;
  final String? code;

  const BookingPage({
    Key? key,
    this.name,
    this.location,
    this.capacity,
    this.code,
  }) : super(key: key);

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  // Controladores para los campos de entrada de texto
  final TextEditingController roomCodeController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController startController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();

  // Método para realizar la reserva
  Future<void> makeReservation() async {
    // Obtener datos de los controladores
    final String roomCode = roomCodeController.text.trim();
    final String date = dateController.text.trim();
    final String start = startController.text.trim();
    final int quantity = int.tryParse(quantityController.text.trim()) ?? 0;

    // Validar que los campos no estén vacíos
    if (roomCode.isEmpty || date.isEmpty || start.isEmpty || quantity <= 0) {
      // Mostrar un mensaje de error al usuario
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('Por favor, complete todos los campos.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Aceptar'),
              ),
            ],
          );
        },
      );
      return;
    }

    // Datos de reserva
    const String apiUrl = "https://api.sebastian.cl/booking/v1/reserve/request";
    const String token =
        "eyJhbGciOiJSUzI1NiIsImtpZCI6ImU0YWRmYjQzNmI5ZTE5N2UyZTExMDZhZjJjODQyMjg0ZTQ5ODZhZmYiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJodHRwczovL2FjY291bnRzLmdvb2dsZS5jb20iLCJhenAiOiIyMTIyNjc2ODY2MDQtMGo0a3M5c25pa2plMHNzdGpqbW10Mm1tZTJvZHYyZnUuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJhdWQiOiIyMTIyNjc2ODY2MDQtMGo0a3M5c25pa2plMHNzdGpqbW10Mm1tZTJvZHYyZnUuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJzdWIiOiIxMTUyNTc2MzkzMzE0NTk1MzM3NDEiLCJoZCI6InV0ZW0uY2wiLCJlbWFpbCI6Implc2NvYmFydkB1dGVtLmNsIiwiZW1haWxfdmVyaWZpZWQiOnRydWUsImF0X2hhc2giOiJ6V2Y0YjYyMVdtdVZiWlJUTEZaNURRIiwiaWF0IjoxNzAxNTA5OTU2LCJleHAiOjE3MDE1MTM1NTZ9.R6LskdfZtI8vCEQupbXyU8XT-TzxJYVE6f3H3yJZ5d4--IQiLJlrNO44QvfS4_d61YU8XmY2ID_voKzmGVfR4Q867eyGDCMzgDqvVGWZps5ywDuV_fLX9Po8V-NgHKVjlSnqTGegBQx0uOK6xbZcmHBIUimsLGuc97MPNNBRna6x3TMusGigC43D3R7kRj2ntSONRtfOf3zu3vfKHfpKWm0bKJs1ONVcUWkIKTjSM_VKjly449qfcOYI7G4JuPhboEOLXOVu-KlstlLmw7AaUGXUpdpM0QMe518L1h7JwG0Eyr24SgnpAPwVwIZ5k2qwXaKTeEKQpyGy744U_GNWjQ"; // Reemplaza con tu token
// Reemplaza con tu correo

    // Datos del cuerpo de la solicitud
    Map<String, dynamic> requestBody = {
      "roomCode": roomCode,
      "date": date,
      "start": start,
      "quantity": quantity,
    };

    // Codificar el cuerpo de la solicitud a JSON
    String requestBodyJson = jsonEncode(requestBody);

    // Encabezados de la solicitud
    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };

    // Realizar la solicitud POST
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: requestBodyJson,
      );

      // Verificar el código de estado de la respuesta
      if (response.statusCode == 200) {
        // Éxito, puedes manejar la respuesta aquí
        print("Respuesta exitosa: ${response.body}");
        // Puedes agregar más lógica según el caso de éxito
      } else {
        // Error, puedes manejar el error aquí
        print("Error en la solicitud: ${response.statusCode}");
        print("Cuerpo de la respuesta: ${response.body}");
        // Puedes mostrar un mensaje de error al usuario
      }
    } catch (e) {
      // Manejar errores de conexión u otros aquí
      print("Error en la solicitud: $e");
      // Puedes mostrar un mensaje de error al usuario
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reserva ${widget.name}'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: roomCodeController,
              decoration:
                  const InputDecoration(labelText: 'Código de la habitación'),
            ),
            TextField(
              controller: dateController,
              decoration:
                  const InputDecoration(labelText: 'Fecha (YYYY-MM-DD)'),
            ),
            TextField(
              controller: startController,
              decoration:
                  const InputDecoration(labelText: 'Hora de inicio (HH:mm:ss)'),
            ),
            TextField(
              controller: quantityController,
              keyboardType: TextInputType.number,
              decoration:
                  const InputDecoration(labelText: 'Aforo'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: makeReservation,
              child: const Text('Realizar Reserva'),
            ),
          ],
        ),
      ),
    );
  }
}
