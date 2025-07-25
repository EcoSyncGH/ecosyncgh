import 'package:flutter/material.dart';
import '../models/ecoponto.dart';

class EcopontoCard extends StatelessWidget {
  final Ecoponto ecoponto;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool isSaved;

  const EcopontoCard({
    super.key,
    required this.ecoponto,
    this.onTap,
    this.onLongPress,
    this.isSaved = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: ecoponto.imagem != null
                    ? Image.network(
                        ecoponto.imagem!,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Icon(Icons.image_not_supported, size: 60),
                      )
                    : const Icon(Icons.location_on, size: 60),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ecoponto.nome,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      ecoponto.endereco,
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Horário: ${ecoponto.horario}',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const SizedBox(height: 4),
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: ecoponto.materiais.map((m) => Chip(
                        label: Text(m, style: const TextStyle(fontSize: 10)),
                        backgroundColor: Colors.green.shade100,
                      )).toList(),
                    ),
                  ],
                ),
              ),
              Icon(
                isSaved ? Icons.bookmark : Icons.bookmark_border,
                color: isSaved ? Colors.green : Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
