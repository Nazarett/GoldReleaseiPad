//
//  Profile.swift
//  DIADAssitantiPad
//
//  Created by Gerardo Nazarett on 11/13/18.
//  Copyright © 2018 Gerardo Nazarett. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class Profile: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    let ref : DatabaseReference = Database.database().reference()
    var uid : String = ""
    
    @IBOutlet weak var firstName: UILabel!
    @IBOutlet weak var lastName: UILabel!
    @IBOutlet weak var driverOrHelper: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    
    
    @IBOutlet weak var badgeOne: UIImageView!
    @IBOutlet weak var badgeOneLabel: UILabel!
    
    @IBOutlet weak var badgeTwo: UIImageView!
    @IBOutlet weak var badgeTwoLabel: UILabel!
    
    @IBOutlet weak var badgeThree: UIImageView!
    @IBOutlet weak var badgeThreeLabel: UILabel!
    
    @IBOutlet weak var badgeFour: UIImageView!
    @IBOutlet weak var badgeFourLabel: UILabel!
    
    @IBOutlet weak var badgeFive: UIImageView!
    @IBOutlet weak var badgeFiveLabel: UILabel!
    
    @IBOutlet weak var badgeSix: UIImageView!
    @IBOutlet weak var badgeSixLabel: UILabel!
    
    @IBOutlet weak var badgeSeven: UIImageView!
    @IBOutlet weak var badgeSevenLabel: UILabel!
    
    @IBOutlet weak var badgeEight: UIImageView!
    @IBOutlet weak var badgeEightLabel: UILabel!
    
    @IBOutlet weak var timeOne: UILabel!
    @IBOutlet weak var timeTwo: UILabel!
    @IBOutlet weak var timeThree: UILabel!
    @IBOutlet weak var timeFour: UILabel!
    @IBOutlet weak var timeFive: UILabel!
    @IBOutlet weak var timeSix: UILabel!
    @IBOutlet weak var timeSeven: UILabel!
    @IBOutlet weak var timeEight: UILabel!
    
    
    
    @IBOutlet weak var grayBadgeOne: UIImageView!
    @IBOutlet weak var grayBadgeTwo: UIImageView!
    @IBOutlet weak var grayBadgeThree: UIImageView!
    @IBOutlet weak var grayBadgeFour: UIImageView!
    @IBOutlet weak var grayBadgeFive: UIImageView!
    @IBOutlet weak var grayBadgeSix: UIImageView!
    @IBOutlet weak var grayBadgeSeven: UIImageView!
    @IBOutlet weak var grayBadgeEight: UIImageView!
    
    
    @IBOutlet weak var editOutlet: UIBarButtonItem!
    @IBOutlet weak var editFirstName: UITextField!
    @IBOutlet weak var editLastName: UITextField!
    
    @IBOutlet weak var editProfileImage: UIImageView!
    
    var returningFromPicker : Bool = false
    
    var pictureName = ""
    
    @IBAction func updateInfo(_ sender: Any) {
        if editOutlet.title == "Edit"{
            editOutlet.title = "Update"
            editFirstName.isHidden = false
            editLastName.isHidden = false
            editProfileImage.isUserInteractionEnabled = true
        }else{
            var object = [String : Any]()
            if !pictureName.isEmpty{
                object["profilePic"] = pictureName
            }
            if !(editFirstName.text?.isEmpty)!{
                object["firstName"] = editFirstName.text!
                firstName.text = editFirstName.text
            }
            if !(editLastName.text?.isEmpty)!{
                object["lastName"] = editLastName.text!
                lastName.text = editLastName.text
            }
            
            
            if let uid = Auth.auth().currentUser?.uid{
                Database.database().reference().child("users").child(uid).updateChildValues(object)
            }
            
            editFirstName.text = ""
            editLastName.text = ""
            editOutlet.title = "Edit"
            editFirstName.isHidden = true
            editLastName.isHidden = true
            editProfileImage.isUserInteractionEnabled = false
            
        }
        
        
    }
    
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        
        if let picturesPicked = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            print("PICTURE HIT")
            self.editProfileImage.image = picturesPicked
            uploadPicture(image: picturesPicked)
            picker.dismiss(animated: true, completion: nil)
        }
        
        
    }
    
    func stringLength(length: Int) -> NSString{
        let allCharacters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        
        let placeholder : NSMutableString = NSMutableString(capacity: length)
        
        for _ in 0..<length{
            let newLength = UInt32(allCharacters.length)
            let random = arc4random_uniform(newLength)
            placeholder.appendFormat("%C", allCharacters.character(at: Int(random)))
        }
        return placeholder
    }
    
    
    //UPLOADING PICTURE
    func uploadPicture(image: UIImage){
        
        let randomName = stringLength(length: 10)
        let imgData = image.jpegData(compressionQuality: 1.0)
        let uploadReference = Storage.storage().reference().child("Images/\(randomName).jpg")
        
        _ = uploadReference.putData(imgData!, metadata: nil){ metadata,
            error in
            if error == nil{
                
                print("Successfully uploaded picture")
                self.pictureName = "\(randomName as String).jpg"
                //self.profileImage.image = image
                
            }else{
                print("error\(String(describing: error?.localizedDescription))")
            }
            
            
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
                self.performSegue(withIdentifier: "logOutId", sender: nil)
            }catch{
                
            }
            
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    func getDataFrom(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
        
    }
    
    func downloadImageFromUrl(url: URL){
        getDataFrom(url: url) { (data, response, error) in
            guard let data = data, error == nil else{ return}
            DispatchQueue.main.async {
                self.profileImage.image = UIImage(data: data)
                
                
            }
            
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if returningFromPicker{
            returningFromPicker = false
            return
        }
        
        
        
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
            
            
            
            if let dictionaryOfItems = snapshot.value as? [String: AnyObject]{
                
                if let nameOfPicture = dictionaryOfItems["profilePic"] as? String {
                    
                    let pictureReference = Storage.storage().reference().child("Images/\(nameOfPicture)")
                    pictureReference.getData(maxSize: 25 * 1024 * 1024, completion: { (data, error) in
                        if error == nil{
                            let picture = UIImage(data: data!)
                            print("VIEW WILL APPEAR")
                            self.editProfileImage.image = picture
                        }else{
                            print("Error Getting Image: \(String(describing: error?.localizedDescription))")
                            
                        }
                    })
                    
                    if let url = URL(string: nameOfPicture){
                        self.profileImage.contentMode = .scaleAspectFit
                        self.downloadImageFromUrl(url: url)
                    }
                    
                }
                
                
            }
            
            
            
            
        })
        
        
        
        
        //badge one check from backend
        
        badgeOne.isHidden = true
        //badgeOneLabel.isHidden = true
        
        badgeTwo.isHidden = true
        //badgeTwoLabel.isHidden = true
        
        badgeThree.isHidden = true
        //badgeThreeLabel.isHidden = true
        
        badgeFour.isHidden = true
        //badgeFourLabel.isHidden = true
        
        badgeFive.isHidden = true
        //badgeFiveLabel.isHidden = true
        
        badgeSix.isHidden = true
        //badgeSixLabel.isHidden = true
        
        badgeSeven.isHidden = true
        //badgeSevenLabel.isHidden = true
        
        badgeEight.isHidden = true
        //badgeEightLabel.isHidden = true
        
        timeOne.isHidden = true
        timeTwo.isHidden = true
        timeThree.isHidden = true
        timeFour.isHidden = true
        timeFive.isHidden = true
        timeSix.isHidden = true
        timeSeven.isHidden = true
        timeEight.isHidden = true
        
        
        
        
        ref.child("badges").child(uid).child("truckBadge").observeSingleEvent(of: .value) { (snapshot) in
            let badgeInfo = snapshot.value as? NSDictionary
            let hasBadge = badgeInfo?["hasBadge"] as? Bool ?? false
            let badgeTime = badgeInfo?["badgeTime"] as? String
            if hasBadge{
                self.badgeOneLabel.isHidden = false
                self.badgeOne.isHidden = false
                self.timeOne.text = badgeTime
                self.timeOne.isHidden = false
                self.grayBadgeOne.isHidden = true
                
            }
        }
        
        
        
        ref.child("badges").child(uid).child("commercialBadge").observeSingleEvent(of: .value) { (snapshot) in
            let badgeInfo = snapshot.value as? NSDictionary
            let hasBadge = badgeInfo?["hasBadge"] as? Bool ?? false
            let badgeTime = badgeInfo?["badgeTime"] as? String
            if hasBadge{
                self.badgeTwo.isHidden = false
                self.badgeTwoLabel.isHidden = false
                self.timeTwo.text = badgeTime
                self.timeTwo.isHidden = false
                self.grayBadgeTwo.isHidden = true
                
            }
        }
        
        
        ref.child("badges").child(uid).child("locationBadge").observeSingleEvent(of: .value) { (snapshot) in
            let badgeInfo = snapshot.value as? NSDictionary
            let hasBadge = badgeInfo?["hasBadge"] as? Bool ?? false
            let badgeTime = badgeInfo?["badgeTime"] as? String
            if hasBadge{
                self.badgeThreeLabel.isHidden = false
                self.badgeThree.isHidden = false
                self.timeThree.text = badgeTime
                self.timeThree.isHidden = false
                self.grayBadgeThree.isHidden = true
                
            }
        }
        
        
        
        ref.child("badges").child(uid).child("signBadge").observeSingleEvent(of: .value) { (snapshot) in
            let badgeInfo = snapshot.value as? NSDictionary
            let hasBadge = badgeInfo?["hasBadge"] as? Bool ?? false
            let badgeTime = badgeInfo?["badgeTime"] as? String
            if hasBadge{
                self.badgeFourLabel.isHidden = false
                self.badgeFour.isHidden = false
                self.timeFour.text = badgeTime
                self.timeFour.isHidden = false
                self.grayBadgeFour.isHidden = true
                
            }
        }
        
        
        
        
        ref.child("badges").child(uid).child("greenClock").observeSingleEvent(of: .value) { (snapshot) in
            let badgeInfo = snapshot.value as? NSDictionary
            let hasBadge = badgeInfo?["hasBadge"] as? Bool ?? false
            let badgeTime = badgeInfo?["badgeTime"] as? String
            if hasBadge{
                self.badgeFiveLabel.isHidden = false
                self.badgeFive.isHidden = false
                self.timeFive.text = badgeTime
                self.timeFive.isHidden = false
                self.grayBadgeFive.isHidden = true
                
            }
        }
        
        
        
        ref.child("badges").child(uid).child("redClock").observeSingleEvent(of: .value) { (snapshot) in
            let badgeInfo = snapshot.value as? NSDictionary
            let hasBadge = badgeInfo?["hasBadge"] as? Bool ?? false
            let badgeTime = badgeInfo?["badgeTime"] as? String
            if hasBadge{
                self.badgeSixLabel.isHidden = false
                self.badgeSix.isHidden = false
                self.timeSix.text = badgeTime
                self.timeSix.isHidden = false
                self.grayBadgeSix.isHidden = true
                
            }
        }
        
        
        
        
        ref.child("badges").child(uid).child("house").observeSingleEvent(of: .value) { (snapshot) in
            let badgeInfo = snapshot.value as? NSDictionary
            let hasBadge = badgeInfo?["hasBadge"] as? Bool ?? false
            let badgeTime = badgeInfo?["badgeTime"] as? String
            if hasBadge{
                self.badgeSevenLabel.isHidden = false
                self.badgeSeven.isHidden = false
                self.timeSeven.text = badgeTime
                self.timeSeven.isHidden = false
                self.grayBadgeSeven.isHidden = true
            }
        }
        
        
        ref.child("badges").child(uid).child("infoBadge").observeSingleEvent(of: .value) { (snapshot) in
            let badgeInfo = snapshot.value as? NSDictionary
            let hasBadge = badgeInfo?["hasBadge"] as? Bool ?? false
            let badgeTime = badgeInfo?["badgeTime"] as? String
            if hasBadge{
                self.badgeEightLabel.isHidden = false
                self.badgeEight.isHidden = false
                self.timeEight.text = badgeTime
                self.timeEight.isHidden = false
                self.grayBadgeEight.isHidden = true
            }
        }
        
        
        
        
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        editProfileImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(clickedPicture)))
        editProfileImage.isUserInteractionEnabled = false
        
        ref.child("users").child(uid).observeSingleEvent(of: .value) { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let first = value?["firstName"] as? String
            let last = value?["lastName"] as? String
            let picked = value?["driverOrHelper"] as? String
            let email = value?["email"] as? String
            
            
            
            self.firstName.text = first
            self.lastName.text = last
            self.driverOrHelper.text = picked
            self.emailLabel.text = email
        }
        
        
        
    }
    
    
    
    
    @objc func clickedPicture(){
        
        guard let button = editProfileImage else{
            return
        }
        
        let choice = UIAlertController(title: "Upload", message: "Choose", preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Take Photo", style: .default, handler:
        {(_) -> Void in
            
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = UIImagePickerController.SourceType.camera
            self.present(picker, animated: true, completion: nil)
            
            
        })
        
        let photoAction = UIAlertAction(title: "Choose From Library", style: .default, handler:
        {(_) -> Void in
            
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = UIImagePickerController.SourceType.photoLibrary
            self.present(picker, animated: true, completion: nil)
            
            
        })
        
        let cancel = UIAlertAction(title: "Cancel", style: .default, handler:
        {(_) -> Void in
            
            self.dismiss(animated: true, completion: nil)
            
        })
        
        choice.addAction(cameraAction)
        choice.addAction(photoAction)
        choice.addAction(cancel)
        returningFromPicker = true
        if let presenter = choice.popoverPresentationController{
            presenter.sourceView = button
            presenter.sourceRect = button.bounds
        }
        self.present(choice, animated: true, completion: nil)
        
        
        //present(picker, animated: true, completion: nil)
    }
    
    func pickerCancel(){
        dismiss(animated: true, completion: nil)
    }
    
    
    
    
    
}


