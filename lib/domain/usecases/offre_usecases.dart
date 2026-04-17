import 'package:dartz/dartz.dart';
import '../entities/offre_emploi.dart';
import '../repositories/offre_repository.dart';

// ─── USE CASE 1 : Voir les offres ────────────────────────────────────────────
// Le Controller appelle ça. Pas l'API directement.
class VoirLesOffres {
  final OffreRepository repository;
  const VoirLesOffres(this.repository);

  Future<Either<String, List<OffreEmploi>>> call({
    String? recherche,
    String? source,
    String? localisation,
    int page = 0,
    int limite = 20,
  }) {
    return repository.getOffres(
      recherche: recherche,
      source: source,
      localisation: localisation,
      page: page,
      limite: limite,
    );
  }
}

// ─── USE CASE 2 : Voir le détail d'une offre ─────────────────────────────────
class VoirDetailOffre {
  final OffreRepository repository;
  const VoirDetailOffre(this.repository);

  Future<Either<String, OffreEmploi>> call(int id) {
    return repository.getOffreParId(id);
  }
}

// ─── USE CASE 3 : Chercher une offre ─────────────────────────────────────────
class ChercherOffres {
  final OffreRepository repository;
  const ChercherOffres(this.repository);

  Future<Either<String, List<OffreEmploi>>> call(String texte) {
    return repository.getOffres(recherche: texte, limite: 50);
  }
}

// ─── USE CASE 4 : Voir les stats ─────────────────────────────────────────────
class VoirStats {
  final OffreRepository repository;
  const VoirStats(this.repository);

  Future<Either<String, Map<String, dynamic>>> call() {
    return repository.getStats();
  }
}
