import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PlotsStore extends ChangeNotifier {
  PlotsStore._();
  static final PlotsStore instance = PlotsStore._();

  final List<Map<String, dynamic>> _plots = [
    {
      'id': 'plot1',
      'position': const LatLng(10.503055, 124.029848),
      'title': 'Plot 1',
      'moisture': 'Dry (20%)',
      'ph': '6.5',
      'temperature': '25°C',
    },
    {
      'id': 'plot2',
      'position': const LatLng(10.504000, 124.030200),
      'title': 'Plot 2',
      'moisture': 'Moist (55%)',
      'ph': '7.0',
      'temperature': '26°C',
    },
    {
      'id': 'plot3',
      'position': const LatLng(10.504270, 124.029090),
      'title': 'Plot 3',
      'moisture': 'Moist (76%)',
      'ph': '6.4',
      'temperature': '24°C',
    },
    {
      'id': 'plot4',
      'position': const LatLng(10.503432, 124.029074),
      'title': 'Plot 4',
      'moisture': 'Moist (76%)',
      'ph': '6.4',
      'temperature': '24°C',
    },
  ];

  List<Map<String, dynamic>> get plots => List.unmodifiable(_plots);

  void addPlot({
    required String id,
    required LatLng position,
    required String title,
    required String moisture,
    required String ph,
    required String temperature,
  }) {
    _plots.add({
      'id': id,
      'position': position,
      'title': title,
      'moisture': moisture,
      'ph': ph,
      'temperature': temperature,
    });
    notifyListeners();
  }

  void removePlot(String id) {
    _plots.removeWhere((e) => e['id'] == id);
    notifyListeners();
  }

  void setPlots(List<Map<String, dynamic>> next) {
    _plots
      ..clear()
      ..addAll(next);
    notifyListeners();
  }
}
