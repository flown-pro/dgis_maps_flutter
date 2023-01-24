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
    
    @Published var size: MarkerSize = .medium
    
    private let map: Map
    private let imageFactory: IImageFactory
    private lazy var mapObjectManager: MapObjectManager =
    MapObjectManager(map: self.map)
    
    private var icons: [TypeSize: DGis.Image] = [:]
    
    init(
        map: Map,
        imageFactory: IImageFactory
    ) {
        self.map = map
        self.imageFactory = imageFactory
    }
    
    func createMarker(geoPoint: GeoPointWithElevation, image: UIImage, text: String?) {
        let icon = self.makeIcon(
            image: image,
            size: self.size
        )
        
        let options = MarkerOptions(
            position: geoPoint,
            icon: icon,
            text: text
        )
        let marker = DGis.Marker(options: options)
        self.mapObjectManager.addObject(item: marker)
    }
    
    
    
    private func makeIcon(image: UIImage, size: MarkerSize) -> DGis.Image? {
        let typeSize = TypeSize(image: image, size: size)
        if let icon = self.icons[typeSize] {
            return icon
        } else if let scaledImage = image.applyingSymbolConfiguration(.init(scale: size.scale)) {
            let icon = self.imageFactory.make(image: scaledImage)
            self.icons[typeSize] = icon
            return icon
        } else {
            return nil
        }
    }
    
    func createPolyline(polyline: String, width: Float = 2, color: DGis.Color = DGis.Color.init()) {
        let coordinates: [CLLocationCoordinate2D]? = decodePolyline(polyline)
        var points = [GeoPoint]()
        coordinates?.forEach({ points.append(GeoPoint(latitude: $0.latitude, longitude: $0.longitude)) })
        
        // Line settings.
        let options = PolylineOptions(
            points: points,
            width: LogicalPixel(value: width),
            color: color
        )
        
        // Create and add the line to the map.
        let polyline = DGis.Polyline(options: options)
        self.mapObjectManager.addObject(item: polyline)
        
    }
    
    func removeAll() {
        self.mapObjectManager.removeAll()
    }
}
