import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ManualControlsPage extends StatefulWidget {
  const ManualControlsPage({super.key});

  @override
  State<ManualControlsPage> createState() => _ManualControlsPageState();
}

class _ManualControlsPageState extends State<ManualControlsPage> {
  @override
  Widget build(BuildContext context) {
    // Define the target location (latitude and longitude)
    const LatLng targetLocation = LatLng(
      10.503055391390058,
      124.02984872550603,
    ); // Cebu Technological University - Danao Campus

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Manual Controls',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        automaticallyImplyLeading: false,
      ),
      body: GoogleMap(
        initialCameraPosition: const CameraPosition(
          target: targetLocation,
          zoom: 16.0, // Zoom level
        ),
        markers: {
          Marker(
            markerId: const MarkerId('targetLocation'),
            position: targetLocation,
            infoWindow: const InfoWindow(
              title: 'Cebu Technological University - Danao Campus',
              snippet: 'Cebu Technological University - Danao Campus',
            ),
          ),
        },
      ),
    );
  }
}
