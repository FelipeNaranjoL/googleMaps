import 'package:flutter/widgets.dart' show ChangeNotifier;
import 'package:found_me/app/ui/pages/routes/routes.dart';
import 'package:permission_handler/permission_handler.dart';

class SplashController extends ChangeNotifier {
  final Permission _locationPermisssion;
  String? _routeName;
  String? get routeName => _routeName;
  SplashController(this._locationPermisssion);

  Future<void> checkPermission() async {
    final isGranted = await _locationPermisssion.isGranted;
    _routeName = isGranted ? Routes.HOME : Routes.PERMISSIONS;
    notifyListeners();
  }
}
