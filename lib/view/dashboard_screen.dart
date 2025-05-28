import 'package:flutter/material.dart';
import 'package:venure/view/home_screen.dart';
import 'package:venure/view/profile_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    Homescreen(),
    Center(child: Text("chat")),
    Center(child: Text('Favourite')),
    ProfileScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },

        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.message_outlined),
            label: "Chat",
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_border),
            label: "Favourite",
          ),
          NavigationDestination(
            icon: Icon(Icons.people_outline),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
