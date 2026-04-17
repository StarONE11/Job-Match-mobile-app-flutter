import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'core/theme/app_colors.dart';
import 'presentation/bindings/home_binding.dart';
import 'presentation/bindings/favoris_binding.dart';
import 'presentation/bindings/profil_binding.dart';
import 'presentation/bindings/detail_binding.dart';
import 'presentation/pages/home/home_page.dart';
import 'presentation/pages/favoris/favoris_page.dart';
import 'presentation/pages/profil/profil_page.dart';
import 'presentation/pages/profil/modifier_profil_page.dart';
import 'presentation/pages/profil/alertes_emploi_page.dart';
import 'presentation/pages/detail/detail_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Barre de statut transparente
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  runApp(const JobMatchTogoApp());
}

class JobMatchTogoApp extends StatelessWidget {
  const JobMatchTogoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'JobMatch Togo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.light(primary: AppColors.bleu),
        scaffoldBackgroundColor: AppColors.fond,
        fontFamily: 'Roboto',
      ),

      // Page de départ
      initialRoute: '/home',

      // Toutes les pages de l'app
      getPages: [
        GetPage(
          name: '/home',
          page: () => const HomePage(),
          // Le Binding crée automatiquement le Controller et tout ce dont il a besoin
          binding: HomeBinding(),
          transition: Transition.fadeIn,
        ),
        GetPage(
          name: '/modifier-profil',
          page: () => const ModifierProfilPage(),
          binding: ProfilBinding(),
          transition: Transition.rightToLeft,
        ),
        GetPage(
          name: '/alertes-emploi',
          page: () => const AlertesEmploiPage(),
          binding: ProfilBinding(),
          transition: Transition.rightToLeft,
        ),
        GetPage(
          name: '/detail',
          page: () => const DetailPage(),
          binding: DetailBinding(),
          transition: Transition.fadeIn,
        ),
        GetPage(
          name: '/favoris',
          page: () => const FavorisPage(),
          binding: FavorisBinding(),
          transition: Transition.fadeIn,
        ),
        GetPage(
          name: '/profil',
          page: () => const ProfilPage(),
          binding: ProfilBinding(),
          transition: Transition.fadeIn,
        ),
      ],
    );
  }
}
