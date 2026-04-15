import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:hci_final_project/homepage.dart';
import 'package:hci_final_project/login_wrapper.dart';
import 'package:hci_final_project/onboardingscreen.dart';

class AnimatedSplashGate extends StatefulWidget {
  final Future<Map<String, bool>> Function() loadStartupState;
  final ValueChanged<double> onTextScaleChanged;

  const AnimatedSplashGate({
    super.key,
    required this.loadStartupState,
    required this.onTextScaleChanged,
  });

  @override
  State<AnimatedSplashGate> createState() => _AnimatedSplashGateState();
}

class _AnimatedSplashGateState extends State<AnimatedSplashGate>
    with SingleTickerProviderStateMixin {
  static const Duration _minSplashDuration = Duration(milliseconds: 2300);

  late final AnimationController _controller;
  Map<String, bool>? _startupState;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat();
    _initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _initialize() async {
    final results = await Future.wait<dynamic>([
      widget.loadStartupState(),
      Future<void>.delayed(_minSplashDuration),
    ]);

    if (!mounted) return;
    setState(() {
      _startupState = results.first as Map<String, bool>;
    });
  }

  Widget _resolveNextScreen() {
    final hasSeenOnboarding = _startupState!['hasSeenOnboarding'] ?? false;
    final loggedIn = _startupState!['loggedIn'] ?? false;

    if (!hasSeenOnboarding) {
      return const OnboardingScreen();
    }

    return loggedIn
        ? HomeScreen(onTextScaleChanged: widget.onTextScaleChanged)
        : const LoginScreen();
  }

  @override
  Widget build(BuildContext context) {
    if (_startupState != null) {
      return AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        switchInCurve: Curves.easeOut,
        switchOutCurve: Curves.easeIn,
        transitionBuilder: (child, animation) =>
            FadeTransition(opacity: animation, child: child),
        child: _resolveNextScreen(),
      );
    }

    return Scaffold(
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          final t = _controller.value;
          final pulse = 1 + math.sin(t * 2 * math.pi) * 0.05;
          final haloOpacity = 0.25 + (math.sin(t * 2 * math.pi) + 1) * 0.15;
          final dotIndex = (t * 3).floor() % 3;

          return Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFD5DEEF), Color(0xFFF8FAFF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Positioned(
                  top: -90,
                  right: -70,
                  child: _GlowOrb(
                    size: 220,
                    color: const Color(0xFF6B8EC1).withValues(alpha: 0.16),
                  ),
                ),
                Positioned(
                  bottom: -120,
                  left: -80,
                  child: _GlowOrb(
                    size: 260,
                    color: const Color(0xFF395886).withValues(alpha: 0.12),
                  ),
                ),
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 170,
                        height: 170,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: haloOpacity),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x44395886),
                              blurRadius: 26,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Transform.scale(
                          scale: pulse,
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Image.asset('assets/splash.png'),
                          ),
                        ),
                      ),
                      const SizedBox(height: 26),
                      Text(
                        'Math Quest',
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(
                              color: const Color(0xFF20334F),
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.2,
                            ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Loading your learning journey',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: const Color(0xFF405B84),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(3, (i) {
                          final active = i == dotIndex;
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 220),
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            height: 8,
                            width: active ? 26 : 8,
                            decoration: BoxDecoration(
                              color: active
                                  ? const Color(0xFF395886)
                                  : const Color(0xFF9EB2CF),
                              borderRadius: BorderRadius.circular(20),
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _GlowOrb extends StatelessWidget {
  final double size;
  final Color color;

  const _GlowOrb({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      ),
    );
  }
}
