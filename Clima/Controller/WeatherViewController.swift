//
//  ViewController.swift
//  Clima
//
//  Created by Gabriel Del VIllar on 10/21/18.
//  Copyright © 2018 gdelvillar. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON

class WeatherViewController: UIViewController, CLLocationManagerDelegate, ChangeCityDelegate {
  
  //Constants
  let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
  let APP_ID = "19db25138cd920d15359125fb23e24cd"
  
  let locationManager = CLLocationManager()
  let weatherDataModel = WeatherDataModel()
  
  
  //IBOutlets
  @IBOutlet weak var weatherIcon: UIImageView!
  @IBOutlet weak var cityLabel: UILabel!
  @IBOutlet weak var temperatureLabel: UILabel!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Set up of Location Manager
    locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
    locationManager.requestWhenInUseAuthorization()
    locationManager.startUpdatingLocation()
    
    
  }

  
  //MARK: - Networking
  /***************************************************************/
  // makes HTTP request for the data from OpenWeatherMap
  
  func getWeatherData(url: String, parameters: [String : String]){
    Alamofire.request(url, method: .get, parameters: parameters).responseJSON {
      response in
      if(response.result.isSuccess){
        print("Success! Get the weather data")
        
        let weatherJSON : JSON = JSON(response.result.value!)
        print(weatherJSON)
        self.updateWeatherData(json: weatherJSON)
        
      }
      else{
        print("Error \(String(describing: response.result.error))")
        
        self.cityLabel.text = "Connection Issues"
      }
    }
  }
  
  
  //MARK: - JSON Parsing
  /***************************************************************/
  // Parses the response we get from the OpenWeatherMap to display on APP
  func updateWeatherData(json: JSON){
    let tempResult = json["main"]["temp"].doubleValue
    
    weatherDataModel.temperature = Int(tempResult - 273.15)
    weatherDataModel.city = json["name"].stringValue
    weatherDataModel.condition = json["weather"][0]["id"].intValue
    weatherDataModel.weatherIconName = weatherDataModel.updateWeatherIcon(condition: weatherDataModel.condition)
    
    updateUIWithWeatherData()
  }
  
  
  //MARK: - UI Updates
  /***************************************************************/
  func updateUIWithWeatherData(){
    cityLabel.text = weatherDataModel.city
    temperatureLabel.text = "\(weatherDataModel.temperature)°"
    weatherIcon.image = UIImage(named: weatherDataModel.weatherIconName)
  }
  
  
  
  //MARK: - Location Manager Delegate Methods
  /***************************************************************/
  // Grabs current location and tells us lat and long of Iphone
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    let location = locations[locations.count - 1]
    if location.horizontalAccuracy > 0 {
      locationManager.stopUpdatingLocation()
      
      let latitude = String(location.coordinate.latitude)
      let longitude = String(location.coordinate.longitude)
      
      let params : [String : String] = ["lat" : latitude, "lon" : longitude, "appid" : APP_ID]
      
      getWeatherData(url: WEATHER_URL, parameters: params)
    }
  }
  
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    print(error)
    cityLabel.text = "Location Unavailable"
  }
  
  
  //MARK: - Change City Delegate methods
  /***************************************************************/
  // Passes data back and forth between ViewControllers
  
  func userEnteredANewCityName(city: String) {
    let params : [String : String] = ["q" : city, "appid" : APP_ID]
    
    getWeatherData(url: WEATHER_URL, parameters: params)
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if (segue.identifier == "changeCityName"){
      let destinationVC = segue.destination as! ChangeCityViewController
      
      destinationVC.delegate = self
    }
  }
}

