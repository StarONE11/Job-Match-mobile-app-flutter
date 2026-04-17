import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_textes.dart';
import '../../controllers/detail_controller.dart';
import '../../controllers/favoris_controller.dart';
import '../../../domain/entities/offre_emploi.dart';

// ─── PAGE DÉTAIL D'UNE OFFRE ──────────────────────────────────────────────────

class DetailPage extends StatelessWidget {
  const DetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl        = Get.find<DetailController>();
    final favCtrl     = Get.find<FavorisController>();

    return Scaffold(
      backgroundColor: AppColors.fond,
      body: Obx(() {
        // ── Chargement ──────────────────────────────────────────────────
        if (ctrl.chargement.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.bleu),
          );
        }

        // ── Erreur ──────────────────────────────────────────────────────
        if (ctrl.erreur.value.isNotEmpty) {
          return _VueErreur(
            message: ctrl.erreur.value,
            onReessayer: () {
              final id = Get.arguments as int?;
              if (id != null) ctrl.chargerOffre(id);
            },
          );
        }

        // ── Données ─────────────────────────────────────────────────────
        final offre = ctrl.offre.value;
        if (offre == null) return const SizedBox.shrink();

        return CustomScrollView(
          slivers: [
            // Header
            SliverToBoxAdapter(
              child: _Header(offre: offre, favCtrl: favCtrl),
            ),

            // Contenu
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _CarteInfosCles(offre: offre),
                  const SizedBox(height: 12),
                  if (offre.listeCompetences.isNotEmpty) ...[
                    _CarteCompetences(offre: offre),
                    const SizedBox(height: 12),
                  ],
                  if (offre.description != null) ...[
                    _CarteDescription(offre: offre),
                    const SizedBox(height: 12),
                  ],
                ]),
              ),
            ),
          ],
        );
      }),

      // ── Boutons bas ──────────────────────────────────────────────────
      bottomNavigationBar: Obx(() {
        final offre = ctrl.offre.value;
        if (offre == null) return const SizedBox.shrink();
        return _BoutonsBas(offre: offre);
      }),
    );
  }
}

// ─── HEADER ───────────────────────────────────────────────────────────────────
class _Header extends StatelessWidget {
  final OffreEmploi offre;
  final FavorisController favCtrl;

  const _Header({required this.offre, required this.favCtrl});

  Color _couleurAvatar() {
    final couleurs = [
      AppColors.bleu, AppColors.orange,
      const Color(0xFF00796B), const Color(0xFF6A1B9A),
    ];
    return couleurs[offre.entreprise.length % couleurs.length];
  }

  String _initiales() {
    final mots = offre.entreprise.trim().split(' ');
    if (mots.length >= 2) return '${mots[0][0]}${mots[1][0]}'.toUpperCase();
    if (offre.entreprise.length >= 2)
      return offre.entreprise.substring(0, 2).toUpperCase();
    return offre.entreprise.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.bleu,
      padding: EdgeInsets.fromLTRB(
        16,
        MediaQuery.of(context).padding.top + 12,
        16,
        20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Bouton retour + bouton favori
          Row(
            children: [
              GestureDetector(
                onTap: () => Get.back(),
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
              const Spacer(),
              // Bouton favori
              Obx(() {
                final estFavori = favCtrl.estFavori(offre.id);
                return GestureDetector(
                  onTap: () => favCtrl.toggleFavori(offre),
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: estFavori
                          ? AppColors.orangeClair
                          : Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      estFavori
                          ? Icons.bookmark_rounded
                          : Icons.bookmark_outline_rounded,
                      color: estFavori ? AppColors.orange : Colors.white,
                      size: 18,
                    ),
                  ),
                );
              }),
            ],
          ),

          const SizedBox(height: 16),

          // Avatar + entreprise + titre
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: _couleurAvatar(),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                      color: Colors.white.withOpacity(0.3), width: 2),
                ),
                child: Center(
                  child: Text(
                    _initiales(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      offre.entreprise,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      offre.titre,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Badges
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _Badge(
                texte: offre.typeContrat ?? 'Non précisé',
                fond: Colors.white.withOpacity(0.15),
                couleur: Colors.white,
              ),
              _Badge(
                texte: offre.villeShort,
                fond: Colors.white.withOpacity(0.15),
                couleur: Colors.white,
              ),
              _Badge(
                texte: offre.niveauExperience ?? 'Non précisé',
                fond: Colors.white.withOpacity(0.15),
                couleur: Colors.white,
              ),
              if (offre.estNouvelle)
                _Badge(
                  texte: 'NOUVEAU',
                  fond: AppColors.orange,
                  couleur: Colors.white,
                ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── CARTE INFOS CLÉS ─────────────────────────────────────────────────────────
class _CarteInfosCles extends StatelessWidget {
  final OffreEmploi offre;
  const _CarteInfosCles({required this.offre});

  String _tempsEcoule() {
    final diff = DateTime.now().difference(offre.datePublication);
    if (diff.inMinutes < 60) return 'Il y a ${diff.inMinutes} min';
    if (diff.inHours < 24) return 'Il y a ${diff.inHours}h';
    if (diff.inDays == 1) return 'Hier';
    if (diff.inDays < 7) return 'Il y a ${diff.inDays}j';
    return 'Il y a ${(diff.inDays / 7).round()} sem.';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.blanc,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.bordure),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Informations',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.texteDoux,
            ),
          ),
          const SizedBox(height: 12),
          _GridInfos(children: [
            _InfoItem(
              label: 'Salaire',
              valeur: offre.salaireRange ?? 'Non précisé',
            ),
            _InfoItem(
              label: 'Source',
              valeur: offre.source,
            ),
            _InfoItem(
              label: 'Publié',
              valeur: _tempsEcoule(),
            ),
            _InfoItem(
              label: 'Niveau',
              valeur: offre.niveauExperience ?? 'Non précisé',
            ),
          ]),
        ],
      ),
    );
  }
}

class _GridInfos extends StatelessWidget {
  final List<Widget> children;
  const _GridInfos({required this.children});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      childAspectRatio: 2.8,
      children: children,
    );
  }
}

class _InfoItem extends StatelessWidget {
  final String label;
  final String valeur;
  const _InfoItem({required this.label, required this.valeur});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.fond,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(label, style: AppTextes.corps.copyWith(fontSize: 10)),
          const SizedBox(height: 2),
          Text(
            valeur,
            style: AppTextes.titreCarte.copyWith(fontSize: 12),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

// ─── CARTE COMPÉTENCES ────────────────────────────────────────────────────────
class _CarteCompetences extends StatelessWidget {
  final OffreEmploi offre;
  const _CarteCompetences({required this.offre});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.blanc,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.bordure),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Compétences requises',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.texteDoux,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: offre.listeCompetences
                .map((c) => Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.bleuFond,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        c,
                        style: AppTextes.badge
                            .copyWith(color: AppColors.bleu, fontSize: 12),
                      ),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}

// ─── CARTE DESCRIPTION ────────────────────────────────────────────────────────
class _CarteDescription extends StatelessWidget {
  final OffreEmploi offre;
  const _CarteDescription({required this.offre});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.blanc,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.bordure),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Description',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.texteDoux,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            offre.description ?? 'Aucune description disponible.',
            style: AppTextes.corps.copyWith(
              fontSize: 13,
              height: 1.6,
              color: AppColors.texte,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── BOUTONS BAS ──────────────────────────────────────────────────────────────
class _BoutonsBas extends StatelessWidget {
  final OffreEmploi offre;
  const _BoutonsBas({required this.offre});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
          16, 12, 16, MediaQuery.of(context).padding.bottom + 12),
      decoration: const BoxDecoration(
        color: AppColors.blanc,
        border: Border(top: BorderSide(color: AppColors.bordure)),
      ),
      child: Row(
        children: [
          // Bouton partager
          Expanded(
            child: GestureDetector(
              onTap: () => Get.snackbar(
                'Partager',
                'Fonctionnalité bientôt disponible',
                snackPosition: SnackPosition.BOTTOM,
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: AppColors.fond,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.bordure),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.share_outlined,
                        size: 16, color: AppColors.texteDoux),
                    SizedBox(width: 6),
                    Text(
                      'Partager',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.texteDoux,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),

          // Bouton postuler
          Expanded(
            flex: 2,
            child: GestureDetector(
              onTap: () {
                if (offre.lienOffre != null) {
                  Get.snackbar(
                    'Redirection',
                    'Ouverture de l\'offre sur ${offre.source}',
                    snackPosition: SnackPosition.BOTTOM,
                  );
                } else {
                  Get.snackbar(
                    'Lien indisponible',
                    'Non précisé pour cette offre',
                    snackPosition: SnackPosition.BOTTOM,
                  );
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: AppColors.bleu,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Postuler maintenant',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 6),
                    Icon(Icons.arrow_forward_rounded,
                        size: 16, color: Colors.white),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── VUE ERREUR ───────────────────────────────────────────────────────────────
class _VueErreur extends StatelessWidget {
  final String message;
  final VoidCallback onReessayer;
  const _VueErreur({required this.message, required this.onReessayer});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.wifi_off_rounded,
                size: 48, color: AppColors.texteLight),
            const SizedBox(height: 16),
            const Text('Impossible de charger l\'offre',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.texte)),
            const SizedBox(height: 8),
            Text(message,
                textAlign: TextAlign.center,
                style: AppTextes.corps),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: onReessayer,
              icon: const Icon(Icons.refresh_rounded, size: 16),
              label: const Text('Réessayer'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.bleu,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── BADGE ────────────────────────────────────────────────────────────────────
class _Badge extends StatelessWidget {
  final String texte;
  final Color fond;
  final Color couleur;
  const _Badge(
      {required this.texte, required this.fond, required this.couleur});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: fond,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        texte,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: couleur,
        ),
      ),
    );
  }
}
