import 'package:dio/dio.dart';
import '../models/offre_emploi_model.dart';

// ─── SOURCE DE DONNÉES DISTANTE ───────────────────────────────────────────────
// C'est la seule classe qui parle à l'API FastAPI.
// Elle envoie des requêtes HTTP avec Dio et retourne des modèles.

class OffreDataSource {
  final Dio _dio;

  // L'URL de notre API FastAPI
  // En local : http://10.0.2.2:8000 (émulateur Android)
  // En production : https://ton-api.render.com
  OffreDataSource()
      : _dio = Dio(
          BaseOptions(
            baseUrl: 'http://10.0.2.2:8000',
            connectTimeout: const Duration(seconds: 10),
            receiveTimeout: const Duration(seconds: 15),
            headers: {'Content-Type': 'application/json'},
          ),
        );

  // Récupère les offres avec filtres
  Future<List<OffreEmploiModel>> getOffres({
    String? recherche,
    String? source,
    String? localisation,
    int page = 0,
    int limite = 20,
  }) async {
    final params = <String, dynamic>{
      'skip':       page * limite,
      'limit':      limite,
      'sort_by':    'scraped_at',
      'sort_order': 'desc',
    };

    if (recherche != null && recherche.isNotEmpty) params['search']   = recherche;
    if (source != null)                             params['source']   = source;
    if (localisation != null)                       params['location'] = localisation;

    final response = await _dio.get('/jobs', queryParameters: params);

    return (response.data as List)
        .map((j) => OffreEmploiModel.fromJson(j as Map<String, dynamic>))
        .toList();
  }

  // Récupère une offre par ID
  Future<OffreEmploiModel> getOffreParId(int id) async {
    final response = await _dio.get('/jobs/$id');
    return OffreEmploiModel.fromJson(response.data as Map<String, dynamic>);
  }

  // Récupère les stats globales
  Future<Map<String, dynamic>> getStats() async {
    final response = await _dio.get('/jobs/stats');
    return response.data as Map<String, dynamic>;
  }
}
