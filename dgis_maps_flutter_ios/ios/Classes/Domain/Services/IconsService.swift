//
//  IconsService.swift
//  dgis_maps_flutter_ios
//
//  Created by Михаил Колчанов on 19.01.2023.
//

import DGis

final class IconsService {
    
    
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
    
    func createMarker(geoPoint: GeoPointWithElevation, image: UIImage, text: String) {
        let icon = self.makeIcon(
            image: image,
            size: self.size
        )
        
        let options = MarkerOptions(
            position: geoPoint,
            icon: icon,
            text: text
        )
        let marker = Marker(options: options)
        self.mapObjectManager.addObject(item: marker)
    }
    
    func removeAll() {
        self.mapObjectManager.removeAll()
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
}
