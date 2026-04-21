import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../controllers/home_controller.dart';
import '../../controllers/favoris_controller.dart';
import '../../widgets/carte_offre.dart';
import '../../widgets/nav_bar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<HomeController>();
    final favCtrl = Get.find<FavorisController>();

    return Scaffold(
      backgroundColor: AppColors.fond,
      body: SafeArea(
        child: Column(
          children: [
            _Header(ctrl: ctrl),
            // Onglets "Pour vous" / "Toutes" — visibles si CV présent
            Obx(() {
              if (!ctrl.aCv) return const SizedBox.shrink();
              return Container(
                color: AppColors.blanc,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Row(
                  children: [
                    _OngletBtn(
                        label: 'Pour vous',
                        actif: ctrl.ongletActif.value == 'recommandees',
                        onTap: () => ctrl.changerOnglet('recommandees')),
                    const SizedBox(width: 8),
                    _OngletBtn(
                        label: 'Toutes les offres',
                        actif: ctrl.ongletActif.value == 'toutes',
                        onTap: () => ctrl.changerOnglet('toutes')),
                  ],
                ),
              );
            }),
            Expanded(
              child: Obx(() {
                final estOngletReco = ctrl.ongletActif.value == 'recommandees';

                // Chargement recommandations
                if (estOngletReco && ctrl.chargementReco.value) {
                  return Column(children: [
                    const SizedBox(height: 24),
                    const CircularProgressIndicator(
                        color: AppColors.primary, strokeWidth: 2),
                    const SizedBox(height: 16),
                    const Text('Analyse de votre CV en cours…',
                        style: TextStyle(
                            fontSize: 14, color: AppColors.texteDoux)),
                  ]);
                }

                // Erreur recommandations
                if (estOngletReco && ctrl.erreurReco.value.isNotEmpty) {
                  return _VueErreur(
                      message: ctrl.erreurReco.value,
                      onRetry: ctrl.chargerRecommandations);
                }

                // Chargement offres générales
                if (!estOngletReco && ctrl.chargement.value) {
                  return ListView.builder(
                    padding: const EdgeInsets.only(top: 8),
                    itemCount: 6,
                    itemBuilder: (_, __) => const CarteOffreChargement(),
                  );
                }
                if (!estOngletReco && ctrl.erreur.value.isNotEmpty) {
                  return _VueErreur(
                      message: ctrl.erreur.value, onRetry: ctrl.chargerOffres);
                }
                final liste = ctrl.offresAffichees;
                if (liste.isEmpty) {
                  return const _VueVide();
                }
                final estRecommandations =
                    estOngletReco && ctrl.aRecommandations;
                return RefreshIndicator(
                  color: AppColors.primary,
                  onRefresh: ctrl.rafraichir,
                  child: ListView.builder(
                    padding: const EdgeInsets.only(top: 8, bottom: 24),
                    itemCount: liste.length +
                        ((!estRecommandations && ctrl.plusDOffres.value)
                            ? 1
                            : 0),
                    itemBuilder: (context, index) {
                      if (index == liste.length) {
                        ctrl.chargerPlus();
                        return Padding(
                          padding: const EdgeInsets.all(16),
                          child: Center(
                              child: CircularProgressIndicator(
                                  color: AppColors.primary, strokeWidth: 2)),
                        );
                      }
                      final offre = liste[index];
                      return Obx(() => CarteOffre(
                            offre: offre,
                            estFavori: favCtrl.estFavori(offre.id),
                            onTap: () =>
                                Get.toNamed('/detail', arguments: offre.id),
                            onToggleFavori: () => favCtrl.toggleFavori(offre),
                          ));
                    },
                  ),
                );
              }),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const AppNavBar(currentIndex: 0),
    );
  }
}

class _Header extends StatelessWidget {
  final HomeController ctrl;
  const _Header({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.fond,
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(12)),
                child:
                    const Icon(Icons.person, color: AppColors.blanc, size: 22),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text('Career Concierge',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: AppColors.texte)),
              ),
              IconButton(
                icon: const Icon(Icons.settings_outlined,
                    color: AppColors.texteDoux),
                onPressed: () => Get.toNamed('/profil'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Obx(() => Text(
                ctrl.totalOffres.value > 0
                    ? 'Recommended for You'
                    : 'Discover Jobs',
                style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    color: AppColors.texte),
              )),
          Obx(() {
            if (ctrl.totalOffres.value > 0) {
              return Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text('Based on your uploaded CV',
                    style: const TextStyle(
                        fontSize: 14, color: AppColors.texteDoux)),
              );
            }
            return const SizedBox.shrink();
          }),
          const SizedBox(height: 12),
          Container(
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.blanc,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 8,
                    offset: const Offset(0, 2))
              ],
            ),
            child: TextField(
              onChanged: ctrl.rechercher,
              style: const TextStyle(fontSize: 14, color: AppColors.texte),
              decoration: InputDecoration(
                hintText: 'Search jobs, companies...',
                hintStyle:
                    const TextStyle(color: AppColors.texteLight, fontSize: 14),
                prefixIcon: const Icon(Icons.search,
                    color: AppColors.texteLight, size: 20),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _VueErreur extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _VueErreur({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Padding(
      padding: const EdgeInsets.all(32),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        const Icon(Icons.wifi_off_rounded,
            size: 56, color: AppColors.texteLight),
        const SizedBox(height: 16),
        Text(message,
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.texteDoux, fontSize: 14)),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: onRetry,
          style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.blanc,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12))),
          child: const Text('Réessayer'),
        ),
      ]),
    ));
  }
}

class _VueVide extends StatelessWidget {
  const _VueVide();

  @override
  Widget build(BuildContext context) {
    return const Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
      Icon(Icons.search_off_rounded, size: 56, color: AppColors.texteLight),
      SizedBox(height: 12),
      Text('Aucune offre trouvée',
          style: TextStyle(
              color: AppColors.texteDoux,
              fontSize: 15,
              fontWeight: FontWeight.w600)),
    ]));
  }
}

class _OngletBtn extends StatelessWidget {
  final String label;
  final bool actif;
  final VoidCallback onTap;
  const _OngletBtn(
      {required this.label, required this.actif, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: actif ? AppColors.primary : AppColors.fond,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: actif ? Colors.white : AppColors.texteDoux,
            )),
      ),
    );
  }
}
