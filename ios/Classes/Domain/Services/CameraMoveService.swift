//
//  CameraMoveService.swift
//  dgis_maps_flutter
//
//  Created by Михаил Колчанов on 19.01.2023.
//

import DGis


final class CameraMoveService {
    private let mapFactory : IMapFactory
    private let flutterApi: PluginFlutterApi
    private let locationService: LocationService
    
    private var moveCameraCancellable: DGis.Cancellable?
    private var cameraStream: DGis.Cancellable?
    
    
    init(
        mapFactory : IMapFactory,
        flutterApi: PluginFlutterApi,
        locationService: LocationService
    ) {
        self.mapFactory = mapFactory
        self.flutterApi = flutterApi
        self.locationService = locationService
        startCameraStateStream()
    }
    
    func startCameraStateStream() {
        stopCameraStateStream()
        cameraStream = mapFactory.map.camera.stateChannel.sink { state in
            var newState : DataCameraState
            switch (state) {
            case .busy:
                newState = DataCameraState.busy
            case .fly:
                newState = DataCameraState.fly
            case .followPosition:
                newState = DataCameraState.followPosition
            case .free:
                newState = DataCameraState.free
            @unknown default:
                newState = DataCameraState.free
            }
            self.flutterApi.onCameraStateChanged(
                cameraState: DataCameraStateValue.init(value: newState),
                completion: {}
            )
        }
    }
    
    func stopCameraStateStream() {
        cameraStream?.cancel()
    }
    
    func moveToSelfPosition() {
        self.locationService.getCurrentPosition { (coordinates) in
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
                dataAnimationType: .linear
            )
        }
    }
    
    func moveToLocation(position: DGis.CameraPosition, time: TimeInterval, dataAnimationType: DataCameraAnimationType) {
        var animationType = DGis.CameraAnimationType.default
        switch (dataAnimationType) {
        case .linear:
            animationType = DGis.CameraAnimationType.linear
        case .showBothPositions:
            animationType = DGis.CameraAnimationType.showBothPositions
        case .def:
            animationType = DGis.CameraAnimationType.default
        }
        DispatchQueue.main.async {
            self.moveCameraCancellable?.cancel()
            self.moveCameraCancellable = self.mapFactory.map
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
