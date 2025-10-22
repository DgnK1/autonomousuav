import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../data/plots_store.dart';

class SoilMonitoringPage extends StatefulWidget {
  const SoilMonitoringPage({super.key});

  @override
  State<SoilMonitoringPage> createState() => _SoilMonitoringPageState();
}

class _SoilMonitoringPageState extends State<SoilMonitoringPage> {
  GoogleMapController? _mapController;
  String? _selectedPlotId;

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
    return Scaffold(
      appBar: AppBar(title: const Text('Soil Monitoring'), centerTitle: true),
      body: AnimatedBuilder(
        animation: PlotsStore.instance,
        builder: (context, _) {
          final plots = PlotsStore.instance.plots;

          final markers = plots.map((plot) {
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

          return Column(
            children: [
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

              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      headingRowColor: MaterialStateProperty.all(
                        isDark ? Colors.white12 : Colors.grey.shade200,
                      ),
                      headingTextStyle: TextStyle(
                        color: scheme.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                      dataTextStyle: TextStyle(color: scheme.onSurface),
                      columns: const [
                        DataColumn(label: Text('Plot')),
                        DataColumn(label: Text('Moisture')),
                        DataColumn(label: Text('pH')),
                        DataColumn(label: Text('Temp')),
                      ],
                      rows: plots.map((plot) {
                        final id = plot['id'].toString();
                        final title = plot['title'].toString();
                        final moisture = plot['moisture'].toString();
                        final ph = plot['ph'].toString();
                        final temp = plot['temperature'].toString();

                        final isSelected = _selectedPlotId == id;

                        return DataRow(
                          color: MaterialStateProperty.all(
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
          );
        },
      ),
    );
  }
}
