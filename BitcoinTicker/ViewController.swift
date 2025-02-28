//
//  ViewController.swift
//  BitcoinTicker
//
//  Created by Angela Yu on 23/01/2016.
//  Copyright © 2016 London App Brewery. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    

    let baseURL = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC"
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    let currencySymbol = ["$", "R$", "$", "¥", "€", "£", "$", "Rp", "₪", "₹", "¥", "$", "kr", "$", "zł", "lei", "₽", "kr", "$", "$", "R"]
    var finalURL = ""
    var displaySymbol = ""

    //Pre-setup IBOutlets
    @IBOutlet weak var bitcoinPriceLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currencyPicker.delegate = self
        currencyPicker.dataSource = self
       
    }
    

    //MARK:  - UIPickerView delegate methods
    /**************************************************************/
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //print(row)
        finalURL = baseURL + currencyArray[row]
        displaySymbol = currencySymbol[row]
        print(finalURL)
        getBitcoinData(url: finalURL)
    }
    
    
    
    //MARK: - Networking
    /***************************************************************/
    func getBitcoinData(url: String) {
        Alamofire.request(url, method: .get).responseJSON { response in
            if response.result.isSuccess {
                print("Success! Got something... like a fish?")
                let bitcoinData: JSON = JSON(response.result.value)
                //print(bitcoinData)
                self.updateBitcoinData(json: bitcoinData)
                
            } else {
                print("Error: \(response.result.error)")
                self.bitcoinPriceLabel.text = "Oops"
                
            }
            
        }
    }
    
    
    
    //MARK: - JSON Parsing
    /***************************************************************/
    func updateBitcoinData(json: JSON) {
        
        if let bitcoinPrice = json["ask"].double {
            
            let doubleNumEditor = NumberFormatter()
            doubleNumEditor.numberStyle = .decimal
            let commaDoubleValue = doubleNumEditor.string(from: NSNumber(value: bitcoinPrice))
            
            bitcoinPriceLabel.text = "\(displaySymbol) \(commaDoubleValue!)"
            
        } else {
            bitcoinPriceLabel.text = "Price Unavailable"
        }
        
        
    }
    


}

