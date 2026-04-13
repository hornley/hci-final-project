import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemeController extends ValueNotifier<ThemeMode> {
  ThemeController() : super(ThemeMode.light);

  bool get isDark => value == ThemeMode.dark;

  void toggle() {
    value = isDark ? ThemeMode.light : ThemeMode.dark;
  }
}

final ThemeController themeController = ThemeController();

@immutable
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.success,
    required this.warning,
    required this.danger,
    required this.action,
    required this.actionHover,
    required this.link,
  });

  final Color success;
  final Color warning;
  final Color danger;
  final Color action;
  final Color actionHover;
  final Color link;

  @override
  AppColors copyWith({
    Color? success,
    Color? warning,
    Color? danger,
    Color? action,
    Color? actionHover,
    Color? link,
  }) {
    return AppColors(
      success: success ?? this.success,
      warning: warning ?? this.warning,
      danger: danger ?? this.danger,
      action: action ?? this.action,
      actionHover: actionHover ?? this.actionHover,
      link: link ?? this.link,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    return AppColors(
      success: Color.lerp(success, other.success, t) ?? success,
      warning: Color.lerp(warning, other.warning, t) ?? warning,
      danger: Color.lerp(danger, other.danger, t) ?? danger,
      action: Color.lerp(action, other.action, t) ?? action,
      actionHover: Color.lerp(actionHover, other.actionHover, t) ?? actionHover,
      link: Color.lerp(link, other.link, t) ?? link,
    );
  }
}

extension AppThemeContext on BuildContext {
  ColorScheme get scheme => Theme.of(this).colorScheme;
  AppSizes get appSizes => Theme.of(this).extension<AppSizes>()!;
  AppColors get appColors => Theme.of(this).extension<AppColors>()!;
}

@immutable
class AppSizes extends ThemeExtension<AppSizes> {
  const AppSizes({required this.appBarHeight, required this.bottomNavHeight});

  final double appBarHeight;
  final double bottomNavHeight;

  @override
  AppSizes copyWith({double? appBarHeight, double? bottomNavHeight}) {
    return AppSizes(
      appBarHeight: appBarHeight ?? this.appBarHeight,
      bottomNavHeight: bottomNavHeight ?? this.bottomNavHeight,
    );
  }

  @override
  AppSizes lerp(ThemeExtension<AppSizes>? other, double t) {
    if (other is! AppSizes) return this;
    return AppSizes(
      appBarHeight: _lerpDouble(appBarHeight, other.appBarHeight, t),
      bottomNavHeight: _lerpDouble(bottomNavHeight, other.bottomNavHeight, t),
    );
  }

  static double _lerpDouble(double a, double b, double t) => a + (b - a) * t;
}

ThemeData buildAppTheme() {
  const primary = Color(0xFF395886);
  const surface = Color(0xFFF2F6FC);
  const appSizes = AppSizes(appBarHeight: 66, bottomNavHeight: 72);
  const appColors = AppColors(
    success: Color(0xFF4CAF50),
    warning: Color(0xFFF59E0B),
    danger: Color(0xFFD14B4B),
    action: Color(0xFF3E5C8A),
    actionHover: Color(0xFF2F4A74),
    link: Color(0xFFD14B4B),
  );

  return ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: primary,
      primary: primary,
      surface: surface,
      brightness: Brightness.light,
    ),
    fontFamily: 'Inter',
    textTheme: GoogleFonts.interTextTheme().copyWith(
      // Titles and headings use Poppins
      displayLarge: GoogleFonts.poppins(
        fontSize: 32,
        fontWeight: FontWeight.bold,
      ),
      displayMedium: GoogleFonts.poppins(
        fontSize: 28,
        fontWeight: FontWeight.bold,
      ),
      displaySmall: GoogleFonts.poppins(
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
      headlineLarge: GoogleFonts.poppins(
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
      headlineMedium: GoogleFonts.poppins(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      headlineSmall: GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
      titleLarge: GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
      titleMedium: GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
      titleSmall: GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
      // Body text uses Inter (default)
      bodyLarge: GoogleFonts.inter(fontSize: 16),
      bodyMedium: GoogleFonts.inter(fontSize: 14),
      bodySmall: GoogleFonts.inter(fontSize: 12),
      labelLarge: GoogleFonts.inter(fontSize: 14),
      labelMedium: GoogleFonts.inter(fontSize: 12),
      labelSmall: GoogleFonts.inter(fontSize: 10),
    ),
    scaffoldBackgroundColor: surface,
    appBarTheme: AppBarTheme(
      toolbarHeight: appSizes.appBarHeight,
      backgroundColor: primary,
      foregroundColor: Colors.white,
      titleTextStyle: GoogleFonts.poppins(
        fontSize: 25,
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: primary,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white,
      type: BottomNavigationBarType.fixed,
    ),
    extensions: const [appSizes, appColors],
  );
}

ThemeData buildDarkTheme() {
  const primary = Color(0xFF1F2E46);
  const surface = Color(0xFF131A24);
  const appSizes = AppSizes(appBarHeight: 66, bottomNavHeight: 72);
  const appColors = AppColors(
    success: Color(0xFF66BB6A),
    warning: Color(0xFFFFB74D),
    danger: Color(0xFFE57373),
    action: Color(0xFF4C78B2),
    actionHover: Color(0xFF3B6798),
    link: Color(0xFFFF8A80),
  );
  const darkButtonForeground = Colors.white;
  final darkScheme = ColorScheme.fromSeed(
    seedColor: primary,
    primary: primary,
    surface: surface,
    brightness: Brightness.dark,
  ).copyWith(onPrimary: Colors.white);

  return ThemeData(
    colorScheme: darkScheme,
    fontFamily: 'Inter',
    textTheme: GoogleFonts.interTextTheme(),
    scaffoldBackgroundColor: surface,
    appBarTheme: AppBarTheme(
      toolbarHeight: appSizes.appBarHeight,
      backgroundColor: primary,
      foregroundColor: Colors.white,
      titleTextStyle: GoogleFonts.poppins(
        fontSize: 25,
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: primary,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white,
      type: BottomNavigationBarType.fixed,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: darkButtonForeground,
        iconColor: darkButtonForeground,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: darkButtonForeground,
        iconColor: darkButtonForeground,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: darkButtonForeground,
        iconColor: darkButtonForeground,
        side: const BorderSide(color: darkButtonForeground),
      ),
    ),
    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(foregroundColor: darkButtonForeground),
    ),
    extensions: const [appSizes, appColors],
  );
}

class ThemeToggleButton extends StatelessWidget {
  const ThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeController,
      builder: (context, mode, _) {
        final isDark = mode == ThemeMode.dark;
        final scheme = Theme.of(context).colorScheme;
        return Padding(
          padding: const EdgeInsets.only(right: 20),
          child: Container(
            decoration: BoxDecoration(
              color: scheme.onPrimary.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(
                color: scheme.onPrimary.withValues(alpha: 0.35),
              ),
            ),
            child: Transform.rotate(
              angle: -0.35,
              child: IconButton(
                tooltip: isDark ? 'Light mode' : 'Dark mode',
                onPressed: themeController.toggle,
                icon: Icon(
                  Icons.nightlight_round,
                  color: isDark ? const Color(0xFFFFD54F) : scheme.onPrimary,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
