//
//  SignUp.swift
//  DIADAssitantiPad
//
//  Created by Gerardo Nazarett on 11/13/18.
//  Copyright © 2018 Gerardo Nazarett. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import Photos

extension String {
    func isValidEmail() -> Bool {
        
        let regex = try! NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
    }
}



class SignUp: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    let ref : DatabaseReference = Database.database().reference()
    
    
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    
    @IBOutlet weak var upsEmail: UITextField!
    @IBOutlet weak var upsPassword: UITextField!
    
    @IBOutlet weak var profileImage: UIImageView!
    
    var returningFromPicker : Bool = false
    
    var pictureName = ""
    
    
    
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if (info[UIImagePickerController.InfoKey.originalImage] as? UIImage) != nil{
            
            if let picturesPicked = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
                print("PICTURE HIT")
                self.profileImage.image = picturesPicked
                uploadPicture(image: picturesPicked)
                picker.dismiss(animated: true, completion: nil)
            }
            
        }
        self.dismiss(animated: true, completion: nil)
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
    
    
    
    
    
    
    
    @IBOutlet weak var dhPicker: UIPickerView!
    
    let pickerData : [String] = ["Driver", "Helper"]
    
    @IBAction func signUpButton(_ sender: Any) {
        
        if CheckInternet.Connection(){
            
            if self.upsEmail.text == "" || self.upsPassword.text == "" || self.firstName.text == "" || self.lastName.text == ""{
                print("empty field")
                let alert = UIAlertController(title: "Please Enter a Name, Email Address and Password", message: "Please Try Again", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
                
                
            }else if !((self.upsPassword.text?.count)! > 5){
                print("small password")
                let alert = UIAlertController(title: "Password must be 6 characters or more", message: "Please Try Again", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
                
                
            }else if !(self.upsEmail.text?.isValidEmail())!{
                print("invalid email")
                let alert = UIAlertController(title: "Please Enter a valid Email Address", message: "Please Try Again", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
                
                
                
            }else{
                print("creating user")
                Auth.auth().createUser(withEmail: upsEmail.text!, password: upsPassword.text!, completion: {
                    
                    user, error in
                    
                    if error != nil{
                        print(error?.localizedDescription as Any)
                    }else{
                        let email = self.upsEmail.text
                        let first = self.firstName.text
                        let last = self.lastName.text
                        let img = self.profileImage.image
                        let picked = self.pickerData[self.dhPicker.selectedRow(inComponent: 0)]
                        if let uid = user?.user.uid{
                            
                            //                        let imageName = NSUUID().uuidString
                            //                        let storageRef = Storage.storage().reference().child("Images/\(imageName)")
                            //
                            //
                            //
                            //
                            //                        if let uploadData = self.profileImage.image!.pngData(){
                            //                            storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                            //                                if error != nil{
                            //                                    print(error)
                            //                                    return
                            //                                }
                            //                                if let profileImg = metadata?.downloadURL()?.absoluteString{
                            //                                    self.ref.child("users").child(uid).child("profilePic").setValue(profileImg)
                            //
                            //                                }
                            //
                            //                            })
                            //                        }
                            
                            //                        extension uploadPicture(image: UIImage){
                            //
                            //                            let randomName = self.stringLength(length: 10)
                            //                            let imgData = image.jpegData(compressionQuality: 1.0)
                            //                            let uploadReference = Storage.storage().reference().child("Images/\(randomName).jpg")
                            //
                            //                            let uploadingTask = uploadReference.putData(imgData!, metadata: nil){ metadata,
                            //                                error in
                            //                                if error == nil{
                            //
                            //                                    print("Successfully uploaded picture")
                            //                                    self.pictureName = "\(randomName as String).jpg"
                            //                                    //self.profileImage.image = image
                            //                                    self.ref.child("users").child(uid).child("profilePic").setValue(imgData)
                            //
                            //                                }else{
                            //                                    print("error\(error?.localizedDescription)")
                            //                                }
                            //
                            //
                            //                            }
                            //
                            //                        }
                            
                            let randomName = self.stringLength(length: 10)
                            let imgData = self.profileImage.image!.jpegData(compressionQuality: 1.0)
                            let uploadReference = Storage.storage().reference().child("Images/\(randomName).jpg")
                            _ = uploadReference.putData(imgData!, metadata: nil){ metadata,
                                error in
                                if error == nil{
                                    
                                    print("Successfully uploaded picture")
                                    self.pictureName = "\(randomName as String).jpg"
                                    self.profileImage.image = img
                                    self.ref.child("users").child(uid).child("profilePic").setValue(self.pictureName)
                                    
                                }else{
                                    print("error\(String(describing: error?.localizedDescription))")
                                }
                                
                                
                            }
                            
                            
                            
                            
                            
                            self.ref.child("users").child(uid).child("firstName").setValue(first)
                            self.ref.child("users").child(uid).child("lastName").setValue(last)
                            self.ref.child("users").child(uid).child("driverOrHelper").setValue(picked)
                            self.ref.child("users").child(uid).child("email").setValue(email)
                            //self.ref.child("users").child(uid).child("profilePic").setValue()
                            
                            let alert = UIAlertController(title: "User Created", message: "User successfully created", preferredStyle: .alert)
                            let action = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                                _ = self.navigationController?.popToRootViewController(animated: true)
                            })
                            alert.addAction(action)
                            self.present(alert, animated: true, completion: nil)
                            
                        }else{
                            print("UID ERROR")
                        }
                        
                        
                    }
                    
                })
            }
            
            
        }else{
            
            let alert = UIAlertController(title: "Alert", message: "No internet connection available", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
            
        }
        
        
        
        
    }
    
    
    func downloadImageFromUrl(url: URL){
        getDataFrom(url: url) { (data, response, error) in
            guard let data = data, error == nil else{ return}
            DispatchQueue.main.async {
                self.profileImage.image = UIImage(data: data)
                
                
            }
            
        }
    }
    
    func getDataFrom(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
        
    }
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkPermission()
        
        self.navigationController?.navigationBar.isHidden = true
        profileImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(clickedPicture)))
        profileImage.isUserInteractionEnabled = true
        
        
        
        dhPicker.delegate = self
        dhPicker.dataSource = self
        
        
        
    }
    
    func checkPermission() {
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        switch photoAuthorizationStatus {
        case .authorized:
            print("Access is granted by user")
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({
                (newStatus) in
                print("status is \(newStatus)")
                if newStatus ==  PHAuthorizationStatus.authorized {
                    /* do stuff here */
                    print("success")
                }
            })
            print("It is not determined until now")
        case .restricted:
            // same same
            print("User do not have access to photo album.")
        case .denied:
            // same same
            print("User has denied the permission.")
        }
    }
    
    
    
    
    @objc func clickedPicture(){
        
        guard let button = profileImage else{
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
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    
    
    
    
    
    
    
    
    
}
