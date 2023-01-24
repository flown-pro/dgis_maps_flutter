import 'dart:math';

import 'package:dgis_maps_flutter/dgis_maps_flutter.dart';
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
  Set<Polyline> polylines = {};

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

  Future<void> getCameraPosition() async {
    final cameraPosition = await controller.getCameraPosition();
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(cameraPosition.toString())));
  }

  Future<void> addMarker() async {
    markers.add(Marker(
      markerId: MapObjectId('m${mId++}'),
      position: LatLng(60.0 + mId, 30.0 + mId),
      infoText: 'm${mId++}',
    ));
    setState(() {});
  }

  Future<void> addPolyline() async {
    polylines.add(
      Polyline(
        polylineId: MapObjectId('p${mId++}'),
        color: Colors.primaries[Random().nextInt(Colors.primaries.length)],
        points: List.generate(
          10,
          (index) => LatLng(60.0 + index + mId, 30.0 + index + mId),
        ),
        erasedPart: 0,
      ),
    );
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
              polylines: polylines,
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Wrap(
                  children: [
                    TextButton(
                      onPressed: moveCamera,
                      child: const Text('moveCamera'),
                    ),
                    TextButton(
                      onPressed: getCameraPosition,
                      child: const Text('getCameraPosition'),
                    ),
                    TextButton(
                      onPressed: addMarker,
                      child: const Text('addMarker'),
                    ),
                    TextButton(
                      onPressed: addPolyline,
                      child: const Text('addPolyline'),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 100),
            ],
          ),
        ],
      ),
    );
  }
}
