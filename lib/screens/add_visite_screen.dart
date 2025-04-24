import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AddVisiteScreen extends StatefulWidget {
  const AddVisiteScreen({super.key});
  @override
  State<AddVisiteScreen> createState() => _AddVisiteScreenState();
}

class _AddVisiteScreenState extends State<AddVisiteScreen> {
  final _formKey = GlobalKey<FormState>();
  List<int> visiteurIds = [];
  int? selectedVisiteurId;
  List<int> medecinIds = [];
  int? selectedMedecinId;
  DateTime? selectedDate;
  final arriveeController = TextEditingController();
  final debutController = TextEditingController();
  final finController = TextEditingController();
  bool rdv = false;
  bool isLoading = false;
  String? token;

  @override
  void initState() {
    super.initState();
    _loadToken();
    _fetchVisiteurIds();
    _fetchMedecinIds();
  }

  Future<void> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() => token = prefs.getString('token'));
  }

  Future<void> _fetchVisiteurIds() async {
    final res = await http.get(
      Uri.parse('https://s5-5025.nuage-peda.fr/missionmv/wbs/APIGetVisiteurId.php'),
      headers: {'Content-Type': 'application/json'},
    );
    if (res.statusCode == 200) {
      final body = jsonDecode(res.body) as Map<String, dynamic>;
      setState(() => visiteurIds = List<int>.from(body['data']));
    }
  }

  Future<void> _fetchMedecinIds() async {
    final res = await http.get(
      Uri.parse('https://s5-5025.nuage-peda.fr/missionmv/wbs/APIGetMedecinIds.php'),
      headers: {'Content-Type': 'application/json'},
    );
    if (res.statusCode == 200) {
      final body = jsonDecode(res.body) as Map<String, dynamic>;
      setState(() => medecinIds = List<int>.from(body['data']));
    }
  }

  Future<void> _pickDate() async {
    final d = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: Theme.of(ctx).colorScheme.copyWith(
                primary: Theme.of(ctx).colorScheme.primary,
              ),
        ),
        child: child!,
      ),
    );
    if (d != null) setState(() => selectedDate = d);
  }

  String? _validateTime(String? v) {
    if (v == null || !RegExp(r'^\d{2}:\d{2}:\d{2}$').hasMatch(v)) {
      return 'Format requis : HH:mm:ss';
    }
    return null;
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate() ||
        selectedVisiteurId == null ||
        selectedMedecinId == null ||
        selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez remplir tous les champs correctement')),
      );
      return;
    }

    setState(() => isLoading = true);

    final data = {
      'id_visiteur': selectedVisiteurId,
      'id_medecin': selectedMedecinId,
      'date_visite': selectedDate!.toIso8601String().split('T')[0],
      'rdv': rdv,
      'heure_arrivee': arriveeController.text,
      'heure_debut': debutController.text,
      'heure_fin': finController.text,
    };

    final res = await http.post(
      Uri.parse('https://s5-5025.nuage-peda.fr/missionmv/wbs/APIVisite.php'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: jsonEncode(data),
    );

    setState(() => isLoading = false);

    final jsonRes = jsonDecode(res.body) as Map<String, dynamic>;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(jsonRes['message'] ?? 'Erreur inconnue')),
    );
    if (jsonRes['status'] == 'success') Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Ajouter une visite')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Card(
          elevation: 6,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          color: theme.cardColor,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: ListView(
                shrinkWrap: true,
                children: [
                  DropdownButtonFormField<int>(
                    decoration: const InputDecoration(labelText: 'Visiteur'),
                    items: visiteurIds
                        .map((id) => DropdownMenuItem(
                              value: id,
                              child: Text('Visiteur #$id'),
                            ))
                        .toList(),
                    value: selectedVisiteurId,
                    onChanged: (v) => setState(() => selectedVisiteurId = v),
                    validator: (v) => v == null ? 'Sélection obligatoire' : null,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<int>(
                    decoration: const InputDecoration(labelText: 'Médecin'),
                    items: medecinIds
                        .map((id) => DropdownMenuItem(
                              value: id,
                              child: Text('Médecin #$id'),
                            ))
                        .toList(),
                    value: selectedMedecinId,
                    onChanged: (v) => setState(() => selectedMedecinId = v),
                    validator: (v) => v == null ? 'Sélection obligatoire' : null,
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Date de visite'),
                    subtitle: Text(
                      selectedDate?.toString().split(' ')[0] ?? '—',
                      style: textTheme.bodyMedium,
                    ),
                    trailing: Icon(Icons.calendar_month, color: theme.colorScheme.primary),
                    onTap: _pickDate,
                  ),
                  const SizedBox(height: 16),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Sur RDV'),
                    value: rdv,
                    activeColor: theme.colorScheme.primary,
                    onChanged: (v) => setState(() => rdv = v),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: arriveeController,
                    decoration: const InputDecoration(labelText: 'Heure arrivée (HH:mm:ss)'),
                    validator: _validateTime,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: debutController,
                    decoration: const InputDecoration(labelText: 'Heure début (HH:mm:ss)'),
                    validator: _validateTime,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: finController,
                    decoration: const InputDecoration(labelText: 'Heure fin (HH:mm:ss)'),
                    validator: _validateTime,
                  ),
                  const SizedBox(height: 24),
                  isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _submit,
                            child: const Text('Enregistrer'),
                          ),
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
