import 'package:flutter/material.dart';
import '../components/bottom_menu.dart';
import 'kunjungan_screen.dart';
import 'dashboard_screen.dart';
import 'books_screen.dart';
import 'setting_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const DashboardScreen(),
    const BooksScreen(),
    const KunjunganScreen(),
    const SettingScreen(),
  ];

  void _onItemTapped(int index) {
    print('Tapped index: $index');
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    print('Current page: $_selectedIndex');
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomMenu(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
