import '../../domain/entities/offre_emploi.dart';

// ─── MODELE ───────────────────────────────────────────────────────────────────
// Hérite de l'entité et ajoute la conversion JSON <-> Objet Dart
// C'est la seule classe qui "comprend" le JSON de l'API FastAPI

class OffreEmploiModel extends OffreEmploi {
  const OffreEmploiModel({
    required super.id,
    required super.titre,
    required super.entreprise,
    super.localisation,
    required super.source,
    super.description,
    super.typeContrat,
    super.salaireRange,
    super.niveauExperience,
    super.competences,
    super.lienOffre,
    required super.datePublication,
    super.descriptionComplete,
  });

  // JSON (venant de /jobs) → objet Dart
  factory OffreEmploiModel.fromJson(Map<String, dynamic> json) {
    return OffreEmploiModel(
      id:                  json['id'] as int,
      titre:               json['title'] as String? ?? '',
      entreprise:          json['company'] as String? ?? '',
      localisation:        json['location'] as String?,
      source:              json['source'] as String? ?? 'emploi.tg',
      description:         json['description'] as String?,
      typeContrat:         json['contract_type'] as String?,
      salaireRange:        json['salary_range'] as String?,
      niveauExperience:    json['experience_level'] as String?,
      competences:         json['skills_text'] as String?,
      lienOffre:           json['job_url'] as String?,
      descriptionComplete: json['has_full_description'] as bool? ?? false,
      datePublication: json['scraped_at'] != null
          ? DateTime.parse(json['scraped_at'] as String)
          : DateTime.now(),
    );
  }

  // Objet Dart → JSON (pour le cache local)
  Map<String, dynamic> toJson() => {
    'id':                   id,
    'title':                titre,
    'company':              entreprise,
    'location':             localisation,
    'source':               source,
    'description':          description,
    'contract_type':        typeContrat,
    'salary_range':         salaireRange,
    'experience_level':     niveauExperience,
    'skills_text':          competences,
    'job_url':              lienOffre,
    'has_full_description': descriptionComplete,
    'scraped_at':           datePublication.toIso8601String(),
  };
}
