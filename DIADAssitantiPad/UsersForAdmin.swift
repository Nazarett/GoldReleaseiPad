//
//  UsersForAdmin.swift
//  DIADAssitantiPad
//
//  Created by Gerardo Nazarett on 1/28/19.
//  Copyright © 2019 Gerardo Nazarett. All rights reserved.
//

import UIKit
import Firebase

class UsersForAdmin: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    let ref : DatabaseReference = Database.database().reference()
    
    @IBAction func backToAdminFromOther(segue: UIStoryboardSegue){
        
    }
    
    @IBOutlet weak var myTableView: UITableView!
    
    var users = [ListUser]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myTableView.dataSource = self
        myTableView.delegate = self
        
        self.navigationController?.navigationBar.isHidden = true
        
        ref.child("users").observe(.value) { (snapshot) in
            //let userList = snapshot.value as? NSDictionary
            for userSnapshot in (snapshot.children.allObjects as? [DataSnapshot])!{
                let user = userSnapshot.value as? NSDictionary
                let uid = userSnapshot.key
                let first = user?["firstName"] as? String
                let last = user?["lastName"] as? String
                let doh = user?["driverOrHelper"] as? String
                let name = first! + " " +  last!
                let newUser = ListUser(name: name,
                                       doh: doh!,
                                       uid: uid)
                self.users.append(newUser)
                
                
            }
            
            self.myTableView.reloadData()
            
        }
        
        
    }
    
    
    @IBAction func logOut(_ sender: Any) {
        
        if Auth.auth().currentUser != nil{
            do{
                //try Auth.auth().signOut()
                try! Auth.auth().signOut()
                
                //                let preferences = UserDefaults.standard
                //                let emailKey = "email"
                //                let passwordKey = "password"
                //
                //                preferences.removeObject(forKey: emailKey)
                //                preferences.removeObject(forKey: passwordKey)
                //
                //                let save = preferences.synchronize()
                
            }catch{
                
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "users", for: indexPath)
        
        let user = users[indexPath.row]
        cell.textLabel?.text = user.name
        cell.detailTextLabel?.text = user.doh
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedUser = users[indexPath.row]
        performSegue(withIdentifier: "selectedUser", sender: selectedUser)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "selectedUser"{
            if let dvc = segue.destination as? UsersInfo{
                if let user = sender as? ListUser{
                    dvc.fullName = user.name
                    dvc.doh = user.doh!
                    dvc.uid = user.uid
                    
                    
                }
            }
        }
    }
    
    
}
