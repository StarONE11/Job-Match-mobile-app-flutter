import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_textes.dart';
import '../../domain/entities/offre_emploi.dart';

// ─── WIDGET CARTE D'OFFRE ─────────────────────────────────────────────────────
// Widget réutilisable affiché dans la liste et ailleurs.
// Reçoit une OffreEmploi et un callback onTap.

class CarteOffre extends StatelessWidget {
  final OffreEmploi offre;
  final VoidCallback? onTap;
  final Widget? trailing;

  const CarteOffre({
    super.key,
    required this.offre,
    this.onTap,
    this.trailing,
  });

  // Couleur de l'avatar selon l'entreprise
  Color _couleurAvatar() {
    final couleurs = [
      AppColors.bleu,
      AppColors.orange,
      const Color(0xFF00796B),
      const Color(0xFF6A1B9A),
      const Color(0xFF558B2F),
    ];
    return couleurs[offre.entreprise.length % couleurs.length];
  }

  // Initiales de l'entreprise (ex: "Orange Togo" → "OT")
  String _initiales() {
    final mots = offre.entreprise.trim().split(' ');
    if (mots.length >= 2) return '${mots[0][0]}${mots[1][0]}'.toUpperCase();
    if (offre.entreprise.length >= 2) return offre.entreprise.substring(0, 2).toUpperCase();
    return offre.entreprise.toUpperCase();
  }

  // Formate la date en texte lisible
  String _tempsEcoule() {
    final diff = DateTime.now().difference(offre.datePublication);
    if (diff.inMinutes < 60) return 'Il y a ${diff.inMinutes} min';
    if (diff.inHours < 24)   return 'Il y a ${diff.inHours}h';
    if (diff.inDays == 1)    return 'Hier';
    if (diff.inDays < 7)     return 'Il y a ${diff.inDays}j';
    return 'Il y a ${(diff.inDays / 7).round()} sem.';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.blanc,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.bordure),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ligne du haut : Avatar + Entreprise + Menu
            Row(
              children: [
                // Avatar avec initiales
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: _couleurAvatar(),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      _initiales(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),

                // Nom entreprise + Localisation
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(offre.entreprise,
                          style: AppTextes.titreCarte.copyWith(fontSize: 12)),
                      Text(offre.villeShort,
                          style: AppTextes.sousTitre.copyWith(fontSize: 10)),
                    ],
                  ),
                ),

                // Badge NOUVEAU ou trailing widget
                if (trailing != null)
                  trailing!
                else if (offre.estNouvelle)
                  _BadgeStatut(
                    texte: 'NOUVEAU',
                    couleur: AppColors.orange,
                    fond: AppColors.orangeClair,
                  ),
              ],
            ),

            const SizedBox(height: 8),

            // Titre du poste
            Text(
              offre.titre,
              style: AppTextes.titreCarte,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 8),

            // Ligne du bas : Type contrat + Temps écoulé
            Row(
              children: [
                if (offre.typeContrat != null)
                  _BadgeStatut(
                    texte: offre.typeContrat!,
                    couleur: AppColors.bleu,
                    fond: AppColors.bleuFond,
                  ),
                const Spacer(),
                Text(_tempsEcoule(), style: AppTextes.corps.copyWith(fontSize: 10)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─── BADGE DE STATUT ─────────────────────────────────────────────────────────
class _BadgeStatut extends StatelessWidget {
  final String texte;
  final Color couleur;
  final Color fond;

  const _BadgeStatut({
    required this.texte,
    required this.couleur,
    required this.fond,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: fond,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        texte,
        style: AppTextes.badge.copyWith(color: couleur),
      ),
    );
  }
}

// ─── SKELETON DE CHARGEMENT ───────────────────────────────────────────────────
// Affiché pendant que les données se chargent (à la place de CircularProgressIndicator)
class CarteOffreChargement extends StatefulWidget {
  const CarteOffreChargement({super.key});

  @override
  State<CarteOffreChargement> createState() => _CarteOffreChargementState();
}

class _CarteOffreChargementState extends State<CarteOffreChargement>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Widget _boite(double w, double h) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) => Container(
        width: w,
        height: h,
        decoration: BoxDecoration(
          color: Color.lerp(
            const Color(0xFFE8ECF4),
            const Color(0xFFF4F6FB),
            _anim.value,
          ),
          borderRadius: BorderRadius.circular(6),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.blanc,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.bordure),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            _boite(38, 38),
            const SizedBox(width: 10),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              _boite(100, 12),
              const SizedBox(height: 5),
              _boite(70, 10),
            ]),
          ]),
          const SizedBox(height: 10),
          _boite(double.infinity, 14),
          const SizedBox(height: 5),
          _boite(180, 14),
          const SizedBox(height: 10),
          _boite(50, 22),
        ],
      ),
    );
  }
}
