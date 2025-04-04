import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:gestiogsb/class/visites.dart';

class VisitesPage extends StatefulWidget {
  const VisitesPage({super.key});

  @override
  _VisitesPageState createState() => _VisitesPageState();
}

class _VisitesPageState extends State<VisitesPage> {
  late Future<List<Visite>> futureVisites;

  @override
  void initState() {
    super.initState();
    futureVisites = fetchVisites(); // Initialisation du future
  }

  // Fonction pour récupérer les visites depuis l'API
  Future<List<Visite>> fetchVisites() async {
    final url = Uri.parse("https://s5-4353.nuage-peda.fr/missionmv/wbs/APIVisite.php");

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        // Vérification que le tableau principal contient un autre tableau
        if (data.isNotEmpty && data.first is List) {
          // Retourner la liste des visites en utilisant la méthode fromJson
          return (data.first as List)
              .map((visite) => Visite.fromJson(visite))
              .toList();
        } else {
          throw Exception("Format de données inattendu");
        }
      } else {
        throw Exception("Erreur de chargement: ${response.statusCode}");
      }
    } catch (e) {
      // Afficher un message d'erreur spécifique en cas de problème de connexion
      throw Exception("Erreur de connexion: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Liste des Visites"),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade200, Colors.blue.shade800],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: FutureBuilder<List<Visite>>(
          future: futureVisites, 
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator()); // En attendant les données
            } else if (snapshot.hasError) {
              // Gestion de l'erreur lors de la récupération des données
              return Center(
                child: Text(
                  "${snapshot.error}",
                  style: const TextStyle(color: Colors.red),
                ),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              // Aucun résultat trouvé
              return const Center(child: Text("Aucune visite trouvée"));
            }

            // Si les données sont chargées avec succès, afficher la liste des visites
            final visitesList = snapshot.data!; // Liste des visites récupérées
            return ListView.builder(
              itemCount: visitesList.length,
              itemBuilder: (context, index) {
                final visite = visitesList[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16.0),
                    leading: Icon(
                      Icons.location_on,
                      color: Colors.blueAccent,
                      size: 40,
                    ),
                    title: Text(
                      "Visite ID: ${visite.idVisite}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Date: ${visite.dateVisite.toLocal().toString().split(' ')[0]}",
                          style: const TextStyle(fontSize: 16),
                        ),
                        Text(
                          visite.avecRdv ? "Avec RDV" : "Sans RDV",
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.blueAccent,
                    ),
                    onTap: () {
                      
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
