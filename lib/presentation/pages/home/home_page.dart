import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_textes.dart';
import '../../controllers/home_controller.dart';
import '../../widgets/carte_offre.dart';

// ─── PAGE ACCUEIL ─────────────────────────────────────────────────────────────
//
// Cette page est BÊTE : elle affiche ce que le Controller lui dit.
// Elle ne fait PAS d'appels API. Elle ne gère PAS l'état.
// Elle appelle juste : ctrl.chargerOffres(), ctrl.rechercher(), etc.
//
// Obx(() => ...) = la partie de l'écran qui se met à jour automatiquement
// quand une variable .obs du Controller change.

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Récupère le Controller créé par le HomeBinding
    final ctrl = Get.find<HomeController>();

    return Scaffold(
      backgroundColor: AppColors.fond,
      body: RefreshIndicator(
        color: AppColors.bleu,
        onRefresh: ctrl.rafraichir,
        child: CustomScrollView(
          slivers: [
            // ── HEADER BLEU ──────────────────────────────────────────────
            SliverToBoxAdapter(child: _Header(ctrl: ctrl)),

            // ── ONGLETS ──────────────────────────────────────────────────
            SliverToBoxAdapter(child: _Onglets(ctrl: ctrl)),

            // ── LISTE DES OFFRES ─────────────────────────────────────────
            // Obx : se met à jour quand offres, chargement ou erreur change
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
              sliver: Obx(() {
                // État 1 : Chargement → skeleton animé
                if (ctrl.chargement.value) {
                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (_, __) => const CarteOffreChargement(),
                      childCount: 5,
                    ),
                  );
                }

                // État 2 : Erreur → message avec bouton réessayer
                if (ctrl.erreur.value.isNotEmpty) {
                  return SliverToBoxAdapter(
                    child: _VueErreur(
                      message: ctrl.erreur.value,
                      onReessayer: ctrl.chargerOffres,
                    ),
                  );
                }

                // État 3 : Liste vide → message vide
                if (ctrl.offres.isEmpty) {
                  return const SliverToBoxAdapter(child: _VueVide());
                }

                // État 4 : Données → liste des offres
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      // Dernier élément → loader "charger plus"
                      if (index == ctrl.offres.length) {
                        return Obx(() => ctrl.chargementPlus.value
                            ? const Padding(
                                padding: EdgeInsets.all(16),
                                child: Center(
                                  child: CircularProgressIndicator(
                                    color: AppColors.bleu,
                                    strokeWidth: 2,
                                  ),
                                ),
                              )
                            : const SizedBox.shrink());
                      }

                      final offre = ctrl.offres[index];
                      return CarteOffre(
                        offre: offre,
                        onTap: () => Get.toNamed('/detail', arguments: offre.id),
                      );
                    },
                    childCount: ctrl.offres.length + 1,
                  ),
                );
              }),
            ),
          ],
        ),
      ),

      // ── BARRE DE NAVIGATION BAS ───────────────────────────────────────
      bottomNavigationBar: const _NavBar(indexActif: 0),
    );
  }
}

// ─── HEADER BLEU ─────────────────────────────────────────────────────────────
class _Header extends StatefulWidget {
  final HomeController ctrl;
  const _Header({required this.ctrl});

  @override
  State<_Header> createState() => _HeaderState();
}

class _HeaderState extends State<_Header> {
  final _searchCtrl = TextEditingController();

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.bleu,
      padding: EdgeInsets.fromLTRB(
        16,
        MediaQuery.of(context).padding.top + 16,
        16,
        16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Logo + cloche notif
          Row(
            children: [
              const Text('JobMatch Togo',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.3,
                  )),
              const Spacer(),

              // Nombre total d'offres
              Obx(() => Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.orange,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${widget.ctrl.totalOffres.value} offres',
                      style: AppTextes.badge.copyWith(color: Colors.white),
                    ),
                  )),

              const SizedBox(width: 8),
              // Cloche notification
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.notifications_outlined,
                    color: Colors.white, size: 18),
              ),
            ],
          ),

          const SizedBox(height: 12),
          const Text('Bonjour, Joe',
              style: TextStyle(
                  color: Colors.white60, fontSize: 13)),
          const SizedBox(height: 2),
          const Text('Trouvez votre emploi ideal.',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.3,
              )),

          const SizedBox(height: 14),

          // Barre de recherche
          Container(
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const SizedBox(width: 12),
                const Icon(Icons.search, color: AppColors.texteLight, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _searchCtrl,
                    onSubmitted: widget.ctrl.rechercher,
                    style: const TextStyle(
                        fontSize: 13, color: AppColors.texte),
                    decoration: const InputDecoration(
                      hintText: 'Rechercher un poste...',
                      hintStyle:
                          TextStyle(color: AppColors.texteLight, fontSize: 13),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => widget.ctrl.rechercher(_searchCtrl.text),
                  child: Container(
                    margin: const EdgeInsets.all(6),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.orange,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text('Filtrer',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        )),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── ONGLETS ──────────────────────────────────────────────────────────────────
class _Onglets extends StatelessWidget {
  final HomeController ctrl;
  const _Onglets({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.bleu,
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.fond,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
        child: Obx(() => Row(
              children: [
                _Onglet(
                  texte: 'Recommandees',
                  actif: ctrl.ongletActif.value == 'recommandees',
                  onTap: () => ctrl.changerOnglet('recommandees'),
                ),
                const SizedBox(width: 8),
                _Onglet(
                  texte: 'Recentes',
                  actif: ctrl.ongletActif.value == 'recentes',
                  onTap: () => ctrl.changerOnglet('recentes'),
                ),
              ],
            )),
      ),
    );
  }
}

class _Onglet extends StatelessWidget {
  final String texte;
  final bool actif;
  final VoidCallback onTap;

  const _Onglet({
    required this.texte,
    required this.actif,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: actif ? AppColors.bleu : AppColors.blanc,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: actif ? AppColors.bleu : AppColors.bordure,
          ),
        ),
        child: Text(
          texte,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: actif ? Colors.white : AppColors.texteDoux,
          ),
        ),
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 60),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.bleuFond,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.wifi_off_rounded,
                size: 36, color: AppColors.bleu),
          ),
          const SizedBox(height: 16),
          const Text('Connexion impossible',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.texte)),
          const SizedBox(height: 6),
          Text(message,
              textAlign: TextAlign.center,
              style: AppTextes.corps),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: onReessayer,
            icon: const Icon(Icons.refresh_rounded, size: 16),
            label: const Text('Reessayer'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.bleu,
              foregroundColor: Colors.white,
              padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              elevation: 0,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── VUE VIDE ─────────────────────────────────────────────────────────────────
class _VueVide extends StatelessWidget {
  const _VueVide();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 60),
      child: Column(
        children: [
          Icon(Icons.work_off_outlined, size: 48, color: AppColors.texteLight),
          SizedBox(height: 12),
          Text('Aucune offre trouvee',
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.texteDoux)),
          SizedBox(height: 6),
          Text('Essayez de modifier vos filtres',
              style: TextStyle(fontSize: 12, color: AppColors.texteLight)),
        ],
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
                icone: Icons.bookmark_outline_rounded,
                label: 'Favoris',
                actif: indexActif == 1,
                onTap: () => Get.offNamed('/favoris'),
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
            Icon(
              icone,
              size: 22,
              color: actif ? AppColors.bleu : AppColors.texteLight,
            ),
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
