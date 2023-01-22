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
    
    @ObservedObject private var viewModel: DGisViewModel
    
    private var _view: UIView
    
    init(
        frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?,
        binaryMessenger messenger: FlutterBinaryMessenger?,
        dgisService: DGisSdkService,
        settingsService: ISettingsService
    ) {
        viewModel = DGisViewModel(
            arguments: args,
            binaryMessenger: messenger,
            dgisService: dgisService,
            settingsService:settingsService
        )
        _view = UIView()
        super.init()
        let controller = UIHostingController(rootView: makeMapView())
        _view = controller.view
    }
    
    private func makeMapView() -> some View {
        let mapView = viewModel.makeMapViewFactory()
//        return mapView.makeMapViewWithMarkerViewOverlay(tapRecognizerCallback: viewModel.onMapTap)
        return mapView.makeMapViewWithMarkerViewOverlay()
    }
    
    func view() -> UIView {
        return _view
    }
}
