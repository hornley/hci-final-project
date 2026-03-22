import 'package:flutter/material.dart';
import 'package:hci_final_project/login_wrapper.dart';
import 'package:hci_final_project/theme/app_theme.dart';
import 'package:hci_final_project/onboardingscreen.dart';
import 'package:hci_final_project/tests/drag_and_drop.dart';
import 'package:hci_final_project/screens/quiz_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      home: const LoginScreen(),
      routes: {
        '/onboarding': (context) => const OnboardingScreen(),
        // '/login': (context) => const LoginWrapper(),
        // '/dragdrop': (context) => const DragAndDropTest(),
      },
    );
  }
}
