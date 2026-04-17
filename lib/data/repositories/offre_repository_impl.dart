import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../domain/entities/offre_emploi.dart';
import '../../domain/repositories/offre_repository.dart';
import '../datasources/offre_datasource.dart';

// ─── IMPLÉMENTATION DU REPOSITORY ────────────────────────────────────────────
// Fait le lien entre le UseCase et le DataSource.
// Son job : attraper les erreurs et les transformer en messages clairs.
// Retourne toujours Either<String, T> — jamais d'exception qui fuit.

class OffreRepositoryImpl implements OffreRepository {
  final OffreDataSource _dataSource;

  const OffreRepositoryImpl(this._dataSource);

  @override
  Future<Either<String, List<OffreEmploi>>> getOffres({
    String? recherche,
    String? source,
    String? localisation,
    int page = 0,
    int limite = 20,
  }) async {
    try {
      final offres = await _dataSource.getOffres(
        recherche:   recherche,
        source:      source,
        localisation: localisation,
        page:        page,
        limite:      limite,
      );
      return Right(offres); // ← Succès
    } on DioException catch (e) {
      return Left(_messageErreur(e)); // ← Erreur réseau
    } catch (e) {
      return Left('Erreur inattendue : $e');
    }
  }

  @override
  Future<Either<String, OffreEmploi>> getOffreParId(int id) async {
    try {
      final offre = await _dataSource.getOffreParId(id);
      return Right(offre);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return const Left('Cette offre n\'existe plus.');
      }
      return Left(_messageErreur(e));
    } catch (e) {
      return Left('Erreur inattendue : $e');
    }
  }

  @override
  Future<Either<String, Map<String, dynamic>>> getStats() async {
    try {
      final stats = await _dataSource.getStats();
      return Right(stats);
    } on DioException catch (e) {
      return Left(_messageErreur(e));
    } catch (e) {
      return Left('Erreur inattendue : $e');
    }
  }

  // Transforme une erreur Dio en message lisible pour l'utilisateur
  String _messageErreur(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionError:
      case DioExceptionType.connectionTimeout:
        return 'Pas de connexion internet. Vérifiez votre réseau.';
      case DioExceptionType.receiveTimeout:
        return 'Le serveur met trop de temps à répondre.';
      case DioExceptionType.badResponse:
        return 'Erreur serveur (${e.response?.statusCode}).';
      default:
        return 'Erreur de connexion. Réessayez.';
    }
  }
}
