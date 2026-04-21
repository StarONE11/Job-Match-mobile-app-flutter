import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/theme/app_colors.dart';
import '../../controllers/favoris_controller.dart';
import '../../widgets/nav_bar.dart';

class FavorisPage extends StatelessWidget {
  const FavorisPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<FavorisController>();

    return Scaffold(
      backgroundColor: AppColors.fond,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Header(ctrl: ctrl),
            Expanded(
              child: Obx(() {
                if (ctrl.favoris.isEmpty) return const _VueVide();
                return ListView.builder(
                  padding: const EdgeInsets.only(top: 8, bottom: 24),
                  itemCount: ctrl.favoris.length,
                  itemBuilder: (context, index) {
                    final offre = ctrl.favoris[index];
                    final savedDaysAgo =
                        DateTime.now().difference(offre.datePublication).inDays;
                    final isExpiringSoon = savedDaysAgo >= 25;

                    return Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 6),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.blanc,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.06),
                              blurRadius: 10,
                              offset: const Offset(0, 2))
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(0.08),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: AppColors.bordure),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  offre.entreprise.isNotEmpty
                                      ? offre.entreprise[0].toUpperCase()
                                      : '?',
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.primary),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(offre.titre,
                                        style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w700,
                                            color: AppColors.texte),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis),
                                    const SizedBox(height: 2),
                                    Text(
                                        '${offre.entreprise} · ${offre.villeShort}',
                                        style: const TextStyle(
                                            fontSize: 13,
                                            color: AppColors.texteDoux)),
                                  ],
                                ),
                              ),
                              Icon(Icons.bookmark,
                                  color: AppColors.primary, size: 22),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              if (isExpiringSoon)
                                const Text('EXPIRING SOON',
                                    style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.erreur,
                                        letterSpacing: 0.5))
                              else
                                Text(
                                  savedDaysAgo == 0
                                      ? 'SAVED TODAY'
                                      : 'SAVED ${savedDaysAgo} DAY${savedDaysAgo > 1 ? 'S' : ''} AGO',
                                  style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.texteLight,
                                      letterSpacing: 0.5),
                                ),
                              const Spacer(),
                              GestureDetector(
                                onTap: () async {
                                  final lien = offre.lienOffre;
                                  if (lien != null && lien.isNotEmpty) {
                                    final uri = Uri.tryParse(lien);
                                    if (uri != null) {
                                      try {
                                        await launchUrl(uri,
                                            mode:
                                                LaunchMode.externalApplication);
                                      } catch (_) {
                                        Get.snackbar('Erreur',
                                            'Impossible d\'ouvrir le lien.',
                                            snackPosition:
                                                SnackPosition.BOTTOM);
                                      }
                                    }
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 18, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Text('Apply',
                                      style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.blanc)),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const AppNavBar(currentIndex: 1),
    );
  }
}

class _Header extends StatelessWidget {
  final FavorisController ctrl;
  const _Header({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
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
                          color: AppColors.texte))),
              IconButton(
                  icon: const Icon(Icons.settings_outlined,
                      color: AppColors.texteDoux),
                  onPressed: () => Get.toNamed('/profil')),
            ],
          ),
          const SizedBox(height: 16),
          const Text('Saved Jobs',
              style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: AppColors.texte)),
          const SizedBox(height: 4),
          Obx(() => Text(
                'You have ${ctrl.total} opportunit${ctrl.total > 1 ? 'ies' : 'y'} bookmarked.',
                style:
                    const TextStyle(fontSize: 14, color: AppColors.texteDoux),
              )),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _VueVide extends StatelessWidget {
  const _VueVide();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        const Icon(Icons.bookmark_border_rounded,
            size: 64, color: AppColors.texteLight),
        const SizedBox(height: 16),
        const Text('No saved jobs yet',
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.texte)),
        const SizedBox(height: 8),
        const Text('Bookmark jobs to see them here',
            style: TextStyle(fontSize: 14, color: AppColors.texteDoux)),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: () => Get.offAllNamed('/home'),
          style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.blanc,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12))),
          child: const Text('Discover Jobs'),
        ),
      ]),
    );
  }
}
