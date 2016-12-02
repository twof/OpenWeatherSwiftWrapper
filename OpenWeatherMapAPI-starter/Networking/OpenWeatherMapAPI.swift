//
//  OpenWeatherMapAPI.swift
//  OpenWeatherMapAPI-starter
//
//  Created by Nikolas Burk on 28/09/16.
//  Copyright © 2016 Nikolas Burk. All rights reserved.
//

import Foundation

class OpenWeatherMapAPI {
    
    func getCurrentWeather(location: String, temperatureUnit: TemeratureUnit = .fahrenheit, callback: @escaping (Weather?, Error?) -> ()) {
        
        let params = ["q": location, "units": translateUnit(unitTemp: temperatureUnit)]
    
         makeAPICall(url: constructAPIURL(baseURL: BaseURLs.currentWeather, params: params)) { (jsonString, error) in
            if let jsonString = jsonString {
                callback(Weather(JSONString: jsonString, context: Context(unit: temperatureUnit)) , nil)
            }else{
                print(error?.localizedDescription ?? "An Error occured")
                callback(nil, error)
            }
        }
    }
    
//    func getWeatherForecast(location: String, temperatureUnit: TemeratureUnit = .fahrenheit, dayCount: Int=5, callback: @escaping ([Weather], Error?) -> ()) {
//        
//        let params = ["q": location, "unit": translateUnit(unitTemp: temperatureUnit), "cnt": String(dayCount)]
//        
//        makeAPICall(url: constructAPIURL(baseURL: BaseURLs.weatherForecast, params: params)) { (jsonDict, error) in
//            if let jsonDict = jsonDict {
//                callback(self.dictionaryToWeatherArray(dict: jsonDict, unit: temperatureUnit), nil)
//            }else{
//                print(error?.localizedDescription ?? "An Error occured")
//                callback([], error)
//            }
//        }
//    }
    
    private func makeAPICall(url: URL, completion: @escaping (String?, Error?) -> ()){
        
        let session: URLSession = URLSession.shared
        
        let task = session.dataTask(with: url, completionHandler: { data, response, error in
            if let data = data {
                let jsonString = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
                
                completion(jsonString as String?, nil)
            }
            else {
                print("no data received: \(error)")
                completion(nil, error)
            }
            
        })
        task.resume()
    }
    
    //URL construct URLs from bases
    private func constructAPIURL(baseURL: String, params: [String: String]) -> URL{
        var newURL = baseURL + "?"
        
        for (key, value) in params {
            newURL += (key + "=" + value)
            newURL += "&"
        }
        
        newURL+="appid=" + Keys.openWeatherAPIKey
        
        return URL(string: newURL)!
    }
    
    private func translateUnit(unitTemp: TemeratureUnit) -> String{
        var unitString: String
        switch unitTemp {
        case .celsius:
            unitString = "metric"
        case .fahrenheit:
            unitString = "imperial"
        default:
            unitString = "anything"
        }
        
        return unitString
    }
    
//    private func dictionaryToWeatherArray(dict: [String: Any], unit: TemeratureUnit) -> [Weather] {
//        if let httpCode = Int((dict["cod"] as? String)!) {
//            if httpCode == 200 {
//                
//                let list = (dict["list"] as! NSArray)
//                
//                var forecast: [Weather] = [Weather]()
//                
//                for item in list {
//                    
//                    let description = ((((item as! NSDictionary)["weather"] as! NSArray)[0] as! NSDictionary)["description"] as! String)
//                    let tempMax = (((item as! NSDictionary)["temp"] as! NSDictionary)["max"] as! Double)
//                    let tempMin = (((item as! NSDictionary)["temp"] as! NSDictionary)["min"] as! Double)
//                    let date = ((item as! NSDictionary)["dt"] as! Int)
//                    let tempUnit = unit
//                    
//                    let realDate = NSDate(timeIntervalSince1970: TimeInterval(date))
//                    
//                    forecast.append(Weather(description: description, tempMax: tempMax, tempMin: tempMin, tempAverage: nil, unit: tempUnit, date: realDate))
//                }
//                
//                return forecast
//            }else{
//                return []
//            }
//        }else {
//            print("optional binding failed")
//            return []
//        }
//    }
    
    enum BaseURLs {
        static let currentWeather = "http://api.openweathermap.org/data/2.5/weather"
        static let weatherForecast = "http://api.openweathermap.org/data/2.5/forecast/daily"
    }
}
