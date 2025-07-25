import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/ecoponto.dart';
import '../providers/favorites_provider.dart';

class SavedScreen extends StatelessWidget {
  const SavedScreen({super.key});

  Future<void> _openMaps(BuildContext context, Ecoponto ecoponto) async {
    String url;

    if (ecoponto.placeId != null && ecoponto.placeId!.isNotEmpty) {
      url = 'https://www.google.com/maps/search/?api=1&query=Google&query_place_id=${ecoponto.placeId}';
    } else if (ecoponto.latitude != null && ecoponto.longitude != null) {
      url = 'https://www.google.com/maps/search/?api=1&query=${ecoponto.latitude},${ecoponto.longitude}';
    } else {
      final query = Uri.encodeComponent('${ecoponto.nome}, ${ecoponto.endereco}, Fortaleza, Ceará');
      url = 'https://www.google.com/maps/search/?api=1&query=$query';
    }

    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Não foi possível abrir o Maps.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFC7DEA6),
      appBar: AppBar(
        title: const Text(
          "Ecopontos Salvos",
          style: TextStyle(
            fontFamily: 'RozhaOne',
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFFA1BD79),
        centerTitle: true,
      ),
      body: Consumer<FavoritesProvider>(
        builder: (context, favoritesProvider, child) {
          final savedEcopontos = favoritesProvider.favorites;

          if (savedEcopontos.isEmpty) {
            return const Center(
              child: Text(
                "Nenhum ecoponto salvo ainda.",
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          return ListView.builder(
            itemCount: savedEcopontos.length,
            padding: const EdgeInsets.all(12),
            itemBuilder: (context, index) {
              final ecoponto = savedEcopontos[index];

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 3,
                child: Column(
                  children: [
                    ecoponto.imagem != null && ecoponto.imagem!.isNotEmpty
                        ? ClipRRect(
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                            child: Image.network(
                              ecoponto.imagem!,
                              height: 160,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          )
                        : ClipRRect(
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                            child: Image.asset(
                              'assets/images/placeholder.jpg',
                              height: 160,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                    ListTile(
                      title: Text(
                        ecoponto.nome,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(ecoponto.endereco),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline, color: Colors.red),
                        onPressed: () {
                          favoritesProvider.toggleFavorite(ecoponto);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${ecoponto.nome} removido dos favoritos.'),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                      ),
                      onTap: () => _openMaps(context, ecoponto),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 16, bottom: 12),
                      child: Row(
                        children: [
                          const Icon(Icons.access_time, size: 18),
                          const SizedBox(width: 4),
                          Text(ecoponto.horario),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
