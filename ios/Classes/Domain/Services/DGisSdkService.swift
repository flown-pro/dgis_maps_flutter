//
//  DGisSdkService.swift
//  dgis_maps_flutter
//
//  Created by Михаил Колчанов on 22.01.2023.
//

import DGis

class DGisSdkService {
    
    static let sdk = DGis.Container()
    var mapFactory : IMapFactory
    
    init(params: DataCreationParams?) {
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
            
            let lightTheme: Theme = "day"
            let darkTheme: Theme = "night"
            switch (params!.mapTheme) {
            case .auto:
                if #available(iOS 13.0, *) {
                    mapOptions.appearance = .automatic(light: lightTheme, dark: darkTheme)
                }
            case .dark:
                mapOptions.appearance = .universal(darkTheme)
            case .light:
                mapOptions.appearance = .universal(lightTheme)
            }
        }
        mapFactory = try! DGisSdkService.sdk.makeMapFactory(options: mapOptions)
    }
    
    
}
