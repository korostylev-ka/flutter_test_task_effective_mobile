import 'package:flutter/material.dart';
import '../resources/strings.dart';
import 'characters_screen.dart';
import 'favourite_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: currentIndex == 0
            ? Text(Strings.homeLabel)
            : Text(Strings.favouriteLabel),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: currentIndex == 0
                ? Icon(Icons.home, color: Colors.blue)
                : Icon(Icons.home),
            label: Strings.homeLabel,
          ),
          BottomNavigationBarItem(
            icon: currentIndex == 1
                ? Icon(Icons.favorite, color: Colors.red)
                : Icon(Icons.favorite),
            label: Strings.favouriteLabel,
          ),
        ],
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
      body: [CharactersScreen(), FavouriteScreen()][currentIndex],
    );
  }
}
