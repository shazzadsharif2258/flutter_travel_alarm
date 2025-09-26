import 'package:assesment_flutter/features/home/pages/welcome_page.dart';
import 'package:assesment_flutter/features/onboarding/pages/onboarding_page.dart';
import 'package:assesment_flutter/helpers/notifications_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'features/home/pages/home_page.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await NotificationHelper.instance.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final box = GetStorage();
    final onboarded = box.read<bool>('onboarded') ?? false;
    final savedLoc = box.read<String>('location');

    Widget start;
    if (!onboarded) {
      start = const OnboardingPage();
    } else if (savedLoc == null) {
      start = const WelcomePage();
    } else {
      start = const HomePage();
    }

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: start,
    );
  }
}
