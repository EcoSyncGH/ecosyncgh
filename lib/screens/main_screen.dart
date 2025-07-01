import 'package:flutter/material.dart';
import 'package:ecosyncgh/services/ecoponto_service.dart';
import 'package:ecosyncgh/models/ecoponto.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  int _selectedChipIndex = 0;

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  final List<String> _chipLabels = [
    "Todos",
    "Plástico",
    "Metal",
    "Vidro",
    "Papel",
  ];

  List<Ecoponto> _allEcopontos = [];
  List<Ecoponto> _filteredEcopontos = [];

  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadEcopontos();
  }

  Future<void> _loadEcopontos() async {
    try {
      final data = await EcopontoService.fetchEcopontos();
      setState(() {
        _allEcopontos = data;
        _filteredEcopontos = data;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  void _applyFilters() {
    String selectedMaterial = _chipLabels[_selectedChipIndex];

    setState(() {
      _filteredEcopontos = _allEcopontos.where((e) {
        final matchesMaterial = selectedMaterial == "Todos" || e.materiais.contains(selectedMaterial);
        final matchesSearch = _searchQuery.isEmpty || e.nome.toLowerCase().contains(_searchQuery);
        return matchesMaterial && matchesSearch;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFC7DEA6),
      body: SafeArea(
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : _error != null
                ? Center(child: Text('Erro: $_error'))
                : SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Título + barra de pesquisa
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Expanded(
                                flex: 2,
                                child: Text(
                                  "Procure\nEcoPontos",
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'RozhaOne',
                                    color: Color(0xFF678E35),
                                    height: 1,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                flex: 2,
                                child: Container(
                                  height: 45,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: TextField(
                                    controller: _searchController,
                                    onChanged: (value) {
                                      _searchQuery = value.trim().toLowerCase();
                                      _applyFilters();
                                    },
                                    decoration: const InputDecoration(
                                      hintText: "Procure...",
                                      prefixIcon: Icon(Icons.search),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(30),
                                        ),
                                        borderSide: BorderSide.none,
                                      ),
                                      contentPadding: EdgeInsets.symmetric(vertical: 14),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Filtros
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 16, 0, 0),
                          child: SizedBox(
                            height: 40,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: _chipLabels.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(width: 8),
                              itemBuilder: (context, index) {
                                final isSelected = _selectedChipIndex == index;
                                return ChoiceChip(
                                  label: Text(_chipLabels[index]),
                                  selected: isSelected,
                                  onSelected: (_) {
                                    setState(() {
                                      _selectedChipIndex = index;
                                    });
                                    _applyFilters();
                                  },
                                  selectedColor: Colors.white,
                                  backgroundColor: const Color(0xFFC7DEA6),
                                  shape: StadiumBorder(
                                    side: BorderSide(
                                      color: Colors.black.withAlpha(50),
                                    ),
                                  ),
                                  labelStyle: TextStyle(
                                    color: isSelected
                                        ? Colors.black
                                        : Colors.black87,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Carrossel
                        SizedBox(
                          height: 450,
                          child: _filteredEcopontos.isEmpty
                              ? const Center(
                                  child: Text(
                                    'Nenhum ecoponto encontrado.',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                )
                              : ListView.builder(
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                  scrollDirection: Axis.horizontal,
                                  itemCount: _filteredEcopontos.length,
                                  itemBuilder: (context, index) {
                                    final ecoponto = _filteredEcopontos[index];
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
                                                  colors: [
                                                    Colors.transparent,
                                                    Colors.black54,
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            left: 8,
                                            bottom: 28,
                                            right: 8,
                                            child: Text(
                                              ecoponto.nome,
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          Positioned(
                                            left: 8,
                                            bottom: 8,
                                            right: 8,
                                            child: Text(
                                              ecoponto.horario,
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.white70,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
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
