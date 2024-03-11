import 'dart:async';
import 'package:flutter/material.dart';
import 'package:found_me/app/ui/pages/request_permission/request_permission_controller.dart';
import 'package:found_me/app/ui/pages/routes/routes.dart';
import 'package:permission_handler/permission_handler.dart';

class RequestPermissionPage extends StatefulWidget {
  const RequestPermissionPage({super.key});

  @override
  State<RequestPermissionPage> createState() => _RequestPermissionPageState();
}

class _RequestPermissionPageState extends State<RequestPermissionPage>
    with WidgetsBindingObserver {
  final _controller = RequestPermissionController(Permission.locationWhenInUse);
  late StreamSubscription _subscription;
  bool _fromSettings = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    _subscription = _controller.onStatusChanged.listen(
      (status) {
        if (status == PermissionStatus.granted) {
          _goTohome();
        } else if (status == PermissionStatus.permanentlyDenied) {
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: const Text('Permisos necesarios'),
              content: const Text(
                  'Necesito que me otorgues permisos de ubicacion para poder funcionar de manera correcta'),
              actions: [
                TextButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    _fromSettings = await openAppSettings();
                  },
                  child: const Text('Ir a configuraciones'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Denegar'),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    // print("$state");
    if (state == AppLifecycleState.resumed && _fromSettings) {
      final status = await _controller.check();
      if (status == PermissionStatus.granted) {
        _goTohome();
      }
    }
    _fromSettings = false;
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    _subscription.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _goTohome() {
    Navigator.pushReplacementNamed(context, Routes.HOME);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          alignment: Alignment.center,
          child: ElevatedButton(
            child: const Text('Permitir'),
            onPressed: () {
              _controller.request();
            },
          ),
        ),
      ),
    );
  }
}
