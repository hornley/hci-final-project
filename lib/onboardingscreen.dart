import 'package:flutter/material.dart';
import 'package:hci_final_project/login_wrapper.dart';
import 'homepage.dart';

// ==========================================
// 1. DATA (THE CONTENT OF YOUR SCREENS)
// ==========================================
class OnboardingContent {
  String title;
  String description;
  IconData icon;

  OnboardingContent({
    required this.title,
    required this.description,
    required this.icon,
  });
}

// 📝 EDIT TEXT AND ICONS HERE:
// Change the titles, descriptions, and icons to match your specific app idea.
List<OnboardingContent> contents = [
  OnboardingContent(
    title: 'Explore Multiple Subjects',
    description:
        'Go beyond basic math. Master Linear Algebra, Integral Calculus, Physics, and Chemistry all in one place.',
    icon: Icons.search_rounded,
  ),
  OnboardingContent(
    title: 'Challenge Your Skills',
    description:
        'Test your knowledge with curated quizzes tailored to your skill level, from Easy to Hard.',
    icon: Icons.people_alt_rounded,
  ),
  OnboardingContent(
    title: 'Earn Epic Badges',
    description:
        'Turn studying into a game. Unlock unique achievements like "Integration Specialist" as you conquer complex topics.',
    icon:
        Icons.rocket_launch_rounded, // Try changing this to Icons.check_circle
  ),
  OnboardingContent(
    title: 'Track Your Growth',
    description:
        'Monitor your quiz scores, see your completion rates, and watch your mastery grow over time.',
    icon:
        Icons.rocket_launch_rounded, // Try changing this to Icons.check_circle
  ),
  OnboardingContent(
    title: 'Study Your Way',
    description:
        'Create an account to save your milestones across devices, or dive right in as a guest to start learning immediately.',
    icon:
        Icons.rocket_launch_rounded, // Try changing this to Icons.check_circle
  ),
];

// ==========================================
// 2. THE SCREEN UI & BEHAVIOR
// ==========================================
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  // This variable remembers which page the user is currently looking at (0, 1, or 2).
  int currentIndex = 0;
  late PageController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // HCI Principle: System Feedback.
  // We build little animated dots to show the user exactly where they are.
  Widget buildDot(int index, BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      height: 10,
      // If this dot matches the current screen, make it wider!
      width: currentIndex == index ? 25 : 10,
      margin: const EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        // 🎨 EDIT DOT COLORS HERE:
        color: currentIndex == index
            ? Theme.of(context)
                  .primaryColor // Color of the active dot
            : Colors.grey.shade300, // Color of the inactive dots
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Scaffold provides the blank canvas for our screen.
    return Scaffold(
      // 🎨 EDIT BACKGROUND COLOR HERE:
      // Change Colors.white to Colors.black, Colors.blue.shade50, etc.
      backgroundColor: Color(0xFFBFC7D1),

      // SafeArea keeps our design from hiding behind the phone's camera notch.
      body: SafeArea(
        child: Column(
          children: [
            // The PageView lets the user swipe horizontally.
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: contents.length,
                onPageChanged: (int index) {
                  // When the user swipes, update our currentIndex variable.
                  setState(() {
                    currentIndex = index;
                  });
                },
                itemBuilder: (_, i) {
                  return Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // 🎨 EDIT ICON APPEARANCE HERE:
                        Icon(
                          contents[i].icon,
                          size: 150, // Change how big the icon is
                          color: Theme.of(context).primaryColor,
                        ),
                        const SizedBox(height: 40), // Adds empty space
                        // 🎨 EDIT TITLE TEXT APPEARANCE HERE:
                        Text(
                          contents[i].title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            // You can add color: Colors.black, here!
                          ),
                        ),
                        const SizedBox(height: 20),

                        // 🎨 EDIT DESCRIPTION TEXT APPEARANCE HERE:
                        Text(
                          contents[i].description,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors
                                .grey, // Changes the description text color
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // ==========================================
            // 3. BOTTOM BUTTONS (SKIP, DOTS, NEXT)
            // ==========================================
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // HCI Principle: User Control. Let the user skip if they want to.
                  TextButton(
                    onPressed: () {
                      _controller.jumpToPage(contents.length - 1);
                    },
                    // 🎨 EDIT SKIP BUTTON TEXT COLOR HERE:
                    child: const Text(
                      "SKIP",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),

                  // Shows the dots we built earlier
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      contents.length,
                      (index) => buildDot(index, context),
                    ),
                  ),

                  // The main Call to Action button (NEXT / START)
                  ElevatedButton(
                    onPressed: () {
                      if (currentIndex == contents.length - 1) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                        );
                      } else {
                        // Animate to the next screen smoothly
                        _controller.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                    // 🎨 EDIT NEXT/START BUTTON COLOR HERE:
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(
                        context,
                      ).primaryColor, // Button background color
                      foregroundColor: Colors.white, // Button text color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          20,
                        ), // Makes the button rounded
                      ),
                    ),
                    child: Text(
                      currentIndex == contents.length - 1 ? "START" : "NEXT",
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
