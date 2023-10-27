//
//  DgisView.swift
//  dgis_maps_flutter
//
//  Created by Михаил Колчанов on 13.01.2023.
//

import Flutter
import UIKit
import SwiftUI
import DGis


class DGisNativeView: NSObject, FlutterPlatformView {    
    
    private var _view: UIView
    private let flutterApi: PluginFlutterApi
    
    init(
        mapViewFactory: MapViewFactory,
        flutterApi: PluginFlutterApi
    ) {
        _view = UIView()
        self.flutterApi = flutterApi
        super.init()
        
        let mapView = mapViewFactory.makeMapViewWithMarkerViewOverlay(
        tapRecognizerCallback: _onMapTapCallback)
            .edgesIgnoringSafeArea([.top, .bottom])
        let controller = UIHostingController(rootView: mapView)
        _view = controller.view
        flutterApi.onNativeMapReady(completion: {})
    }
    
    func _onMapTapCallback(objectInfo : RenderedObjectInfo) {
        self.flutterApi.onMapObjectTapCallback(renderedObjectInfo: objectInfo)
    }
    
    func view() -> UIView {
        return _view
    }
}
