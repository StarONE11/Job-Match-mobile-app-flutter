import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextes {
  static const TextStyle h1 = TextStyle(
    fontSize: 26, fontWeight: FontWeight.w800, color: AppColors.texte, letterSpacing: -0.5,
  );
  static const TextStyle h2 = TextStyle(
    fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.texte, letterSpacing: -0.3,
  );
  static const TextStyle h3 = TextStyle(
    fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.texte,
  );
  static const TextStyle titreCarte = TextStyle(
    fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.texte,
  );
  static const TextStyle sousTitre = TextStyle(
    fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.texteDoux,
  );
  static const TextStyle corps = TextStyle(
    fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.texteDoux, height: 1.6,
  );
  static const TextStyle badge = TextStyle(
    fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.2,
  );
  static const TextStyle bouton = TextStyle(
    fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.blanc, letterSpacing: 0.3,
  );
  static const TextStyle caption = TextStyle(
    fontSize: 11, fontWeight: FontWeight.w500, color: AppColors.texteLight, letterSpacing: 0.5,
  );
}
