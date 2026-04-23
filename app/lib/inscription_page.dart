import 'package:flutter/material.dart';
//import 'dart:async'; // <--- Permet d'utiliser le Timer
//import 'package:menu_bar/menu_bar.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:app/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer';

class InscriptionPage extends StatefulWidget {
  const InscriptionPage({super.key});
  @override
  State<InscriptionPage> createState() => InscriptionPageState();
}

class InscriptionPageState extends State<InscriptionPage> {
  bool _isPasswordVisible = false; 
  bool _result = false;
  bool _confBool = false;
  String _msg = "";
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
   
  @override
  void initState() {
    super.initState();
    _confBool = false;
    if (devmode) {
      _emailController.text = "vincent.gouygou@gmx.fr";
      _passwordController.text = "alicia46!";
      _nameController.text = 'VincentG';
    }
  }  
  void _validateForm() async {
          
    try {
      //  final client = http.Client();    // ?? obsolete ??
      
      // Uri url = Uri.parse("https://devince.fr/api/user.php?email=$_emailController.text&pwd=$_passwordController.text");
      final url = Uri.https('devince.fr', '/api/user.php'); 
      var response = await http.post( url, headers: {
          'User-Agent': 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36',
          'Accept': 'application/json',
        },body: { 'action': 'subscribe',
                  'email': _emailController.text,
                  'pwd': _passwordController.text, 
                  'name': _nameController.text, }, );
        // On décode le JSON peu importe le statut pour voir
        // ce que le serveur dit
  
      final Map<String, dynamic> data = jsonDecode(response.body);
       
     
      // si connexion ok, alors on bascule sur une autre page
      if (response.statusCode == 200) {
        setState(() {
          _result = data['result']; // On récupère le champ 'result' et 'msg',
          _msg = data['action'];
          
        });
        if (_result){
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Veuillez confirmer votre inscription par l'email qui vous a été envoyé et revenez ici pour le signaler et vous connecter.")),
          );
          setState(() {
            _confBool=true;
          });
          /*
          final prefs = await SharedPreferences.getInstance(); 
          if (!mounted) return;
          final navigator = Navigator.of(context); // enreg le context avant l'await
          await prefs.setString("msg", _msg); 
                      
          navigator.pushReplacementNamed( "/connexion", arguments: data['action'], );
          */
        }        
      }
    } catch (e) {
      // erreur de connexion      
      log( " errorserver : $e"   );      
    }
  }
  void goLogin()  {
    Navigator.pushReplacementNamed(context, "/connexion");
  }
  void checkConf() async {
    try {
      //  final client = http.Client();    // ?? obsolete ??
      
      // Uri url = Uri.parse("https://devince.fr/api/user.php?email=$_emailController.text&pwd=$_passwordController.text");
      final url = Uri.https('devince.fr', '/api/user.php'); 
      var response = await http.post( url,
      headers: {
          'User-Agent': 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36',
          'Accept': 'application/json',
        },
      body: {   'action': 'checkConf',
                'email': _emailController.text, },  
      );

      if (response.statusCode== 200) {
        final prefs = await SharedPreferences.getInstance(); 
          final Map<String, dynamic> data = jsonDecode(response.body);
          if (!mounted) return;
          final navigator = Navigator.of(context); // enreg le context avant l'await
          await prefs.setString("msg", _msg); 
                      
          navigator.pushReplacementNamed( "/connexion", arguments: data['action'], );
      } else {
        
      }
    } catch (e) {
      // erreur de connexion
      log( " errorserver : $e.toString()");      
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center( 
          child:    const Text("Inscription"),
        ),
      ),
      body: Center( 
        child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [

                  Text(strWelcome, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  Text(strEnterEmailAndPassword),
                  TextFormField(
                    controller: _nameController,
                    validator: (value) {
                      // add name validation
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
 
                      return null;
                    },
                    decoration: const InputDecoration(
                      labelText: 'Name',
                      hintText: 'Enter your name',
                      prefixIcon: Icon(Icons.perm_identity_outlined),
                      border: OutlineInputBorder(),
                    ),
                  ),
                   _gap(),
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
                    decoration:   InputDecoration(
                      labelText: 'Password',
                      hintText: 'Enter your password',
                      prefixIcon: const Icon(Icons.lock_outline_rounded),
                      border:   OutlineInputBorder(),
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
                          'Susbscribe',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      onPressed: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          _validateForm();
                        }
                      },
                    ),
                  ),
                  
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      onPressed: goLogin,
                      child: const Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text(
                          'Login ?',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      
                    ),
                  ),
                  _gap(),
                  if (_confBool) 
                  SizedBox(
                    
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        onPressed: checkConf,
                        child: const Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Text(
                            "Confirmer l'inscription",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        
                      ),
                    
                  ),
                ],
              ),
            ),
        ),
      ),
    );
  }
  Widget _gap() => const SizedBox(height: 16);
}


