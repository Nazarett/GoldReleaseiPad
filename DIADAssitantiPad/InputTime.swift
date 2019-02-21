//
//  InputTime.swift
//  DIADAssitantiPad
//
//  Created by Gerardo Nazarett on 1/31/19.
//  Copyright © 2019 Gerardo Nazarett. All rights reserved.
//

import UIKit
import Firebase


class InputTime: UIViewController, UITextFieldDelegate {
    
    let ref : DatabaseReference = Database.database().reference()
    
    
    
    
    @IBOutlet weak var tripHour: UITextField!
    @IBOutlet weak var tripMinute: UITextField!
    
    
    
    
    @IBAction func doneButton(_ sender: Any) {
        
        
        if tripHour.text == "" && tripMinute.text == "" {
            let alert = UIAlertController(title: "Alert", message: "Please fill in required fields", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
        
        
        if let uid = Auth.auth().currentUser?.uid{
            let hoursAndMinutes = "\(tripHour.text!) - \(tripMinute.text!)"
            
            ref.child("users").child(uid).child("hoursAndMinutes").setValue(hoursAndMinutes) { (error, reference) in
                if error != nil {
                    print(error?.localizedDescription as Any)
                }else{
                    self.ref.child("badges").child(uid).child("greenClock").observeSingleEvent(of: .value, with: { (snapshot) in
                        let badgeInfo = snapshot.value as? NSDictionary
                        let hasBadge = badgeInfo?["hasBadge"] as? Bool ?? false
                        if !hasBadge{
                            self.ref.child("badges").child(uid).child("greenClock").child("hasBadge").setValue(true, withCompletionBlock: { (error, reference) in
                                let currentDateTime = Date()
                                let dateFormatter = DateFormatter()
                                dateFormatter.dateFormat = "MM-dd-yyyy"
                                let date = dateFormatter.string(from: currentDateTime)
                                self.ref.child("badges").child(uid).child("greenClock").child("badgeTime").setValue(date
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tripHour.delegate = self
        tripMinute.delegate = self
        
        self.navigationController?.navigationBar.isHidden = false
        
        // Do any additional setup after loading the view.
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var startString = ""
        if (tripHour.text != nil && tripMinute.text != nil){
            startString += tripHour.text!
            startString += tripMinute.text!
        }
        startString += string
        
        let limitNumber = startString.count
        if limitNumber > 4{
            return false
        }else{
            return true
        }
        
    }
    
}
