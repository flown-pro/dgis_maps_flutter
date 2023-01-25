//
//  CameraMoveService.swift
//  dgis_maps_flutter
//
//  Created by Михаил Колчанов on 19.01.2023.
//

import DGis


final class CameraMoveService {
    private let locationManagerFactory: () -> LocationService?
    private let map: Map
    private let flutterApi: PluginFlutterApi
    
    private var locationService: LocationService?
    private var moveCameraCancellable: DGis.Cancellable?
    private var cameraStream: DGis.Cancellable?
     
    
    init(
        locationManagerFactory: @escaping () -> LocationService?,
        map: Map,
        flutterApi: PluginFlutterApi
    ) {
        self.locationManagerFactory = locationManagerFactory
        self.map = map
        self.flutterApi = flutterApi
        startCameraStateStream()
    }
    
    func startCameraStateStream() {
        stopCameraStateStream()
//        cameraStream = map.camera.stateChannel.sink { state in
//            var newState : DataCameraState
//            switch (state) {
//            case .busy:
//                newState = DataCameraState.busy
//            case .fly:
//                newState = DataCameraState.fly
//            case .followPosition:
//                newState = DataCameraState.followPosition
//            case .free:
//                newState = DataCameraState.free
//            @unknown default:
//                newState = DataCameraState.free
//            }
//            print(newState)
////            self.flutterApi.onCameraStateChanged( //TODO: enum wtf
////                cameraState: newState,
////                completion: {}
////            )
//        }
    }
    
    func stopCameraStateStream() {
        cameraStream?.cancel()
    }
    
    func moveToSelfPosition() {
        if self.locationService == nil {
            self.locationService = self.locationManagerFactory()
        }
        self.locationService?.getCurrentPosition { (coordinates) in
            self.moveToLocation(
                position: DGis.CameraPosition(
                    point: DGis.GeoPoint(
                        latitude: .init(value: coordinates.latitude),
                        longitude: .init(value: coordinates.longitude)
                    ),
                    zoom: .init(value: 14),
                    tilt: .init(value: 15),
                    bearing: .init(value: 0)
                ),
                time: 1.0,
                animationType: .linear
            )
        }
    }
    
    func moveToLocation(position: DGis.CameraPosition, time: TimeInterval, animationType: DGis.CameraAnimationType) {
        DispatchQueue.main.async {
            self.moveCameraCancellable?.cancel()
            self.moveCameraCancellable = self.map
                .camera
                .move(
                    position: position,
                    time: time,
                    animationType: animationType
                ).sink { _ in
                    print("Move to location")
                } failure: { error in
                    print("Something went wrong: \(error.localizedDescription)")
                }
        }
    }
}
