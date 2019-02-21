//
//  CommercialPageTwo.swift
//  DIADAssitantiPad
//
//  Created by Gerardo Nazarett on 1/28/19.
//  Copyright © 2019 Gerardo Nazarett. All rights reserved.
//

import UIKit
import Firebase

class CommercialPageTwo: UIViewController, UITextFieldDelegate{
    
    let ref : DatabaseReference = Database.database().reference()
    
    
    @IBOutlet weak var roomNumber: UITextField!
    @IBOutlet weak var floorNumber: UITextField!
    
    
    
    @IBAction func doneButton(_ sender: Any) {
        
        
        if roomNumber.text == "" && floorNumber.text == ""{
            let alert = UIAlertController(title: "Alert", message: "Please fill in the required information", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
        
        
        let numbers = "\(roomNumber.text!) - \(floorNumber.text!)"
        
        if let uid = Auth.auth().currentUser?.uid{
            
            ref.child("users").child(uid).child("roomAndFloor").setValue(numbers) { (error, reference) in
                if error != nil {
                    print(error?.localizedDescription as Any)
                }else{
                    
                    self.ref.child("badges").child(uid).child("commercialBadge").observeSingleEvent(of: .value, with: { (snapshot) in
                        let badgeInfo = snapshot.value as? NSDictionary
                        let hasBadge = badgeInfo?["hasBadge"] as? Bool ?? false
                        if !hasBadge{
                            self.ref.child("badges").child(uid).child("commercialBadge").child("hasBadge").setValue(true, withCompletionBlock: { (error, reference) in
                                let currentDateTime = Date()
                                let dateFormatter = DateFormatter()
                                dateFormatter.dateFormat = "MM-dd-yyyy"
                                let date = dateFormatter.string(from: currentDateTime)
                                self.ref.child("badges").child(uid).child("commercialBadge").child("badgeTime").setValue(date
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
                                self.performSegue(withIdentifier: "showSig", sender: nil)
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
        
        roomNumber.delegate = self
        floorNumber.delegate = self
        
        
        
        // Do any additional setup after loading the view.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var startString = ""
        if (roomNumber.text != nil && floorNumber.text != nil){
            startString += roomNumber.text!
            startString += floorNumber.text!
        }
        startString += string
        
        let limitNumber = startString.count
        if limitNumber > 8{
            return false
        }else{
            return true
        }
        
        
        
    }
    
    
    
}
