//
//  ViewController.swift
//  DIADAssitantiPad
//
//  Created by Gerardo Nazarett on 11/15/18.
//  Copyright © 2018 Gerardo Nazarett. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class ViewController: UIViewController {
    
    
    @IBAction func signInButton(_ sender: Any) {
        
    }
    
    
    @IBAction func signUpButton(_ sender: Any) {
        
        
        
    }
    
    
    
    @IBAction func signInBack(segue: UIStoryboardSegue){
        
    }
    
    @IBAction func signUpBack(segue: UIStoryboardSegue){
        
    }
    
    @IBAction func logOutUser(segue: UIStoryboardSegue){
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        //        backgroundImage.image = UIImage(cgImage: "HomePage" as! CGImage)
        //        backgroundImage.translatesAutoresizingMaskIntoConstraints = false
        //        backgroundImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        //        backgroundImage.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        //backgroundImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 1920).isActive = true
        
        
        //view.addSubview(backgroundImage)
        
        
        self.navigationController?.navigationBar.isHidden = false
        
        let _ : DatabaseReference = Database.database().reference()
        
        
        //        let preferences = UserDefaults.standard
        //        let emailKey = "email"
        //        let passwordKey = "password"
        //
        //        if preferences.object(forKey: emailKey) != nil && preferences.object(forKey: passwordKey) != nil {
        //            print("VIEW DID LOAD - email: \(preferences.object(forKey: emailKey)), password: \(preferences.object(forKey: passwordKey))")
        //        }else{
        //            print("preferences not saved")
        //
        //        }
        
        Auth.auth().addStateDidChangeListener { (auth
            , user) in
            
            if user != nil {
                //user exist.. sign in
                self.driverOrHelper()
                
            }else{
                //nobody here
            }
        }
        
        
        //self.navigationController?.isNavigationBarHidden = true
        
        
    }
    
    func driverOrHelper(){
        let ref : DatabaseReference = Database.database().reference()
        
        
        if let uid = Auth.auth().currentUser?.uid{
            //let dhValue = self.ref.child(uid).child("driverOrHelper")
            ref.child(uid).observeSingleEvent(of: .value) { (snapshot) in
                let value = snapshot.value as? NSDictionary
                let dhValue = value?["driverOrHelper"] as? String
                
                if dhValue == "Driver"{
                    //Perform toDriver segue
                    self.performSegue(withIdentifier: "toDriver", sender: nil)
                }else if dhValue == "Helper" {
                    //perform toHelper segue
                    self.performSegue(withIdentifier: "toHelper", sender: nil)
                    
                }
                
            }
            
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewDidAppear(true)
        
        
        
        
        
        
        //        let preferences = UserDefaults.standard
        //        let emailKey = "email"
        //        let passwordKey = "password"
        //
        //        if preferences.object(forKey: emailKey) != nil && preferences.object(forKey: passwordKey) != nil{
        //            print("VIEW WILL APPEAR - email: \(preferences.object(forKey: emailKey)), password: \(preferences.object(forKey: passwordKey))")
        //        }else{
        //            print("preferences not saved")
        //
        //        }
        //
        //        if let email = preferences.object(forKey: emailKey) as? String, let password = preferences.object(forKey: passwordKey) as? String{
        //            print("email: \(preferences.object(forKey: emailKey)), password: \(preferences.object(forKey: passwordKey))")
        //            Auth.auth().signIn(withEmail: email, password: password, completion: {
        //
        //                user, error in
        //
        //
        //                if error != nil{
        //
        //
        //                    let alert = UIAlertController(title: "Email Address/Password Incorrect", message: error?.localizedDescription, preferredStyle: .alert)
        //                    let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        //                    alert.addAction(action)
        //                    self.present(alert, animated: true, completion: nil)
        //
        //                }else{
        //
        //                    self.performSegue(withIdentifier: "autoLogIn", sender: nil)
        //
        //                }
        //
        //            })
        //
        //        }else{
        //            print("preferences not saved")
        //
        //        }
        
        
    }
    
    
    
    
    
}


