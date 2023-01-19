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
    var mapObjectService: MapObjectService
    
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
        mapObjectService = MapObjectService(
            map: map,
            imageFactory: sdk.imageFactory
        )
        
        cameraMoveService = CameraMoveService(
            locationManagerFactory: locationServiceFactory,
            map: map,
            sdkContext: sdk.context
        )
        self.addTestMarker()
        self.addTestPolyline()
        self.startVisibleRectTracking()
    }
    
    func makeMapViewFactory() -> MapViewFactory {
        MapViewFactory(
            sdk: sdk,
            mapFactory: mapFactory,
            settingsService: settingsService
        )
    }
    
    func addTestMarker() {
        let flatPoint = self.map.camera.position.point
        let point = GeoPointWithElevation(
            latitude: flatPoint.latitude,
            longitude: flatPoint.longitude
        )
        mapObjectService.createMarker(
            geoPoint: point,
            image: UIImage(systemName: "camera.fill")!
                .withTintColor(.systemGray),
            text: "hello, world"
        )
    }
    
    func addTestPolyline() {
        mapObjectService.createPolyline(
            polyline: "miaz@}mvrVkez@?sbAgtcApu^_wXbubAucAdjErwg@ejE~|x@iuKfxv@y~u@?go`AidPwbg@inc@cmGehjBztdAkdPt~hA}vXpn~@?vs\\f~vA?||x@glXpqnBoi`B?qvwArcA",
            width: 4,
            color: DGis.Color.init(argb: 0x80FF0000)
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

