//
//  CustomerSign.swift
//  DIADAssitantiPad
//
//  Created by Gerardo Nazarett on 1/28/19.
//  Copyright © 2019 Gerardo Nazarett. All rights reserved.
//

import UIKit
import Firebase

class CustomerSign: UIViewController {
    let ref : DatabaseReference = Database.database().reference()
    
    var lastPoint = CGPoint.zero
    var color = UIColor.black
    var brushWidth: CGFloat = 5.0
    var opacity: CGFloat = 1.0
    var swiped = false
    
    @IBOutlet weak var tempImageView: UIImageView!
    @IBOutlet weak var mainImageView: UIImageView!
    @IBAction func doneButton(_ sender: Any) {
        
        if let uid = Auth.auth().currentUser?.uid{
            
            self.ref.child("badges").child(uid).child("signBadge").observeSingleEvent(of: .value, with: { (snapshot) in
                let badgeInfo = snapshot.value as? NSDictionary
                let hasBadge = badgeInfo?["hasBadge"] as? Bool ?? false
                if !hasBadge{
                    self.ref.child("badges").child(uid).child("signBadge").child("hasBadge").setValue(true, withCompletionBlock: { (error, reference) in
                        let currentDateTime = Date()
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "MM-dd-yyyy"
                        let date = dateFormatter.string(from: currentDateTime)
                        self.ref.child("badges").child(uid).child("signBadge").child("badgeTime").setValue(date
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
                    _ = self.navigationController?.popToRootViewController(animated: true)
                    
                }
            })
            
        }
        
        
        
        
        
        
        
        tempImageView.image = nil
    }
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else{
            return
        }
        swiped = false
        lastPoint = touch.location(in: view)
    }
    
    
    func drawLine(from fromPoint: CGPoint, to toPoint: CGPoint){
        UIGraphicsBeginImageContext(view.frame.size)
        guard let context = UIGraphicsGetCurrentContext() else{
            return
        }
        
        tempImageView.image?.draw(in: view.bounds)
        context.move(to: fromPoint)
        context.addLine(to: toPoint)
        
        context.setLineCap(.round)
        context.setBlendMode(.normal)
        context.setLineWidth(brushWidth)
        context.setStrokeColor(color.cgColor)
        
        context.strokePath()
        
        tempImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        tempImageView.alpha = opacity
        UIGraphicsEndImageContext()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else{
            return
        }
        
        swiped = true
        let currentPoint = touch.location(in: view)
        drawLine(from: lastPoint, to: currentPoint)
        
        lastPoint = currentPoint
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !swiped {
            drawLine(from: lastPoint, to: lastPoint)
            
        }
        
        UIGraphicsBeginImageContext(mainImageView.frame.size)
        mainImageView.image?.draw(in: view.bounds, blendMode: .normal, alpha: 1.0)
        tempImageView.image?.draw(in: view.bounds, blendMode: .normal, alpha: opacity)
        mainImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        //tempImageView.image = nil
    }
    
}


