import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../widgets/app_header.dart';
import '../widgets/simple_search_delegate.dart';
import '../widgets/notifications_sheet.dart';

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

    return ColoredBox(
      color: const Color(0xFFF2F2F2),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header (shared)
            AppHeader(
              title: 'Manual Controls',
              actions: [
                IconButton(
                  icon: const Icon(Icons.search, color: Colors.white),
                  onPressed: () async {
                    // Example search over simple manual actions
                    const actions = [
                      'Arm Motors',
                      'Disarm Motors',
                      'Takeoff',
                      'Land',
                      'Return to Home',
                    ];
                    await showSearch<String>(
                      context: context,
                      delegate: SimpleSearchDelegate(data: actions),
                    );
                  },
                ),
                const SizedBox(width: 4),
                IconButton(
                  icon: const Icon(Icons.notifications, color: Colors.white),
                  onPressed: () => showNotificationsSheet(context),
                ),
              ],
            ),

            // Page content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    // Google Maps below the header
                    SizedBox(
                      height: 300,
                      child: GoogleMap(
                        initialCameraPosition: const CameraPosition(
                          target: targetLocation,
                          zoom: 16.0,
                        ),
                        markers: {
                          const Marker(
                            markerId: MarkerId('targetLocation'),
                            position: targetLocation,
                            infoWindow: InfoWindow(
                              title:
                                  'Cebu Technological University - Danao Campus',
                              snippet:
                                  'Cebu Technological University - Danao Campus',
                            ),
                          ),
                        },
                      ),
                    ),
                    const SizedBox(height: 16),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Row(
                              children: [
                                Icon(
                                  Icons.water_drop,
                                  size: 36,
                                  color: Color.fromARGB(255, 0, 0, 163),
                                ),
                                SizedBox(width: 6),
                                Text(
                                  '60%',
                                  style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 36,
                                    color: Color(0xFF1C1C1C),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 16),
                            Row(
                              children: [
                                Icon(
                                  Icons.thermostat,
                                  size: 36,
                                  color: Color.fromARGB(255, 255, 0, 0),
                                ),
                                SizedBox(width: 6),
                                Text(
                                  '25°C',
                                  style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 36,
                                    color: Color(0xFF1C1C1C),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const Spacer(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Row(
                              children: [
                                Icon(Icons.battery_6_bar, size: 36),
                                SizedBox(width: 6),
                                Text(
                                  '85%',
                                  style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 36,
                                    color: Color(0xFF1C1C1C),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
