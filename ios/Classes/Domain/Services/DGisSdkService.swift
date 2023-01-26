//
//  DGisSdkService.swift
//  dgis_maps_flutter
//
//  Created by Михаил Колчанов on 22.01.2023.
//

import DGis

class DGisSdkService {
    
    var sdk: DGis.Container
    var mapFactory : IMapFactory
    
    init(params: DataCreationParams?) {
        sdk = DGis.Container()
        var mapOptions = MapOptions.default
        mapOptions.deviceDensity = DeviceDensity(value: Float(UIScreen.main.nativeScale))
        if (params != nil) {
            let coordinate = GeoPoint(
                latitude: DGis.Latitude(value: params!.position.latitude),
                longitude: DGis.Longitude(value: params!.position.longitude)
            )
            let cameraPosition = CameraPosition(
                point: coordinate,
                zoom: Zoom(value: Float(params!.zoom))
            )
            mapOptions.position = cameraPosition
        }
        mapFactory = try! sdk.makeMapFactory(options: mapOptions)
    }
    
    
}
