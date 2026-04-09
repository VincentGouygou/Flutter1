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
  bool _result = false;
  String _name = "";
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  @override
  void initState() {
    super.initState();

    if (devmode) {
      _emailController.text = "vincent.gouygou@gmx.fr";
      _passwordController.text = "alicia46!";
    }
  }
  void validateForm() async {
    // récupère les valeurs des champs de texte
    log(_emailController.text);
    log(_passwordController.text);

    try {
      final client = http.Client();    
      log('zzzz');
     // Uri url = Uri.parse("https://devince.fr/api/user.php?email=$_emailController.text&pwd=$_passwordController.text");
      final url = Uri.https('devince.fr', '/api/user.php', {
        'email': _emailController.text,
        'pwd': _passwordController.text,
      });
      var response = await http.get( url,
      headers: {
          'User-Agent': 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36',
          'Accept': 'application/json',
        },);
   
     final Map<String, dynamic> data = jsonDecode(response.body);
  // On décode le JSON peu importe le statut pour voir
        // ce que le serveur dit
   
       // si connexion ok, alors on bascule sur une autre page
      if (response.statusCode == 200) {
        setState(() {
          _result = data['result']; // On récupère le champ 'result',
           _name = data['name'];
        });
        if (_result){
          final prefs = await SharedPreferences.getInstance();
          await prefs.setBool("isLoggedIn", true);
          await prefs.setString("userName", _name); // On enregistre le nom ici
          isLoggedIn = true;
          Navigator.pushReplacementNamed(context, "/home");
        }
        
        
      }
    } catch (e) {
      // erreur de connexion
      log( ' sdfqsd ' + e.toString());
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center( 
          child:    const Text("Connexion"),
        ),
      ),
      body: Center( 
        child: 
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [

                  Text(str_welcome, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  Text(str_enter_email_and_password),
                  TextFormField(
                      controller: _emailController,
                      validator: (value) {
                        // add email validation
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }

                        bool emailValid = RegExp(
                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
                        ).hasMatch(value);
                        if (!emailValid) {
                          return 'Please enter a valid email';
                        }

                        return null;
                      },
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        hintText: 'Enter your email',
                        prefixIcon: Icon(Icons.email_outlined),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    _gap(),
                    TextFormField(
                      controller: _passwordController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }

                        if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                      obscureText: !_isPasswordVisible,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        hintText: 'Enter your password',
                        prefixIcon: const Icon(Icons.lock_outline_rounded),
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                      ),
                    ),
                    _gap(),
                    CheckboxListTile(
                      value: _rememberMe,
                      onChanged: (value) {
                        if (value == null) return;
                        setState(() {
                          _rememberMe = value;
                        });
                      },
                      title: const Text('Remember me'),
                      controlAffinity: ListTileControlAffinity.leading,
                      dense: true,
                      contentPadding: const EdgeInsets.all(0),
                    ),
                    _gap(),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Text(
                            'Sign in',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        onPressed: () {
                          if (_formKey.currentState?.validate() ?? false) {
                            validateForm();
                          }
                        },
                      ),
                    ),
                  // Ajoute tes TextFormField ici pour l'email et le mot de passe
                ],
              ),
            ),
          ),
    ),
    );
  }
  Widget _gap() => const SizedBox(height: 16);
}
   

