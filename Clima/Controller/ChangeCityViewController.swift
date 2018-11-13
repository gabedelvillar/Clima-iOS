//
//  ChangeCityViewController.swift
//  Clima
//
//  Created by Gabriel Del VIllar on 10/21/18.
//  Copyright © 2018 gdelvillar. All rights reserved.
//

import UIKit
protocol ChangeCityDelegate {
  func userEnteredANewCityName (city: String)
}

class ChangeCityViewController: UIViewController {
  
  var delegate : ChangeCityDelegate?
  
  //IBOutlets
  @IBOutlet weak var chnageCityTextField: UITextField!

  @IBAction func getWeatherPressed(_ sender: Any) {
    
    let cityName = chnageCityTextField.text!
    
    delegate?.userEnteredANewCityName(city: cityName)
    
    self.dismiss(animated: true, completion: nil)
  }
  override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
  
  
  
  @IBAction func backButtonPressed(_ sender: Any) {
    self.dismiss(animated: true, completion: nil)
  }
  

}
