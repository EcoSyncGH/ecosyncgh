import 'package:flutter/material.dart';
import 'package:ecosyncgh/services/favorites_manager.dart';

class SavedScreen extends StatefulWidget {
  const SavedScreen({super.key});

  @override
  State<SavedScreen> createState() => _SavedScreenState();
}

class _SavedScreenState extends State<SavedScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";
  final List<String> _chipLabels = [
    "Baterias",
    "Garrafas de vidro",
    "Eletrônicos",
    "Cartuchos de tinta",
    "Latas de metal",
    "Lâmpadas",
    "Sacos plásticos",
    "Roupas",
    "Garrafas plásticas",
  ];
  Set<int> _selectedChipIndices = {};

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.trim().toLowerCase();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // Filtra favoritos pelo nome e chips
    final filteredFavorites = FavoritesManager.favorites.where((e) {
      final matchesSearch = _searchQuery.isEmpty || e.nome.toLowerCase().contains(_searchQuery);
      if (_selectedChipIndices.isEmpty) return matchesSearch;

      final selectedMaterials = _selectedChipIndices.map((i) => _chipLabels[i]);
      final matchesMaterial = e.materiais.any(selectedMaterials.contains);
      return matchesSearch && matchesMaterial;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFC7DEA6),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título
            const Padding(
              padding: EdgeInsets.only(top: 16),
              child: Center(
                child: Text(
                  "Salvos",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'RozhaOne',
                    color: Color(0xFF678E35),
                  ),
                ),
              ),
            ),
            // Barra de pesquisa
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Container(
                height: 45,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    hintText: "Procure...",
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ),
            // Chips de filtros
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 0, 0),
              child: SizedBox(
                height: 40,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _chipLabels.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final isSelected = _selectedChipIndices.contains(index);
                    return FilterChip(
                      label: Text(_chipLabels[index]),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            _selectedChipIndices.add(index);
                          } else {
                            _selectedChipIndices.remove(index);
                          }
                        });
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
            // Grade de favoritos
            Expanded(
              child: filteredFavorites.isEmpty
                  ? const Center(
                      child: Text(
                        'Nenhum item salvo.',
                        style: TextStyle(fontSize: 16),
                      ),
                    )
                  : GridView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: 1,
                      ),
                      itemCount: filteredFavorites.length,
                      itemBuilder: (context, index) {
                        final ecoponto = filteredFavorites[index];
                        return GestureDetector(
                          onTap: () {
                            // Remover ao tocar
                            setState(() {
                              FavoritesManager.remove(ecoponto);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('${ecoponto.nome} removido dos favoritos.'),
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: .4),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                (ecoponto.imagem != null && ecoponto.imagem!.isNotEmpty)
                                    ? Image.network(
                                        ecoponto.imagem!,
                                        height: 60,
                                        fit: BoxFit.cover,
                                      )
                                    : const Icon(
                                        Icons.image_not_supported,
                                        size: 48,
                                        color: Colors.black45,
                                      ),
                                const SizedBox(height: 8),
                                Text(
                                  ecoponto.nome,
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                                Text(
                                  ecoponto.horario,
                                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                                ),
                              ],
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
