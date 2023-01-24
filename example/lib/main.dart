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
  int mId = 0;
  late DGisMapController controller;

  Set<Marker> markers = {};

  void onMapCreated(DGisMapController controller) {
    this.controller = controller;
  }

  Future<void> moveCamera() async {
    await controller.moveCamera(
      cameraPosition: CameraPosition(
        target: LatLng(60, 30),
        zoom: 7,
        bearing: 0,
        tilt: 0,
      ),
      duration: 1000,
      cameraAnimationType: DataCameraAnimationType.linear,
    );
  }

  Future<void> addMarker() async {
    markers.add(Marker(
      markerId: DataMarkerId(value: 'm${mId++}'),
      position: LatLng(60.0 + mId, 30.0 + mId),
    ));
    setState(() {});
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
              markers: markers,
            ),
          ),
          Row(
            children: [
              TextButton(
                onPressed: moveCamera,
                child: const Text('moveCamera'),
              ),
              TextButton(
                onPressed: addMarker,
                child: const Text('addMarker'),
              ),
            ],
          ),
          const SizedBox(height: 52),
        ],
      ),
    );
  }
}
