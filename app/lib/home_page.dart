// sdfdsf
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String str_welcome = "Bienvenue !";

  void _logout() async {
    log("logout");
    // Effacer les données de connexion
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("isLoggedIn");
    String token = prefs.getString("access_token") ?? "";
    String token_type = prefs.getString("token_type") ?? "";

    if (token == "") {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vous n\'êtes pas connecté')),
      );
      return;
    }

    var headers = {"Authorization": "$token_type $token"};

    Uri url = Uri.parse("http://192.168.1.10/api/logout");

    var response = await http.post(url, headers: headers);

    log(response.statusCode.toString());
    log(response.body);

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Vous êtes déconnecté')));
      await prefs.remove("access_token");
      await prefs.remove("token_type");
      Navigator.pushReplacementNamed(context, "/connexion");
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Erreur de déconnexion')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(str_welcome)),
      body: Center(
        child: Column(
          children: [
            Text(str_welcome),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _logout,
              child: const Text('Déconnexion'),
            ),
          ],
        ),
      ),
    );
  }
}
