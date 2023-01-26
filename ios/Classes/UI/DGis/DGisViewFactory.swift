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
        var initParams : DataCreationParams?
//        if (args != nil) {
//            initParams = DataCreationParams.fromList(args as! [Any?])
//        }
        let dgisService = DGisSdkService(params: initParams)
        let settingsStorage = UserDefaults.standard
        let settingsService = SettingsService(
            storage: settingsStorage
        )
        settingsService.onCurrentLanguageDidChange = {
            dgisService.mapFactoryProvider.resetMapFactory()
        }
        let locationServiceFactory = {
            LocationService()
        }
        let map = dgisService.mapFactory.map
        let mapObjectService = MapObjectService(dgisSdkService: dgisService)
        let flutterApi = PluginFlutterApi(binaryMessenger: messenger, id: viewId)
        let cameraMoveService = CameraMoveService(
            locationManagerFactory: locationServiceFactory,
            map: map,
            flutterApi: flutterApi
        )
        let dgisHostApi = DgisHostApi(
            sdk: dgisService.sdk,
            mapFactory: dgisService.mapFactory,
            mapFactoryProvider: dgisService.mapFactoryProvider,
            mapObjectService: mapObjectService,
            settingsService: settingsService,
            cameraMoveService: cameraMoveService
        )
//        PluginHostApiSetup.setUp(
//            binaryMessenger: messenger,
//            id: viewId,
//            api: dgisHostApi
//        )

        return DGisNativeView(
            frame: frame,
            viewIdentifier: viewId,
            arguments: args,
            binaryMessenger: messenger,
            dgisService: dgisService,
            settingsService: settingsService,
            flutterApi: flutterApi
        )
    }
    
   
    
}
