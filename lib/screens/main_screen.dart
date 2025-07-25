import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import 'home_screen.dart';
import 'saved_screen.dart';
import 'ecoponto_map_screen.dart';
import '../models/ecoponto.dart';
import '../services/ecoponto_service.dart';
import '../providers/favorites_provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  late Future<List<Ecoponto>> _ecopontosFuture;

  @override
  void initState() {
    super.initState();
    _ecopontosFuture = _loadEcopontosAndFavorites();
  }

  Future<List<Ecoponto>> _loadEcopontosAndFavorites() async {
    // 1. Busca todos os ecopontos
    final ecopontos = await EcopontoService.fetchEcopontos();

    // 2. Após obter a lista, carrega os favoritos salvos no Firebase
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final favoritesProvider = Provider.of<FavoritesProvider>(context, listen: false);
      await favoritesProvider.loadFavoritesFromFirestore(ecopontos);
    }

    return ecopontos;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Ecoponto>>(
      future: _ecopontosFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text('Erro: ${snapshot.error}')),
          );
        } else if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: Text('Nenhum ecoponto encontrado.')),
          );
        }

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
                child: const Center(child: Text("Configurações")),
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
      },
    );
  }
}
