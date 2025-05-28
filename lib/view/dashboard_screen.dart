import 'package:flutter/material.dart';
import 'package:venure/view/home_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    Homescreen(),
    Center(child: Text("chat"),),
    Center(child: Text('Favourite'),),
    
  ];
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}