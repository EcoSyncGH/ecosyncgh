class Ecoponto {
  final int id;
  final String nome;
  final String endereco;
  final List<String> materiais;
  final String horario;

  Ecoponto({
    required this.id,
    required this.nome,
    required this.endereco,
    required this.materiais,
    required this.horario,
  });

  factory Ecoponto.fromJson(Map<String, dynamic> json) {
    return Ecoponto(
      id: json['id'],
      nome: json['nome'],
      endereco: json['endereco'],
      materiais: List<String>.from(json['materiais']),
      horario: json['horario'],
    );
  }
}
