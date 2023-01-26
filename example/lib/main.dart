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
  bool isShrinked = false;
  bool isShrinkedTop = false;
  late DGisMapController controller;
  bool myLocationEnabled = true;

  Set<Marker> markers = {};
  Set<Polyline> polylines = {};

  void onMapCreated(DGisMapController controller) {
    this.controller = controller;
  }

  void shrinkMapTop() {
    setState(() => isShrinkedTop = !isShrinkedTop);
  }

  void shrinkMap() {
    setState(() => isShrinked = !isShrinked);
  }

  void moveMap() {
    isShrinkedTop = !isShrinkedTop;
    setState(() => isShrinked = !isShrinked);
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
      cameraAnimationType: CameraAnimationType.linear,
    );
  }

  Future<void> moveCameraToBounds() async {
    await controller.moveCameraToBounds(
      cameraPosition: LatLngBounds(
        southwest: LatLng(58, 28),
        northeast: LatLng(62, 32),
      ),
      padding: MapPadding.all(20),
      duration: 1000,
      cameraAnimationType: CameraAnimationType.showBothPositions,
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

  void toggleMyLocation() {
    setState(() {
      myLocationEnabled = !myLocationEnabled;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DGisMap(
      key: ValueKey(i),
      myLocationEnabled: myLocationEnabled,
      initialPosition: CameraPosition(target: LatLng(60, 30), zoom: 7),
      onMapCreated: onMapCreated,
      markers: markers,
      polylines: polylines,
      onCameraStateChanged: (cameraState) {
        print(cameraState);
      },
    );
    return Column(
      children: [
        AnimatedCrossFade(
          firstChild: const SizedBox(height: 0),
          secondChild: const SizedBox(height: 100),
          crossFadeState: !isShrinkedTop
              ? CrossFadeState.showFirst
              : CrossFadeState.showSecond,
          duration: const Duration(seconds: 2),
        ),
        Expanded(
          child: DGisMap(
            key: ValueKey(i),
            myLocationEnabled: myLocationEnabled,
            initialPosition: CameraPosition(target: LatLng(60, 30), zoom: 7),
            onMapCreated: onMapCreated,
            markers: markers,
            polylines: polylines,
            onCameraStateChanged: (cameraState) {
              print(cameraState);
            },
          ),
        ),
        AnimatedCrossFade(
          firstChild: const SizedBox(height: 0),
          secondChild: const SizedBox(height: 100),
          crossFadeState: !isShrinked
              ? CrossFadeState.showFirst
              : CrossFadeState.showSecond,
          duration: const Duration(seconds: 2),
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
                    onPressed: moveCameraToBounds,
                    child: const Text('moveCameraToBounds'),
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
                  TextButton(
                    onPressed: toggleMyLocation,
                    child: const Text('toggleMyLocation'),
                  ),
                  TextButton(
                    onPressed: shrinkMapTop,
                    child: const Text('shrinkMapTop'),
                  ),
                  TextButton(
                    onPressed: shrinkMap,
                    child: const Text('shrinkMap'),
                  ),
                  TextButton(
                    onPressed: moveMap,
                    child: const Text('moveMap'),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 100),
          ],
        ),
      ],
    );
  }
}
