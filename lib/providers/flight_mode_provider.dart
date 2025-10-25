import 'package:flutter/foundation.dart';

class FlightModeProvider extends ChangeNotifier {
  String _flightMode = "Auto";

  String get flightMode => _flightMode;

  void setFlightMode(String mode) {
    if (_flightMode != mode) {
      _flightMode = mode;
      notifyListeners();
    }
  }

  bool get isManualMode => _flightMode == "Manual";
  bool get isAutoMode => _flightMode == "Auto";
}
