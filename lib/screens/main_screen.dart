import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  int _selectedChipIndex = 0;

  final List<String> _chipLabels = [
    "Todos",
    "Plástico",
    "Metal",
    "Vidro",
    "Papel",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFC7DEA6),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Padding único com Row
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Título ocupando metade da largura
                    const Expanded(
                      flex: 2,
                      child: Text(
                        "Procure\nEcoPontos",
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'RozhaOne',
                          color: Color(0xFF678E35),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Barra de busca ocupando metade
                    Expanded(
                      flex: 2,
                      child: Container(
                        height: 45,
                        width: 174,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const TextField(
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.zero,
                            hintText: "Procure...",
                            prefixIcon: Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(30),
                              ),
                              borderSide: BorderSide.none,
                            ),
                            // contentPadding: EdgeInsets.symmetric(vertical: 14),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Padding dos filtros
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 0, 0),
                child: SizedBox(
                  height: 40,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _chipLabels.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final isSelected = _selectedChipIndex == index;
                      return ChoiceChip(
                        label: Text(_chipLabels[index]),
                        selected: isSelected,
                        onSelected: (_) {
                          setState(() {
                            _selectedChipIndex = index;
                          });
                        },
                        selectedColor: Colors.white,
                        backgroundColor: const Color(0xFFC7DEA6),
                        shape: StadiumBorder(
                          side: BorderSide(
                            color: Colors.black.withValues(alpha: .2),
                          ),
                        ),
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.black : Colors.black87,
                        ),
                      );
                    },
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // 🌿 Carrossel lateral de cards
              SizedBox(
                height: 450,
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  scrollDirection: Axis.horizontal,
                  itemCount: 6,
                  itemBuilder: (context, index) {
                    return Container(
                      width: 220,
                      margin: const EdgeInsets.only(right: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        image: const DecorationImage(
                          image: AssetImage('assets/images/placeholder.jpg'),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              height: 60,
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.vertical(
                                  bottom: Radius.circular(16),
                                ),
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [Colors.transparent, Colors.black54],
                                ),
                              ),
                            ),
                          ),
                          const Positioned(
                            left: 8,
                            bottom: 28,
                            child: Text(
                              "Ecoponto",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const Positioned(
                            left: 8,
                            bottom: 8,
                            child: Text(
                              "Atualizado hoje",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white70,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
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
          NavigationDestination(icon: Icon(Icons.home), label: "Início"),
          NavigationDestination(icon: Icon(Icons.map), label: "Mapa"),
          NavigationDestination(icon: Icon(Icons.favorite), label: "Favoritos"),
          NavigationDestination(
            icon: Icon(Icons.settings),
            label: "Configurações",
          ),
        ],
      ),
    );
  }
}
