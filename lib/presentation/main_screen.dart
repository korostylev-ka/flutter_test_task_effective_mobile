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
  ThemeMode _themeMode = ThemeMode.system;
  late bool _isDarkThemeOnDevice;
  late bool _isDarkThemeApp;

  void _checkAppTheme(BuildContext context) {
    if (MediaQuery.of(context).platformBrightness == Brightness.dark) {
      _isDarkThemeOnDevice = true;
    } else {
      _isDarkThemeOnDevice = false;
    }
    switch (_themeMode) {
      case ThemeMode.system:
        _isDarkThemeApp = _isDarkThemeOnDevice;

      case ThemeMode.light:
        _isDarkThemeApp = false;
      case ThemeMode.dark:
        _isDarkThemeApp = true;
    }
  }

  void _changeTheme() {
    switch (_themeMode) {
      case ThemeMode.system:
        if (_isDarkThemeOnDevice == true) {
          setState(() {
            _themeMode = ThemeMode.light;
          });
        } else {
          setState(() {
            _themeMode = ThemeMode.dark;
          });
        }
        break;
      case ThemeMode.light:
        setState(() {
          _themeMode = ThemeMode.dark;
        });
        break;
      case ThemeMode.dark:
        setState(() {
          _themeMode = ThemeMode.light;
        });
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    _checkAppTheme(context);

    return MaterialApp(
      title: Strings.projectTitle,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      darkTheme: ThemeData.dark(),
      themeMode: _themeMode,
      home: Scaffold(
        appBar: AppBar(
          title: currentIndex == 0
              ? Text(Strings.homeLabel)
              : Text(Strings.favouriteLabel),
          leading: IconButton(
            onPressed: () {
              _changeTheme();
            },
            icon: _isDarkThemeApp
                ? Icon(Icons.light_mode)
                : Icon(Icons.dark_mode),
          ),
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
      ),
    );
  }
}
