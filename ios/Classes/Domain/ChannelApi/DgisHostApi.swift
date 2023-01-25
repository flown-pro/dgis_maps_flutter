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
            time: Double(duration ?? 300) / 1000,
            dataAnimationType: cameraAnimationType
        )
        completion()
    }
    
    func moveCameraToBounds(
        firstPoint: DataLatLng,
        secondPoint: DataLatLng,
        padding: DataPadding,
        duration: Int?,
        cameraAnimationType: DataCameraAnimationType,
        completion: @escaping () -> Void
    ) {
        var animationType = DGis.CameraAnimationType.default
        let geometry = ComplexGeometry(
            geometries: [
                PointGeometry(
                    point: GeoPoint(
                        latitude: firstPoint.latitude,
                        longitude: firstPoint.longitude
                    )
                ),
                PointGeometry(
                    point: GeoPoint(
                        latitude: secondPoint.latitude,
                        longitude: secondPoint.longitude
                    )
                )
            ]
        )
        let position = calcPosition(
            camera: mapFactory.map.camera,
            geometry: geometry,
            padding: Padding(
                left: UInt32(padding.left),
                top: UInt32(padding.top),
                right: UInt32(padding.right),
                bottom: UInt32(padding.bottom)
            )
        )
        cameraMoveService.moveToLocation(
            position: position,
            time: Double(duration ?? 300) / 1000,
            dataAnimationType: cameraAnimationType
        )
        completion()
    }
    
    func updateMarkers(updates: DataMarkerUpdates) {
        mapObjectService.updateMarkers(markerUpdates: updates)
    }
    
    func updatePolylines(updates: DataPolylineUpdates) {
        mapObjectService.updatePolylines(polylineUpdates: updates)
    }
    
    func changeMyLocationLayerState(isVisible: Bool) {
        mapObjectService.toggleSelfMarker(isVisible: isVisible)
    }
    
}
