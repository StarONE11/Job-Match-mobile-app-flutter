import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'core/services/storage_service.dart';
import 'core/theme/app_colors.dart';
import 'presentation/bindings/home_binding.dart';
import 'presentation/bindings/favoris_binding.dart';
import 'presentation/bindings/profil_binding.dart';
import 'presentation/bindings/detail_binding.dart';
import 'presentation/bindings/onboarding_binding.dart';
import 'presentation/pages/splash/splash_page.dart';
import 'presentation/pages/onboarding/onboarding_page.dart';
import 'presentation/pages/home/home_page.dart';
import 'presentation/pages/favoris/favoris_page.dart';
import 'presentation/pages/profil/profil_page.dart';
import 'presentation/pages/profil/modifier_profil_page.dart';
import 'presentation/pages/profil/alertes_emploi_page.dart';
import 'presentation/pages/detail/detail_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
  ));

  // Initialiser StorageService avant tout et l'enregistrer globalement
  final storage = await StorageService.init();
  Get.put<StorageService>(storage, permanent: true);

  runApp(const JobMatchApp());
}

class JobMatchApp extends StatelessWidget {
  const JobMatchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Career Concierge',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.light(primary: AppColors.primary),
        scaffoldBackgroundColor: AppColors.fond,
        fontFamily: 'Roboto',
        appBarTheme: const AppBarTheme(backgroundColor: AppColors.blanc, elevation: 0),
      ),
      initialRoute: '/splash',
      getPages: [
        GetPage(name: '/splash',          page: () => const SplashPage(),                                             transition: Transition.fadeIn),
        GetPage(name: '/onboarding',      page: () => const OnboardingPage(),      binding: OnboardingBinding(),      transition: Transition.fadeIn),
        GetPage(name: '/home',            page: () => const HomePage(),            binding: HomeBinding(),             transition: Transition.fadeIn),
        GetPage(name: '/favoris',         page: () => const FavorisPage(),         binding: FavorisBinding(),          transition: Transition.fadeIn),
        GetPage(name: '/profil',          page: () => const ProfilPage(),          binding: ProfilBinding(),           transition: Transition.fadeIn),
        GetPage(name: '/detail',          page: () => const DetailPage(),          binding: DetailBinding(),           transition: Transition.rightToLeft),
        GetPage(name: '/modifier-profil', page: () => const ModifierProfilPage(),  binding: ProfilBinding(),           transition: Transition.rightToLeft),
        GetPage(name: '/alertes-emploi',  page: () => const AlertesEmploiPage(),   binding: ProfilBinding(),           transition: Transition.rightToLeft),
      ],
    );
  }
}
