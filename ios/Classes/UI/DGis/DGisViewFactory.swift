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
        
        let dgisService = DGisSdkService()
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
        let mapObjectService = MapObjectService(
            map: map,
            imageFactory: dgisService.sdk.imageFactory
        )
        let cameraMoveService = CameraMoveService(
            locationManagerFactory: locationServiceFactory,
            map: map,
            sdkContext: dgisService.sdk.context
        )
        let dgisHostApi = DgisHostApi(
            sdk: dgisService.sdk,
            mapFactory: dgisService.mapFactory,
            mapFactoryProvider: dgisService.mapFactoryProvider,
            mapObjectService: mapObjectService,
            settingsService: settingsService,
            cameraMoveService: cameraMoveService
        )
        PluginHostApiSetup.setUp(
            binaryMessenger: messenger,
            id: viewId,
            api: dgisHostApi
        )

        return DGisNativeView(
            frame: frame,
            viewIdentifier: viewId,
            arguments: args,
            binaryMessenger: messenger,
            dgisService: dgisService,
            settingsService: settingsService
        )
    }
    
   
    
}
