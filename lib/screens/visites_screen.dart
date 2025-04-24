import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:gestiogsb/class/visites.dart';
import 'package:intl/intl.dart';

class VisitesPage extends StatefulWidget {
  const VisitesPage({super.key});

  @override
  State<VisitesPage> createState() => _VisitesPageState();
}

class _VisitesPageState extends State<VisitesPage> {
  late Future<List<Visite>> futureVisites;

  @override
  void initState() {
    super.initState();
    futureVisites = fetchVisites();
  }

  Future<List<Visite>> fetchVisites() async {
    final url = Uri.parse("https://s5-5025.nuage-peda.fr/missionmv/wbs/APIVisite.php");

    try {
      final response = await http.get(url, headers: {'Content-Type': 'application/json'});

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonRes = json.decode(response.body);
        if (jsonRes['status'] == 'success' && jsonRes['data'] is List) {
          return (jsonRes['data'] as List)
              .map((v) => Visite.fromJson(v))
              .toList();
        } else {
          throw Exception("API status error or bad format");
        }
      } else {
        throw Exception("Erreur de chargement: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Erreur de connexion: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgGradient = isDark
        ? [const Color(0xFF1E1E1E), const Color(0xFF121212)]
        : [Colors.blue.shade100, Colors.blue.shade300];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Liste des Visites"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                futureVisites = fetchVisites();
              });
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: bgGradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: FutureBuilder<List<Visite>>(
          future: futureVisites,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                  "Erreur : ${snapshot.error}",
                  style: const TextStyle(color: Colors.redAccent),
                ),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text("Aucune visite trouvée"));
            }

            final visitesList = snapshot.data!;
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: visitesList.length,
              itemBuilder: (context, index) {
                final visite = visitesList[index];
                final dateFormatted = DateFormat('dd/MM/yyyy').format(visite.dateVisite);

                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  color: Theme.of(context).cardColor,
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: CircleAvatar(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      child: const Icon(Icons.calendar_today, color: Colors.white),
                    ),
                    title: Text(
                      "Visite #${visite.idVisite}",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Date : $dateFormatted", style: Theme.of(context).textTheme.bodyMedium),
                          Text("RDV : ${visite.avecRdv ? "Oui" : "Non"}", style: Theme.of(context).textTheme.bodyMedium),
                        ],
                      ),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 18),
                    onTap: () {
                      // TODO: Aller vers la page de détails
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
