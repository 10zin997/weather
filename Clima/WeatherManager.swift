//
//  WeatherManager.swift
//  Clima
//
//  Created by Tenzin wangyal on 4/8/22.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation
import CoreLocation
protocol WeatherManagerDelegate {
    func didUpdateWeather (_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager{
    let weatherURL =
    "https://api.openweathermap.org/data/2.5/weather?appid=96b0c956a9a5bb59548f3c84ad08202b&units=imperial"
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName: String){
        let urlString = "\(weatherURL)&q=\(cityName)"
        print (urlString)
        performRequest(with: urlString)
    }
    func fetchWeather (latitude : CLLocationDegrees,longitude : CLLocationDegrees){
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: urlString)
        
    }
    
    
    func performRequest(with urlString : String){
        if let url = URL(string : urlString){
            let session = URLSession (configuration: .default)
            
            //perform closure
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if  let weather = self.parseJSON(safeData){
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                   
                    
                }
                
            }
            task.resume()
            
        }
        
    }
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            let weather = WeatherModel (conditionId :id , cityName: name , temperature : temp)
            return weather
        }catch{
            delegate?.didFailWithError(error: error)
            return nil
          
         }
        
    }
    
}
