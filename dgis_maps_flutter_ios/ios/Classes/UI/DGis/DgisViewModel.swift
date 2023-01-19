//
//  DgisViewModel.swift
//  dgis_maps_flutter_ios
//
//  Created by Михаил Колчанов on 19.01.2023.
//

import Flutter
import DGis


final class DGisViewModel: ObservableObject {
        
    var sdk: DGis.Container
    var mapFactory : IMapFactory
    
    lazy var mapFactoryProvider = MapFactoryProvider(container: self.sdk, mapGesturesType: .default(.event))
    lazy var settingsStorage: IKeyValueStorage = UserDefaults.standard
    lazy var settingsService: ISettingsService = {
        let service = SettingsService(
            storage: self.settingsStorage
        )
        service.onCurrentLanguageDidChange = { [weak self] in
            self?.mapFactoryProvider.resetMapFactory()
        }
        return service
    }()
    
    init(
        arguments args: Any?,
        binaryMessenger messenger: FlutterBinaryMessenger?
    ) {
        sdk = DGis.Container()
        let coordinate = GeoPoint(latitude: 55.759909, longitude: 37.618806)
        let cameraPosition = CameraPosition(point: coordinate, zoom: Zoom(value: 17))
        var mapOptions = MapOptions.default
        mapOptions.position = cameraPosition
        mapOptions.deviceDensity = DeviceDensity(value: Float(UIScreen.main.nativeScale))
        mapFactory = try! sdk.makeMapFactory(options: mapOptions)
    }
    
    func makeMapViewFactory() -> MapViewFactory {
        MapViewFactory(
            sdk: self.sdk,
            mapFactory: self.mapFactory,
            settingsService: self.settingsService
        )
    }
    
}

