import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'doctors_screen.dart';
import 'appointments_screen.dart';
import 'services_screen.dart';
import 'profile_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const DoctorsScreen(),
    const AppointmentsScreen(),
    const ServicesScreen(),
    const ProfileScreen(),
  ];

  final List<String> _titles = [
    'Главная',
    'Врачи',
    'Записи',
    'Услуги',
    'Профиль',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Главная',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Врачи',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Записи',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.medical_services),
            label: 'Услуги',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Профиль',
          ),
        ],
      ),
    );
  }
}