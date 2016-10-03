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
        
        let params = ["q": location, "unit": translateUnit(unitTemp: temperatureUnit)]
    
         makeAPICall(url: constructAPIURL(baseURL: BaseURLs.currentWeather, params: params)) { (jsonDict, error) in
            if let jsonDict = jsonDict {
                callback(self.dictionaryToWeather(dict: jsonDict, unit: temperatureUnit), nil)
            }else{
                print(error?.localizedDescription)
                callback(nil, error)
            }
        }
    }
    
    func getWeatherForecast(location: String, temperatureUnit: TemeratureUnit = .fahrenheit, dayCount: Int=5, callback: @escaping ([Weather], Error?) -> ()) {
        
        let params = ["q": location, "unit": translateUnit(unitTemp: temperatureUnit), "cnt": String(dayCount)]
        
        makeAPICall(url: constructAPIURL(baseURL: BaseURLs.weatherForecast, params: params)) { (jsonDict, error) in
            if let jsonDict = jsonDict {
                callback(self.dictionaryToWeatherArray(dict: jsonDict, unit: temperatureUnit), nil)
            }else{
                print(error?.localizedDescription)
                callback([], error)
            }
        }
    }
    
    private func makeAPICall(url: URL, completion: @escaping ([String: Any]?, Error?) -> ()){
        
        let session: URLSession = URLSession.shared
        
        let task = session.dataTask(with: url, completionHandler: { data, response, error in
            if let data = data {

                let json = try! JSONSerialization.jsonObject(with: data) as! [String: Any]
                print("received json: \(json)")
                completion(json, nil)
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
    
    private func dictionaryToWeather(dict: [String: Any], unit: TemeratureUnit) -> Weather? {
        if let httpCode = dict["cod"] as? Int {
            if httpCode == 200 {
                let description = (((dict["weather"] as! NSArray)[0] as! NSDictionary)["description"] as! String)
                let tempMax = ((dict["main"] as! NSDictionary)["temp_max"] as! Double)
                let tempMin = ((dict["main"] as! NSDictionary)["temp_min"] as! Double)
                let tempAvg = ((dict["main"] as! NSDictionary)["temp"] as! Double)
                let date = (dict["dt"] as! Double)
                let tempUnit = unit
                
                let realDate = NSDate(timeIntervalSince1970: TimeInterval(date))
                
                return Weather(description: description, tempMax: tempMax, tempMin: tempMin, tempAverage: tempAvg, unit: tempUnit, date: realDate)
            }else{
                return nil
            }
        }else {
            print("optional binding failed")
            return nil
        }
    }
    
    private func dictionaryToWeatherArray(dict: [String: Any], unit: TemeratureUnit) -> [Weather] {
        if let httpCode = dict["cod"] as? String {
            if httpCode == "200" {
                
                let list = (dict["list"] as! NSArray)
                
                var forecast: [Weather] = [Weather]()
                
                for item in list {
                    
                    let description = ((((item as! NSDictionary)["weather"] as! NSArray)[0] as! NSDictionary)["description"] as! String)
                    let tempMax = (((item as! NSDictionary)["temp"] as! NSDictionary)["max"] as! Double)
                    let tempMin = (((item as! NSDictionary)["temp"] as! NSDictionary)["min"] as! Double)
                    let date = ((item as! NSDictionary)["dt"] as! Int)
                    let tempUnit = unit
                    
                    let realDate = NSDate(timeIntervalSince1970: TimeInterval(date))
                    
                    forecast.append(Weather(description: description, tempMax: tempMax, tempMin: tempMin, tempAverage: nil, unit: tempUnit, date: realDate))
                }
                
                return forecast
            }else{
                return []
            }
        }else {
            print("optional binding failed")
            return []
        }
    }
    
    struct Weather {
        let description: String
        let tempMax: Double
        let tempMin: Double
        let tempAverage: Double
        let unit: TemeratureUnit
        let date: NSDate
        
        init(description: String, tempMax: Double, tempMin: Double, tempAverage: Double?, unit: TemeratureUnit, date: NSDate) {
            self.description = description
            self.tempMax = tempMax
            self.tempMin = tempMin
            self.tempAverage = tempAverage ?? ((tempMax+tempMin)/2)
            self.unit = unit
            self.date = date
        }
    }
    
    enum TemeratureUnit {
        case fahrenheit
        case celsius
        case kelvin
    }
    
    enum BaseURLs {
        static let currentWeather = "http://api.openweathermap.org/data/2.5/weather"
        static let weatherForecast = "http://api.openweathermap.org/data/2.5/forecast/daily"
    }
}
