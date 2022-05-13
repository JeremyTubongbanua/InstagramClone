import 'package:at_app_flutter/at_app_flutter.dart';
import 'package:flutter/material.dart';

import './screens/onboarding_screen.dart';

void main() async {
  try {
    await AtEnv.load();
  } catch (err) {
    print("AtEnv error: $err");
  }
  final ThemeData themeData = ThemeData(
    // Define the default brightness and colors.
    brightness: Brightness.light,
    backgroundColor: const Color.fromRGBO(250, 250, 250, 1),
  );
  final MaterialApp app = MaterialApp(
    theme: themeData,
    routes: {
      OnboardingScreen.id: (ctx) => const OnboardingScreen(),
    },
  );

  runApp(app);
}
