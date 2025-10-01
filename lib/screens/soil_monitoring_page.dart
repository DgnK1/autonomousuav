import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SoilMonitoringPage extends StatefulWidget {
  const SoilMonitoringPage({super.key});

  @override
  State<SoilMonitoringPage> createState() => _SoilMonitoringPageState();
}

class _SoilMonitoringPageState extends State<SoilMonitoringPage> {
  GoogleMapController? _mapController;
  String? _selectedPlotId;

  final List<Map<String, dynamic>> _plots = [
    {
      'id': 'plot1',
      'position': LatLng(10.503055, 124.029848),
      'title': 'Plot 1',
      'moisture': 'Dry (20%)',
      'ph': '6.5',
      'temperature': '25°C',
    },
    {
      'id': 'plot2',
      'position': LatLng(10.504000, 124.030200),
      'title': 'Plot 2',
      'moisture': 'Moist (55%)',
      'ph': '7.0',
      'temperature': '26°C',
    },
  ];

  void _goToPlot(Map<String, dynamic> plot) {
    setState(() {
      _selectedPlotId = plot['id'].toString();
    });

    final pos = plot['position'] as LatLng;
    _mapController?.animateCamera(CameraUpdate.newLatLngZoom(pos, 17));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final markers = _plots.map((plot) {
      final id = plot['id'].toString();
      final title = plot['title'].toString();
      final pos = plot['position'] as LatLng;
      final isSelected = _selectedPlotId == id;

      return Marker(
        markerId: MarkerId(id),
        position: pos,
        infoWindow: InfoWindow(
          title: title,
          snippet:
              'Moisture: ${plot['moisture']}, pH: ${plot['ph']}, Temp: ${plot['temperature']}',
        ),
        icon: isSelected
            ? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure)
            : BitmapDescriptor.defaultMarker,
      );
    }).toSet();

    return Scaffold(
      appBar: AppBar(title: const Text('Soil Monitoring'), centerTitle: true),
      body: Column(
        children: [
          // Map
          SizedBox(
            height: 250,
            child: GoogleMap(
              initialCameraPosition: const CameraPosition(
                target: LatLng(10.503055, 124.029848),
                zoom: 16,
              ),
              markers: markers,
              onMapCreated: (controller) => _mapController = controller,
            ),
          ),

          // Table
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal, // allow sideways scroll
                child: DataTable(
                  headingRowColor: WidgetStateProperty.all(
                    isDark ? Colors.white12 : Colors.grey.shade200,
                  ),
                  headingTextStyle: TextStyle(
                    color: scheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                  dataTextStyle: TextStyle(color: scheme.onSurface),
                  columns: [
                    DataColumn(label: Text('Plot', style: TextStyle(color: scheme.onSurface))),
                    DataColumn(label: Text('Moisture', style: TextStyle(color: scheme.onSurface))),
                    DataColumn(label: Text('pH', style: TextStyle(color: scheme.onSurface))),
                    DataColumn(label: Text('Temp', style: TextStyle(color: scheme.onSurface))),
                  ],
                  rows: _plots.map((plot) {
                    final id = plot['id'].toString();
                    final title = plot['title'].toString();
                    final moisture = plot['moisture'].toString();
                    final ph = plot['ph'].toString();
                    final temp = plot['temperature'].toString();

                    final isSelected = _selectedPlotId == id;

                    return DataRow(
                      color: WidgetStateProperty.all(
                        isSelected
                            ? (isDark
                                ? Colors.blue.withOpacity(0.2)
                                : Colors.blue.shade100)
                            : null,
                      ),
                      cells: [
                        DataCell(Text(title, style: TextStyle(color: scheme.onSurface)), onTap: () => _goToPlot(plot)),
                        DataCell(Text(moisture, style: TextStyle(color: scheme.onSurface)), onTap: () => _goToPlot(plot)),
                        DataCell(Text(ph, style: TextStyle(color: scheme.onSurface)), onTap: () => _goToPlot(plot)),
                        DataCell(Text(temp, style: TextStyle(color: scheme.onSurface)), onTap: () => _goToPlot(plot)),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
