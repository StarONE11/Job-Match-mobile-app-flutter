import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/theme/app_colors.dart';

class AppNavBar extends StatelessWidget {
  final int currentIndex;
  const AppNavBar({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.blanc,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 12, offset: const Offset(0, -2))],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _BoutonNav(icon: Icons.explore_outlined, activeIcon: Icons.explore, label: 'Discover', isActive: currentIndex == 0, onTap: () { if (currentIndex != 0) Get.offAllNamed('/home'); }),
              _BoutonNav(icon: Icons.bookmark_border, activeIcon: Icons.bookmark, label: 'Saved', isActive: currentIndex == 1, onTap: () { if (currentIndex != 1) Get.offAllNamed('/favoris'); }),
              _BoutonNav(icon: Icons.person_outline, activeIcon: Icons.person, label: 'Profile', isActive: currentIndex == 2, onTap: () { if (currentIndex != 2) Get.offAllNamed('/profil'); }),
            ],
          ),
        ),
      ),
    );
  }
}

class _BoutonNav extends StatelessWidget {
  final IconData icon, activeIcon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;
  const _BoutonNav({required this.icon, required this.activeIcon, required this.label, required this.isActive, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Icon(isActive ? activeIcon : icon, color: isActive ? AppColors.primary : AppColors.texteLight, size: 24),
          const SizedBox(height: 3),
          Text(label, style: TextStyle(fontSize: 11, fontWeight: isActive ? FontWeight.w700 : FontWeight.w500, color: isActive ? AppColors.primary : AppColors.texteLight)),
          if (isActive) ...[
            const SizedBox(height: 3),
            Container(width: 5, height: 5, decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle)),
          ],
        ]),
      ),
    );
  }
}
