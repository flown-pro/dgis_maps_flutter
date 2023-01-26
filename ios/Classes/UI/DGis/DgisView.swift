//
//  DgisView.swift
//  dgis_maps_flutter
//
//  Created by Михаил Колчанов on 13.01.2023.
//

import Flutter
import UIKit
import SwiftUI


class DGisNativeView: NSObject, FlutterPlatformView {    
    
    private var _view: UIView
    
    init(
        mapViewFactory: MapViewFactory,
        flutterApi: PluginFlutterApi
    ) {
        _view = UIView()
        super.init()
        let mapView = mapViewFactory.makeMapViewWithMarkerViewOverlay()
        let controller = UIHostingController(rootView: mapView)
        _view = controller.view
        flutterApi.onNativeMapReady(completion: {})
    }
    
    func view() -> UIView {
        return _view
    }
}
