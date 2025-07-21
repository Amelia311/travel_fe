import 'package:flutter/material.dart';
import 'trip_screen.dart';
import 'budget_screen.dart';
import 'profile_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    TripScreen(),
    BudgetScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 2,
              offset: const Offset(0, -2),
            ),
          ],
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          child: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            selectedItemColor: Colors.blue[400],
            unselectedItemColor: Colors.grey[400],
            selectedLabelStyle: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.blue[400],
            ),
            unselectedLabelStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            showSelectedLabels: true,
            showUnselectedLabels: true,
            elevation: 0,
            items: [
              BottomNavigationBarItem(
                icon: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _selectedIndex == 0 
                        ? Colors.blue[50] 
                        : Colors.transparent,
                  ),
                  child: Icon(
                    Icons.card_travel,
                    size: 24,
                    color: _selectedIndex == 0 
                        ? Colors.blue[400] 
                        : Colors.grey[400],
                  ),
                ),
                label: 'Trip',
              ),
              BottomNavigationBarItem(
                icon: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _selectedIndex == 1 
                        ? Colors.blue[50] 
                        : Colors.transparent,
                  ),
                  child: Icon(
                    Icons.attach_money,
                    size: 24,
                    color: _selectedIndex == 1 
                        ? Colors.blue[400] 
                        : Colors.grey[400],
                  ),
                ),
                label: 'Budget',
              ),
              BottomNavigationBarItem(
                icon: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _selectedIndex == 2 
                        ? Colors.blue[50] 
                        : Colors.transparent,
                  ),
                  child: Icon(
                    Icons.person,
                    size: 24,
                    color: _selectedIndex == 2 
                        ? Colors.blue[400] 
                        : Colors.grey[400],
                  ),
                ),
                label: 'Profil',
              ),
            ],
          ),
        ),
      ),
    );
  }
}