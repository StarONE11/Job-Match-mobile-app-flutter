import 'dart:io';
import 'package:dio/dio.dart';
import '../../domain/entities/offre_emploi.dart';
import '../models/offre_emploi_model.dart';

/// Résultat du matching CV → jobs
class MatchResult {
  final String cvTextPreview;
  final int totalMatched;
  final List<OffreEmploi> jobs;
  const MatchResult(
      {required this.cvTextPreview,
      required this.totalMatched,
      required this.jobs});
}

class CandidatDataSource {
  final Dio _dio;

  CandidatDataSource()
      : _dio = Dio(BaseOptions(
          baseUrl: 'http://95.111.244.63:8000',
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 60),
        ));

  /// Envoie le PDF au backend et retourne les jobs recommandés.
  Future<MatchResult> matcherCv({
    required String cheminFichier,
    int topK = 20,
    double minScore = 0.0,
  }) async {
    final fichier = File(cheminFichier);
    if (!fichier.existsSync())
      throw Exception('Fichier introuvable : $cheminFichier');

    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(cheminFichier,
          filename: fichier.uri.pathSegments.last),
    });

    final response = await _dio.post(
      '/candidates/match',
      data: formData,
      queryParameters: {'top_k': topK, 'min_score': minScore},
    );

    final data = response.data as Map<String, dynamic>;
    final rawJobs = (data['jobs'] as List)
        .map((j) => OffreEmploiModel.fromMatchJson(j as Map<String, dynamic>))
        .toList();

    return MatchResult(
      cvTextPreview: data['cv_text_preview'] as String? ?? '',
      totalMatched: data['total_matched'] as int? ?? rawJobs.length,
      jobs: rawJobs,
    );
  }

  /// Inscrit le candidat dans Supabase (profil + CV embedding).
  /// Silencieux en cas d'erreur : l'app continue même si la sync échoue.
  Future<void> inscrireCandidatSupabase({
    required String cheminFichier,
    required String nom,
    required String metier,
    required String ville,
    required String email,
    required String telephone,
  }) async {
    try {
      final fichier = File(cheminFichier);
      if (!fichier.existsSync()) return;

      final formData = FormData.fromMap({
        'name': nom,
        'job_title': metier,
        'city': ville,
        'email': email,
        'phone': telephone,
        'file': await MultipartFile.fromFile(cheminFichier,
            filename: fichier.uri.pathSegments.last),
      });

      await _dio.post('/candidates/register', data: formData);
    } catch (_) {
      // Erreur réseau ignorée — la sync sera retentée au prochain lancement
    }
  }
}
