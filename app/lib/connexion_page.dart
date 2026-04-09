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
      _emailController.text = "vincent.gouygou@gmx.fr";
      _passwordController.text = "alicia46!";
    }
  }
  void validateForm() async {
    // récupère les valeurs des champs de texte
    log(_emailController.text);
    log(_passwordController.text);

    try {
      // connexion au serveur Laravel,
      Uri url = Uri.parse("https://devince.fr/api/user.php?email=$_emailController.text&pwd=$_passwordController.text");
      var response = await http.post(
        url,
        body: {
          "email": _emailController.text,
          "password": _passwordController.text,
        },
      );

      // si connexion ok, alors on bascule sur une autre page
      if (response.statusCode == 200) {
        // on récupère le token
        var bodyjson = jsonDecode(response.body);
        var token = bodyjson["access_token"];
        var token_type = bodyjson["token_type"];

        final prefs = await SharedPreferences.getInstance();
        isLoggedIn = true;
        if (_rememberMe) {
          // on sauvegarde le token et le type de token dans les SharedPreferences
          prefs.setBool("isLoggedIn", true);
          prefs.setString("access_token", token);
          prefs.setString("token_type", token_type);
        } else {
          // on supprime le token et le type de token des SharedPreferences
          prefs.remove("isLoggedIn");
          prefs.remove("access_token");
          prefs.remove("token_type");
        }

        var headers = {
          "Authorization": "$token_type $token",
          "Accept": "application/json",
        };

        // on demande les infos de l'utilisateur
        Uri url = Uri.parse("http://192.168.1.10/api/user");
        response = await http.get(url, headers: headers);
        log(response.body);

        Navigator.pushReplacementNamed(context, "/home");
      }
    } catch (e) {
      // erreur de connexion
      log(e.toString());
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
   

