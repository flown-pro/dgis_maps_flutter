//
//  FlutterChannelService.swift
//  dgis_maps_flutter
//
//  Created by Михаил Колчанов on 22.01.2023.
//

import DGis

class DgisHostApi : NSObject, PluginHostApi {
    
    private let mapFactory : IMapFactory
    private let mapObjectService: MapObjectService
    private let cameraMoveService: CameraMoveService
    
    init(
        mapFactory : IMapFactory,
        mapObjectService: MapObjectService,
        cameraMoveService: CameraMoveService
    ) {
        self.mapFactory = mapFactory
        self.mapObjectService = mapObjectService
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
    
    func moveCamera(
        cameraPosition: DataCameraPosition,
        duration: Int?,
        cameraAnimationType: DataCameraAnimationType,
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
    
    func getVisibleArea() -> DataLatLngBounds {
        let bounds = mapFactory.map.camera.visibleArea.bounds
        return DataLatLngBounds(
            southwest: DataLatLng(
                latitude: bounds.southWestPoint.latitude.value,
                longitude: bounds.southWestPoint.longitude.value
            ),
            northeast: DataLatLng(
                latitude: bounds.northEastPoint.latitude.value,
                longitude: bounds.northEastPoint.longitude.value
            )
        )
    }
    
}
