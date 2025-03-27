import 'package:flutter/material.dart';
import '../services/api_service.dart';

class AjouterVisitePage extends StatefulWidget {
  const AjouterVisitePage({super.key});

  @override
  _AjouterVisitePageState createState() => _AjouterVisitePageState();
}

class _AjouterVisitePageState extends State<AjouterVisitePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController heureArriverController = TextEditingController();
  final TextEditingController heureDepartController = TextEditingController();
  final TextEditingController idVisiteurController = TextEditingController();
  final TextEditingController idMedecinController = TextEditingController();
  bool avecRdv = false;

  Future<void> _ajouterVisite() async {
    if (_formKey.currentState!.validate()) {
      final visiteData = {
        "date_visite": dateController.text,
        "heure_arriver": heureArriverController.text,
        "heure_depart": heureDepartController.text,
        "id_visiteur": idVisiteurController.text,
        "id_medecin": idMedecinController.text,
        "rdv": avecRdv ? "1" : "0",
      };

      try {
        await ApiService.addVisite(visiteData);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Visite ajoutée avec succès !")),
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Erreur lors de l'ajout de la visite")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Ajouter une Visite")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: dateController,
                decoration: const InputDecoration(labelText: "Date de visite"),
                validator: (value) => value!.isEmpty ? "Entrez une date" : null,
              ),
              TextFormField(
                controller: heureArriverController,
                decoration: const InputDecoration(labelText: "Heure d'arrivée"),
                validator: (value) => value!.isEmpty ? "Entrez une heure" : null,
              ),
              TextFormField(
                controller: heureDepartController,
                decoration: const InputDecoration(labelText: "Heure de départ"),
                validator: (value) => value!.isEmpty ? "Entrez une heure" : null,
              ),
              TextFormField(
                controller: idVisiteurController,
                decoration: const InputDecoration(labelText: "ID Visiteur"),
                validator: (value) => value!.isEmpty ? "Entrez un ID" : null,
              ),
              TextFormField(
                controller: idMedecinController,
                decoration: const InputDecoration(labelText: "ID Médecin"),
                validator: (value) => value!.isEmpty ? "Entrez un ID" : null,
              ),
              SwitchListTile(
                title: const Text("Avec RDV"),
                value: avecRdv,
                onChanged: (bool value) {
                  setState(() {
                    avecRdv = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _ajouterVisite,
                child: const Text("Ajouter la visite"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
