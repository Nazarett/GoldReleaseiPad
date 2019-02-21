//
//  MilesEndedTwo.swift
//  DIADAssitantiPad
//
//  Created by Gerardo Nazarett on 1/28/19.
//  Copyright © 2019 Gerardo Nazarett. All rights reserved.
//
import UIKit
import Firebase

class MilesEndedTwo: UIViewController {
    
    let ref : DatabaseReference = Database.database().reference()
    
    
    @IBOutlet weak var milesLabel: UILabel!
    
    var passFinishMiles : String!
    
    @IBAction func doneButton(_ sender: Any) {
        
        let finishedMiles = "\(milesLabel.text!)"
        
        if let uid = Auth.auth().currentUser?.uid{
            ref.child("users").child(uid).child("endedMiles").setValue(finishedMiles) { (error, reference) in
                if error != nil {
                    print(error?.localizedDescription as Any)
                }else{
                    
                    self.ref.child("badges").child(uid).child("redClock").observeSingleEvent(of: .value, with: { (snapshot) in
                        let badgeInfo = snapshot.value as? NSDictionary
                        let hasBadge = badgeInfo?["hasBadge"] as? Bool ?? false
                        if !hasBadge{
                            self.ref.child("badges").child(uid).child("redClock").child("hasBadge").setValue(true, withCompletionBlock: { (error, reference) in
                                let currentDateTime = Date()
                                let dateFormatter = DateFormatter()
                                dateFormatter.dateFormat = "MM-dd-yyyy"
                                let date = dateFormatter.string(from: currentDateTime)
                                self.ref.child("badges").child(uid).child("redClock").child("badgeTime").setValue(date
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        milesLabel.text = passFinishMiles
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = false
        
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

