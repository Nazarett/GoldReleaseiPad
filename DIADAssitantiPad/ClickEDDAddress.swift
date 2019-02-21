//
//  ClickEDDAddress.swift
//  DIADAssitantiPad
//
//  Created by Gerardo Nazarett on 1/28/19.
//  Copyright © 2019 Gerardo Nazarett. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import Firebase
import FirebaseDatabase


class ClickEDDAddress: UIViewController {
    
    @IBAction func goToAddress(_ sender: Any) {
        
        let latitiude : CLLocationDegrees = 25.942923
        let longitude : CLLocationDegrees = -80.145736
        
        let distance : CLLocationDistance = 1000
        let coordinates = CLLocationCoordinate2DMake(latitiude, longitude);
        
        let span = MKCoordinateRegion(center: coordinates, latitudinalMeters: distance, longitudinalMeters: distance)
        
        let options = [MKLaunchOptionsMapCenterKey : NSValue(mkCoordinate: span.center), MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: span.span)]
        
        let pin = MKPlacemark(coordinate: coordinates)
        let item = MKMapItem(placemark: pin)
        
        item.name = "18061 Biscayne"
        item.openInMaps(launchOptions: options)
    }
    
    let ref : DatabaseReference = Database.database().reference()
    
    @IBAction func doneButtion(_ sender: Any) {
        
        if let uid = Auth.auth().currentUser?.uid{
            
            self.ref.child("badges").child(uid).child("locationBadge").observeSingleEvent(of: .value, with: { (snapshot) in
                let badgeInfo = snapshot.value as? NSDictionary
                let hasBadge = badgeInfo?["hasBadge"] as? Bool ?? false
                if !hasBadge{
                    self.ref.child("badges").child(uid).child("locationBadge").child("hasBadge").setValue(true, withCompletionBlock: { (error, reference) in
                        let currentDateTime = Date()
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "MM-dd-yyyy"
                        let date = dateFormatter.string(from: currentDateTime)
                        self.ref.child("badges").child(uid).child("locationBadge").child("badgeTime").setValue(date
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

