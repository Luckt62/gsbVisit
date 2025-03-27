import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "https://s5-4353.nuage-peda.fr/missionmv/wbs/APIVisite.php";

  // Fonction pour récupérer les visites
  static Future<List<Map<String, dynamic>>> getVisites() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      // Décodage de la réponse JSON
      final Map<String, dynamic> responseBody = json.decode(response.body);
      if (responseBody['status'] == 'success') {
        // Si la réponse est un succès, retourne les données
        List<dynamic> data = responseBody['data'];
        return data.map((visite) => visite as Map<String, dynamic>).toList();
      } else {
        throw Exception('Erreur : ${responseBody['message']}');
      }
    } else {
      throw Exception("Erreur lors du chargement des visites");
    }
  }

  static Future<void> addVisite(Map<String, dynamic> visiteData) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(visiteData),
    );

    if (response.statusCode != 201) {
      throw Exception("Erreur lors de l'ajout de la visite");
    }
  }
}
