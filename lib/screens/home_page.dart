import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isDark = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          SizedBox(height: 64),
          SearchAnchor(
            builder: (BuildContext context, SearchController controller) {
              return SearchBar(
                controller: controller,
                padding: const WidgetStatePropertyAll<EdgeInsets>(
                  EdgeInsets.symmetric(horizontal: 16.0),
                ),
                onTap: () {
                  controller.openView();
                },
                onChanged: (_) {
                  controller.openView();
                },
                leading: const Icon(Icons.search),
              );
            },
            suggestionsBuilder:
                (BuildContext context, SearchController controller) {
                  return List<ListTile>.generate(5, (int index) {
                    final String item = 'item $index';
                    return ListTile(
                      title: Text(item),
                      onTap: () {
                        setState(() {
                          // Add your code here
                        });
                      },
                    );
                  });
                },
          ),
          SizedBox(height: 24),
          // Google Maps below the search bar
          SizedBox(
            height: 350,
            child: GoogleMap(
              initialCameraPosition: const CameraPosition(
                target: LatLng(10.503055391390058, 124.02984872550603),
                zoom: 16.0,
              ),
              markers: {
                const Marker(
                  markerId: MarkerId('targetLocation'),
                  position: LatLng(10.503055391390058, 124.02984872550603),
                  infoWindow: InfoWindow(
                    title: 'Cebu Technological University - Danao Campus',
                    snippet: 'Cebu Technological University - Danao Campus',
                  ),
                ),
              },
            ),
          ),
          SizedBox(height: 24),

          // Add some space between the search bar and the status text
          Text(
            'Status',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.water_drop,
                        size: 40,
                        color: Color.fromARGB(255, 0, 0, 163),
                      ),
                      Text(
                        '60%',
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          color: Color(0xFF1C1C1C),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 48),
                  Row(
                    children: [
                      Icon(
                        Icons.thermostat,
                        size: 40,
                        color: Color.fromARGB(255, 255, 0, 0),
                      ),
                      Text(
                        '25°C',
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          color: Color(0xFF1C1C1C),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Spacer(), // Take up the remaining space
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.battery_6_bar, size: 40),
                      Text(
                        '85%',
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          color: Color(0xFF1C1C1C),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 48),
            ],
          ),
          SizedBox(height: 32),
          ElevatedButton(
            onPressed: () {
              // pseudo start
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromARGB(255, 0, 0, 0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              minimumSize: Size(0, 0),
              padding: EdgeInsets.symmetric(horizontal: 48, vertical: 12),
            ),
            child: Text(
              'START',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 26),
        ],
      ),
    );
  }
}
