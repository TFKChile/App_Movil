
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/login/login_page.dart';
import 'package:flutter_application_1/login/autenticacion.dart';
import 'package:flutter_application_1/Reservas/Busqueda.dart';
import 'package:flutter_application_1/Reservas/Eliminar.dart';
import 'package:flutter_application_1/Reservas/BusquedaRoomYFecha.dart';
import 'package:flutter_application_1/Reservas/agendar.dart';

class MyHomePage extends StatefulWidget {
  final String jwt; 

  const MyHomePage({Key? key, required this.jwt}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController roomCodeController = TextEditingController();
  List<Map<String, dynamic>> allSalas = [];
  List<Map<String, dynamic>> filteredSalas = [];

  @override
  void initState() {
    super.initState();
    Obtener_Salas();
  }

  Future<void> Obtener_Salas() async {


    AuthService authService = AuthService();
    //String? jwt = await authService.signInWithGoogle();
    String? jwt = 'eyJhbGciOiJSUzI1NiIsImtpZCI6ImU0YWRmYjQzNmI5ZTE5N2UyZTExMDZhZjJjODQyMjg0ZTQ5ODZhZmYiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJodHRwczovL2FjY291bnRzLmdvb2dsZS5jb20iLCJhenAiOiIyMTIyNjc2ODY2MDQtMGo0a3M5c25pa2plMHNzdGpqbW10Mm1tZTJvZHYyZnUuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJhdWQiOiIyMTIyNjc2ODY2MDQtMGo0a3M5c25pa2plMHNzdGpqbW10Mm1tZTJvZHYyZnUuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJzdWIiOiIxMTUyNTc2MzkzMzE0NTk1MzM3NDEiLCJoZCI6InV0ZW0uY2wiLCJlbWFpbCI6Implc2NvYmFydkB1dGVtLmNsIiwiZW1haWxfdmVyaWZpZWQiOnRydWUsImF0X2hhc2giOiJ6V2Y0YjYyMVdtdVZiWlJUTEZaNURRIiwiaWF0IjoxNzAxNTA5OTU2LCJleHAiOjE3MDE1MTM1NTZ9.R6LskdfZtI8vCEQupbXyU8XT-TzxJYVE6f3H3yJZ5d4--IQiLJlrNO44QvfS4_d61YU8XmY2ID_voKzmGVfR4Q867eyGDCMzgDqvVGWZps5ywDuV_fLX9Po8V-NgHKVjlSnqTGegBQx0uOK6xbZcmHBIUimsLGuc97MPNNBRna6x3TMusGigC43D3R7kRj2ntSONRtfOf3zu3vfKHfpKWm0bKJs1ONVcUWkIKTjSM_VKjly449qfcOYI7G4JuPhboEOLXOVu-KlstlLmw7AaUGXUpdpM0QMe518L1h7JwG0Eyr24SgnpAPwVwIZ5k2qwXaKTeEKQpyGy744U_GNWjQ';
    if (jwt == null) {
      return;
    }

    var url = Uri.parse('https://api.sebastian.cl/booking/v1/rooms/');
    try {
      var response = await http.get(
        url,
        headers: {'Authorization': 'Bearer ${jwt}'}, // Usa el JWT de la instancia de widget
      );
      if (response.statusCode == 200) {
        setState(() {
          allSalas = List<Map<String, dynamic>>.from(json.decode(response.body));
          filteredSalas = List.from(allSalas);
        });
      } else {
        print('Error en la solicitud: ${response.statusCode}');
      }
    } catch (e) {
      print('Error al obtener salas: $e');
    }
  }

  Future<void> signOut() async {
    try {
      await GoogleSignIn().signOut();
      await FirebaseAuth.instance.signOut();
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginPage()));
      print('Deslogueo exitoso');
    } catch (e) {
      print('Error al desloguearse: $e');
    }
  }

  void buscarSala() {
    String roomCode = roomCodeController.text;
    setState(() {
      if (roomCode.isEmpty) {
        filteredSalas = List.from(allSalas);
      } else {
        filteredSalas = allSalas.where((sala) => sala['code'].contains(roomCode)).toList();
      }
    });
  }

@override
Widget build(BuildContext context) {
  return MaterialApp(
    title: 'Material App',
    home: Scaffold(
      appBar: AppBar(
        title: const Text('Material App Bar'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: signOut, // Llama al método signOut cuando se presiona
          ),
        ],
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
                onChanged: (value) => buscarSala(),
              ),
            ),
            DataTable(
              columns: const [
                DataColumn(label: Text('Código')),
                DataColumn(label: Text('Ubicación')),
                DataColumn(label: Text('Nombre')),
                DataColumn(label: Text('Capacidad')),
              ],
              rows: filteredSalas.map((sala) => DataRow(cells: [
                DataCell(Text(sala['code'] ?? '')),
                DataCell(Text(sala['location'] ?? '')),
                DataCell(Text(sala['name'] ?? '')),
                DataCell(Text(sala['capacity'].toString())),
              ])).toList(),
            ),
            SizedBox(height: 20), // Espacio adicional para separar el botón
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ReservePage(jwt: widget.jwt),
                  ),
                );
              },
              child: Text('Buscar reserva de salas'),
            ),
            SizedBox(height: 10), // Espacio adicional para el siguiente botón
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => CancelReservationPage(), 
                  ),
                );
              },
              child: Text('Cancelar Reserva'),
            ),
            SizedBox(height: 10), // Espacio para el nuevo botón
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => SchedulePage(), 
                  ),
                );
              },
              child: Text('Consultar Agenda de Sala'),
            ),
                        SizedBox(height: 10), // Espacio para el nuevo botón
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => BookingPage(), 
                  ),
                );
              },
              child: Text('Agendar Reserva'),
            ),
          ],
        ),
      ),
    ),
  );
}



}
