//
//  ViewController.swift
//  OpenWeatherMapAPI-starter
//
//  Created by Nikolas Burk on 28/09/16.
//  Copyright © 2016 Nikolas Burk. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  
  let openWeatherMapAPI = OpenWeatherMapAPI()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    openWeatherMapAPI.requestCurrentWeather()
  }
  
  
  
}

