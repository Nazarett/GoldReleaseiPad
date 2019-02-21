//
//  Admin.swift
//  DIADAssitantiPad
//
//  Created by Gerardo Nazarett on 1/28/19.
//  Copyright © 2019 Gerardo Nazarett. All rights reserved.
//

import UIKit
import Firebase

class Admin: UIViewController {
    //password: adminpassword
    
    
    
    
    let ref : DatabaseReference = Database.database().reference()
    
    @IBOutlet weak var adminEmail: UITextField!
    @IBOutlet weak var adminPassword: UITextField!
    
    
    @IBAction func signIn(_ sender: Any) {
        
        if self.adminEmail.text == "" || self.adminPassword.text == ""{
            
            let alert = UIAlertController(title: "Please Fill in the Fields", message: "Please Try Again", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }else{
            
            Auth.auth().signIn(withEmail: adminEmail.text!, password: adminPassword.text!, completion: {
                
                user, error in
                
                
                if error != nil{
                    
                    
                    let alert = UIAlertController(title: "Email or Password Incorrect", message: error?.localizedDescription, preferredStyle: .alert)
                    let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alert.addAction(action)
                    self.present(alert, animated: true, completion: nil)
                    
                }else{
                    
                    print("Sign in success")
                    
                    //self.performSegue(withIdentifier: "logInSuccess", sender: nil)
                    
                }
                
            })
            
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        
        
        //        Auth.auth().addStateDidChangeListener { (auth, user) in
        //            self.ref.child("admins").observeSingleEvent(of: .value, with: { (snapshot) in
        //                let adminUid = snapshot.value as? String
        //                if let uid = user?.uid{
        //                    if adminUid != uid{
        //                        //user not an admin
        //                        print("Not an admin")
        //                        let alert = UIAlertController(title: "Alert", message: "User does not have administrator access", preferredStyle: .alert)
        //                        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        //                        alert.addAction(action)
        //                        self.present(alert, animated: true, completion: nil)
        //
        //                    }else{
        //                        //admin
        //                        self.performSegue(withIdentifier: "adminSuccess", sender: self)
        //
        //
        //                    }
        //                }
        //            })
        //        }
        
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

