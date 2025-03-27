import 'package:flutter/material.dart';
import '../services/api_service.dart';

class VisitesPage extends StatefulWidget {
  const VisitesPage({super.key});

  @override
  _VisitesPageState createState() => _VisitesPageState();
}

class _VisitesPageState extends State<VisitesPage> {
  List<Map<String, dynamic>> visites = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchVisites();
  }

  Future<void> fetchVisites() async {
    try {
      final data = await ApiService.getVisites();
      print("Données récupérées : $data"); // Ajout du print pour déboguer
      setState(() {
        visites = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Erreur : $e");  // Affiche l'erreur dans la console
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Liste des Visites")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : visites.isEmpty
              ? const Center(child: Text("Aucune visite disponible."))
              : ListView.builder(
                  itemCount: visites.length,
                  itemBuilder: (context, index) {
                    final visite = visites[index];
                    return ListTile(
                      title: Text("Visite ID: ${visite['idVisite']}"),
                      subtitle: Text("Date: ${visite['dateVisite']}"),
                      trailing: Text(visite['avecRdv'] == 1 ? "Avec RDV" : "Sans RDV"),
                    );
                  },
                ),
    );
  }
}
