//
//  AttemptNumber.swift
//  DIADAssitantiPad
//
//  Created by Gerardo Nazarett on 1/31/19.
//  Copyright © 2019 Gerardo Nazarett. All rights reserved.
//

import UIKit
import Firebase

class AttemptNumber: UIViewController {
    
    let ref : DatabaseReference = Database.database().reference()
    
    
    
    @IBAction func doneButton(_ sender: Any) {
        if let uid = Auth.auth().currentUser?.uid{
            self.ref.child("badges").child(uid).child("house").observeSingleEvent(of: .value, with: { (snapshot) in
                let badgeInfo = snapshot.value as? NSDictionary
                let hasBadge = badgeInfo?["hasBadge"] as? Bool ?? false
                if !hasBadge{
                    self.ref.child("badges").child(uid).child("house").child("hasBadge").setValue(true, withCompletionBlock: { (error, reference) in
                        let currentDateTime = Date()
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "MM-dd-yyyy"
                        let date = dateFormatter.string(from: currentDateTime)
                        self.ref.child("badges").child(uid).child("house").child("badgeTime").setValue(date
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
