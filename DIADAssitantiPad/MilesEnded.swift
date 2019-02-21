//
//  MilesEnded.swift
//  DIADAssitantiPad
//
//  Created by Gerardo Nazarett on 1/28/19.
//  Copyright © 2019 Gerardo Nazarett. All rights reserved.
//

import UIKit

class MilesEnded: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var endedMiles: UITextField!
    
    
    @IBAction func nextButton(_ sender: Any) {
        if endedMiles.text == ""{
            let alert = UIAlertController(title: "Alert", message: "Please Fill In Miles", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        endedMiles.delegate = self
        self.navigationController?.navigationBar.isHidden = false
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "passFinishMiles"{
            if let dvc = segue.destination as? MilesEndedTwo{
                dvc.passFinishMiles = self.endedMiles.text
            }
        }
    }
    
    
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var startString = ""
        if (endedMiles.text != nil){
            startString += endedMiles.text!
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

