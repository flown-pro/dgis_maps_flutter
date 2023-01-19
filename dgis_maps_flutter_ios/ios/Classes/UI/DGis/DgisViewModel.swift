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
    var map : Map
    var iconsService: IconsService
    
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
    let locationServiceFactory = {
        LocationService()
    }
    var cameraMoveService: CameraMoveService
    var visibleRect: GeoRect?
    private var initialRectCancellable: DGis.Cancellable?
    
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
        map = mapFactory.map
        iconsService = IconsService(
            map: map,
            imageFactory: sdk.imageFactory
        )
        
        cameraMoveService = CameraMoveService(
            locationManagerFactory: locationServiceFactory,
            map: map,
            sdkContext: sdk.context
        )
        self.addTestMarker()
        self.startVisibleRectTracking()
    }
    
    func makeMapViewFactory() -> MapViewFactory {
        MapViewFactory(
            sdk: self.sdk,
            mapFactory: self.mapFactory,
            settingsService: self.settingsService
        )
    }
    
    func addTestMarker() {
        let flatPoint = self.map.camera.position.point
        let point = GeoPointWithElevation(
            latitude: flatPoint.latitude,
            longitude: flatPoint.longitude
        )
        iconsService.createMarker(
            geoPoint: point,
            image: UIImage(systemName: "camera.fill")!
                .withTintColor(.systemGray),
            text: "hello, world"
        )
    }
    
    func startVisibleRectTracking() {
        let visibleRectChannel = self.map.camera.visibleRectChannel
        self.initialRectCancellable = visibleRectChannel.sinkOnMainThread{ [weak self] rect in
            self?.updateVisibleRect(rect)
        }
    }
    
    func stopVisibleRectTracking() {
        self.initialRectCancellable?.cancel()
        self.initialRectCancellable = nil
    }
    
    
    func onMapTap(point: CGPoint) -> Void {
        cameraMoveService.moveToSelfPosition()
    }
    
    private func updateVisibleRect(_ rect: GeoRect) {
        visibleRect = rect
        print(rect)
    }
    
    
}

