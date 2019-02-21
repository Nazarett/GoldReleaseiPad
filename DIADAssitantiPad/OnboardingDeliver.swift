//
//  OnboardingDeliver.swift
//  DIADAssitantiPad
//
//  Created by Gerardo Nazarett on 1/30/19.
//  Copyright © 2019 Gerardo Nazarett. All rights reserved.
//


import UIKit
import paper_onboarding

class OnboardingDeliver: UIViewController {
    @IBOutlet weak var onboardingObject: OnboardingViewClass!
    @IBOutlet weak var doneButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        onboardingObject.dataSource = self
        onboardingObject.delegate = self
        
        navigationController?.navigationBar.isHidden = true
        doneButton.isHidden = true
    }
    
    
    
    
    
}




extension OnboardingDeliver: PaperOnboardingDataSource, PaperOnboardingDelegate{
    
    func onboardingItem(at index: Int) -> OnboardingItemInfo {
        let bgColorOne = #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1)
        let bgColorTwo = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
        let bgColorThree = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
        let textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        let titleFont = UIFont(name: "HelveticaNeue-Bold", size: 18)!
        let descriptionFont = UIFont(name: "HelveticaNeue", size: 14)!
        
        
        var onboardingViews : [OnboardingItemInfo] = []
        
        onboardingViews.append(OnboardingItemInfo(informationImage: #imageLiteral(resourceName: "truckBadge"), title: "Delivery", description: "Choose Commercial Or Residential", pageIcon: #imageLiteral(resourceName: "circlegray"), color: bgColorOne, titleColor: UIColor.white, descriptionColor: UIColor.white, titleFont: titleFont, descriptionFont: descriptionFont))
        
        onboardingViews.append(OnboardingItemInfo(informationImage: #imageLiteral(resourceName: "Building"), title: "Delivery", description: "Scan QRCode", pageIcon: #imageLiteral(resourceName: "circlegray"), color: bgColorTwo, titleColor: textColor, descriptionColor: textColor, titleFont: titleFont, descriptionFont: descriptionFont))
        
        onboardingViews.append(OnboardingItemInfo(informationImage: #imageLiteral(resourceName: "map"), title: "Delivery", description: "Choose Signature or No Signature, Message: Earn Badge", pageIcon: #imageLiteral(resourceName: "circlegray"), color: bgColorThree, titleColor: textColor, descriptionColor: textColor, titleFont: titleFont, descriptionFont: descriptionFont))
        
        return onboardingViews[index]
    }
    
    
    func onboardingDidTransitonToIndex(_ index: Int) {
        if index == 2{
            doneButton.isHidden = false
        }
    }
    
    func onboardingWillTransitonToIndex(_ index: Int) {
        if index != 2 {
            if doneButton.isHidden == false{
                doneButton.isHidden = true
            }
        }
    }
    
    func onboardingConfigurationItem(_: OnboardingContentViewItem, index _: Int) {
        
    }
    
    
    
    func onboardingItemsCount() -> Int {
        return 3
    }
    
    
}

