import 'package:flutter/material.dart';
import 'package:pattyventas/register_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'db/firebase_service.dart';
import 'listproducts_screen.dart'; // Cambia por la pantalla deseada

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirestoreService _firestoreService = FirestoreService();

  Future<void> _signIn() async {
    final String username = _usernameController.text;
    final String password = _passwordController.text;

    // Aquí tendrías tu lógica para autenticar al usuario y obtener el token
    final String token = 'your_generated_token';

    // Guarda el token en SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);

    // Navegar a la pantalla de lista de productos
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => ProductsListScreen()),
    );
  }

  Future<void> _signInWithCredentials() async {
    if (mounted) {
      final String username = _usernameController.text;
      final String password = _passwordController.text;

      final bool isAuthenticated =
          await _firestoreService.verifyCredentials(username, password);

      if (mounted) {
        if (isAuthenticated) {
          // Navegar a la pantalla deseada
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => ProductsListScreen()),
          );
          print('Autenticación exitosa');
        } else {
          print('Credenciales inválidas');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegistrationScreen()),
                );
              },
              child: Text('Register'),
            ),
            ElevatedButton(
              onPressed: _signInWithCredentials,
              child: Text('Sign In'),
            ),
          ],
        ),
      ),
    );
  }
}
