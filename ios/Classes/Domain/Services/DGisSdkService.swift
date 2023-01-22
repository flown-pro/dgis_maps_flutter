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
    
    lazy var mapFactoryProvider = MapFactoryProvider(container: self.sdk, mapGesturesType: .default(.event))
    
    init() {
        sdk = DGis.Container()
        var mapOptions = MapOptions.default
        mapOptions.deviceDensity = DeviceDensity(value: Float(UIScreen.main.nativeScale))
//        if (flutterArgs != nil) {
//            let args = flutterArgs!
//            let coordinate = GeoPoint(
//                latitude: DGis.Latitude(value: args.initLatitude),
//                longitude: DGis.Longitude(value: args.initLongitude)
//            )
//            let cameraPosition = CameraPosition(
//                point: coordinate,
//                zoom: Zoom(value: args.initZoom)
//            )
//            mapOptions.position = cameraPosition
//        }
        mapFactory = try! sdk.makeMapFactory(options: mapOptions)
    }
    
    
}
