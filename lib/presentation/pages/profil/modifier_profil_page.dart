import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_textes.dart';
import '../../controllers/profil_controller.dart';

// ─── PAGE MODIFIER PROFIL ─────────────────────────────────────────────────────

class ModifierProfilPage extends StatefulWidget {
  const ModifierProfilPage({super.key});

  @override
  State<ModifierProfilPage> createState() => _ModifierProfilPageState();
}

class _ModifierProfilPageState extends State<ModifierProfilPage> {
  late final ProfilController ctrl;

  late final TextEditingController _nomCtrl;
  late final TextEditingController _metierCtrl;
  late final TextEditingController _villeCtrl;
  late final TextEditingController _emailCtrl;
  late final TextEditingController _telCtrl;

  @override
  void initState() {
    super.initState();
    ctrl = Get.find<ProfilController>();

    _nomCtrl    = TextEditingController(text: ctrl.nom.value);
    _metierCtrl = TextEditingController(text: ctrl.metier.value);
    _villeCtrl  = TextEditingController(text: ctrl.ville.value);
    _emailCtrl  = TextEditingController(text: ctrl.email.value);
    _telCtrl    = TextEditingController(text: ctrl.telephone.value);
  }

  @override
  void dispose() {
    _nomCtrl.dispose();
    _metierCtrl.dispose();
    _villeCtrl.dispose();
    _emailCtrl.dispose();
    _telCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.fond,
      body: Column(
        children: [
          // ── HEADER ──────────────────────────────────────────────────
          _Header(),

          // ── FORMULAIRE ──────────────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
              child: Column(
                children: [
                  // Avatar
                  _SectionAvatar(ctrl: ctrl),
                  const SizedBox(height: 16),

                  // Champs
                  _CarteChamps(
                    children: [
                      _Champ(
                        label: 'NOM COMPLET',
                        controller: _nomCtrl,
                        icone: Icons.person_outline_rounded,
                      ),
                      _Champ(
                        label: 'MÉTIER',
                        controller: _metierCtrl,
                        icone: Icons.work_outline_rounded,
                      ),
                      _Champ(
                        label: 'VILLE',
                        controller: _villeCtrl,
                        icone: Icons.location_on_outlined,
                      ),
                      _Champ(
                        label: 'EMAIL',
                        controller: _emailCtrl,
                        icone: Icons.email_outlined,
                        clavier: TextInputType.emailAddress,
                      ),
                      _Champ(
                        label: 'TÉLÉPHONE',
                        controller: _telCtrl,
                        icone: Icons.phone_outlined,
                        clavier: TextInputType.phone,
                        dernierElement: true,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

      // ── BOUTON SAUVEGARDER ───────────────────────────────────────────
      bottomNavigationBar: _BoutonSauvegarder(
        onTap: () => ctrl.sauvegarderProfil(
          nouveauNom:        _nomCtrl.text,
          nouveauMetier:     _metierCtrl.text,
          nouvelleVille:     _villeCtrl.text,
          nouvelEmail:       _emailCtrl.text,
          nouveauTelephone:  _telCtrl.text,
        ),
      ),
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
            'Modifier le profil',
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

// ─── SECTION AVATAR ───────────────────────────────────────────────────────────
class _SectionAvatar extends StatelessWidget {
  final ProfilController ctrl;
  const _SectionAvatar({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.blanc,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.bordure),
      ),
      child: Column(
        children: [
          Obx(() => Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: const BoxDecoration(
                      color: AppColors.accent,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        ctrl.initiales,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 26,
                    height: 26,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Icon(
                      Icons.camera_alt_rounded,
                      color: Colors.white,
                      size: 12,
                    ),
                  ),
                ],
              )),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () => Get.snackbar(
              'Photo',
              'Upload de photo bientôt disponible',
              snackPosition: SnackPosition.BOTTOM,
            ),
            child: const Text(
              'Changer la photo',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── CARTE CHAMPS ─────────────────────────────────────────────────────────────
class _CarteChamps extends StatelessWidget {
  final List<Widget> children;
  const _CarteChamps({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.blanc,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.bordure),
      ),
      child: Column(children: children),
    );
  }
}

// ─── CHAMP ────────────────────────────────────────────────────────────────────
class _Champ extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final IconData icone;
  final TextInputType clavier;
  final bool dernierElement;

  const _Champ({
    required this.label,
    required this.controller,
    required this.icone,
    this.clavier = TextInputType.text,
    this.dernierElement = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: AppColors.texteDoux,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(icone, size: 16, color: AppColors.texteLight),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: controller,
                      keyboardType: clavier,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.texte,
                      ),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        if (!dernierElement)
          const Divider(height: 1, color: AppColors.bordure),
      ],
    );
  }
}

// ─── BOUTON SAUVEGARDER ───────────────────────────────────────────────────────
class _BoutonSauvegarder extends StatelessWidget {
  final VoidCallback onTap;
  const _BoutonSauvegarder({required this.onTap});

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
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Text(
            'Sauvegarder les modifications',
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

