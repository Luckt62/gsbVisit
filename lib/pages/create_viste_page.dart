import 'package:flutter/material.dart';

class CreateVisitePage extends StatefulWidget {
  const CreateVisitePage({super.key});

  @override
  _CreateVisitePageState createState() => _CreateVisitePageState();
}

class _CreateVisitePageState extends State<CreateVisitePage> {
  final _formKey = GlobalKey<FormState>();
  final _rdvController = TextEditingController();
  final _heureArriverController = TextEditingController();
  final _heureDepartController = TextEditingController();
  final _dateVisiteController = TextEditingController();
  final _idVisiteurController = TextEditingController();
  final _idMedecinController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Créer une Visite'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _rdvController,
                  decoration: const InputDecoration(
                    labelText: 'Rendez-vous',
                    border: OutlineInputBorder(),
                    hintText: 'Indiquez si c\'est un rendez-vous',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer un rendez-vous';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _heureArriverController,
                  decoration: const InputDecoration(
                    labelText: 'Heure d\'arrivée',
                    border: OutlineInputBorder(),
                    hintText: 'Ex: 08:30',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer l\'heure d\'arrivée';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _heureDepartController,
                  decoration: const InputDecoration(
                    labelText: 'Heure de départ',
                    border: OutlineInputBorder(),
                    hintText: 'Ex: 09:30',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer l\'heure de départ';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _dateVisiteController,
                  decoration: const InputDecoration(
                    labelText: 'Date de la visite',
                    border: OutlineInputBorder(),
                    hintText: 'Ex: 2025-04-04',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer une date';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _idVisiteurController,
                  decoration: const InputDecoration(
                    labelText: 'ID Visiteur',
                    border: OutlineInputBorder(),
                    hintText: 'Entrez l\'ID du visiteur',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer l\'ID du visiteur';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _idMedecinController,
                  decoration: const InputDecoration(
                    labelText: 'ID Médecin',
                    border: OutlineInputBorder(),
                    hintText: 'Entrez l\'ID du médecin',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer l\'ID du médecin';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      // Envoie des données à une API ou autre
                      final rdv = _rdvController.text;
                      final heureArriver = _heureArriverController.text;
                      final heureDepart = _heureDepartController.text;
                      final dateVisite = _dateVisiteController.text;
                      final idVisiteur = _idVisiteurController.text;
                      final idMedecin = _idMedecinController.text;

                      // Exemple d'affichage dans la console, à remplacer par l'envoi des données
                      print('Rendez-vous: $rdv');
                      print('Heure d\'arrivée: $heureArriver');
                      print('Heure de départ: $heureDepart');
                      print('Date de la visite: $dateVisite');
                      print('ID Visiteur: $idVisiteur');
                      print('ID Médecin: $idMedecin');

                      // Affiche un message de succès
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Visite créée avec succès!')),
                      );

                      // Retour à la page d'accueil ou autre
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    backgroundColor: Colors.blueAccent,
                  ),
                  child: const Text('Créer Visite'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
