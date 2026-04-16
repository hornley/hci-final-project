import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class MyBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTabChange;
  final List<GlobalKey>? navItemKeys;

  const MyBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onTabChange,
    this.navItemKeys,
  });

  GlobalKey? _navItemKey(int index) {
    if (navItemKeys == null || index >= navItemKeys!.length) {
      return null;
    }
    return navItemKeys![index];
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isCompact = width < 390;

    return SafeArea(
      top: false,
      minimum: const EdgeInsets.fromLTRB(12, 0, 12, 10),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(40),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isCompact ? 4 : 8,
            vertical: isCompact ? 6 : 8,
          ),
          child: GNav(
            gap: isCompact ? 2 : 6,
            iconSize: isCompact ? 20 : 24,
            activeColor: Theme.of(context).colorScheme.onPrimary,
            color: Theme.of(
              context,
            ).colorScheme.onPrimary.withValues(alpha: 0.7),
            tabBackgroundColor: Theme.of(
              context,
            ).colorScheme.onPrimary.withValues(alpha: 0.28),
            padding: EdgeInsets.symmetric(
              horizontal: isCompact ? 10 : 16,
              vertical: isCompact ? 10 : 12,
            ),
            tabs: [
              GButton(
                key: _navItemKey(0),
                icon: Icons.home_rounded,
                text: isCompact ? '' : 'Home',
                onPressed: () => onTabChange(0),
              ),
              GButton(
                key: _navItemKey(1),
                icon: Icons.show_chart_rounded,
                text: isCompact ? '' : 'Progress',
                onPressed: () => onTabChange(1),
              ),
              GButton(
                key: _navItemKey(2),
                icon: Icons.menu_book_rounded,
                text: isCompact ? '' : 'Subjects',
                onPressed: () => onTabChange(2),
              ),
              GButton(
                key: _navItemKey(3),
                icon: Icons.task_alt_rounded,
                text: isCompact ? '' : 'Quests',
                onPressed: () => onTabChange(3),
              ),
              GButton(
                key: _navItemKey(4),
                icon: Icons.person_rounded,
                text: isCompact ? '' : 'Profile',
                onPressed: () => onTabChange(4),
              ),
            ],
            selectedIndex: selectedIndex,
            onTabChange: onTabChange,
          ),
        ),
      ),
    );
  }
}
