//
//  ViewController.swift
//  OpenWeatherMapAPI-starter
//
//  Created by Nikolas Burk on 28/09/16.
//  Copyright © 2016 Nikolas Burk. All rights reserved.
//

import UIKit

class ViewController: UIViewController{
  
    @IBOutlet weak var maxTempLabel: UILabel!
    @IBOutlet weak var minTempLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var locationTextField: UITextField!
    
    let openWeatherMapAPI = OpenWeatherMapAPI()
  
    override func viewDidLoad() {
        super.viewDidLoad()
    }
  
    @IBAction func weatherButtonPressed(_ sender: AnyObject) {
        openWeatherMapAPI.getCurrentWeather(location: locationTextField.text!) { (weather, error) in
            
            if let error = error {
                print(error)
            }else{
                DispatchQueue.main.async {
                    self.maxTempLabel.text = "Max: \(weather!.tempMax ?? 0)"
                    self.minTempLabel.text = "Min: \(weather!.tempMin ?? 0)"
                    self.descriptionLabel.text = weather?.description ?? "?"
                }
            }
        }
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        openWeatherMapAPI.getCurrentWeather(location: locationTextField.text!) { (weather, error) in
            
            if let error = error {
                print(error)
            }else{
                DispatchQueue.main.async {
                    self.maxTempLabel.text = "Max: \(weather!.tempMax)"
                    self.minTempLabel.text = "Min: \(weather!.tempMin)"
                    self.descriptionLabel.text = weather?.description ?? "?"
                }
            }
        }
        return true
    }
}
