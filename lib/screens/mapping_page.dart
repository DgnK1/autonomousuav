import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MappingPage extends StatefulWidget {
  const MappingPage({super.key});

  @override
  State<MappingPage> createState() => _MappingPageState();
}

class _MappingPageState extends State<MappingPage> {
  GoogleMapController? _mapController;
  final List<LatLng> _points = [];

  void _onMapTap(LatLng position) {
    if (_points.length >= 4) return;
    setState(() {
      _points.add(position);
    });

    if (_points.length == 4) {
      Future.delayed(const Duration(milliseconds: 500), () {
        Navigator.pop(context, _points);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Define Mapping Area"),
        backgroundColor: Colors.black,
      ),
      body: GoogleMap(
        onMapCreated: (controller) => _mapController = controller,
        initialCameraPosition: const CameraPosition(
          target: LatLng(37.42796133580664, -122.085749655962),
          zoom: 16,
        ),
        mapType: MapType.hybrid,
        markers: _points
            .asMap()
            .entries
            .map(
              (e) => Marker(
                markerId: MarkerId('point${e.key}'),
                position: e.value,
                infoWindow: InfoWindow(title: 'Point ${e.key + 1}'),
              ),
            )
            .toSet(),
        onTap: _onMapTap,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
      ),
      floatingActionButton: _points.isNotEmpty
          ? FloatingActionButton.extended(
              backgroundColor: Colors.redAccent,
              icon: const Icon(Icons.refresh),
              label: const Text("Reset"),
              onPressed: () => setState(() => _points.clear()),
            )
          : null,
    );
  }
}
