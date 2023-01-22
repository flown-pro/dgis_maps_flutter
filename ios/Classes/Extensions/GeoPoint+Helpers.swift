//
//  GeoPoint+Helpers.swift
//  dgis_maps_flutter
//
//  Created by Михаил Колчанов on 19.01.2023.
//

import DGis

extension GeoPoint: CustomStringConvertible {

    public var description: String {
        "Latitude: \(self.latitude.value)\nLongitude: \(self.longitude.value)"
    }
}

extension GeoPointWithElevation: CustomStringConvertible {

    public var description: String {
        "Latitude: \(self.latitude.value)\nLongitude: \(self.longitude.value)\nElevation: \(self.elevation.value)"
    }
}
