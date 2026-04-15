import 'package:flutter/material.dart';
import 'package:hci_final_project/screens/animated_splash_gate.dart';
import 'package:hci_final_project/theme/app_theme.dart';
import 'local_storage.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  double _textScale = 1.0;

  @override
  void initState() {
    super.initState();
    _loadTextScale(); // ✅ LOAD SAVED VALUE
  }

  void _updateTextScale(double scale) async {
    setState(() {
      _textScale = scale;
    });

    await LocalStorage.setTextScale(scale); // ✅ SAVE VALUE
  }

  Future<void> _loadTextScale() async {
    final savedScale = await LocalStorage.getTextScale();
    if (savedScale != null) {
      setState(() {
        _textScale = savedScale;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeController,
      builder: (context, mode, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: buildAppTheme(),
          darkTheme: buildDarkTheme(),
          themeMode: mode,

          // ✅ GLOBAL TEXT SCALING
          builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(
                context,
              ).copyWith(textScaler: TextScaler.linear(_textScale)),
              child: child!,
            );
          },
          home: AnimatedSplashGate(
            loadStartupState: _loadStartupState,
            onTextScaleChanged: _updateTextScale,
          ),
        );
      },
    );
  }

  Future<Map<String, bool>> _loadStartupState() async {
    final seenOnboarding = await LocalStorage.hasSeenOnboarding();
    final loggedIn = await LocalStorage.isLoggedIn();

    return {'hasSeenOnboarding': seenOnboarding, 'loggedIn': loggedIn};
  }
}
