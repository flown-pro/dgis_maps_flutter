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
    private var locationService: LocationService?
    
    private var moveCameraCancellable: DGis.Cancellable?
    
    init(
        locationManagerFactory: @escaping () -> LocationService?,
        map: Map,
        sdkContext: DGis.Context
    ) {
        self.locationManagerFactory = locationManagerFactory
        self.map = map
        
        
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
