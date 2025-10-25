import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../widgets/app_header.dart';
import '../widgets/notifications_sheet.dart';
import '../screens/soil_monitoring_page.dart';
import '../screens/mapping_page.dart';
import '../utils/responsive_utils.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool isMapping = false;
  bool hasMapped = false;
  bool isAnalyzing = false;
  String flightMode = "Auto";

  GoogleMapController? mapController;

  LatLng dronePosition = const LatLng(37.42796133580664, -122.085749655962);
  double fillProgress = 0.0;

  final LatLngBounds mappedArea = LatLngBounds(
    southwest: const LatLng(37.426, -122.088),
    northeast: const LatLng(37.429, -122.083),
  );

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    );

    _controller.addListener(() {
      setState(() {
        fillProgress = _controller.value;

        if (isAnalyzing) {
          // Zigzag movement simulation
          final totalRows = 6;
          final rowHeight =
              (mappedArea.northeast.latitude - mappedArea.southwest.latitude) /
              totalRows;
          final progressInRows = fillProgress * totalRows;
          final currentRow = progressInRows.floor();
          final progressWithinRow = progressInRows - currentRow;

          bool isRight = currentRow % 2 == 0;
          final lat = mappedArea.northeast.latitude - currentRow * rowHeight;
          final lngStart = mappedArea.southwest.longitude;
          final lngEnd = mappedArea.northeast.longitude;
          final lng = isRight
              ? lngStart + (lngEnd - lngStart) * progressWithinRow
              : lngEnd - (lngEnd - lngStart) * progressWithinRow;

          dronePosition = LatLng(lat, lng);
        }
      });

      if (_controller.isCompleted) {
        if (isMapping) {
          setState(() {
            isMapping = false;
            hasMapped = true;
            isAnalyzing = true;
            _controller.duration = const Duration(seconds: 30);
            _controller.reset();
            _controller.forward();
          });
        } else if (isAnalyzing) {
          setState(() {
            isAnalyzing = false;
            fillProgress = 1.0;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _toggleMapping() async {
    if (hasMapped && !isMapping && !isAnalyzing) {
      final confirm = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: Colors.grey[900],
          title: const Text(
            'New Mapping?',
            style: TextStyle(color: Colors.white),
          ),
          content: const Text(
            'A mapping already exists. Start a new one?',
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Yes, Start New Scan'),
            ),
          ],
        ),
      );

      if (confirm != true) return;
      setState(() {
        hasMapped = false;
        fillProgress = 0.0;
      });
    }

    if (!isMapping && !isAnalyzing) {
      setState(() {
        _controller.duration = const Duration(seconds: 10);
        fillProgress = 0.0;
        _controller.reset();
        _controller.forward();
        isMapping = true;
      });

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const MappingPage()),
      );
    } else {
      setState(() {
        _controller.stop();
        isMapping = false;
        isAnalyzing = false;
      });
    }
  }

  void _selectMode() async {
    final result = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.grey[900],
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.auto_mode, color: Colors.white),
            title: const Text(
              'Auto Mode',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () => Navigator.pop(context, 'Auto'),
          ),
          ListTile(
            leading: const Icon(Icons.flight, color: Colors.white),
            title: const Text(
              'Manual Mode',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () => Navigator.pop(context, 'Manual'),
          ),
        ],
      ),
    );

    if (result != null) {
      setState(() => flightMode = result);
    }
  }

  Widget _mapSection() {
    final responsive = ResponsiveUtils(context);
    // Map takes 28% of screen height - adapts automatically
    return SizedBox(
      height: responsive.hp(28),
      child: Stack(
        children: [
          GoogleMap(
            onMapCreated: (controller) => mapController = controller,
            initialCameraPosition: const CameraPosition(
              target: LatLng(37.42796133580664, -122.085749655962),
              zoom: 16,
            ),
            markers: {
              if (hasMapped || isMapping || isAnalyzing)
                Marker(
                  markerId: const MarkerId('drone'),
                  position: dronePosition,
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueAzure,
                  ),
                ),
            },
            polygons: {
              if (hasMapped || isAnalyzing)
                Polygon(
                  polygonId: const PolygonId('mapped_area'),
                  fillColor: Colors.blue.withOpacity(0.2 + fillProgress * 0.3),
                  strokeColor: Colors.blueAccent,
                  strokeWidth: 2,
                  points: [
                    mappedArea.southwest,
                    LatLng(
                      mappedArea.southwest.latitude,
                      mappedArea.northeast.longitude,
                    ),
                    mappedArea.northeast,
                    LatLng(
                      mappedArea.northeast.latitude,
                      mappedArea.southwest.longitude,
                    ),
                  ],
                ),
            },
            myLocationEnabled: false,
            zoomControlsEnabled: false,
          ),
          if (isMapping || isAnalyzing)
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                margin: const EdgeInsets.all(8),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  isMapping
                      ? "Mapping in Progress..."
                      : "Analyzing Soil Data (${(fillProgress * 100).toStringAsFixed(0)}%)",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ✅ Modern Stat Card
  Widget _statCard({
    required IconData icon,
    required String title,
    required String value,
    Color iconColor = Colors.blueAccent,
    bool isAverage = false,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final responsive = ResponsiveUtils(context);
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
                  'AVERAGE',
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final responsive = ResponsiveUtils(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            AppHeader(
              title: 'Drone Dashboard',
              actions: [
                IconButton(
                  icon: const Icon(Icons.notifications),
                  onPressed: () => showNotificationsSheet(context),
                ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(responsive.wp(2)),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _mapSection(),
                      SizedBox(height: responsive.hp(0.8)),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: _toggleMapping,
                              icon: Icon(
                                isMapping || isAnalyzing
                                    ? Icons.stop_circle
                                    : Icons.play_circle,
                                color: Colors.black,
                              ),
                              label: Text(
                                isMapping || isAnalyzing
                                    ? "Cancel Mapping"
                                    : "Start Mapping",
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: isMapping || isAnalyzing
                                    ? Colors.redAccent
                                    : Colors.lightGreenAccent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: responsive.wp(2.5)),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: _selectMode,
                              icon: const Icon(
                                Icons.settings,
                                color: Colors.black,
                              ),
                              label: Text(
                                "Mode: $flightMode",
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orangeAccent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: responsive.hp(1)),
                      GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: responsive.gridColumns,
                        mainAxisSpacing: responsive.hp(1.2),
                        crossAxisSpacing: responsive.wp(3),
                        childAspectRatio: responsive.cardAspectRatio,
                        children: [
                          _statCard(
                            icon: Icons.water_drop,
                            title: 'Soil Moisture',
                            value: 'Dry',
                            iconColor: Colors.blueAccent,
                            isAverage: true,
                          ),
                          _statCard(
                            icon: Icons.science_outlined,
                            title: 'Soil pH Level',
                            value: '7.0',
                            iconColor: Colors.green,
                            isAverage: true,
                          ),
                          _statCard(
                            icon: Icons.thermostat,
                            title: 'Soil Temp',
                            value: '25°C',
                            iconColor: Colors.redAccent,
                            isAverage: true,
                          ),
                          _statCard(
                            icon: Icons.battery_6_bar,
                            title: 'Battery',
                            value: '85%',
                            iconColor: Colors.teal,
                          ),
                        ],
                      ),
                      SizedBox(height: responsive.hp(1.2)),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SoilMonitoringPage(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: EdgeInsets.symmetric(
                            horizontal: responsive.wp(8),
                            vertical: responsive.hp(1.5),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          'Summary',
                          style: TextStyle(
                            fontSize: responsive.sp(20),
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: responsive.hp(1)),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
