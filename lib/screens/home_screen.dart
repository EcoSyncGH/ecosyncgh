import 'package:flutter/material.dart';
import 'package:ecosyncgh/services/ecoponto_service.dart';
import 'package:ecosyncgh/models/ecoponto.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';
import 'package:ecosyncgh/providers/favorites_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Set<int> _selectedChipIndices = {0};
  final Set<int> _pressedIndices = {};
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  final List<String> _chipLabels = [
    "Todos",
    "Baterias",
    "Garrafas de vidro",
    "Eletrônicos",
    "Cartuchos de tinta",
    "Latas de metal",
    "Lâmpadas",
    "Sacos de plástico",
    "Roupas",
    "Garrafas de plástico",
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
    if (_selectedChipIndices.contains(0)) {
      setState(() {
        _filteredEcopontos = _allEcopontos.where((e) {
          return _searchQuery.isEmpty ||
              e.nome.toLowerCase().contains(_searchQuery);
        }).toList();
      });
      return;
    }

    final selectedMaterials = _selectedChipIndices.map((i) => _chipLabels[i]);
    setState(() {
      _filteredEcopontos = _allEcopontos.where((e) {
        final matchesMaterial = selectedMaterials.every(e.materiais.contains);
        final matchesSearch =
            _searchQuery.isEmpty || e.nome.toLowerCase().contains(_searchQuery);
        return matchesMaterial && matchesSearch;
      }).toList();
    });
  }

  Future<void> _openMaps(Ecoponto ecoponto) async {
    String url;
    if (ecoponto.placeId != null && ecoponto.placeId!.isNotEmpty) {
      url =
          'https://www.google.com/maps/search/?api=1&query=Google&query_place_id=${ecoponto.placeId}';
    } else if (ecoponto.latitude != null && ecoponto.longitude != null) {
      url =
          'https://www.google.com/maps/search/?api=1&query=${ecoponto.latitude},${ecoponto.longitude}';
    } else {
      final query = Uri.encodeComponent(
        '${ecoponto.nome}, ${ecoponto.endereco}, Fortaleza, Ceará',
      );
      url = 'https://www.google.com/maps/search/?api=1&query=$query';
    }

    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Não foi possível abrir o Maps.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final favoritesProvider = Provider.of<FavoritesProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFC7DEA6),
      body: SafeArea(
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : _error != null
            ? Center(child: Text('Erro: $_error'))
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Topo
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                    child: Row(
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
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Chips de filtro
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 0, 0),
                    child: SizedBox(
                      height: 40,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: _chipLabels.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 8),
                        itemBuilder: (context, index) {
                          final isSelected = _selectedChipIndices.contains(
                            index,
                          );
                          return FilterChip(
                            label: Text(_chipLabels[index]),
                            selected: isSelected,
                            onSelected: (selected) {
                              setState(() {
                                if (index == 0) {
                                  _selectedChipIndices = {0};
                                } else {
                                  _selectedChipIndices.remove(0);
                                  if (selected) {
                                    _selectedChipIndices.add(index);
                                  } else {
                                    _selectedChipIndices.remove(index);
                                    if (_selectedChipIndices.isEmpty) {
                                      _selectedChipIndices = {0};
                                    }
                                  }
                                }
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
                              color: isSelected ? Colors.black : Colors.black87,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Carrossel
                  Expanded(
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
                              final isPressed = _pressedIndices.contains(index);
                              final isFavorite = favoritesProvider.isFavorite(
                                ecoponto,
                              );

                              return GestureDetector(
                                onTap: () => _openMaps(ecoponto),
                                onLongPressStart: (_) {
                                  setState(() {
                                    _pressedIndices.add(index);
                                  });
                                },
                                onLongPressEnd: (_) {
                                  setState(() {
                                    _pressedIndices.remove(index);
                                  });

                                  favoritesProvider.toggleFavorite(ecoponto);

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        isFavorite
                                            ? '${ecoponto.nome} removido dos favoritos.'
                                            : '${ecoponto.nome} adicionado aos favoritos.',
                                      ),
                                      duration: const Duration(seconds: 2),
                                    ),
                                  );
                                },
                                child: AnimatedScale(
                                  duration: const Duration(milliseconds: 150),
                                  scale: isPressed ? 0.95 : 1.0,
                                  curve: Curves.easeInOut,
                                  child: Card(
                                    clipBehavior: Clip.hardEdge,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Stack(
                                      children: [
                                        SizedBox(
                                          width: 300,
                                          height: double.infinity,
                                          child:
                                              ecoponto.imagem != null &&
                                                  ecoponto.imagem!.isNotEmpty
                                              ? Image.network(
                                                  ecoponto.imagem!,
                                                  fit: BoxFit.cover,
                                                  errorBuilder:
                                                      (
                                                        context,
                                                        error,
                                                        stackTrace,
                                                      ) {
                                                        return Image.asset(
                                                          'assets/images/placeholder.jpg',
                                                          fit: BoxFit.cover,
                                                        );
                                                      },
                                                )
                                              : Image.asset(
                                                  'assets/images/placeholder.jpg',
                                                  fit: BoxFit.cover,
                                                ),
                                        ),

                                        Positioned(
                                          bottom: 0,
                                          left: 0,
                                          right: 0,
                                          child: Container(
                                            height: 70,
                                            decoration: const BoxDecoration(
                                              gradient: LinearGradient(
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter,
                                                colors: [
                                                  Colors.transparent,
                                                  Colors.black87,
                                                ],
                                              ),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(
                                                8.0,
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    ecoponto.nome,
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  Text(
                                                    ecoponto.horario,
                                                    style: const TextStyle(
                                                      color: Colors.white70,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
      ),
    );
  }
}
