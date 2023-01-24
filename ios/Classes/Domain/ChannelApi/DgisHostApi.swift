//
//  FlutterChannelService.swift
//  dgis_maps_flutter
//
//  Created by Михаил Колчанов on 22.01.2023.
//

import DGis

class DgisHostApi : NSObject, PluginHostApi {
    
    
    
    private let sdk: DGis.Container
    private let mapFactory : IMapFactory
    private let mapFactoryProvider : IMapFactoryProvider
    private let mapObjectService: MapObjectService
    
    private let settingsService: ISettingsService
    private let cameraMoveService: CameraMoveService
    
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
    
    
    func getCameraPosition(completion: @escaping (CameraPosition) -> Void) {
        let dgisPosition = mapFactory.map.camera.position
        let position = CameraPosition(
            bearing: dgisPosition.bearing.value,
            target: LatLng(
                latitude: dgisPosition.point.latitude.value,
                longitude: dgisPosition.point.longitude.value
            ),
            tilt: Double(dgisPosition.tilt.value),
            zoom: Double(dgisPosition.zoom.value)
        )
        completion(position)
    }
    
    func moveCamera(
        cameraPosition: CameraPosition,
        duration: Int32?,
        cameraAnimationType: CameraAnimationType,
        completion: @escaping () -> Void
    ) {
        cameraMoveService.moveToLocation(
            position: DGis.CameraPosition(
                point: DGis.GeoPoint(
                    latitude: cameraPosition.target.latitude,
                    longitude: cameraPosition.target.longitude
                ),
                zoom: Zoom(floatLiteral: Float(cameraPosition.zoom)),
                tilt: Tilt(floatLiteral: Float(cameraPosition.tilt)),
                bearing: Bearing(floatLiteral: cameraPosition.bearing)
            ),
            time: Double(duration ?? 500) / 1000,
            animationType: DGis.CameraAnimationType.default //TODO: add CameraAnimationType enum support
        )
        completion()
    }
    
    func updateMarkers(markerUpdates: MarkerUpdates) {
        
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
    
}
