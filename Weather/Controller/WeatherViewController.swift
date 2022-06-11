//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var conditionImageView: UIImageView! //the weather icon
    @IBOutlet weak var temperatureLabel: UILabel!       //the temperature
    @IBOutlet weak var cityLabel: UILabel!              //city name
    @IBOutlet weak var searchTextField: UITextField!    //search field
    
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        weatherManager.delegate = self
        searchTextField.delegate = self
        // Do any additional setup after loading the view.
    }

    @IBAction func locationPressed(_ sender: UIButton) { //current location button
        locationManager.requestLocation()
    }
}
extension WeatherViewController : UITextFieldDelegate{
@IBAction func searchPressed(_ sender: UIButton) { //search button
    searchTextField.endEditing(true)
    print (searchTextField.text!)
}
func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    searchTextField.endEditing(true)
    print (searchTextField.text!)
    return true
}
func textFieldDidEndEditing(_ textField: UITextField) {
    if let city = searchTextField.text{
        weatherManager.fetchWeather(cityName: city)
    }
    searchTextField.text = ""
}


func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
    if textField.text != ""{
        return true
    }else{
        textField.placeholder = "Type Location"
        return false
    }
}
}

//MARK : - WeatherManagerDelegate

extension WeatherViewController : WeatherManagerDelegate {
    func didUpdateWeather (_ weatherManager: WeatherManager, weather: WeatherModel){
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.temperatureString
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            self.cityLabel.text=weather.cityName
        }
    }
    func didFailWithError(error: Error) {
        print(error)
    }
}
//MARK : - CLLocationManager
extension WeatherViewController : CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fetchWeather(latitude : lat,longitude : lon)
            
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print (error)
    }
}
