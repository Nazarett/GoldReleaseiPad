//
//  PunchInOut.swift
//  DIADAssitantiPad
//
//  Created by Gerardo Nazarett on 11/13/18.
//  Copyright © 2018 Gerardo Nazarett. All rights reserved.
//

import UIKit
import Firebase

class PunchInOut: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    
    var ref : DatabaseReference!
    let uid = Auth.auth().currentUser?.uid
    
    @IBOutlet weak var inOutText: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var punch: UIButton!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    var punchedIn = false
    
    
    
    var uidString = ""
    var fullName = ""
    var doh = ""
    var timecard = [TimecardInfo]()
    
    
    @IBOutlet weak var myTableView: UITableView!
    
    
    @IBAction func punchInButton(_ sender: Any) {
        //get current time and post to time label
        //change inoutText to in/out
        
        let currentDateTime = Date()
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .none
        let timeText = formatter.string(from: currentDateTime)
        time.text = timeText
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy"
        let date = dateFormatter.string(from: currentDateTime)
        dateLabel.text = date
        let timecardRef = self.ref.child("timecard").child(self.uid!).child(date).childByAutoId()
        
        if punchedIn{
            //            timecardRef.child("punch").setValue("punchedIn")
            //            timecardRef.child("time").setValue(timeText)
            //            self.ref.child("users").child(self.uid!).child("punch").setValue("punchedIn")
            //            self.ref.child("users").child(self.uid!).child("punchTime").setValue(timeText)
            //            inOutText.text = "Punched In At: "
            //            punch.setTitle("Punch Out", for: .normal)
            
            timecardRef.child("punch").setValue("punchedOut")
            timecardRef.child("time").setValue(timeText)
            self.ref.child("users").child(self.uid!).child("punch").setValue("punchedOut")
            self.ref.child("users").child(self.uid!).child("punchTime").setValue(timeText)
            inOutText.text = "Punched Out At: "
            punch.setTitle("Punch In", for: .normal)
            
        }else{
            timecardRef.child("punch").setValue("punchedIn")
            timecardRef.child("time").setValue(timeText)
            self.ref.child("users").child(self.uid!).child("punch").setValue("punchedIn")
            self.ref.child("users").child(self.uid!).child("punchTime").setValue(timeText)
            
            inOutText.text = "Punched In At: "
            punch.setTitle("Punch Out", for: .normal)
            
            //            timecardRef.child("punch").setValue("punchedOut")
            //            timecardRef.child("time").setValue(timeText)
            //            self.ref.child("users").child(self.uid!).child("punch").setValue("punchedOut")
            //            self.ref.child("users").child(self.uid!).child("punchTime").setValue(timeText)
            //            inOutText.text = "Punched Out At: "
            //            punch.setTitle("Punch In", for: .normal)
        }
        
        punchedIn = !punchedIn
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    
    
    @IBAction func showTable(_ sender: Any) {
        
        if self.myTableView.isHidden == true{
            self.myTableView.isHidden = false
        }else if self.myTableView.isHidden == false{
            self.myTableView.isHidden = true
        }
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.myTableView.isHidden = true
        
        // Do any additional setup after loading the view.
        
        ref = Database.database().reference()
        ref.child("users").child(uid!).observeSingleEvent(of: .value) { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let punchStatus = value?["punch"] as? String
            let punchTime = value?["punchTime"] as? String
            self.time.text = punchTime
            print(punchTime as Any)
            if punchStatus == "punchedIn"{
                self.punchedIn = true
                self.inOutText.text = "Punched In At: "
                self.punch.setTitle("Punch Out", for: .normal)
                
                
            }else if punchStatus == "punchedOut"{
                self.punchedIn = false
                self.inOutText.text = "Punched Out At: "
                self.punch.setTitle("Punch In", for: .normal)
                
            }else{
                self.punchedIn = false
                self.inOutText.text = "Please Punch In"
                self.punch.setTitle("Punch In", for: .normal)
            }
            
        }
        
        
        ref.child("timecard").child(uid!).observeSingleEvent(of: .value) { (snapshot) in
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
    
    
    
    
}

