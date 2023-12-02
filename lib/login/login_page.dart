import 'package:flutter/material.dart';
import 'autenticacion.dart'; 
import 'package:flutter_application_1/api.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            String? jwt = await AuthService().signInWithGoogle();
            if (jwt != null) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => MyHomePage(jwt: jwt),
                ),
              );
            }
          },
          child: const Text('Login with Google'),
        ),
      ),
    );
  }
}


