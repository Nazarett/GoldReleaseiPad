//
//  InfoNotice.swift
//  DIADAssitantiPad
//
//  Created by Gerardo Nazarett on 1/31/19.
//  Copyright © 2019 Gerardo Nazarett. All rights reserved.
//

import UIKit
import Firebase

class InfoNotice: UIViewController, UITextFieldDelegate{
    
    let ref : DatabaseReference = Database.database().reference()
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var dateField: UITextField!
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacters = CharacterSet.letters
        let characterSet = CharacterSet(charactersIn: string)
        
        return allowedCharacters.isSuperset(of: characterSet)
    }
    
    
    @IBAction func doneButton(_ sender: Any) {
        
        
        if nameField.text == "" && dateField.text == "" {
            let alert = UIAlertController(title: "Alert", message: "Please fill in the required information", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
        
        
        
        let nameAndDate = "\(nameField.text!) - \(dateField.text!)"
        
        if let uid = Auth.auth().currentUser?.uid{
            ref.child("users").child(uid).child("nameAndDateInfoNotice").setValue(nameAndDate) { (error, reference) in
                if error != nil {
                    print(error?.localizedDescription as Any)
                }else{
                    //put in logic so that badge doesn't keep showing up
                    self.ref.child("badges").child(uid).child("infoBadge").observeSingleEvent(of: .value, with: { (snapshot) in
                        let badgeInfo = snapshot.value as? NSDictionary
                        let hasBadge = badgeInfo?["hasBadge"] as? Bool ?? false
                        if !hasBadge{
                            self.ref.child("badges").child(uid).child("infoBadge").child("hasBadge").setValue(true, withCompletionBlock: { (error, reference) in
                                let currentDateTime = Date()
                                let dateFormatter = DateFormatter()
                                dateFormatter.dateFormat = "MM-dd-yyyy"
                                let date = dateFormatter.string(from: currentDateTime)
                                self.ref.child("badges").child(uid).child("infoBadge").child("badgeTime").setValue(date
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
    
    
    @IBAction func unsureButton(_ sender: Any) {
        
        let alert = UIAlertController(title: "Instructions", message: "Please enter the Name and Package Information of the recipient, as well as your ID Number", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.nameField.delegate = self
        self.dateField.delegate = self
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
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

