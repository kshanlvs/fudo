import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:fudo/src/core/router/route_location.dart'; // Update this with your actual route location file

class RoundedBottomNavBar extends StatefulWidget {
  const RoundedBottomNavBar({super.key});

  @override
  _RoundedBottomNavBarState createState() => _RoundedBottomNavBarState();
}

class _RoundedBottomNavBarState extends State<RoundedBottomNavBar> {
  int _currentIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

    switch (index) {
      case 0:
        context.go(RouteLocation.home);
        break;
      case 1:
        context.go(RouteLocation.search);
        break;
      case 2:
        context.go(RouteLocation.orders);
        break;
      case 3:
        context.go(RouteLocation.profile);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            spreadRadius: 1,
            blurRadius: 10,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: BottomNavigationBar(
          unselectedIconTheme: const IconThemeData(color: Colors.grey),
          selectedIconTheme: const IconThemeData(color: Colors.black),
          unselectedLabelStyle: const TextStyle(color: Colors.grey),
          selectedLabelStyle: const TextStyle(color: Colors.black),
          currentIndex: _currentIndex,
          onTap: _onItemTapped, // Handle navigation
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart),
              label: 'Orders',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
          unselectedItemColor: Colors.black,
          backgroundColor: Colors.white,
          type: BottomNavigationBarType.fixed,
        ),
      ),
    );
  }
}
