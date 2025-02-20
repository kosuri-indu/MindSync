import 'package:flutter/material.dart';
import 'home_page.dart';
import 'explore_page.dart';
import 'sleep_page.dart';
import 'insights_page.dart';
import 'account_page.dart';

class MainPage extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomePage(),
    ExplorePage(),
    SleepPage(),
    InsightsPage(),
    AccountPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: Container(
        height: 70, // Increase the height of the navigation bar
        child: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(
                _selectedIndex == 0 ? Icons.home : Icons.home_outlined,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                _selectedIndex == 1 ? Icons.explore : Icons.explore_outlined,
              ),
              label: 'Explore',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                _selectedIndex == 2 ? Icons.bedtime : Icons.bedtime_outlined,
              ),
              label: 'Sleep',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                _selectedIndex == 3 ? Icons.insights : Icons.insights_outlined,
              ),
              label: 'Insights',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                _selectedIndex == 4
                    ? Icons.account_circle
                    : Icons.account_circle_outlined,
              ),
              label: 'Account',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Color(0xFF9EB567),
          unselectedItemColor: Colors.grey,
          backgroundColor: Colors.white,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,
          iconSize: 25,
          selectedFontSize: 12,
          unselectedFontSize: 12,
        ),
      ),
    );
  }
}
