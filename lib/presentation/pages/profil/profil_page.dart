import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_textes.dart';
import '../../controllers/profil_controller.dart';

// ─── PAGE PROFIL ──────────────────────────────────────────────────────────────
// Affiche les informations du candidat : nom, stats, CV, compétences, paramètres.

class ProfilPage extends StatelessWidget {
  const ProfilPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<ProfilController>();

    return Scaffold(
      backgroundColor: AppColors.fond,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ── HEADER BLEU avec avatar ────────────────────────────────
            _Header(ctrl: ctrl),

            // ── CONTENU ───────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
              child: Column(
                children: [
                  // Stats
                  _CarteStats(ctrl: ctrl),
                  const SizedBox(height: 12),

                  // CV
                  _CarteCv(ctrl: ctrl),
                  const SizedBox(height: 12),

                  // Compétences
                  _CarteCompetences(ctrl: ctrl),
                  const SizedBox(height: 12),

                  // Paramètres
                  _CarteParametres(ctrl: ctrl),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const _NavBar(indexActif: 2),
    );
  }
}

// ─── HEADER ───────────────────────────────────────────────────────────────────
class _Header extends StatelessWidget {
  final ProfilController ctrl;
  const _Header({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.bleu,
      padding: EdgeInsets.fromLTRB(
        16,
        MediaQuery.of(context).padding.top + 16,
        16,
        28,
      ),
      child: Column(
        children: [
          // Avatar avec initiales
          Obx(() => Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: AppColors.orange,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 3),
                ),
                child: Center(
                  child: Text(
                    ctrl.initiales,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              )),
          const SizedBox(height: 12),

          // Nom
          Obx(() => Text(
                ctrl.nom.value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              )),
          const SizedBox(height: 4),

          // Métier + ville
          Obx(() => Text(
                '${ctrl.metier.value} · ${ctrl.ville.value}',
                style: const TextStyle(
                  color: Colors.white60,
                  fontSize: 12,
                ),
              )),
        ],
      ),
    );
  }
}

// ─── CARTE STATS ──────────────────────────────────────────────────────────────
class _CarteStats extends StatelessWidget {
  final ProfilController ctrl;
  const _CarteStats({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.blanc,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.bordure),
      ),
      child: Obx(() => Row(
            children: [
              _Stat(valeur: ctrl.candidatures.value, label: 'Candidatures'),
              _Separateur(),
              _Stat(valeur: ctrl.favoris.value, label: 'Favoris'),
             // _Separateur(),
              //_Stat(valeur: ctrl.entretiens.value, label: 'Entretiens'),
            ],
          )),
    );
  }
}

class _Stat extends StatelessWidget {
  final int valeur;
  final String label;
  const _Stat({required this.valeur, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            '$valeur',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: AppColors.texte,
            ),
          ),
          const SizedBox(height: 4),
          Text(label, style: AppTextes.corps.copyWith(fontSize: 11)),
        ],
      ),
    );
  }
}

class _Separateur extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(width: 1, height: 40, color: AppColors.bordure);
  }
}

// ─── CARTE CV ─────────────────────────────────────────────────────────────────
class _CarteCv extends StatelessWidget {
  final ProfilController ctrl;
  const _CarteCv({required this.ctrl});

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
            'Mon CV',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.texteDoux,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 12),
          Obx(() => Row(
                children: [
                  // Icône PDF
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.bleuFond,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.picture_as_pdf_rounded,
                      color: AppColors.bleu,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Nom + date
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ctrl.nomCv.value,
                          style: AppTextes.titreCarte.copyWith(fontSize: 13),
                        ),
                        const SizedBox(height: 2),
                        Text(ctrl.dateCv.value, style: AppTextes.corps),
                      ],
                    ),
                  ),

                  // Bouton modifier
                  GestureDetector(
                    onTap: () => ctrl.choisirCv(),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.bleuFond,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'Modifier',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppColors.bleu,
                        ),
                      ),
                    ),
                  ),
                ],
              )),
        ],
      ),
    );
  }
}

// ─── CARTE COMPÉTENCES ────────────────────────────────────────────────────────
class _CarteCompetences extends StatelessWidget {
  final ProfilController ctrl;
  const _CarteCompetences({required this.ctrl});

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
            'Compétences',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.texteDoux,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 12),
          Obx(() => Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  // Badges compétences
                  ...ctrl.competences.map((c) => GestureDetector(
                        onLongPress: () => ctrl.retirerCompetence(c),
                        child: Container(
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
                        ),
                      )),

                  // Bouton ajouter
                  GestureDetector(
                    onTap: () => _afficherDialogueAjout(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.fond,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: AppColors.bordure, style: BorderStyle.solid),
                      ),
                      child: const Text(
                        '+ Ajouter',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.texteDoux,
                        ),
                      ),
                    ),
                  ),
                ],
              )),
          const SizedBox(height: 6),
          const Text(
            'Appui long pour supprimer une compétence',
            style: TextStyle(fontSize: 10, color: AppColors.texteLight),
          ),
        ],
      ),
    );
  }

  void _afficherDialogueAjout(BuildContext context) {
    final textCtrl = TextEditingController();
    Get.dialog(
      AlertDialog(
        title: const Text('Ajouter une compétence'),
        content: TextField(
          controller: textCtrl,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Ex: Dart, SQL, Figma...',
          ),
          onSubmitted: (v) {
            ctrl.ajouterCompetence(v);
            Get.back();
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              ctrl.ajouterCompetence(textCtrl.text);
              Get.back();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.bleu,
              foregroundColor: Colors.white,
              elevation: 0,
            ),
            child: const Text('Ajouter'),
          ),
        ],
      ),
    );
  }
}

// ─── CARTE PARAMÈTRES ─────────────────────────────────────────────────────────
class _CarteParametres extends StatelessWidget {
  final ProfilController ctrl;
  const _CarteParametres({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.blanc,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.bordure),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 14, 16, 8),
            child: Text(
              'Paramètres',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.texteDoux,
                letterSpacing: 0.5,
              ),
            ),
          ),
          _LigneParametre(
            icone: Icons.person_outline_rounded,
            label: 'Modifier le profil',
            onTap: () => Get.toNamed('/modifier-profil'),
          ),
          const Divider(height: 1, color: AppColors.bordure),
          _LigneParametre(
            icone: Icons.notifications_outlined,
            label: 'Alertes emploi',
            onTap: () => Get.toNamed('/alertes-emploi'),
          ),
          const Divider(height: 1, color: AppColors.bordure),
          _LigneParametre(
            icone: Icons.logout_rounded,
            label: 'Se déconnecter',
            couleur: AppColors.erreur,
            onTap: ctrl.deconnecter,
            dernierElement: true,
          ),
        ],
      ),
    );
  }
}

class _LigneParametre extends StatelessWidget {
  final IconData icone;
  final String label;
  final VoidCallback onTap;
  final Color couleur;
  final bool dernierElement;

  const _LigneParametre({
    required this.icone,
    required this.label,
    required this.onTap,
    this.couleur = AppColors.texte,
    this.dernierElement = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: EdgeInsets.fromLTRB(
            16, 14, 16, dernierElement ? 14 : 14),
        child: Row(
          children: [
            Icon(icone, size: 18, color: couleur),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: couleur,
                ),
              ),
            ),
            Icon(Icons.chevron_right_rounded,
                size: 18, color: AppColors.texteLight),
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
                onTap: () => Get.offNamed('/favoris'),
              ),
              _BoutonNav(
                icone: Icons.person_outline_rounded,
                label: 'Profil',
                actif: indexActif == 2,
                onTap: () {},
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
