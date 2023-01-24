//
//  FlutterChannelService.swift
//  dgis_maps_flutter
//
//  Created by Михаил Колчанов on 22.01.2023.
//

import DGis

class DgisHostApi : NSObject, PluginHostApi {
    func asy(msg: LatLng, completion: @escaping (LatLng) -> Void) {
        addTestMarker()
    }
    
    func sy(msg: LatLng) -> LatLng {
      return LatLng(latitude: 0, longitude: 0)
    }
    
    
    private let sdk: DGis.Container
    private let mapFactory : IMapFactory
    private let mapFactoryProvider : IMapFactoryProvider
    private let mapObjectService: MapObjectService
    
    private let settingsService: ISettingsService
    private let cameraMoveService: CameraMoveService
    private var visibleRect: GeoRect?
    private var initialRectCancellable: DGis.Cancellable?
    
    
    static func register(with registrar: FlutterPluginRegistrar) {}
    
    init(
        sdk: DGis.Container,
        mapFactory: IMapFactory,
        mapFactoryProvider: IMapFactoryProvider,
        mapObjectService: MapObjectService,
        settingsService: ISettingsService,
        cameraMoveService: CameraMoveService
    ) {
        self.sdk = sdk
        self.mapFactory = mapFactory
        self.mapFactoryProvider = mapFactoryProvider
        self.mapObjectService = mapObjectService
        self.settingsService = settingsService
        self.cameraMoveService = cameraMoveService
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if let args = call.arguments as? Dictionary<String, Any> {
            print(call.method, args)
        } else {
            result(FlutterError.init(code: "bad args", message: nil, details: nil))
        }
    }
    
    
    func addTestMarker() {
        let flatPoint = mapFactory.map.camera.position.point
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
        let visibleRectChannel = mapFactory.map.camera.visibleRectChannel
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
