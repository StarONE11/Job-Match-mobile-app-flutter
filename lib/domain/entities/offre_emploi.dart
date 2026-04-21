// ─── ENTITE ───────────────────────────────────────────────────────────────────
// C'est l'objet "offre d'emploi" dans notre app.
// Pas de JSON ici, pas de Dio — juste des données propres.

class OffreEmploi {
  final int id;
  final String titre;
  final String entreprise;
  final String? localisation;
  final String source;
  final String? description;
  final String? typeContrat;
  final String? salaireRange;
  final String? niveauExperience;
  final String? competences;
  final String? lienOffre;
  final DateTime datePublication;
  final bool descriptionComplete;
  final double scoreMatch; // 0.0 → 1.0 depuis /candidates/match, 0 sinon

  const OffreEmploi({
    required this.id,
    required this.titre,
    required this.entreprise,
    this.localisation,
    required this.source,
    this.description,
    this.typeContrat,
    this.salaireRange,
    this.niveauExperience,
    this.competences,
    this.lienOffre,
    required this.datePublication,
    this.descriptionComplete = false,
    this.scoreMatch = 0.0,
  });

  // Retourne la liste des compétences sous forme de liste
  List<String> get listeCompetences {
    if (competences == null || competences!.isEmpty) return [];
    return competences!.split(',').map((c) => c.trim()).toList();
  }

  // Retourne "Lomé" depuis "Lomé, Togo"
  String get villeShort {
    if (localisation == null) return 'Togo';
    return localisation!.split(',').first.trim();
  }

  // Est-ce une offre récente (moins de 24h) ?
  bool get estNouvelle {
    final diff = DateTime.now().difference(datePublication);
    return diff.inHours < 24;
  }
}
