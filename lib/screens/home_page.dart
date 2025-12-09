import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../utils/responsive_utils.dart'; // If you have a responsive utils class

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Future<FirebaseApp> _fApp = Firebase.initializeApp();

  String realTimeTemp = '0';
  String realTimeMoist = '0';
  String realBatteryLevel = '0';

  GoogleMapController? mapController;
  LatLng dronePosition = const LatLng(37.42796133580664, -122.085749655962);
  final LatLngBounds mappedArea = LatLngBounds(
    southwest: const LatLng(37.426, -122.088),
    northeast: const LatLng(37.429, -122.083),
  );

  @override
  void initState() {
    super.initState();
    // Temperature listener
    DatabaseReference tempRef =
        FirebaseDatabase.instance.ref().child('temperature_data');
    tempRef.onValue.listen((event) {
      if (event.snapshot.exists) {
        setState(() {
          realTimeTemp = event.snapshot.value.toString();
        });
      }
    });

    // Moisture listener
    DatabaseReference moistRef =
        FirebaseDatabase.instance.ref().child('Moisture_data');
    moistRef.onValue.listen((event) {
      if (event.snapshot.exists) {
        setState(() {
          realTimeMoist = event.snapshot.value.toString();
        });
      }
    });

    DatabaseReference batRef =
        FirebaseDatabase.instance.ref().child('battery_level');
    batRef.onValue.listen((event) {
      if (event.snapshot.exists) {
        setState(() {
          realBatteryLevel = event.snapshot.value.toString();
        });
      }
    });
  }

  Widget _statCard({
    required IconData icon,
    required String title,
    required String value,
    Color iconColor = Colors.blueAccent,
    bool isAverage = false,
  }) {
    final responsive = ResponsiveUtils(context);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF3B3B3B) : const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDarkMode ? Colors.white24 : Colors.black12),
      ),
      padding: EdgeInsets.all(responsive.wp(4.5)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: responsive.sp(30)),
              SizedBox(width: responsive.wp(2.5)),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: responsive.sp(14),
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),
          if (isAverage)
            Align(
              alignment: Alignment.center,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: isDarkMode
                      ? Colors.white24
                      : Colors.black.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'REAL-TIME',
                  style: TextStyle(
                    fontSize: responsive.sp(10),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          const SizedBox(height: 6),
          Align(
            alignment: Alignment.center,
            child: Text(
              value,
              style: TextStyle(
                fontSize: responsive.sp(28),
                fontWeight: FontWeight.bold,
                color: iconColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _mapSection() {
    final responsive = ResponsiveUtils(context);

    return SizedBox(
      height: responsive.hp(35),
      child: GoogleMap(
        onMapCreated: (controller) => mapController = controller,
        initialCameraPosition: const CameraPosition(
          target: LatLng(37.42796133580664, -122.085749655962),
          zoom: 16,
        ),
        markers: {
          Marker(
            markerId: const MarkerId('drone'),
            position: dronePosition,
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
          ),
        },
        polygons: {
          Polygon(
            polygonId: const PolygonId('mapped_area'),
            fillColor: Colors.blue.withOpacity(0.2),
            strokeColor: Colors.blueAccent,
            strokeWidth: 2,
            points: [
              mappedArea.southwest,
              LatLng(mappedArea.southwest.latitude, mappedArea.northeast.longitude),
              mappedArea.northeast,
              LatLng(mappedArea.northeast.latitude, mappedArea.southwest.longitude),
            ],
          ),
        },
        zoomControlsEnabled: false,
        myLocationEnabled: false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveUtils(context);

    return Scaffold(
      appBar: AppBar(title: const Text('ESP32 Dashboard')),
      body: FutureBuilder(
        future: _fApp,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong with Firebase'));
          } else if (snapshot.hasData) {
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(responsive.wp(3)),
                child: Column(
                  children: [
                    _mapSection(),
                    SizedBox(height: responsive.hp(2)),
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: responsive.gridColumns,
                      mainAxisSpacing: responsive.hp(1.5),
                      crossAxisSpacing: responsive.wp(3),
                      childAspectRatio: responsive.cardAspectRatio,
                      children: [
                        _statCard(
                          icon: Icons.water_drop,
                          title: 'Soil Moisture',
                          value: '$realTimeMoist%',
                          iconColor: Colors.blueAccent,
                          isAverage: true,
                        ),
                        _statCard(
                          icon: Icons.thermostat,
                          title: 'Temperature',
                          value: '$realTimeTemp°C',
                          iconColor: Colors.redAccent,
                          isAverage: true,
                        ),
                          _statCard(
                          icon: Icons.battery_6_bar,
                          title: 'Battery',
                          value: '$realBatteryLevel%',
                          iconColor: Colors.teal,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
