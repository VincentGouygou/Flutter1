import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
class DetailScreen extends StatelessWidget {
  final String imageUrl;
  final String titre;
  final String id;
  
  const DetailScreen({super.key, required this.imageUrl, required this.titre, required this.id});
  //final String id="";
  Future<void> _deleteImage(BuildContext context, String id, String url) async {
    final response = await http.post(
      Uri.parse("https://devince.fr/api/delete_image.php"),
      body: {"id": id, "url": url},
    );

    if (response.statusCode == 200) {
      // On ferme la page de détails et on retourne à la galerie
      Navigator.pop(context, true); 
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Image supprimée")),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Fond noir pour faire ressortir l'image
      appBar: AppBar(
        title: Text(titre),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              // Optionnel : Ajouter un dialogue de confirmation ici
              _deleteImage(context, id, imageUrl);
            },
          ),
        ],
      ),
      body: Center(
        child: Hero(
          tag: imageUrl, // Animation de transition fluide
          child: InteractiveViewer(
            panEnabled: true, 
            minScale: 0.5,
            maxScale: 4.0,
            child: Image.network(
              imageUrl,
              fit: BoxFit.contain,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return const CircularProgressIndicator(color: Colors.white);
              },
            ),
          ),
        ),
      ),
    );
  }
}