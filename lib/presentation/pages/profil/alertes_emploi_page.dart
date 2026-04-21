import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_textes.dart';
import '../../controllers/profil_controller.dart';

// ─── PAGE ALERTES EMPLOI ──────────────────────────────────────────────────────

class AlertesEmploiPage extends StatelessWidget {
  const AlertesEmploiPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<ProfilController>();

    return Scaffold(
      backgroundColor: AppColors.fond,
      body: Column(
        children: [
          // ── HEADER ──────────────────────────────────────────────────
          _Header(),

          // ── CONTENU ─────────────────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
              child: Column(
                children: [
                  // Activer/désactiver
                  _CarteActiver(ctrl: ctrl),
                  const SizedBox(height: 12),

                  // Fréquence
                  _CarteFrequence(ctrl: ctrl),
                  const SizedBox(height: 12),

                  // Mots-clés
                  _CarteMotsCles(ctrl: ctrl),
                  const SizedBox(height: 12),

                  // Localisation
                  _CarteLocalisation(ctrl: ctrl),
                  const SizedBox(height: 12),

                  // Type de contrat
                  _CarteTypeContrat(ctrl: ctrl),
                ],
              ),
            ),
          ),
        ],
      ),

      // ── BOUTON ENREGISTRER ───────────────────────────────────────────
      bottomNavigationBar: _BoutonEnregistrer(ctrl: ctrl),
    );
  }
}

// ─── HEADER ───────────────────────────────────────────────────────────────────
class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primary,
      padding: EdgeInsets.fromLTRB(
        16,
        MediaQuery.of(context).padding.top + 12,
        16,
        16,
      ),
      child: Row(
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
          const SizedBox(width: 12),
          const Text(
            'Alertes emploi',
            style: TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── CARTE ACTIVER ────────────────────────────────────────────────────────────
class _CarteActiver extends StatelessWidget {
  final ProfilController ctrl;
  const _CarteActiver({required this.ctrl});

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
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: ctrl.alertesActives.value
                      ? AppColors.accentLight
                      : AppColors.fond,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.notifications_rounded,
                  color: ctrl.alertesActives.value
                      ? AppColors.primary
                      : AppColors.texteLight,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Activer les alertes',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.texte,
                      ),
                    ),
                    Text(
                      ctrl.alertesActives.value
                          ? 'Vous recevrez des notifications'
                          : 'Alertes désactivées',
                      style: AppTextes.corps,
                    ),
                  ],
                ),
              ),
              // Toggle switch
              GestureDetector(
                onTap: () => ctrl.alertesActives.toggle(),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 44,
                  height: 24,
                  decoration: BoxDecoration(
                    color: ctrl.alertesActives.value
                        ? AppColors.primary
                        : AppColors.bordure,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: AnimatedAlign(
                    duration: const Duration(milliseconds: 200),
                    alignment: ctrl.alertesActives.value
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.all(3),
                      width: 18,
                      height: 18,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )),
    );
  }
}

// ─── CARTE FRÉQUENCE ──────────────────────────────────────────────────────────
class _CarteFrequence extends StatelessWidget {
  final ProfilController ctrl;
  const _CarteFrequence({required this.ctrl});

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
            'Fréquence',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.texteDoux,
            ),
          ),
          const SizedBox(height: 12),
          Obx(() => Row(
                children: [
                  _BoutonFrequence(
                    label: 'Immédiat',
                    valeur: 'immediat',
                    actif: ctrl.frequenceAlerte.value == 'immediat',
                    onTap: () => ctrl.frequenceAlerte.value = 'immediat',
                  ),
                  const SizedBox(width: 8),
                  _BoutonFrequence(
                    label: 'Quotidien',
                    valeur: 'quotidien',
                    actif: ctrl.frequenceAlerte.value == 'quotidien',
                    onTap: () => ctrl.frequenceAlerte.value = 'quotidien',
                  ),
                  const SizedBox(width: 8),
                  _BoutonFrequence(
                    label: 'Hebdo',
                    valeur: 'hebdo',
                    actif: ctrl.frequenceAlerte.value == 'hebdo',
                    onTap: () => ctrl.frequenceAlerte.value = 'hebdo',
                  ),
                ],
              )),
        ],
      ),
    );
  }
}

class _BoutonFrequence extends StatelessWidget {
  final String label;
  final String valeur;
  final bool actif;
  final VoidCallback onTap;

  const _BoutonFrequence({
    required this.label,
    required this.valeur,
    required this.actif,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: actif ? AppColors.primary : AppColors.fond,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: actif ? AppColors.primary : AppColors.bordure,
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: actif ? Colors.white : AppColors.texteDoux,
            ),
          ),
        ),
      ),
    );
  }
}

// ─── CARTE MOTS-CLÉS ──────────────────────────────────────────────────────────
class _CarteMotsCles extends StatelessWidget {
  final ProfilController ctrl;
  const _CarteMotsCles({required this.ctrl});

  void _afficherDialogue(BuildContext context) {
    final textCtrl = TextEditingController();
    Get.dialog(
      AlertDialog(
        title: const Text('Ajouter un mot-clé'),
        content: TextField(
          controller: textCtrl,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Ex: Flutter, Comptable, Manager...',
          ),
          onSubmitted: (v) {
            ctrl.ajouterMotCle(v);
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
              ctrl.ajouterMotCle(textCtrl.text);
              Get.back();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              elevation: 0,
            ),
            child: const Text('Ajouter'),
          ),
        ],
      ),
    );
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
            'Mots-clés à surveiller',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.texteDoux,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Recevez une alerte quand ces mots apparaissent dans une offre',
            style: AppTextes.corps,
          ),
          const SizedBox(height: 12),
          Obx(() => Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ...ctrl.motsCles.map((m) => GestureDetector(
                        onTap: () => ctrl.retirerMotCle(m),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.accentLight,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                m,
                                style: AppTextes.badge.copyWith(
                                    color: AppColors.primary, fontSize: 12),
                              ),
                              const SizedBox(width: 4),
                              const Icon(Icons.close_rounded,
                                  size: 12, color: AppColors.primary),
                            ],
                          ),
                        ),
                      )),
                  GestureDetector(
                    onTap: () => _afficherDialogue(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.fond,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.bordure),
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
        ],
      ),
    );
  }
}

// ─── CARTE LOCALISATION ───────────────────────────────────────────────────────
class _CarteLocalisation extends StatelessWidget {
  final ProfilController ctrl;
  const _CarteLocalisation({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    final villes = ['Lomé, Togo', 'Kara, Togo', 'Sokodé, Togo', 'Atakpamé, Togo', 'Tout le Togo'];

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
            'Localisation',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.texteDoux,
            ),
          ),
          const SizedBox(height: 12),
          Obx(() => DropdownButtonFormField<String>(
                value: ctrl.localisationAlerte.value,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: AppColors.bordure),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: AppColors.bordure),
                  ),
                ),
                style: const TextStyle(
                    fontSize: 13, color: AppColors.texte),
                items: villes
                    .map((v) => DropdownMenuItem(value: v, child: Text(v)))
                    .toList(),
                onChanged: (v) {
                  if (v != null) ctrl.localisationAlerte.value = v;
                },
              )),
        ],
      ),
    );
  }
}

// ─── CARTE TYPE CONTRAT ───────────────────────────────────────────────────────
class _CarteTypeContrat extends StatelessWidget {
  final ProfilController ctrl;
  const _CarteTypeContrat({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    final types = ['tous', 'CDI', 'CDD', 'Stage', 'Freelance'];
    final labels = ['Tous', 'CDI', 'CDD', 'Stage', 'Freelance'];

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
            'Type de contrat',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.texteDoux,
            ),
          ),
          const SizedBox(height: 12),
          Obx(() => Wrap(
                spacing: 8,
                runSpacing: 8,
                children: List.generate(types.length, (i) {
                  final actif = ctrl.typeContratAlerte.value == types[i];
                  return GestureDetector(
                    onTap: () => ctrl.typeContratAlerte.value = types[i],
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: actif ? AppColors.primary : AppColors.fond,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: actif ? AppColors.primary : AppColors.bordure,
                        ),
                      ),
                      child: Text(
                        labels[i],
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: actif ? Colors.white : AppColors.texteDoux,
                        ),
                      ),
                    ),
                  );
                }),
              )),
        ],
      ),
    );
  }
}

// ─── BOUTON ENREGISTRER ───────────────────────────────────────────────────────
class _BoutonEnregistrer extends StatelessWidget {
  final ProfilController ctrl;
  const _BoutonEnregistrer({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
          16, 12, 16, MediaQuery.of(context).padding.bottom + 12),
      decoration: const BoxDecoration(
        color: AppColors.blanc,
        border: Border(top: BorderSide(color: AppColors.bordure)),
      ),
      child: GestureDetector(
        onTap: ctrl.sauvegarderAlertes,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Text(
            'Enregistrer les alertes',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

