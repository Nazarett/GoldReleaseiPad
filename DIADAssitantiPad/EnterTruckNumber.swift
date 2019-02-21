//
//  EnterTruckNumber.swift
//  DIADAssitantiPad
//
//  Created by Gerardo Nazarett on 1/28/19.
//  Copyright © 2019 Gerardo Nazarett. All rights reserved.
//

import UIKit

class EnterTruckNumber: UIViewController, UITextFieldDelegate {
    
    
    
    @IBOutlet weak var truckNumber: UITextField!
    
    @IBAction func nextButton(_ sender: Any) {
        
        if truckNumber.text == "" {
            let alert = UIAlertController(title: "Alert", message: "Please Fill In Truck Number", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func backToTruck(segue: UIStoryboardSegue){
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        truckNumber.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "passTruckNumber"{
            if truckNumber.text != "166962"{
                let alert = UIAlertController(title: "Alert", message: "Vehicle number needs to match", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(action)
                present(alert, animated: true, completion: nil)
                return false
            }
        }
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "passTruckNumber" {
            if let dvc = segue.destination as? EnterMiles{
                dvc.passTruckNumber = self.truckNumber.text
                
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var startString = ""
        if (truckNumber.text != nil){
            startString += truckNumber.text!
        }
        startString += string
        
        let limitNumber = startString.count
        if limitNumber > 6{
            return false
        }else{
            return true
        }
        
        //THIS WORKS ON PHYSICAL DEVICE ONLY.. ALLOWS USER TO ONLY ENTER NUMBERS INTO TEXTFIELD
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
        
    }
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
