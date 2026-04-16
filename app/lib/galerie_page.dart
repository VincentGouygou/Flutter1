import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'dart:developer';
/*

void main() => runApp(const GaleriePage());
 

class GaleriePage extends StatelessWidget {
  const GaleriePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: const GalleryScreen(),
    );
  }
}
*/
class GaleriePage extends StatefulWidget {
  const GaleriePage({super.key});
 
  @override
  State<GaleriePage> createState() => _GaleriePageState();
}

class _GaleriePageState extends State<GaleriePage> {
  /*  final url = Uri.https('devince.fr', '/api/user.php'); 

    var response = await http.post(url, */
     
  void goHome() {
   // Navigator.pop(context, "/home");
  }
  Future<List<dynamic>> fetchImages() async {
    final String apiUrl = 'https://devince.fr/api/get_images.php'; 

    var response = await http.get(Uri.parse(apiUrl)
     // headers: {
      //  'User-Agent': 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36',
     //   'Accept': 'application/json',
     // },
     // body: {  'Authorization': token,
      //         'action': "logOut",},  
    );  //



   // final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      log('htttp 200');
      log('body '+response.body);
      return json.decode(response.body);
    } else {
      throw Exception('Erreur de chargement');
    }
  }
  final ImagePicker _picker = ImagePicker();

Future<void> _uploadImage() async {
  // 1. Choisir l'image
  final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
  
  if (pickedFile != null) {
    File imageFile = File(pickedFile.path);
    
    // 2. Préparer la requête Multipart
    var request = http.MultipartRequest(
      'POST', 
      Uri.parse("https://devince.fr/upload_image.php")
    );
    
    request.files.add(
      await http.MultipartFile.fromPath('image', imageFile.path)
    );

    // 3. Envoyer
    var response = await request.send();

    if (response.statusCode == 200) {
      print("Image envoyée !");
      setState(() {}); // Rafraîchir la galerie
    } else {
      print("Échec de l'envoi");
    }
  }
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Center( 
        child: const Text("Ma Galerie Photo")),
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: goHome,
              child: const Text('retour Home'),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: FutureBuilder<List<dynamic>>(
                future: fetchImages(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Erreur: ${snapshot.error}"));
                  } else {
                    return GridView.builder(
                      padding: const EdgeInsets.all(10),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, // 2 colonnes
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.network(
                            snapshot.data![index]['url'],
                            fit: BoxFit.cover,
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
            ElevatedButton(
              onPressed: _uploadImage,
              child: const Text('Ajouter une photo'),
                     
            ),
            /*  floatingActionButton: FloatingActionButton(
              onPressed: _uploadImage,
              child: const Icon(Icons.add_a_photo),
            ), */
          ]
        ),
      ),
    );
  }
}