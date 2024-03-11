import 'package:flutter/material.dart';
import 'package:found_me/app/ui/pages/home/home_controller.dart';
import 'package:found_me/app/ui/pages/home/widgets/google_map.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  // ignore: use_super_parameters
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomeController>(
      create: (_) {
        final controller = HomeController();
        controller.onMarkerTap.listen((String id) {
          // print('$id');
        });
        return controller;
      },
      child: Scaffold(
        appBar: AppBar(),
        body: Selector<HomeController, bool>(
          selector: (_, controller) => controller.loading,
          builder: (context, loading, loadingWidget) {
            if (loading) {
              return loadingWidget!;
            }
            return const MapView();
          },
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}
