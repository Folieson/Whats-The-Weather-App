//
//  ViewController.swift
//  Whats The Weather App
//
//  Created by Андрей Понамарчук on 15.08.2018.
//  Copyright © 2018 Андрей Понамарчук. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var cityNameTextField: UITextField!
    @IBOutlet weak var weatherLabel: UILabel!
    
    @IBAction func submitButton(_ sender: Any) {
        if let cityNameString = cityNameTextField.text {
            let cityNameNSString = NSString(string: cityNameString)
            var cityNameWithoutSpaces = ""
            for element in cityNameNSString.components(separatedBy: " ") {
                cityNameWithoutSpaces += element
            }
            if let url = URL(string: "https://www.weather-forecast.com/locations/\(cityNameWithoutSpaces)/forecasts/latest") {
                let request = URLRequest(url: url)
                let task = URLSession.shared.dataTask(with: request) {
                    data, response, error in
                    if let error = error {
                        print(error)
                        self.weatherLabel.text = "The weather there couldn't be found. Please try again."
                    } else {
                        if let unwrappedData = data {
                            let dataNSString = NSString(data: unwrappedData, encoding: String.Encoding.utf8.rawValue)
                            if dataNSString!.contains("<span class=\"phrase\">") {
                                if let tmpDataString = dataNSString?.components(separatedBy: "<span class=\"phrase\">")[1] {
                                    let tmpDataNSString = NSString(string: tmpDataString)
                                    let weatherString = tmpDataNSString.components(separatedBy: "</span>")[0]
                                    let formatedWeatherString = weatherString.replacingOccurrences(of: "&deg;", with: "\u{00B0}")
                                    DispatchQueue.main.sync(execute: {
                                        self.weatherLabel.text = formatedWeatherString
                                    })
                                    
                                }
                            } else {
                                DispatchQueue.main.sync(execute: {
                                    self.weatherLabel.text = "The weather there couldn't be found. Please try again."
                                })
                                
                            }
                            

                        }
                    }
                }
                task.resume()
            }
        } else {
            self.weatherLabel.text = "The weather there couldn't be found. Please try again."
        }
    }
    
    //выключение клавиатуры, когда происходит касание области вне Text Field
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //функция, позволяющая выполнить определенные действия, когда на клавиатуре нажата клавиша return. В данном случае скрывается клавиатура
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

