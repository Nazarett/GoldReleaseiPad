//
//  CommercialScan.swift
//  DIADAssitantiPad
//
//  Created by Gerardo Nazarett on 1/28/19.
//  Copyright © 2019 Gerardo Nazarett. All rights reserved.
//

import UIKit
import AVFoundation


class CommercialScan: UIViewController, AVCaptureMetadataOutputObjectsDelegate{
    
    var video = AVCaptureVideoPreviewLayer()
    
    
    
    override func viewDidLoad() {
        
        
        let session = AVCaptureSession()
        
        let captureDevice = AVCaptureDevice.default(for: .video)
        
        do{
            let input = try AVCaptureDeviceInput(device: captureDevice!)
            session.addInput(input)
        }catch{
            print("Scan Failed")
        }
        
        let output = AVCaptureMetadataOutput()
        session.addOutput(output)
        
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        
        output.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
        
        video = AVCaptureVideoPreviewLayer(session: session)
        
        video.frame = view.layer.bounds
        view.layer.addSublayer(video)
        
        
        session.startRunning()
    }
    
    
    
    
    
    
    //
    //    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects:[Any]!, from connection: AVCaptureConnection!){
    //        if metadataObjects.count > 0 {
    //
    //            if let object = metadataObjects[0] as? AVMetadataMachineReadableCodeObject{
    //                                if object.type == AVMetadataObject.ObjectType.qr{
    //                                    let alert = UIAlertController(title: "Package Detected", message: object.stringValue, preferredStyle: .alert)
    //                                    let action = UIAlertAction(title: "Retake", style: .default, handler: nil)
    //                                    //COME BACK AND ADD HANDLER
    //                                    let actionTwo = UIAlertAction(title: "Continue", style: .default, handler: { (action) in
    //                                        self.performSegue(withIdentifier: "toNextPage", sender: self)
    //                                    })
    //
    //                                    alert.addAction(action)
    //                                    alert.addAction(actionTwo)
    //
    //                                    present(alert, animated: true, completion: nil)
    //                                }
    //                            }
    //            }
    //        }
    //
    //
    
    
    ///NEED TO MAKE QR CODE WITH TRACKING INFORMATION AND ADDRESS
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if metadataObjects != nil && metadataObjects.count != 0 {
            if let object = metadataObjects[0] as? AVMetadataMachineReadableCodeObject{
                if object.type == AVMetadataObject.ObjectType.qr{
                    let alert = UIAlertController(title: "Package Detected", message: object.stringValue, preferredStyle: .alert)
                    let action = UIAlertAction(title: "Retake", style: .default, handler: nil)
                    //COME BACK AND ADD HANDLER
                    let actionTwo = UIAlertAction(title: "Continue", style: .default, handler: { (action) in
                        self.performSegue(withIdentifier: "toNextPage", sender: self)
                    })
                    
                    alert.addAction(action)
                    alert.addAction(actionTwo)
                    
                    present(alert, animated: true, completion: nil)
                }
            }
        }
        
        
    }
    
}

