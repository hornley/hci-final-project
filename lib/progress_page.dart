import 'package:flutter/material.dart';

class ProgressPage extends StatelessWidget {
  const ProgressPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFBFC7D1),

      appBar: AppBar(
        title: const Text("Progress"),
        centerTitle: true,
        backgroundColor: const Color(0xFF395886),
        foregroundColor: Colors.white,
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            const SizedBox(height: 10),

            _buildCard("Linear Algebra", "7/15", "46.67%"),
            _buildCard("Integral Calculus", "3/20", "15%"),
            _buildCard("Physics", "1/20", "5%"),
            _buildCard("Chemistry", "3/25", "12%"),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                // TODO: reset logic
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6F8FB3),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
              ),
              child: const Text("Reset Progress"),
            ),
          ],
        ),
      ),

      // Bottom Navigation (same style as your HomeScreen)
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF395886),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        currentIndex: 1,

        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: "Subjects"),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_box),
            label: "Progress",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }

  Widget _buildCard(String title, String quizzes, String progress) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFFD3D9E2),
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 5, offset: Offset(2, 3)),
        ],
      ),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Text("Quizzes Taken: $quizzes"),
          Text("Progress: $progress"),
        ],
      ),
    );
  }
}
