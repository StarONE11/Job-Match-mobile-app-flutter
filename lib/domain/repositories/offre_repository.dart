import 'package:dartz/dartz.dart';
import '../entities/offre_emploi.dart';

// ─── CONTRAT ──────────────────────────────────────────────────────────────────
// C'est la "promesse" de ce que l'app peut faire.
// La vraie implementation est dans Data — ici on dit juste QUOI faire.
// Le Controller ne sait pas si les données viennent de l'API ou d'un cache.

abstract class OffreRepository {
  // Récupère la liste des offres
  // Retourne soit une erreur (Left) soit les offres (Right)
  Future<Either<String, List<OffreEmploi>>> getOffres({
    String? recherche,
    String? source,
    String? localisation,
    int page = 0,
    int limite = 20,
  });

  // Récupère une offre par son ID
  Future<Either<String, OffreEmploi>> getOffreParId(int id);

  // Récupère les statistiques
  Future<Either<String, Map<String, dynamic>>> getStats();
}
