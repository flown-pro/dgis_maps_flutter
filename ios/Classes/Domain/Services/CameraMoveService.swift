//
//  CameraMoveService.swift
//  dgis_maps_flutter_ios
//
//  Created by Михаил Колчанов on 19.01.2023.
//

import DGis


final class CameraMoveService {
    private let locationManagerFactory: () -> LocationService?
    private let map: Map
    private var locationService: LocationService?
    
    private var moveCameraCancellable: DGis.Cancellable?
    
    init(
        locationManagerFactory: @escaping () -> LocationService?,
        map: Map,
        sdkContext: DGis.Context
    ) {
        self.locationManagerFactory = locationManagerFactory
        self.map = map
        
        let source = MyLocationMapObjectSource(
            context: sdkContext,
            directionBehaviour: .followMagneticHeading
        )
        self.map.addSource(source: source)
    }
    
    
    func moveToSelfPosition() {
        if self.locationService == nil {
            self.locationService = self.locationManagerFactory()
        }
        self.locationService?.getCurrentPosition { (coordinates) in
            self.moveToLocation(
                position: CameraPosition(
                    point: GeoPoint(
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
    
    func moveToLocation(position: CameraPosition, time: TimeInterval, animationType: CameraAnimationType) {
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
