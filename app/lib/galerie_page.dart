import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
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

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  
  // Remplacez par l'URL de votre serveur (ex: http://10.0.2.2/api/ pour l'émulateur Android)
  final String apiUrl = "http://votre-site.com/get_images.php";

  Future<List<dynamic>> fetchImages() async {
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
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
      Uri.parse("http://votre-site.com/upload_image.php")
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
      appBar: AppBar(title: const Text("Ma Galerie Photo")),
      
      body: FutureBuilder<List<dynamic>>(
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
      floatingActionButton: FloatingActionButton(
        onPressed: _uploadImage,
        child: const Icon(Icons.add_a_photo),
      ),
    );
  }
}