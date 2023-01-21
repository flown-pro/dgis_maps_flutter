//
//  FlutterArgs.swift
//  dgis_maps_flutter_ios
//
//  Created by Михаил Колчанов on 19.01.2023.
//

import Foundation

struct FlutterArgs { //TODO: not final model
    let initLatitude: Double
    let initLongitude: Double
    let initZoom: Float
    
    init?(args: Any?) {
        if (args is Dictionary<String, Any>) {
            let _args = args as! Dictionary<String, Any>
            self.initLatitude = _args["initLatitude"] as! Double
            self.initLongitude = _args["initLongitude"] as! Double
            self.initZoom = _args["initZoom"] as! Float
        } else {
            return nil
        }
        
    }
    
}

