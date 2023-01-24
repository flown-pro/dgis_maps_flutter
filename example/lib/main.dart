import 'package:dgis_maps_flutter/dgis_maps_flutter.dart';
import 'package:dgis_maps_flutter/src/controller.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DGis Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int i = 0;
  late DGisMapController controller;
  void onMapCreated(DGisMapController controller) {
    this.controller = controller;
  }

  Future<void> onAsyPressed() async {
    // await controller.api.moveCamera(
    //   CameraPosition(
    //     target: LatLng(30, 60),
    //     zoom: 12,
    //     bearing: 0,
    //     tilt: 0,
    //   ),
    //   1000,
    //   CameraAnimationType.def,
    // );
    // ignore: use_build_context_synchronously
    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(
    //     behavior: SnackBarBehavior.fixed,
    //     duration: const Duration(seconds: 1),
    //     dismissDirection: DismissDirection.horizontal,
    //     content: Text(
    //       newPos.encode().toString(),
    //     ),
    //   ),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      floatingActionButton: FloatingActionButton(
        child: Text("iter\n$i"),
        onPressed: () => setState(() => i++),
      ),
      body: Column(
        children: [
          Expanded(
            child: DGisMap(
              key: ValueKey(i),
              initialPosition: CameraPosition(target: LatLng(60, 30), zoom: 7),
              onMapCreated: onMapCreated,
              // onCameraStateChanged:
            ),
          ),
          Row(
            children: [
              TextButton(
                onPressed: onAsyPressed,
                child: const Text('moveMap'),
              )
            ],
          ),
          const SizedBox(height: 52),
        ],
      ),
    );
  }
}
