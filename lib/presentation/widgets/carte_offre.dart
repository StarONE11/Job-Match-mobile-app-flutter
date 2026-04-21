import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../domain/entities/offre_emploi.dart';

class CarteOffre extends StatelessWidget {
  final OffreEmploi offre;
  final bool        estFavori;
  final VoidCallback onTap;
  final VoidCallback onToggleFavori;
  final double?     scoreMatch; // 0.0 - 1.0

  const CarteOffre({
    super.key,
    required this.offre,
    required this.estFavori,
    required this.onTap,
    required this.onToggleFavori,
    this.scoreMatch,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.blanc,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 10, offset: const Offset(0, 2))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _LogoEntreprise(nom: offre.entreprise),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(offre.titre, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.texte), maxLines: 2, overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 2),
                      Text('${offre.entreprise} · ${offre.villeShort}', style: const TextStyle(fontSize: 13, color: AppColors.texteDoux)),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: onToggleFavori,
                  icon: Icon(estFavori ? Icons.bookmark : Icons.bookmark_border, color: estFavori ? AppColors.primary : AppColors.texteLight, size: 22),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            if (scoreMatch != null) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: scoreMatch!,
                        backgroundColor: AppColors.matchBarBg,
                        valueColor: const AlwaysStoppedAnimation(AppColors.matchBar),
                        minHeight: 5,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text('${(scoreMatch! * 100).round()}% MATCH',
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.matchBar)),
                ],
              ),
            ],
            if (offre.typeContrat != null || offre.salaireRange != null) ...[
              const SizedBox(height: 10),
              Wrap(
                spacing: 6,
                children: [
                  if (offre.typeContrat != null) _Chip(offre.typeContrat!),
                  if (offre.salaireRange != null) _Chip(offre.salaireRange!),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _LogoEntreprise extends StatelessWidget {
  final String nom;
  const _LogoEntreprise({required this.nom});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48, height: 48,
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.bordure),
      ),
      alignment: Alignment.center,
      child: Text(
        nom.isNotEmpty ? nom[0].toUpperCase() : '?',
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.primary),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  const _Chip(this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.fond,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.bordure),
      ),
      child: Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.texteDoux)),
    );
  }
}

// Skeleton loader
class CarteOffreChargement extends StatefulWidget {
  const CarteOffreChargement({super.key});
  @override
  State<CarteOffreChargement> createState() => _CarteOffreChargementState();
}

class _CarteOffreChargementState extends State<CarteOffreChargement> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200))..repeat(reverse: true);
    _anim = Tween(begin: 0.4, end: 1.0).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _anim,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: AppColors.blanc, borderRadius: BorderRadius.circular(16)),
        child: Row(children: [
          Container(width: 48, height: 48, decoration: BoxDecoration(color: AppColors.bordure, borderRadius: BorderRadius.circular(12))),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(height: 14, width: double.infinity, decoration: BoxDecoration(color: AppColors.bordure, borderRadius: BorderRadius.circular(6))),
            const SizedBox(height: 8),
            Container(height: 12, width: 140, decoration: BoxDecoration(color: AppColors.bordure, borderRadius: BorderRadius.circular(6))),
          ])),
        ]),
      ),
    );
  }
}
