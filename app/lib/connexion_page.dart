import 'package:flutter/material.dart';
import 'dart:async'; // <--- Permet d'utiliser le Timer
//import 'package:menu_bar/menu_bar.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:app/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer';

class ConnexionPage extends StatefulWidget {
  const ConnexionPage({super.key});

  @override
  State<ConnexionPage> createState() => _ConnexionPageState();
}

class _ConnexionPageState extends State<ConnexionPage> {
  bool _isPasswordVisible = false;
  bool _rememberMe = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  @override
  void initState() {
    super.initState();

    if (devmode) {
      _emailController.text = "n.dubois.formation@gmail.com";
      _passwordController.text = "password";
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Connexion"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Text(str_welcome, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              Text(str_enter_email_and_password),
              // Ajoute tes TextFormField ici pour l'email et le mot de passe
            ],
          ),
        ),
      ),
    );
  }
}
   

