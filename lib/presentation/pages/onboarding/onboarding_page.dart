import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../controllers/onboarding_controller.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<OnboardingController>();
    return Scaffold(
      backgroundColor: AppColors.fond,
      body: Obx(() {
        switch (ctrl.etape.value) {
          case EtapeOnboarding.profil:
            return _EtapeProfil(ctrl: ctrl);
          case EtapeOnboarding.cv:
            return _EtapeCv(ctrl: ctrl);
          case EtapeOnboarding.traitement:
            return _EtapeTraitement(ctrl: ctrl);
        }
      }),
    );
  }
}

// ── Étape 1 : Informations personnelles ────────────────────────────────────────
class _EtapeProfil extends StatefulWidget {
  final OnboardingController ctrl;
  const _EtapeProfil({required this.ctrl});

  @override
  State<_EtapeProfil> createState() => _EtapeProfilState();
}

class _EtapeProfilState extends State<_EtapeProfil> {
  late final TextEditingController _nom =
      TextEditingController(text: widget.ctrl.nom.value);
  late final TextEditingController _metier =
      TextEditingController(text: widget.ctrl.metier.value);
  late final TextEditingController _ville =
      TextEditingController(text: widget.ctrl.ville.value);
  late final TextEditingController _email =
      TextEditingController(text: widget.ctrl.email.value);
  late final TextEditingController _telephone =
      TextEditingController(text: widget.ctrl.telephone.value);

  @override
  void dispose() {
    _nom.dispose();
    _metier.dispose();
    _ville.dispose();
    _email.dispose();
    _telephone.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          _BarreProgression(etape: 1),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  const Text('Bienvenue 👋',
                      style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: AppColors.texte,
                          letterSpacing: -0.5)),
                  const SizedBox(height: 8),
                  const Text(
                      'Dites-nous qui vous êtes pour recevoir\nles meilleures offres d\'emploi.',
                      style: TextStyle(
                          fontSize: 15,
                          color: AppColors.texteDoux,
                          height: 1.5)),
                  const SizedBox(height: 32),
                  _Champ(
                      label: 'Nom complet *',
                      hint: 'Ex: Kofi Mensah',
                      controller: _nom,
                      onChanged: (v) => widget.ctrl.nom.value = v),
                  const SizedBox(height: 16),
                  _Champ(
                      label: 'Métier / Poste recherché *',
                      hint: 'Ex: Développeur Flutter',
                      controller: _metier,
                      onChanged: (v) => widget.ctrl.metier.value = v),
                  const SizedBox(height: 16),
                  _Champ(
                      label: 'Ville *',
                      hint: 'Ex: Lomé, Togo',
                      controller: _ville,
                      onChanged: (v) => widget.ctrl.ville.value = v),
                  const SizedBox(height: 16),
                  _Champ(
                      label: 'Email',
                      hint: 'votre@email.com',
                      controller: _email,
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (v) => widget.ctrl.email.value = v),
                  const SizedBox(height: 16),
                  _Champ(
                      label: 'Téléphone',
                      hint: '+228 XX XX XX XX',
                      controller: _telephone,
                      keyboardType: TextInputType.phone,
                      onChanged: (v) => widget.ctrl.telephone.value = v),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
          _BoutonSuivant(
            label: 'Continuer',
            onTap: widget.ctrl.validerEtape1,
          ),
        ],
      ),
    );
  }
}

// ── Étape 2 : Upload CV ─────────────────────────────────────────────────────────
class _EtapeCv extends StatelessWidget {
  final OnboardingController ctrl;
  const _EtapeCv({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          _BarreProgression(etape: 2),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  const Text('Votre CV',
                      style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: AppColors.texte,
                          letterSpacing: -0.5)),
                  const SizedBox(height: 8),
                  const Text(
                      'Uploadez votre CV PDF pour que\nnous trouvions les offres qui vous correspondent.',
                      style: TextStyle(
                          fontSize: 15,
                          color: AppColors.texteDoux,
                          height: 1.5)),
                  const SizedBox(height: 40),
                  // Zone d'upload
                  Obx(() => GestureDetector(
                        onTap: ctrl.choisirCv,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: double.infinity,
                          padding: const EdgeInsets.all(32),
                          decoration: BoxDecoration(
                            color: ctrl.cheminCv.value.isNotEmpty
                                ? AppColors.accentLight
                                : AppColors.blanc,
                            border: Border.all(
                              color: ctrl.cheminCv.value.isNotEmpty
                                  ? AppColors.accent
                                  : AppColors.bordure,
                              width: ctrl.cheminCv.value.isNotEmpty ? 2 : 1,
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: ctrl.cheminCv.value.isEmpty
                              ? Column(children: [
                                  Container(
                                    width: 64,
                                    height: 64,
                                    decoration: BoxDecoration(
                                      color: AppColors.accentLight,
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: const Icon(Icons.upload_file_rounded,
                                        color: AppColors.accent, size: 32),
                                  ),
                                  const SizedBox(height: 16),
                                  const Text(
                                      'Appuyez pour sélectionner votre CV',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.texte)),
                                  const SizedBox(height: 6),
                                  const Text('PDF uniquement • Max 5 Mo',
                                      style: TextStyle(
                                          fontSize: 13,
                                          color: AppColors.texteLight)),
                                ])
                              : Row(children: [
                                  Container(
                                    width: 48,
                                    height: 48,
                                    decoration: BoxDecoration(
                                      color: AppColors.accent,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Icon(
                                        Icons.picture_as_pdf_rounded,
                                        color: Colors.white,
                                        size: 24),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                      child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(ctrl.nomCv.value,
                                          style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: AppColors.texte),
                                          overflow: TextOverflow.ellipsis),
                                      const SizedBox(height: 4),
                                      const Text('CV sélectionné ✓',
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: AppColors.accent)),
                                    ],
                                  )),
                                  IconButton(
                                    icon: const Icon(Icons.close,
                                        color: AppColors.texteLight, size: 20),
                                    onPressed: () {
                                      ctrl.cheminCv.value = '';
                                      ctrl.nomCv.value = '';
                                    },
                                  ),
                                ]),
                        ),
                      )),
                  const Spacer(),
                  // Bouton ignorer
                  Center(
                    child: TextButton(
                      onPressed: ctrl.ignorerCv,
                      child: const Text('Passer cette étape',
                          style: TextStyle(
                              color: AppColors.texteLight, fontSize: 14)),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
          _BoutonSuivant(
            label: 'Analyser mon CV',
            onTap: ctrl.validerEtape2,
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 24, top: 4),
            child: TextButton.icon(
              onPressed: ctrl.retourEtape1,
              icon: const Icon(Icons.arrow_back,
                  size: 16, color: AppColors.texteLight),
              label: const Text('Retour',
                  style: TextStyle(color: AppColors.texteLight)),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Étape 3 : Traitement ────────────────────────────────────────────────────────
class _EtapeTraitement extends StatelessWidget {
  final OnboardingController ctrl;
  const _EtapeTraitement({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final aErreur = ctrl.erreur.value.isNotEmpty;
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (!aErreur) ...[
                _AnimationAnalyse(),
                const SizedBox(height: 32),
                Text(ctrl.messageEtat.value,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.texte)),
                const SizedBox(height: 12),
                const Text('Cela peut prendre quelques secondes…',
                    style:
                        TextStyle(fontSize: 14, color: AppColors.texteLight)),
              ] else ...[
                const Icon(Icons.warning_amber_rounded,
                    color: AppColors.warning, size: 64),
                const SizedBox(height: 24),
                const Text('Analyse impossible',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: AppColors.texte)),
                const SizedBox(height: 12),
                Text(ctrl.erreur.value,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 14, color: AppColors.texteDoux, height: 1.5)),
                const SizedBox(height: 32),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () => Get.offAllNamed('/home'),
                  child: const Text('Continuer sans recommandations',
                      style: TextStyle(fontWeight: FontWeight.w600)),
                ),
              ],
            ],
          ),
        ),
      );
    });
  }
}

// ── Widgets communs ─────────────────────────────────────────────────────────────
class _BarreProgression extends StatelessWidget {
  final int etape; // 1, 2, 3
  const _BarreProgression({required this.etape});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.blanc,
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
      child: Row(children: [
        for (int i = 1; i <= 3; i++) ...[
          if (i > 1) const SizedBox(width: 8),
          Expanded(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: 4,
              decoration: BoxDecoration(
                color: i <= etape ? AppColors.primary : AppColors.bordure,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        ],
      ]),
    );
  }
}

class _Champ extends StatelessWidget {
  final String label, hint;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final ValueChanged<String> onChanged;
  const _Champ(
      {required this.label,
      required this.hint,
      required this.controller,
      this.keyboardType,
      required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.texte)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          onChanged: onChanged,
          style: const TextStyle(fontSize: 15, color: AppColors.texte),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: AppColors.texteLight),
            filled: true,
            fillColor: AppColors.blanc,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.bordure),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.bordure),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primary, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}

class _BoutonSuivant extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _BoutonSuivant({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.blanc,
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          elevation: 0,
        ),
        onPressed: onTap,
        child: Text(label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
      ),
    );
  }
}

class _AnimationAnalyse extends StatefulWidget {
  @override
  State<_AnimationAnalyse> createState() => _AnimationAnalyseState();
}

class _AnimationAnalyseState extends State<_AnimationAnalyse>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _pulse;

  @override
  void initState() {
    super.initState();
    _ctrl =
        AnimationController(vsync: this, duration: const Duration(seconds: 1))
          ..repeat(reverse: true);
    _pulse = Tween<double>(begin: 0.9, end: 1.1)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _pulse,
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: AppColors.accentLight,
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.psychology_rounded,
            color: AppColors.accent, size: 52),
      ),
    );
  }
}
