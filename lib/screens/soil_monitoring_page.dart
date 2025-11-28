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
                  ? BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueAzure,
                    )
                  : BitmapDescriptor.defaultMarker,
            );
          }).toSet();

          // Simple recommendation based on average moisture / pH / temperature
          String recommendationTitle = 'Next Action';
          String recommendationText = 'Waiting for mapping data...';
          Color recommendationColor = Colors.blueAccent;

          if (plots.isNotEmpty) {
            double totalMoisture = 0;
            double totalPh = 0;
            double totalTemp = 0;

            for (final plot in plots) {
              totalMoisture += (plot['moistureValue'] ?? 0).toDouble();
              totalPh += (plot['phValue'] ?? 7.0).toDouble();
              totalTemp += (plot['temperatureValue'] ?? 25.0).toDouble();
            }

            final avgMoisture = totalMoisture / plots.length;
            final avgPh = totalPh / plots.length;
            final avgTemp = totalTemp / plots.length;

            // Very simple heuristic: you can tweak thresholds as needed
            if (avgMoisture < 30) {
              recommendationText =
                  'Soil is generally dry (avg moisture ${avgMoisture.toStringAsFixed(0)}%). It is a good time to irrigate the field.';
              recommendationColor = Colors.redAccent;
            } else if (avgMoisture > 70) {
              recommendationText =
                  'Soil moisture is high (avg ${avgMoisture.toStringAsFixed(0)}%). Avoid irrigating to prevent overwatering.';
              recommendationColor = Colors.orangeAccent;
            } else {
              recommendationText =
                  'Soil moisture is in the optimal range (avg ${avgMoisture.toStringAsFixed(0)}%). You can wait before irrigating.';
              recommendationColor = Colors.green;
            }

            // Optional pH note
            if (avgPh < 5.5 || avgPh > 7.5) {
              recommendationText +=
                  '\nNote: Average pH ${avgPh.toStringAsFixed(1)} is outside the ideal 5.5–7.5 range. Consider soil amendments.';
            }

            // Optional temperature note
            if (avgTemp < 15 || avgTemp > 35) {
              recommendationText +=
                  '\nTemperature (${avgTemp.toStringAsFixed(1)}°C) is not ideal. Plan irrigation during cooler periods of the day.';
            }
          }

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
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
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
                            DataColumn(label: Text('Temp')),
                          ],
                          rows: plots.map((plot) {
                            final id = plot['id'].toString();
                            final title = plot['title'].toString();
                            final moisture = plot['moisture'].toString();
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
                                DataCell(
                                  Text(
                                    title,
                                    style: TextStyle(color: scheme.onSurface),
                                  ),
                                  onTap: () => _goToPlot(plot),
                                ),
                                DataCell(
                                  Text(
                                    moisture,
                                    style: TextStyle(color: scheme.onSurface),
                                  ),
                                  onTap: () => _goToPlot(plot),
                                ),
                                DataCell(
                                  Text(
                                    temp,
                                    style: TextStyle(color: scheme.onSurface),
                                  ),
                                  onTap: () => _goToPlot(plot),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ),

                      const SizedBox(height: 12),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isDark
                                ? Colors.white10
                                : recommendationColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: recommendationColor.withOpacity(0.7),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                recommendationTitle,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: recommendationColor,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                recommendationText,
                                style: TextStyle(color: scheme.onSurface),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),
                    ],
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
