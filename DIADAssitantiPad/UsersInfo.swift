//
//  UsersInfo.swift
//  DIADAssitantiPad
//
//  Created by Gerardo Nazarett on 1/28/19.
//  Copyright © 2019 Gerardo Nazarett. All rights reserved.
//

import UIKit
import Firebase

class UsersInfo: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let ref : DatabaseReference = Database.database().reference()
    
    
    //    @IBOutlet weak var firstNameLabel: UILabel!
    //    @IBOutlet weak var lastNameLabel: UILabel!
    //    @IBOutlet weak var driverOrHelper: UILabel!
    //    @IBOutlet weak var badgesEarned: UILabel!
    
    
    var uid = ""
    var fullName = ""
    var doh = ""
    var timecard = [TimecardInfo]()
    var earnedBadges = ""
    
    @IBOutlet weak var myTableView: UITableView!
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //lastNameLabel.text = fullName
        print("FULL NAME: " + fullName)
        //driverOrHelper.text = doh
        
        self.navigationController?.navigationBar.isHidden = false
        
        ref.child("badges").child(uid).observeSingleEvent(of: .value) { (snapshot) in
            for child in (snapshot.children.allObjects as? [DataSnapshot])!{
                if self.earnedBadges == ""{
                    self.earnedBadges += child.key
                }else{
                    self.earnedBadges += ", \(child.key)"
                }
                
            }
            // self.badgesEarned.text = self.earnedBadges
        }
        
        
        
        
        ref.child("timecard").child(uid).observeSingleEvent(of: .value) { (snapshot) in
            for child in (snapshot.children.allObjects as? [DataSnapshot])!{
                let date = child.key
                for punchCard in (child.children.allObjects as? [DataSnapshot])!{
                    let card = punchCard.value as? NSDictionary
                    let punch = card!["punch"] as? String
                    let time = card!["time"] as? String
                    let newInfo = TimecardInfo(punch: punch!, date: date, time: time!)
                    self.timecard.append(newInfo)
                }
                
                
            }
            self.myTableView.reloadData()
            
        }
        
        
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.timecard.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "punchId", for: indexPath)
        
        let info = timecard[indexPath.row]
        cell.textLabel?.text = "\(info.date) at \(info.time)"
        cell.detailTextLabel?.text = info.punch
        
        return cell
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("prepare for segue")
        if segue.identifier == "toUserProfile"{
            print("identifier check")
            if let dvc = segue.destination as? Profile{
                print("dvc check")
                dvc.uid = uid
                
            }
        }
    }
    
    
}
