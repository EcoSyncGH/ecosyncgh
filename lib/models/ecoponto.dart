class Ecoponto {
  final int id;
  final String nome;
  final String endereco;
  final List<String> materiais;
  final String horario;
  final String? imagem;
  final String? placeId;
  double? latitude;
  double? longitude;

  Ecoponto({
    required this.id,
    required this.nome,
    required this.endereco,
    required this.materiais,
    required this.horario,
    this.imagem,
    this.placeId,
    this.latitude,
    this.longitude,
  });

  factory Ecoponto.fromJson(Map<String, dynamic> json) {
    return Ecoponto(
      id: json['id'],
      nome: json['nome'],
      endereco: json['endereco'],
      materiais: List<String>.from(json['materiais']),
      horario: json['horario'],
      imagem: json['imagem'],
      placeId: json['place_id'],
      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
    );
  }
}
