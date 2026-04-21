import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/theme/app_colors.dart';
import '../../controllers/detail_controller.dart';
import '../../controllers/favoris_controller.dart';
import '../../../domain/entities/offre_emploi.dart';

class DetailPage extends StatelessWidget {
  const DetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<DetailController>();
    final favCtrl = Get.find<FavorisController>();

    return Scaffold(
      backgroundColor: AppColors.fond,
      body: Obx(() {
        if (ctrl.chargement.value) {
          return const Center(
              child: CircularProgressIndicator(color: AppColors.primary));
        }
        if (ctrl.erreur.value.isNotEmpty) {
          return _VueErreur(message: ctrl.erreur.value);
        }
        if (ctrl.offre.value == null) {
          return const SizedBox.shrink();
        }
        final offre = ctrl.offre.value!;
        return _DetailContent(offre: offre, favCtrl: favCtrl);
      }),
    );
  }
}

class _DetailContent extends StatefulWidget {
  final OffreEmploi offre;
  final FavorisController favCtrl;
  const _DetailContent({required this.offre, required this.favCtrl});

  @override
  State<_DetailContent> createState() => _DetailContentState();
}

class _DetailContentState extends State<_DetailContent>
    with SingleTickerProviderStateMixin {
  late TabController _tab;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final offre = widget.offre;

    return Column(
      children: [
        // Header
        Container(
          color: AppColors.blanc,
          child: SafeArea(
            bottom: false,
            child: Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Row(
                    children: [
                      IconButton(
                          icon: const Icon(Icons.arrow_back,
                              color: AppColors.texte),
                          onPressed: Get.back),
                      const Expanded(
                          child: Text('Job Details',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.texte))),
                      Obx(() => IconButton(
                            icon: Icon(
                              widget.favCtrl.estFavori(offre.id)
                                  ? Icons.more_vert
                                  : Icons.more_vert,
                              color: AppColors.texte,
                            ),
                            onPressed: () => widget.favCtrl.toggleFavori(offre),
                          )),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                // Logo
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    offre.entreprise.isNotEmpty
                        ? offre.entreprise[0].toUpperCase()
                        : '?',
                    style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: AppColors.blanc),
                  ),
                ),
                const SizedBox(height: 16),
                Text(offre.titre,
                    style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: AppColors.texte),
                    textAlign: TextAlign.center),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(offre.entreprise,
                        style: const TextStyle(
                            fontSize: 14, color: AppColors.texteDoux)),
                    if (offre.localisation != null) ...[
                      Container(
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          width: 4,
                          height: 4,
                          decoration: const BoxDecoration(
                              color: AppColors.texteLight,
                              shape: BoxShape.circle)),
                      const Icon(Icons.location_on_outlined,
                          size: 14, color: AppColors.texteDoux),
                      Text(offre.villeShort,
                          style: const TextStyle(
                              fontSize: 14, color: AppColors.texteDoux)),
                    ],
                  ],
                ),
                const SizedBox(height: 16),
                if (offre.typeContrat != null ||
                    offre.salaireRange != null ||
                    offre.niveauExperience != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      alignment: WrapAlignment.center,
                      children: [
                        if (offre.typeContrat != null)
                          _BadgeDetail(offre.typeContrat!),
                        if (offre.niveauExperience != null)
                          _BadgeDetail(offre.niveauExperience!),
                        if (offre.salaireRange != null)
                          _BadgeDetail(offre.salaireRange!),
                      ],
                    ),
                  ),
                const SizedBox(height: 16),
                // Tabs
                TabBar(
                  controller: _tab,
                  labelColor: AppColors.primary,
                  unselectedLabelColor: AppColors.texteDoux,
                  labelStyle: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w700),
                  unselectedLabelStyle: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w500),
                  indicatorColor: AppColors.primary,
                  indicatorWeight: 2.5,
                  tabs: const [
                    Tab(text: 'Description'),
                    Tab(text: 'Requirements'),
                    Tab(text: 'Company')
                  ],
                ),
              ],
            ),
          ),
        ),
        // Tab content
        Expanded(
          child: TabBarView(
            controller: _tab,
            children: [
              _TabDescription(offre: offre),
              _TabRequirements(offre: offre),
              _TabCompany(offre: offre),
            ],
          ),
        ),
        // Bottom buttons
        Container(
          color: AppColors.blanc,
          padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 12,
              bottom: MediaQuery.of(context).padding.bottom + 12),
          child: Row(
            children: [
              Obx(() {
                final isFav = widget.favCtrl.estFavori(offre.id);
                return GestureDetector(
                  onTap: () => widget.favCtrl.toggleFavori(offre),
                  child: Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: isFav ? AppColors.accentLight : AppColors.fond,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.bordure),
                    ),
                    child: Icon(isFav ? Icons.bookmark : Icons.bookmark_border,
                        color:
                            isFav ? AppColors.primary : AppColors.texteLight),
                  ),
                );
              }),
              const SizedBox(width: 12),
              Expanded(
                child: GestureDetector(
                  onTap: () async {
                    final lien = offre.lienOffre;
                    if (lien != null && lien.isNotEmpty) {
                      final uri = Uri.tryParse(lien);
                      if (uri != null) {
                        try {
                          await launchUrl(uri,
                              mode: LaunchMode.externalApplication);
                        } catch (_) {
                          Get.snackbar(
                              'Erreur', 'Impossible d\'ouvrir le lien.',
                              snackPosition: SnackPosition.BOTTOM);
                        }
                      }
                    }
                  },
                  child: Container(
                    height: 52,
                    decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(14)),
                    alignment: Alignment.center,
                    child: const Text('Apply Now',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.blanc)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TabDescription extends StatelessWidget {
  final OffreEmploi offre;
  const _TabDescription({required this.offre});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (offre.description != null && offre.description!.isNotEmpty) ...[
            const Text('About the Role',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.texte)),
            const SizedBox(height: 10),
            Text(offre.description!,
                style: const TextStyle(
                    fontSize: 14, color: AppColors.texteDoux, height: 1.6)),
          ] else
            const Center(
                child: Padding(
              padding: EdgeInsets.all(32),
              child: Text('Pas de description disponible.',
                  style: TextStyle(color: AppColors.texteLight, fontSize: 14)),
            )),
        ],
      ),
    );
  }
}

class _TabRequirements extends StatelessWidget {
  final OffreEmploi offre;
  const _TabRequirements({required this.offre});

  @override
  Widget build(BuildContext context) {
    final competences = offre.listeCompetences;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (competences.isNotEmpty) ...[
            const Text('What You\'ll Do',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.texte)),
            const SizedBox(height: 12),
            ...competences.map((c) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 2, right: 10),
                        width: 20,
                        height: 20,
                        decoration: const BoxDecoration(
                            color: AppColors.primary, shape: BoxShape.circle),
                        child: const Icon(Icons.check,
                            size: 13, color: AppColors.blanc),
                      ),
                      Expanded(
                          child: Text(c,
                              style: const TextStyle(
                                  fontSize: 14,
                                  color: AppColors.texteDoux,
                                  height: 1.5))),
                    ],
                  ),
                )),
          ] else if (offre.niveauExperience != null) ...[
            const Text('Expérience requise',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.texte)),
            const SizedBox(height: 8),
            Text(offre.niveauExperience!,
                style:
                    const TextStyle(fontSize: 14, color: AppColors.texteDoux)),
          ] else
            const Center(
                child: Padding(
              padding: EdgeInsets.all(32),
              child: Text('Pas d\'informations disponibles.',
                  style: TextStyle(color: AppColors.texteLight, fontSize: 14)),
            )),
        ],
      ),
    );
  }
}

class _TabCompany extends StatelessWidget {
  final OffreEmploi offre;
  const _TabCompany({required this.offre});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(14)),
              alignment: Alignment.center,
              child: Text(
                  offre.entreprise.isNotEmpty
                      ? offre.entreprise[0].toUpperCase()
                      : '?',
                  style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary)),
            ),
            const SizedBox(width: 12),
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text(offre.entreprise,
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.texte)),
                  Text(offre.source,
                      style: const TextStyle(
                          fontSize: 13, color: AppColors.texteDoux)),
                ])),
          ]),
          const SizedBox(height: 20),
          if (offre.localisation != null)
            _InfoRow(Icons.location_on_outlined, 'Localisation',
                offre.localisation!),
          if (offre.typeContrat != null)
            _InfoRow(Icons.work_outline, 'Type de contrat', offre.typeContrat!),
          if (offre.salaireRange != null)
            _InfoRow(Icons.attach_money, 'Salaire', offre.salaireRange!),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label, value;
  const _InfoRow(this.icon, this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(children: [
        Icon(icon, size: 20, color: AppColors.primary),
        const SizedBox(width: 12),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label,
              style:
                  const TextStyle(fontSize: 12, color: AppColors.texteLight)),
          Text(value,
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.texte)),
        ]),
      ]),
    );
  }
}

class _BadgeDetail extends StatelessWidget {
  final String label;
  const _BadgeDetail(this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.fond,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.bordure),
      ),
      child: Text(label,
          style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.texte)),
    );
  }
}

class _VueErreur extends StatelessWidget {
  final String message;
  const _VueErreur({required this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.fond,
      body: Center(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
        const Icon(Icons.error_outline, size: 56, color: AppColors.texteLight),
        const SizedBox(height: 16),
        Text(message,
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.texteDoux, fontSize: 14)),
        const SizedBox(height: 20),
        ElevatedButton(
            onPressed: Get.back,
            style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.blanc),
            child: const Text('Retour')),
      ])),
    );
  }
}
