//
//  DGisViewFactory.swift
//  dgis_maps_flutter
//
//  Created by Михаил Колчанов on 19.01.2023.
//

import Flutter
import UIKit
import DGis
import SwiftUI

class DgisNativeViewFactory: NSObject, FlutterPlatformViewFactory {
    private let messenger: FlutterBinaryMessenger
    
    init(messenger: FlutterBinaryMessenger) {
        self.messenger = messenger
        super.init()
    }
    
    func create(
        withFrame frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?
    ) -> FlutterPlatformView {
        var initParams : DataCreationParams?
        if (args != nil) {
            initParams = DataCreationParams.fromList(args as! [Any?])
        }
        let dgisService = DGisSdkService(params: initParams)
        
        let locationService = LocationService()
        let mapObjectService = MapObjectService(dgisSdkService: dgisService)
        let flutterApi = PluginFlutterApi(binaryMessenger: messenger, id: viewId)
        let cameraMoveService = CameraMoveService(
            mapFactory: dgisService.mapFactory,
            flutterApi: flutterApi,
            locationService: locationService
        )
        let dgisHostApi = DgisHostApi(
            mapFactory: dgisService.mapFactory,
            mapObjectService: mapObjectService,
            cameraMoveService: cameraMoveService
        )
        PluginHostApiSetup.setUp(
            binaryMessenger: messenger,
            id: viewId,
            api: dgisHostApi
        )
        let mapViewFactory = MapViewFactory(mapFactory: dgisService.mapFactory)
        return DGisNativeView(
            mapViewFactory: mapViewFactory,
            flutterApi: flutterApi
        )
    }
}
