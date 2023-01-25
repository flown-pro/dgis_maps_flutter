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
    
    
    func getCameraPosition() -> DataCameraPosition {
        let dgisPosition = mapFactory.map.camera.position
        let position = DataCameraPosition(
            bearing: dgisPosition.bearing.value,
            target: DataLatLng(
                latitude: dgisPosition.point.latitude.value,
                longitude: dgisPosition.point.longitude.value
            ),
            tilt: Double(dgisPosition.tilt.value),
            zoom: Double(dgisPosition.zoom.value)
        )
        return position
    }
    
    func moveCamera(cameraPosition: DataCameraPosition, duration: Int?, cameraAnimationType: DataCameraAnimationType, completion: @escaping () -> Void) {
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
    
    func updateMarkers(markerUpdates: DataMarkerUpdates) {
        mapObjectService.updateMarkers(markerUpdates: markerUpdates)
    }
    
    func updatePolylines(polylineUpdates: DataPolylineUpdates) {
        mapObjectService.updatePolylines(polylineUpdates: polylineUpdates)
    }
    
    func changeMyLocationLayerState(isVisible: Bool) {
        mapObjectService.toggleSelfMarker(isVisible: isVisible)
    }
    
}
