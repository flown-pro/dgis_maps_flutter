//
//  DgisViewModel.swift
//  dgis_maps_flutter
//
//  Created by Михаил Колчанов on 19.01.2023.
//

import Flutter
import DGis


final class DGisViewModel: ObservableObject {
    
    private let dgisService: DGisSdkService
    private let settingsService: ISettingsService
    
//    var sdk: DGis.Container
//    var mapFactory : IMapFactory
//    var map : Map
//    var mapObjectService: MapObjectService
//    var flutterArgs: FlutterArgs?
//
//    lazy var mapFactoryProvider = MapFactoryProvider(container: self.sdk, mapGesturesType: .default(.event))
//    lazy var settingsStorage: IKeyValueStorage = UserDefaults.standard
//    lazy var settingsService: ISettingsService = {
//        let service = SettingsService(
//            storage: self.settingsStorage
//        )
//        service.onCurrentLanguageDidChange = { [weak self] in
//            self?.mapFactoryProvider.resetMapFactory()
//        }
//        return service
//    }()
//    let locationServiceFactory = {
//        LocationService()
//    }
//    var cameraMoveService: CameraMoveService
//    var visibleRect: GeoRect?
//    private var initialRectCancellable: DGis.Cancellable?
    
    init(
        arguments args: Any?,
        binaryMessenger messenger: FlutterBinaryMessenger?,
        dgisService: DGisSdkService,
        settingsService: ISettingsService
    ) {
        self.dgisService = dgisService
        self.settingsService = settingsService
//        flutterArgs = FlutterArgs(args: args)
//        sdk = DGis.Container()
//        var mapOptions = MapOptions.default
//        mapOptions.deviceDensity = DeviceDensity(value: Float(UIScreen.main.nativeScale))
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
//        mapFactory = try! sdk.makeMapFactory(options: mapOptions)
//        map = mapFactory.map
//        mapObjectService = MapObjectService(
//            map: map,
//            imageFactory: sdk.imageFactory
//        )
//        cameraMoveService = CameraMoveService(
//            locationManagerFactory: locationServiceFactory,
//            map: map,
//            sdkContext: sdk.context
//        )
    }
    
    
    func makeMapViewFactory() -> MapViewFactory {
        MapViewFactory(
            sdk: dgisService.sdk,
            mapFactory: dgisService.mapFactory,
            settingsService: settingsService
        )
    }
  
    
}

