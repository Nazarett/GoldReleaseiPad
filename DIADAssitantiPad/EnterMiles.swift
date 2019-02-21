//
//  EnterMiles.swift
//  DIADAssitantiPad
//
//  Created by Gerardo Nazarett on 1/28/19.
//  Copyright © 2019 Gerardo Nazarett. All rights reserved.
//

import UIKit
import Firebase

class EnterMiles: UIViewController, UITextFieldDelegate {
    
    let ref : DatabaseReference = Database.database().reference()
    
    var passTruckNumber : String!
    
    @IBOutlet weak var miles: UITextField!
    
    @IBOutlet weak var truckNumber: UILabel!
    
    
    @IBAction func doneButton(_ sender: Any) {
        
        
        if miles.text == ""{
            let alert = UIAlertController(title: "Alert", message: "Please Fill In Miles", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
        
        //ADD BADGE
        
        let truckAndMiles = "\(truckNumber.text!) - \(miles.text!)"
        
        if let uid = Auth.auth().currentUser?.uid{
            ref.child("users").child(uid).child("truckAndMiles").setValue(truckAndMiles) { (error, reference) in
                if error != nil {
                    print(error?.localizedDescription as Any)
                }else{
                    //put in logic so that badge doesn't keep showing up
                    self.ref.child("badges").child(uid).child("truckBadge").observeSingleEvent(of: .value, with: { (snapshot) in
                        let badgeInfo = snapshot.value as? NSDictionary
                        let hasBadge = badgeInfo?["hasBadge"] as? Bool ?? false
                        if !hasBadge{
                            self.ref.child("badges").child(uid).child("truckBadge").child("hasBadge").setValue(true, withCompletionBlock: { (error, reference) in
                                let currentDateTime = Date()
                                let dateFormatter = DateFormatter()
                                dateFormatter.dateFormat = "MM-dd-yyyy"
                                let date = dateFormatter.string(from: currentDateTime)
                                self.ref.child("badges").child(uid).child("truckBadge").child("badgeTime").setValue(date
                                    , withCompletionBlock: { (error, reference) in
                                        if error != nil{
                                            print(error?.localizedDescription as Any)
                                        }else{
                                            let alert = UIAlertController(title: "Good Job", message: "You've earned a badge!  It's located in your profile", preferredStyle: .alert)
                                            let action = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                                                //self.performSegue(withIdentifier: "backToTruck", sender: nil)
                                                _ = self.navigationController?.popToRootViewController(animated: true)
                                            })
                                            
                                            alert.addAction(action)
                                            self.present(alert, animated: true, completion: nil)
                                        }
                                })
                            })
                            
                            
                        }else{
                            let alert = UIAlertController(title: "Alert", message: "Badge already earned", preferredStyle: .alert)
                            let action = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                                _ = self.navigationController?.popToRootViewController(animated: true)
                            })
                            alert.addAction(action)
                            self.present(alert, animated: true, completion: nil)
                            //self.performSegue(withIdentifier: "backToTruck", sender: nil)
                            //_ = self.navigationController?.popToRootViewController(animated: true)
                            
                        }
                    })
                    
                    
                    
                    
                    
                    
                }
            }
        }
        
        
        
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        miles.delegate = self
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(true)
        truckNumber.text = passTruckNumber
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var startString = ""
        if (miles.text != nil){
            startString += miles.text!
        }
        startString += string
        
        let limitNumber = startString.count
        if limitNumber > 4{
            return false
        }else{
            return true
        }
        
        //THIS WORKS ON PHYSICAL DEVICE ONLY.. ALLOWS USER TO ONLY ENTER NUMBERS INTO TEXTFIELD
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
    }
    
    
}
