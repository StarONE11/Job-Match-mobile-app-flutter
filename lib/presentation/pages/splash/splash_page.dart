import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/theme/app_colors.dart';

/// Page de démarrage : vérifie si l'utilisateur est déjà inscrit.
/// Redirige vers /onboarding (1ère fois) ou /home (sinon).
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _anim;
  late Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800));
    _fade = CurvedAnimation(parent: _anim, curve: Curves.easeIn);
    _anim.forward();
    _verifierInscription();
  }

  Future<void> _verifierInscription() async {
    // Délai minimal pour que l'animation soit visible
    await Future.delayed(const Duration(milliseconds: 1500));
    final storage = Get.find<StorageService>();
    if (storage.estInscrit) {
      Get.offAllNamed('/home');
    } else {
      Get.offAllNamed('/onboarding');
    }
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: FadeTransition(
        opacity: _fade,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Icon(Icons.work_outline_rounded,
                    color: Colors.white, size: 44),
              ),
              const SizedBox(height: 20),
              const Text('Career Concierge',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5)),
              const SizedBox(height: 8),
              Text('Trouvez votre emploi idéal',
                  style: TextStyle(
                      color: Colors.white.withOpacity(0.7), fontSize: 14)),
              const SizedBox(height: 48),
              SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white.withOpacity(0.6),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
