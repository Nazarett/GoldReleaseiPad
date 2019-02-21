//
//  SignIn.swift
//  DIADAssitantiPad
//
//  Created by Gerardo Nazarett on 11/13/18.
//  Copyright © 2018 Gerardo Nazarett. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class SignIn: UIViewController {
    
    @IBOutlet weak var upsEmail: UITextField!
    @IBOutlet weak var upsPassword: UITextField!
    
    let ref : DatabaseReference = Database.database().reference()
    
    
    
    @IBAction func bts(segue: UIStoryboardSegue){
        
    }
    
    @IBAction func signInButton(_ sender: Any) {
        
        if self.upsEmail.text == "" || self.upsPassword.text == ""{
            
            let alert = UIAlertController(title: "Please Fill in the Fields", message: "Please Try Again", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
            
            
        }else{
            
            Auth.auth().signIn(withEmail: upsEmail.text!, password: upsPassword.text!, completion: {
                
                user, error in
                
                
                if error != nil{
                    
                    
                    let alert = UIAlertController(title: "Email Address/Password Incorrect", message: error?.localizedDescription, preferredStyle: .alert)
                    let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alert.addAction(action)
                    self.present(alert, animated: true, completion: nil)
                    
                }else{
                    let preferences = UserDefaults.standard
                    let emailKey = "email"
                    let passwordKey = "password"
                    preferences.set(user?.user.email, forKey: emailKey)
                    preferences.set(self.upsPassword.text, forKey: passwordKey)
                    
                    _ = preferences.synchronize()
                    
                    
                    
                    //self.performSegue(withIdentifier: "logInSuccess", sender: nil)
                    self.driverOrHelper()
                }
                
            })
            
            
            
        }
        
    }
    
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //        if (segue.identifier == "logInSuccess"){
    //            _ = segue.destination as? PickDriverHelper
    //        }
    //    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        
        
        
        
        
    }
    
    @IBAction func logOutFromAdmin(segue: UIStoryboardSegue) {
        
    }
    
    @IBAction func backToSignIn(segue: UIStoryboardSegue){
        
    }
    
    
    func driverOrHelper(){
        if let uid = Auth.auth().currentUser?.uid{
            //let dhValue = self.ref.child(uid).child("driverOrHelper")
            ref.child("users").child(uid).observeSingleEvent(of: .value) { (snapshot) in
                let value = snapshot.value as? NSDictionary
                let dhValue = value?["driverOrHelper"] as? String
                
                if dhValue == "Driver"{
                    //Perform toDriver segue
                    self.performSegue(withIdentifier: "toDriver", sender: nil)
                }else if dhValue == "Helper" {
                    //perform toHelper segue
                    self.performSegue(withIdentifier: "toHelper", sender: nil)
                    
                }else if dhValue == "Admin"{
                    self.performSegue(withIdentifier: "toAdmin", sender: nil)
                }
                
            }
            
        }
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
