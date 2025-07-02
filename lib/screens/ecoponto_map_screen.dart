import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ecosyncgh/models/ecoponto.dart';
import 'package:ecosyncgh/services/ecoponto_service.dart';
import 'package:geocoding/geocoding.dart';


class EcopontoMapScreen extends StatefulWidget {
  const EcopontoMapScreen({super.key});

  @override
  State<EcopontoMapScreen> createState() => _EcopontoMapScreenState();
}

class _EcopontoMapScreenState extends State<EcopontoMapScreen> {
  late GoogleMapController _mapController;
  final Set<Marker> _markers = {};
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadEcopontos();
  }

  Future<void> _geocodeEcoponto(Ecoponto ecoponto) async {
  try {
    final enderecoCompleto = "${ecoponto.endereco}, Fortaleza, Ceará, Brasil";
    List<Location> locations = await locationFromAddress(enderecoCompleto);

    if (locations.isNotEmpty) {
      ecoponto.latitude = locations.first.latitude;
      ecoponto.longitude = locations.first.longitude;
    } else {
      print("Nenhuma localização encontrada para ${ecoponto.nome}");
    }
  } catch (e) {
    debugPrint("Erro ao geocodificar: $e");
  }
}



  Future<void> _loadEcopontos() async {
  try {
    final data = await EcopontoService.fetchEcopontos();
    // Geocodificar cada ecoponto que não tenha lat/lng
    for (var e in data) {
      if (e.latitude == null || e.longitude == null) {
        await _geocodeEcoponto(e);
      }
    }

    setState(() {
      _markers.clear();
      for (var e in data) {
        if (e.latitude != null && e.longitude != null) {
          _markers.add(
            Marker(
              markerId: MarkerId(e.id.toString()),
              position: LatLng(e.latitude!, e.longitude!),
              infoWindow: InfoWindow(
                title: e.nome,
                snippet: e.endereco,
              ),
            ),
          );
        }
      }
      _loading = false;
    });
  } catch (e) {
    setState(() {
      _error = e.toString();
      _loading = false;
    });
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mapa de Ecopontos'),
        backgroundColor: const Color(0xFFA1BD79),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text('Erro: $_error'))
              : GoogleMap(
                  initialCameraPosition: const CameraPosition(
                    target: LatLng(-3.7319, -38.5267), // Fortaleza
                    zoom: 12,
                  ),
                  markers: _markers,
                  onMapCreated: (controller) {
                    _mapController = controller;
                  },
                ),
    );
  }
}
