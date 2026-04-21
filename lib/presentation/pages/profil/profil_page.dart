import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../controllers/profil_controller.dart';
import '../../widgets/nav_bar.dart';

class ProfilPage extends StatelessWidget {
  const ProfilPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<ProfilController>();

    return Scaffold(
      backgroundColor: AppColors.fond,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _Header(ctrl: ctrl),
              const SizedBox(height: 8),
              _CarteCv(ctrl: ctrl),
              const SizedBox(height: 8),
              _CarteParametres(ctrl: ctrl),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const AppNavBar(currentIndex: 2),
    );
  }
}

class _Header extends StatelessWidget {
  final ProfilController ctrl;
  const _Header({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.blanc,
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      child: Column(
        children: [
          Row(
            children: [
              const BackButton(color: AppColors.primary),
              const Expanded(
                  child: Text('Profile',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.texte))),
              const SizedBox(width: 48),
            ],
          ),
          const SizedBox(height: 20),
          Obx(() => CircleAvatar(
                radius: 44,
                backgroundColor: AppColors.primary,
                child: Text(ctrl.initiales,
                    style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: AppColors.blanc)),
              )),
          const SizedBox(height: 14),
          Obx(() => Text(ctrl.nom.value,
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AppColors.texte))),
          const SizedBox(height: 4),
          Obx(() => Text(ctrl.metier.value,
              style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600))),
          const SizedBox(height: 4),
          Obx(() => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.location_on_outlined,
                      size: 14, color: AppColors.texteDoux),
                  const SizedBox(width: 4),
                  Text(ctrl.ville.value,
                      style: const TextStyle(
                          fontSize: 13, color: AppColors.texteDoux)),
                ],
              )),
        ],
      ),
    );
  }
}

class _CarteCv extends StatelessWidget {
  final ProfilController ctrl;
  const _CarteCv({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.blanc,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.description_outlined,
                  color: AppColors.primary, size: 20),
              const SizedBox(width: 8),
              const Expanded(
                  child: Text('Resume',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.texte))),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                    color: AppColors.accentLight,
                    borderRadius: BorderRadius.circular(20)),
                child: const Text('Primary',
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.accent)),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Obx(
            () => ctrl.cvCharge.value
                ? Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                        color: AppColors.fond,
                        borderRadius: BorderRadius.circular(12)),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8)),
                          child: const Icon(Icons.picture_as_pdf,
                              color: AppColors.primary, size: 22),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(ctrl.nomCv.value,
                                style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.texte),
                                overflow: TextOverflow.ellipsis),
                            Text(ctrl.dateCv.value,
                                style: const TextStyle(
                                    fontSize: 12, color: AppColors.texteLight)),
                          ],
                        )),
                      ],
                    ),
                  )
                : const SizedBox.shrink(),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.texte,
                    side: const BorderSide(color: AppColors.bordure),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text('View',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton(
                  onPressed: ctrl.choisirCv,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.texte,
                    side: const BorderSide(color: AppColors.bordure),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text('Replace',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CarteParametres extends StatelessWidget {
  final ProfilController ctrl;
  const _CarteParametres({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.blanc,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2))
        ],
      ),
      child: Column(
        children: [
          _LigneParametre(
            icon: Icons.manage_accounts_outlined,
            label: 'Account Settings',
            onTap: () => Get.toNamed('/modifier-profil'),
          ),
          Divider(height: 1, color: AppColors.bordure, indent: 56),
          _LigneParametre(
            icon: Icons.notifications_none_outlined,
            label: 'Notification Preferences',
            onTap: () => Get.toNamed('/alertes-emploi'),
          ),
          Divider(height: 1, color: AppColors.bordure, indent: 56),
          _LigneParametre(
            icon: Icons.lock_outline,
            label: 'Privacy Policy',
            onTap: () {},
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: GestureDetector(
              onTap: ctrl.deconnecter,
              child: const Text('Log Out',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.erreur)),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _LigneParametre extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _LigneParametre(
      {required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.texteDoux, size: 22),
      title: Text(label,
          style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.texte)),
      trailing: const Icon(Icons.chevron_right,
          color: AppColors.texteLight, size: 20),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
    );
  }
}
