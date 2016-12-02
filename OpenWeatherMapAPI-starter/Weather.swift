//
//  Weather.swift
//  OpenWeatherMapAPI-starter
//
//  Created by fnord on 12/2/16.
//  Copyright © 2016 Nikolas Burk. All rights reserved.
//

import Foundation
import ObjectMapper

struct Context: MapContext {
    var unit: TemeratureUnit = .fahrenheit
}

enum TemeratureUnit {
    case fahrenheit
    case celsius
    case kelvin
}

class Weather: Mappable{
    var description: String!
    var tempMax: Double!
    var tempMin: Double!
    var tempAverage: Double!
    var unit: TemeratureUnit!
    var date: NSDate!
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        if let context = map.context as! Context?{
            unit = context.unit
        }
        
        description <- map["weather.0.description"]
        tempMax <- map["main.temp_max"]
        tempMin <- map["main.temp_min"]
        tempAverage <- map["main.temp"]
        date <- map["dt"]
    }
}
