import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'saved_screen.dart';
import 'ecoponto_map_screen.dart';
// import 'settings_screen.dart'; // pode criar depois se quiser

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Offstage(
            offstage: _selectedIndex != 0,
            child: const HomeScreen(),
          ),
          Offstage(
            offstage: _selectedIndex != 1,
            child: const EcopontoMapScreen(),
          ),
          Offstage(
            offstage: _selectedIndex != 2,
            child: const SavedScreen(),
          ),
          Offstage(
            offstage: _selectedIndex != 3,
            child: const Center(child: Text("Configurações")), // Temporário
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        height: 66,
        backgroundColor: const Color(0xFFA1BD79),
        indicatorColor: Colors.white,
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            label: "Início",
          ),
          NavigationDestination(
            icon: Icon(Icons.map_outlined),
            label: "Mapa",
          ),
          NavigationDestination(
            icon: Icon(Icons.bookmark_border_outlined),
            label: "Salvos",
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            label: "Configurações",
          ),
        ],
      ),
    );
  }
}
