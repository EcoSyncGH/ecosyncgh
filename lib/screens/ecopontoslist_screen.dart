import 'package:flutter/material.dart';
import 'package:ecosyncgh/models/ecoponto.dart';
import 'package:ecosyncgh/services/ecoponto_service.dart';

class EcopontoListScreen extends StatefulWidget {
  const EcopontoListScreen({super.key});

  @override
  State<EcopontoListScreen> createState() => _EcopontoListScreenState();
}

class _EcopontoListScreenState extends State<EcopontoListScreen> {
  late Future<List<Ecoponto>> _futureEcopontos;

  @override
  void initState() {
    super.initState();
    _futureEcopontos = EcopontoService.fetchEcopontos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Lista de Ecopontos',
          style: TextStyle(
            fontFamily: 'RozhaOne',
          ),
        ),
        backgroundColor: const Color(0xFFA1BD79),
      ),
      backgroundColor: const Color(0xFFC7DEA6),
      body: FutureBuilder<List<Ecoponto>>(
        future: _futureEcopontos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Erro: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('Nenhum ecoponto encontrado.'),
            );
          }

          final ecopontos = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: ecopontos.length,
            itemBuilder: (context, index) {
              final e = ecopontos[index];
              return Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  title: Text(
                    e.nome,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text(e.endereco),
                      const SizedBox(height: 4),
                      Text(
                        'Horário: ${e.horario}',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    // Aqui no futuro você pode abrir detalhes ou mapa
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
