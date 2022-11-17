import 'package:flutter/material.dart';

class NavBar extends StatelessWidget {
  const NavBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          backgroundColor: Colors.blue,
          label: 'Home',
        ),
        BottomNavigationBarItem(
            icon: Icon(Icons.search),
            backgroundColor: Colors.blue,
            label: 'Search'
        ),
        BottomNavigationBarItem(
            icon: Icon(Icons.camera),
            backgroundColor: Colors.blue,
            label: 'Camera'
        ),
        BottomNavigationBarItem(
            icon: Icon(Icons.person),
            backgroundColor: Colors.blue,
            label: 'Profile'
        ),
      ],
    );
  }
}