//
//  ForgotPassword.swift
//  DIADAssitantiPad
//
//  Created by Gerardo Nazarett on 11/13/18.
//  Copyright © 2018 Gerardo Nazarett. All rights reserved.
//

import UIKit
import Firebase

class ForgotPassword: UIViewController {
    
    
    
    @IBOutlet weak var email: UITextField!
    
    
    
    @IBAction func forgotPassword(_ sender: Any) {
        
        Auth.auth().sendPasswordReset(withEmail: email.text!) { (error) in
            if let error = error{
                print(error)
            }else{
                let alert = UIAlertController(title: "Recovery Email Sent", message: "Please check your email to reset your password", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                    self.navigationController?.popToRootViewController(animated: true)
                    
                })
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            }
        }
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
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

