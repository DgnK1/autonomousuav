import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../widgets/app_header.dart';
import '../widgets/notifications_sheet.dart';
import '../screens/soil_monitoring_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isDark = false;
  // Controller for swiping between Map and Drone Footage
  final PageController _topPagerController = PageController();
  int _topPagerIndex = 0;

  Widget _statCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String value,
    required Color valueColor,
    bool isAverage = false,
    String averageLabel = 'Average',
    String? averageTooltip,
    VoidCallback? onTap,
    double? titleFontSize,
    double? valueFontSize,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.black12),
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(icon, color: iconColor, size: 24),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: titleFontSize ?? 16,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (isAverage)
              Align(
                alignment: Alignment.center,
                child: Tooltip(
                  message: averageTooltip ?? 'Average across analyzed plots',
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.06),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      averageLabel.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.4,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
              ),
            if (isAverage) const SizedBox(height: 6),
            Align(
              alignment: Alignment.center,
              child: Text(
                value,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: valueFontSize ?? 24,
                  fontWeight: FontWeight.w900,
                  color: valueColor,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _topPagerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: const Color(0xFFF2F2F2),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header (shared) with notifications action
            AppHeader(
              title: 'Dashboard',
              actions: [
                IconButton(
                  icon: const Icon(Icons.notifications, color: Colors.white),
                  onPressed: () => showNotificationsSheet(context),
                ),
              ],
            ),

            // Content with page padding
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Swipeable top area: Google Map <-> Drone Footage
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: SizedBox(
                        height: 250,
                        child: Stack(
                          children: [
                            PageView(
                              controller: _topPagerController,
                              onPageChanged: (i) =>
                                  setState(() => _topPagerIndex = i),
                              children: [
                                // Google Map page
                                GoogleMap(
                                  initialCameraPosition: const CameraPosition(
                                    target: LatLng(
                                      10.503055391390058,
                                      124.02984872550603,
                                    ),
                                    zoom: 16.0,
                                  ),
                                  markers: {
                                    const Marker(
                                      markerId: MarkerId('targetLocation'),
                                      position: LatLng(
                                        10.503055391390058,
                                        124.02984872550603,
                                      ),
                                      infoWindow: InfoWindow(
                                        title:
                                            'Cebu Technological University - Danao Campus',
                                        snippet:
                                            'Cebu Technological University - Danao Campus',
                                      ),
                                    ),
                                  },
                                ),
                                // Drone footage page (GIF placeholder)
                                Container(
                                  color: Colors.black,
                                  alignment: Alignment.center,
                                  child: Image.asset(
                                    'assets/gifs/droneflyby.gif',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ],
                            ),
                            // Page indicator
                            Positioned(
                              right: 8,
                              bottom: 8,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.4),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: List.generate(2, (index) {
                                    final isActive = _topPagerIndex == index;
                                    return Container(
                                      width: isActive ? 10 : 8,
                                      height: isActive ? 10 : 8,
                                      margin: const EdgeInsets.symmetric(
                                        horizontal: 3,
                                      ),
                                      decoration: BoxDecoration(
                                        color: isActive
                                            ? Colors.white
                                            : Colors.white70,
                                        shape: BoxShape.circle,
                                      ),
                                    );
                                  }),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Stats grid (responsive tile height)
                    Builder(
                      builder: (context) {
                        final tiles = <Widget>[
                          _statCard(
                            icon: Icons.water_drop,
                            iconColor: const Color(0xFF1565C0),
                            title: 'Soil Moisture',
                            value: 'Dry',
                            valueColor: const Color(0xFFB00020),
                            isAverage: true,
                            averageTooltip:
                                'Average soil moisture across analyzed plots',
                          ),
                          _statCard(
                            icon: Icons.science_outlined,
                            iconColor: const Color(0xFF00897B),
                            title: 'Soil pH Level',
                            value: '7',
                            valueColor: const Color(0xFF2E7D32),
                            isAverage: true,
                            averageLabel: 'Neutral',
                            averageTooltip:
                                'Average soil pH across analyzed plots',
                          ),
                          _statCard(
                            icon: Icons.thermostat,
                            iconColor: const Color(0xFFE53935),
                            title: 'Soil Temperature',
                            value: '25°C',
                            valueColor: const Color(0xFF1565C0),
                            isAverage: true,
                            averageTooltip:
                                'Average soil temperature across analyzed plots',
                            titleFontSize: 14,
                          ),
                          _statCard(
                            icon: Icons.battery_6_bar,
                            iconColor: const Color(0xFF2E7D32),
                            title: 'Battery Left',
                            value: '85%',
                            valueColor: const Color(0xFF2E7D32),
                            valueFontSize: 42,
                          ),
                        ];

                        return LayoutBuilder(
                          builder: (context, constraints) {
                            final mediaQuery = MediaQuery.of(context);
                            final isPortrait =
                                mediaQuery.orientation == Orientation.portrait;
                            final width = constraints.maxWidth;

                            // Breakpoints:
                            // - Very small width: 1 column
                            // - Portrait phones: 2 columns
                            // - Landscape/wider screens: 3 columns when wide enough, else 2
                            int crossAxisCount;
                            if (width < 340) {
                              crossAxisCount = 1;
                            } else if (isPortrait) {
                              crossAxisCount = 2;
                            } else {
                              crossAxisCount = width >= 720 ? 3 : 2;
                            }

                            const spacing = 12.0;
                            final totalSpacing = spacing * (crossAxisCount - 1);
                            final tileWidth =
                                (width - totalSpacing) / crossAxisCount;

                            // Base height ratio with bounds, adjusts nicely per column count
                            // Slightly tighter aspect; vary bounds per column count
                            double tileHeight = tileWidth * 0.70;
                            final minH = crossAxisCount == 1 ? 140.0 : 125.0;
                            final maxH = crossAxisCount == 3 ? 170.0 : 200.0;
                            tileHeight = tileHeight.clamp(minH, maxH);

                            return GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: tiles.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: crossAxisCount,
                                    mainAxisSpacing: spacing,
                                    crossAxisSpacing: spacing,
                                    mainAxisExtent: tileHeight,
                                  ),
                              itemBuilder: (context, index) => tiles[index],
                            );
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.info_outline,
                          size: 16,
                          color: Colors.black54,
                        ),
                        SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            'Values shown are averages across analyzed plots.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    const Spacer(),

                    // Start button (intrinsic size, centered) with bottom space
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const SoilMonitoringPage(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                          ),
                          child: const Text(
                            'Summary',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        ElevatedButton(
                          onPressed: () {
                            // TODO: Hook start action
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                          ),
                          child: const Text(
                            'Start Drone',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
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
