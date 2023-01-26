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
    
    private var viewModel: DGisViewModel
    
    private var _view: UIView
    
    init(
        frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?,
        binaryMessenger messenger: FlutterBinaryMessenger?,
        dgisService: DGisSdkService,
        settingsService: ISettingsService,
        flutterApi: PluginFlutterApi
    ) {
        print(dgisService.mapFactory.mapView.bounds)
        viewModel = DGisViewModel(
//            arguments: args,
//            binaryMessenger: messenger,
            dgisService: dgisService
//            settingsService:settingsService
        )
        _view = UIView()
        super.init()
        let factory = MapViewFactory(
            dgisService: dgisService,
            mapFactory: dgisService.mapFactory,
            settingsService: settingsService
        )
        let mapView = factory.makeMapViewWithMarkerViewOverlay()
        let controller = UIHostingController(rootView: mapView)
        _view = controller.view
        flutterApi.onNativeMapReady(completion: {})
    }
    
    
    func view() -> UIView {
        return _view
    }
}
