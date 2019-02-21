//
//  Helper.swift
//  DIADAssitantiPad
//
//  Created by Gerardo Nazarett on 11/13/18.
//  Copyright © 2018 Gerardo Nazarett. All rights reserved.
//

import UIKit
import Firebase

class Helper: UIViewController {
    
    @IBAction func toProfile(_ sender: Any) {
        self.performSegue(withIdentifier: "helperToProfile", sender: nil)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "helperToProfile"{
            if let uid = Auth.auth().currentUser?.uid{
                if let dvc = segue.destination as? Profile{
                    dvc.uid = uid
                }
            }
        }
    }
    
}
