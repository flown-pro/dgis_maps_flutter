//
//  IconsService.swift
//  dgis_maps_flutter
//
//  Created by Михаил Колчанов on 19.01.2023.
//

import DGis
import CoreLocation

final class MapObjectService {
    
    
    enum MarkerSize: UInt {
        case small
        case medium
        case big
        
        mutating func next() {
            self = MarkerSize(rawValue: self.rawValue + 1) ?? .small
        }
        
        var scale: UIImage.SymbolScale {
            switch self {
            case .small: return .small
            case .medium: return .medium
            case .big: return .large
            }
        }
        
    }
    
    private struct TypeSize: Hashable {
        let image: UIImage
        let size: MarkerSize
    }
    
    ///
    
    @Published var size: MarkerSize = .medium
    
    private let imageFactory: IImageFactory
    private let mapFactory: IMapFactory
    private let context: DGis.Context
    
    private lazy var mapObjectManager: MapObjectManager = MapObjectManager(map: self.mapFactory.map)
    private lazy var myLocationSource: MyLocationMapObjectSource = MyLocationMapObjectSource(
        context: context,
        directionBehaviour: .followMagneticHeading
    )
    private var icons: [TypeSize: DGis.Image] = [:]
    
    
    init(dgisSdkService: DGisSdkService) {
        
        self.imageFactory = dgisSdkService.sdk.imageFactory
        self.mapFactory = dgisSdkService.mapFactory
        self.context = dgisSdkService.sdk.context
    }
    
    func toggleSelfMarker(isVisible: Bool) {
        if (isVisible) {
            self.mapFactory.map.addSource(source: myLocationSource)
        } else {
            self.mapFactory.map.removeSource(source: myLocationSource)
        }
    }
    
    
    func updateMarkers(markerUpdates: DataMarkerUpdates) {
        let toAdd = markerUpdates.toAdd.filter({ marker in
            marker != nil
        }).map { data2Marker(data: $0!) }
        let toRemove = markerUpdates.toRemove.filter({ marker in
            marker != nil
        }).map { data2Marker(data: $0!) }
        
        self.mapObjectManager.removeAndAddObjects(
            objectsToRemove: toRemove,
            objectsToAdd: toAdd
        )
    }
    
    private func data2Marker(data: DataMarker) -> DGis.Marker {
        let icon = data.bitmap == nil ? nil : makeIcon(bitmap: data.bitmap!, size: MarkerSize.medium)
        return DGis.Marker(
            options: MarkerOptions(
                position: GeoPointWithElevation(
                    latitude: Latitude(floatLiteral: data.position.latitude),
                    longitude: Longitude(floatLiteral: data.position.longitude)
                ),
                icon: icon,
                text: data.infoText
            )
        )
    }
    
    
    private func makeIcon(bitmap: DataMarkerBitmap, size: MarkerSize) -> DGis.Image? {
        let image = UIImage(data: Data(bitmap.bytes.data))
        if (image != nil) {
            let typeSize = TypeSize(image: image!, size: size)
            if let icon = self.icons[typeSize] {
                return icon
            } else if let scaledImage = image!.applyingSymbolConfiguration(.init(scale: size.scale)) {
                let icon = self.imageFactory.make(image: scaledImage)
                self.icons[typeSize] = icon
                return icon
            }
        }
        return nil
    }
    
    func updatePolylines(polylineUpdates: DataPolylineUpdates) {
        let toAdd = polylineUpdates.toAdd.filter({ line in
            line != nil
        }).map { data2Polyline(data: $0!) }
        let toRemove = polylineUpdates.toRemove.filter({ line in
            line != nil
        }).map { data2Polyline(data: $0!) }
        self.mapObjectManager.removeAndAddObjects(
            objectsToRemove: toRemove,
            objectsToAdd: toAdd
        )
    }
    
    private func data2Polyline(data: DataPolyline) -> DGis.Polyline {
        var points = [GeoPoint]()
        data.points.forEach(
            { p in
                if (p != nil) {
                    points.append(
                        GeoPoint(
                            latitude: p!.latitude,
                            longitude: p!.longitude
                        )
                    )
                }
            }
        )
        let options = DGis.PolylineOptions(
            points: points,
            width: LogicalPixel(value: Float(data.width)),
            color: DGis.Color(argb: UInt32(data.color))
        )
        return DGis.Polyline(options: options)
    }
    
    func removeAll() {
        self.mapObjectManager.removeAll()
    }
}
