class Visite {
  final int idVisite;
  final int idMedecin;
  final int idVisiteur;
  final DateTime dateVisite;
  final bool avecRdv;
  final String heureArrivee;
  final String heureDebut;
  final String heureFin;

  // Constructeur classique
  Visite({
    required this.idVisite,
    required this.idMedecin,
    required this.idVisiteur,
    required this.dateVisite,
    required this.avecRdv,
    required this.heureArrivee,
    required this.heureDebut,
    required this.heureFin,
  });

  // Méthode pour convertir un objet Visite en format JSON
  Map<String, dynamic> toJson() {
    return {
      'idVisite': idVisite,
      'idMedecin': idMedecin,
      'idVisiteur': idVisiteur,
      'dateVisite': dateVisite.toIso8601String(),
      'avecRdv': avecRdv,
      'heureArrivee': heureArrivee,
      'heureDebut': heureDebut,
      'heureFin': heureFin,
    };
  }
  static Visite fromJson(Map<String, dynamic> json) {
    return Visite(
      idVisite: json['idVisite'],
      idMedecin: json['idMedecin'],
      idVisiteur: json['idVisiteur'],
      dateVisite: DateTime.parse(json['dateVisite']),
      avecRdv: json['avecRdv'],
      heureArrivee: json['heureArrivee'],
      heureDebut: json['heureDebut'],
      heureFin: json['heureFin'],
    );
  }
}
