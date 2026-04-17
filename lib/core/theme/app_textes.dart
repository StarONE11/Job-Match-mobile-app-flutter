import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextes {
  // Grands titres (header)
  static const TextStyle titre = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w800,
    color: AppColors.blanc,
    letterSpacing: -0.3,
  );

  // Titre de carte
  static const TextStyle titreCarte = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: AppColors.texte,
  );

  // Sous-titre
  static const TextStyle sousTitre = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.texteDoux,
  );

  // Corps de texte
  static const TextStyle corps = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.texteDoux,
    height: 1.5,
  );

  // Badge / label
  static const TextStyle badge = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w700,
  );

  // Bouton
  static const TextStyle bouton = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w800,
    color: AppColors.blanc,
  );
}
