// =========================================
// MAIN_PAGE.DART
// =========================================
import 'package:flutter/material.dart';
import '../../features/events/presentation/pages/home_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../shared/widgets/custom_bottom_nav.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  // Current tab index
  int _currentIndex = 0;

  // Pages list
  final List<Widget> _pages = [
    const HomePage(), // Home tab
    const ProfilePage(), // Profile tab
  ];

  // Tab change handler
  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // IndexedStack - Sob pages load thake, just hide/show hoy
      // Eta kore page state maintain hoy (scroll position, etc)
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      // Bottom navigation
      bottomNavigationBar: CustomBottomNav(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
    );
  }
}