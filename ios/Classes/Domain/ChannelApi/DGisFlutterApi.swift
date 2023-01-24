////
////  FlutterChannelService.swift
////  dgis_maps_flutter
////
////  Created by Михаил Колчанов on 22.01.2023.
////
//
//import DGis
//
//class DgisFlutterApi : NSObject, PluginFlutterApi {
//    
//    private let sdk: DGis.Container
//    private let mapFactory : IMapFactory
//    private let mapFactoryProvider : IMapFactoryProvider
//    private let mapObjectService: MapObjectService
//    
//    private let settingsService: ISettingsService
//    private let cameraMoveService: CameraMoveService
//    private var visibleRect: GeoRect?
//    private var initialRectCancellable: DGis.Cancellable?
//    
//    init(
//        sdk: DGis.Container,
//        mapFactory: IMapFactory,
//        mapFactoryProvider: IMapFactoryProvider,
//        mapObjectService: MapObjectService,
//        settingsService: ISettingsService,
//        cameraMoveService: CameraMoveService
//    ) {
//        self.sdk = sdk
//        self.mapFactory = mapFactory
//        self.mapFactoryProvider = mapFactoryProvider
//        self.mapObjectService = mapObjectService
//        self.settingsService = settingsService
//        self.cameraMoveService = cameraMoveService
//    }
//    
//   
//    func startVisibleRectTracking() {
//        let visibleRectChannel = mapFactory.map.camera.visibleRectChannel
//        self.initialRectCancellable = visibleRectChannel.sinkOnMainThread{ [weak self] rect in
//            self?.updateVisibleRect(rect)
//        }
//    }
//    
//    func stopVisibleRectTracking() {
//        self.initialRectCancellable?.cancel()
//        self.initialRectCancellable = nil
//    }
//    
//    
//    func onMapTap(point: CGPoint) -> Void {
//        cameraMoveService.moveToSelfPosition()
//    }
//    
//    private func updateVisibleRect(_ rect: GeoRect) {
//        visibleRect = rect
//        print(rect)
//    }
//    
//}
