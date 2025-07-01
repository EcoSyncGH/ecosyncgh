import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/ecoponto.dart';

class EcopontoService {
  static const String apiUrl = 'https://ecosync-app.web.app/ecopontos.json';

  static Future<List<Ecoponto>> fetchEcopontos() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((e) => Ecoponto.fromJson(e)).toList();
    } else {
      throw Exception('Erro ao carregar ecopontos');
    }
  }
}
