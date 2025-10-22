import 'package:flutter/material.dart';
import '../widgets/app_header.dart';
import '../widgets/notifications_sheet.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:typed_data';
import 'dart:ui' as ui;
import '../data/plots_store.dart';

class ManualControlsPage extends StatefulWidget {
  const ManualControlsPage({super.key});

  @override
  State<ManualControlsPage> createState() => _ManualControlsPageState();
}

class _ManualControlsPageState extends State<ManualControlsPage> {
  GoogleMapController? _mapController;
  String? _selectedPlotId;
  BitmapDescriptor? _iconDefault;
  BitmapDescriptor? _iconSelected;

  void _goToPlot(Map<String, dynamic> plot) {
    setState(() {
      _selectedPlotId = plot['id'].toString();
    });

    final pos = plot['position'] as LatLng;
    _mapController?.animateCamera(CameraUpdate.newLatLngZoom(pos, 17));
  }

  Future<void> _confirmChangeCourse(Map<String, dynamic> plot) async {
    final previous = _selectedPlotId;
    setState(() {
      _selectedPlotId = plot['id'].toString();
    });

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Change course'),
          content: const Text('Are you sure?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('No'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      _goToPlot(plot);
    } else {
      if (!mounted) return;
      setState(() {
        _selectedPlotId = previous;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadMarkerIcons());
  }

  Future<void> _loadMarkerIcons() async {
    final dpr = MediaQuery.of(context).devicePixelRatio;
    final size = (28.0 * dpr); // logical 28px scaled

    final defaultBytes = await _buildCircleMarkerBytes(
      size: size,
      fillColor: Colors.white,
      strokeColor: Colors.blue.shade700,
      strokeWidth: 4.0 * dpr,
    );
    final selectedBytes = await _buildCircleMarkerBytes(
      size: size,
      fillColor: Colors.blue.shade700,
      strokeColor: Colors.white,
      strokeWidth: 3.0 * dpr,
    );

    if (!mounted) return;
    setState(() {
      _iconDefault = BitmapDescriptor.fromBytes(defaultBytes);
      _iconSelected = BitmapDescriptor.fromBytes(selectedBytes);
    });
  }

  Future<Uint8List> _buildCircleMarkerBytes({
    required double size,
    required Color fillColor,
    required Color strokeColor,
    required double strokeWidth,
  }) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final rect = Rect.fromLTWH(0, 0, size, size);
    final center = Offset(rect.width / 2, rect.height / 2);
    final radius = rect.width / 2;

    final strokePaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = strokeColor
      ..strokeWidth = strokeWidth
      ..isAntiAlias = true;

    final fillPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = fillColor
      ..isAntiAlias = true;

    // Outer stroke ring
    canvas.drawCircle(center, radius - strokeWidth / 2, strokePaint);
    // Fill inner circle
    canvas.drawCircle(center, radius - strokeWidth, fillPaint);

    final image = await recorder.endRecording().toImage(
      size.toInt(),
      size.toInt(),
    );
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    return ColoredBox(
      color: theme.scaffoldBackgroundColor,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header (shared)
            AppHeader(
              title: 'Manual Controls',
              actions: [
                IconButton(
                  icon: const Icon(Icons.notifications),
                  onPressed: () => showNotificationsSheet(context),
                ),
              ],
            ),

            Expanded(
              child: AnimatedBuilder(
                animation: PlotsStore.instance,
                builder: (context, _) {
                  final plots = PlotsStore.instance.plots;

                  final markers = plots.map((plot) {
                    final id = plot['id'].toString();
                    final pos = plot['position'] as LatLng;
                    final isSelected = _selectedPlotId == id;

                    return Marker(
                      markerId: MarkerId(id),
                      position: pos,
                      infoWindow: const InfoWindow(),
                      onTap: () => _confirmChangeCourse(plot),
                      icon: (_iconDefault == null || _iconSelected == null)
                          ? (isSelected
                                ? BitmapDescriptor.defaultMarkerWithHue(
                                    BitmapDescriptor.hueAzure,
                                  )
                                : BitmapDescriptor.defaultMarker)
                          : (isSelected ? _iconSelected! : _iconDefault!),
                    );
                  }).toSet();

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(
                        height: 250,
                        child: GoogleMap(
                          initialCameraPosition: const CameraPosition(
                            target: LatLng(10.503055, 124.029848),
                            zoom: 16,
                          ),
                          markers: markers,
                          onMapCreated: (controller) =>
                              _mapController = controller,
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
                              columns: [
                                DataColumn(
                                  label: Text(
                                    'Plot',
                                    style: TextStyle(color: scheme.onSurface),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    'Moisture',
                                    style: TextStyle(color: scheme.onSurface),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    'pH',
                                    style: TextStyle(color: scheme.onSurface),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    'Temp',
                                    style: TextStyle(color: scheme.onSurface),
                                  ),
                                ),
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
                                    DataCell(
                                      Text(
                                        title,
                                        style: TextStyle(
                                          color: scheme.onSurface,
                                        ),
                                      ),
                                      onTap: () => _confirmChangeCourse(plot),
                                    ),
                                    DataCell(
                                      Text(
                                        moisture,
                                        style: TextStyle(
                                          color: scheme.onSurface,
                                        ),
                                      ),
                                      onTap: () => _confirmChangeCourse(plot),
                                    ),
                                    DataCell(
                                      Text(
                                        ph,
                                        style: TextStyle(
                                          color: scheme.onSurface,
                                        ),
                                      ),
                                      onTap: () => _confirmChangeCourse(plot),
                                    ),
                                    DataCell(
                                      Text(
                                        temp,
                                        style: TextStyle(
                                          color: scheme.onSurface,
                                        ),
                                      ),
                                      onTap: () => _confirmChangeCourse(plot),
                                    ),
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
            ),
          ],
        ),
      ),
    );
  }
}
