//
//  Channel+Helpers.swift
//  dgis_maps_flutter_ios
//
//  Created by Михаил Колчанов on 19.01.2023.
//

import SwiftUI
import DGis

extension Channel {
    @inlinable public func sinkOnMainThread(receiveValue: @escaping (Value) -> Void) -> DGis.Cancellable {
        self.sink { value in
            DispatchQueue.main.async {
                receiveValue(value)
            }
        }
    }
}
