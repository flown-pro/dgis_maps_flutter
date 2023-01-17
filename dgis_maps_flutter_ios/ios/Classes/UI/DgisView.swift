//
//  DgisView.swift
//  dgis_maps_flutter_ios
//
//  Created by Михаил Колчанов on 13.01.2023.
//

import Flutter
import UIKit
import DGis
import SwiftUI

class DGisNativeViewFactory: NSObject, FlutterPlatformViewFactory {
    private var messenger: FlutterBinaryMessenger

    init(messenger: FlutterBinaryMessenger) {
        self.messenger = messenger
        super.init()
    }

    func create(
        withFrame frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?
    ) -> FlutterPlatformView {
        return DGisNativeView(
            frame: frame,
            viewIdentifier: viewId,
            arguments: args,
            binaryMessenger: messenger)
    }
}

class DGisNativeView: NSObject, FlutterPlatformView {
   
    private var _view: UIView
    private(set) lazy var sdk: DGis.Container = {
        return DGis.Container()
    }()
    
    private lazy var mapFactoryProvider = MapFactoryProvider(container: self.sdk, mapGesturesType: .default(.event))
    private lazy var settingsStorage: IKeyValueStorage = UserDefaults.standard
    private lazy var settingsService: ISettingsService = {
        let service = SettingsService(
            storage: self.settingsStorage
        )
        service.onCurrentLanguageDidChange = { [weak self] in
            self?.mapFactoryProvider.resetMapFactory()
        }
        return service
    }()
    
    private func makeMapView() -> some View {
        let coordinate = GeoPoint(latitude: 55.759909, longitude: 37.618806)
        let cameraPosition = CameraPosition(point: coordinate, zoom: Zoom(value: 17))
        var mapOptions = MapOptions.default
        mapOptions.position = cameraPosition
        mapOptions.deviceDensity = DeviceDensity(value: Float(UIScreen.main.nativeScale))
        let mapFactory = try! self.sdk.makeMapFactory(options: mapOptions)

        let mapView = makeMapViewFactory(mapFactory: mapFactory)
        return mapView.makeMapView()
    }

    private func makeMapViewFactory(mapFactory: IMapFactory) -> MapViewFactory {
        MapViewFactory(
            sdk: self.sdk,
            mapFactory: mapFactory,
            settingsService: self.settingsService
        )
    }
    
    init(
        frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?,
        binaryMessenger messenger: FlutterBinaryMessenger?
    ) {
        _view = UIView()
        super.init()
        // iOS views can be created here
        let controller = UIHostingController(rootView: makeMapView())
        _view = controller.view
    }

    func view() -> UIView {
        return _view
    }
}
