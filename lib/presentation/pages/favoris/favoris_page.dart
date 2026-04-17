import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_textes.dart';
import '../../controllers/favoris_controller.dart';
import '../../widgets/carte_offre.dart';

// ─── PAGE FAVORIS ─────────────────────────────────────────────────────────────
// Affiche les offres sauvegardées par l'utilisateur.
// Les données viennent du FavorisController (stockage local).

class FavorisPage extends StatelessWidget {
  const FavorisPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<FavorisController>();

    return Scaffold(
      backgroundColor: AppColors.fond,
      body: Column(
        children: [
          // ── HEADER BLEU ────────────────────────────────────────────────
          _Header(ctrl: ctrl),

          // ── LISTE DES FAVORIS ──────────────────────────────────────────
          Expanded(
            child: Obx(() {
              if (ctrl.favoris.isEmpty) {
                return const _VueVide();
              }

              return ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
                itemCount: ctrl.favoris.length,
                itemBuilder: (context, index) {
                  final offre = ctrl.favoris[index];
                  return CarteOffre(
                    offre: offre,
                    onTap: () => Get.toNamed('/detail', arguments: offre.id),
                    trailing: _BoutonRetirer(
                      onTap: () => ctrl.toggleFavori(offre),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
      bottomNavigationBar: const _NavBar(indexActif: 1),
    );
  }
}

// ─── HEADER ───────────────────────────────────────────────────────────────────
class _Header extends StatelessWidget {
  final FavorisController ctrl;
  const _Header({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.bleu,
      padding: EdgeInsets.fromLTRB(
        16,
        MediaQuery.of(context).padding.top + 16,
        16,
        20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Mes Favoris',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 4),
          Obx(() => Text(
                '${ctrl.total} offre${ctrl.total > 1 ? 's' : ''} sauvegardée${ctrl.total > 1 ? 's' : ''}',
                style: const TextStyle(
                  color: Colors.white60,
                  fontSize: 13,
                ),
              )),
        ],
      ),
    );
  }
}

// ─── BOUTON RETIRER ───────────────────────────────────────────────────────────
class _BoutonRetirer extends StatelessWidget {
  final VoidCallback onTap;
  const _BoutonRetirer({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: AppColors.orangeClair,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(
          Icons.bookmark_rounded,
          color: AppColors.orange,
          size: 16,
        ),
      ),
    );
  }
}

// ─── VUE VIDE ─────────────────────────────────────────────────────────────────
class _VueVide extends StatelessWidget {
  const _VueVide();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.bleuFond,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.bookmark_outline_rounded,
                size: 40,
                color: AppColors.bleu,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Aucun favori pour l\'instant',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.texte,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Appuie sur le signet d\'une offre\npour la sauvegarder ici.',
              textAlign: TextAlign.center,
              style: AppTextes.corps,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => Get.offNamed('/home'),
              icon: const Icon(Icons.search_rounded, size: 16),
              label: const Text('Voir les offres'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.bleu,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                    horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                elevation: 0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── BARRE DE NAVIGATION ──────────────────────────────────────────────────────
class _NavBar extends StatelessWidget {
  final int indexActif;
  const _NavBar({required this.indexActif});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.blanc,
        border: Border(top: BorderSide(color: AppColors.bordure)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _BoutonNav(
                icone: Icons.home_rounded,
                label: 'Accueil',
                actif: indexActif == 0,
                onTap: () => Get.offNamed('/home'),
              ),
              _BoutonNav(
                icone: Icons.bookmark_rounded,
                label: 'Favoris',
                actif: indexActif == 1,
                onTap: () {},
              ),
              _BoutonNav(
                icone: Icons.person_outline_rounded,
                label: 'Profil',
                actif: indexActif == 2,
                onTap: () => Get.offNamed('/profil'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BoutonNav extends StatelessWidget {
  final IconData icone;
  final String label;
  final bool actif;
  final VoidCallback onTap;

  const _BoutonNav({
    required this.icone,
    required this.label,
    required this.actif,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icone,
                size: 22,
                color: actif ? AppColors.bleu : AppColors.texteLight),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: actif ? FontWeight.w700 : FontWeight.w400,
                color: actif ? AppColors.bleu : AppColors.texteLight,
              ),
            ),
            if (actif) ...[
              const SizedBox(height: 3),
              Container(
                width: 4,
                height: 4,
                decoration: const BoxDecoration(
                  color: AppColors.orange,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
