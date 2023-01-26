//
//  DgisViewModel.swift
//  dgis_maps_flutter
//
//  Created by Михаил Колчанов on 19.01.2023.
//

import Flutter
import DGis


final class DGisViewModel {
    
    private let dgisService: DGisSdkService
//    private let settingsService: ISettingsService
    
    init(
//        arguments args: Any?,
//        binaryMessenger messenger: FlutterBinaryMessenger?,
        dgisService: DGisSdkService
//        settingsService: ISettingsService
    ) {
        self.dgisService = dgisService
//        self.settingsService = settingsService
    }
    
    
//    func makeMapViewFactory() -> MapViewFactory {
//        MapViewFactory(
//            sdk: dgisService.sdk,
//            mapFactory: dgisService.mapFactory,
//            settingsService: settingsService
//        )
//    }
    
}

