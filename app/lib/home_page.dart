import 'dart:developer';
import 'package:app/constants.dart';
//import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String strWelcome = "Bienvenue !";
  String _displayName = "";
  String tokenErrorMsg ="";
  @override 
  void initState() {
    super.initState();
    _loadUserName();
  }
  void _loadUserName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _displayName = prefs.getString("userName") ?? "Utilisateur";
    });
  }
  void _logout() async {
    log("logout");
    // Effacer les données de connexion
    final prefs = await SharedPreferences.getInstance();
    isLoggedIn = prefs.getBool("isLoggedIn") ?? false;
    String token = prefs.getString("access_token") ?? "";
    
   // String token_type = prefs.getString("token_type") ?? ""; ?? obsolete ??

    if (!isLoggedIn) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vous n\'êtes pas connecté')),
      );
      return;
    }
 
    
        
    final url = Uri.https('devince.fr', '/api/user.php'); 

    var response = await http.post(url, 
      headers: {
        'User-Agent': 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36',
        'Accept': 'application/json',
      },
      body: {  'Authorization': token,
               'action': "logOut",},  
    );  //

    log(response.statusCode.toString());
    
  
       
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Vous êtes déconnecté')));
      await prefs.setBool("isLoggedIn", false);
     // await prefs.remove("token_type"); ?? obsolete ??
      await prefs.remove("access_token");
      Navigator.pushReplacementNamed(context, "/connexion");
    } 
    if (response.statusCode == 404) {
      //final Map<String, dynamic> data = jsonDecode(response.body);
      //tokenErrorMsg = data['tokenErrorMsg']; 
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(  
        SnackBar(content: Text('Erreur de déconnexion    '  )));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(title: Center( 
        child: Text('$strWelcome  $_displayName')),
      ),
      
      body: Center(
        child: Column(
          children: [
            Text(strWelcome),
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
