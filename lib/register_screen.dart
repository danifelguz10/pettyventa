import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'db/firebase_service.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _registerUser() async {
    try {
      final String username = _usernameController.text;
      final String password = _passwordController.text;

      await FirestoreService().createUser(username, password);

      print('User registered: $username');
    } catch (e) {
      print('Error during registration: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Registrar Cuenta')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(controller: _usernameController, decoration: InputDecoration(labelText: 'Nombre de Usuario')),
            TextField(controller: _passwordController, decoration: InputDecoration(labelText: 'Contraseña'), obscureText: true),
            SizedBox(height: 16),
            ElevatedButton(onPressed: _registerUser, child: Text('Registrar Cuenta')),
          ],
        ),
      ),
    );
  }
}