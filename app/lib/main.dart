 
import 'package:flutter/material.dart';
 // import 'dart:async'; // <--- Permet d'utiliser le Timer
//import 'package:menu_bar/menu_bar.dart';
import 'package:app/inscription_page.dart';
import 'package:app/connexion_page.dart';
import 'package:app/home_page.dart';
import 'package:app/constants.dart';
import 'package:app/galerie_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var prefs = await SharedPreferences.getInstance();
    
  userLang = prefs.getString("userLang") ?? "en";
 // prefs.setBool("isLoggedIn", false);
  isLoggedIn = prefs.getBool("isLoggedIn") ?? false;
  log("isLoggedIn: $isLoggedIn");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter App 1',
      theme: ThemeData(
        
        colorScheme: .fromSeed(seedColor: const Color.fromARGB(255, 60, 202, 24)),
      ),
      home:   isLoggedIn ? HomePage() : ConnexionPage(),  
      routes: {
        "/home": (context) => const HomePage(),
        "/connexion": (context) => const ConnexionPage(),
        "/inscription": (context) => const InscriptionPage(),
        "/galerie": (context) => const GaleriePage(),
      },
    );
  }
}
 