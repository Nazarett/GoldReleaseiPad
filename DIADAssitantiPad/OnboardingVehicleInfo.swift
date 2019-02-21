//
//  OnboardingVehicleInfo.swift
//  DIADAssitantiPad
//
//  Created by Gerardo Nazarett on 1/30/19.
//  Copyright © 2019 Gerardo Nazarett. All rights reserved.
//

import UIKit
import paper_onboarding

class OnboardingVehicleInfo: UIViewController {
    
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




extension OnboardingVehicleInfo: PaperOnboardingDataSource, PaperOnboardingDelegate{
    
    func onboardingItem(at index: Int) -> OnboardingItemInfo {
        let bgColorOne = #colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1)
        let bgColorTwo = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        let bgColorThree = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        let textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        let titleFont = UIFont(name: "HelveticaNeue-Bold", size: 18)!
        let descriptionFont = UIFont(name: "HelveticaNeue", size: 14)!
        
        
        var onboardingViews : [OnboardingItemInfo] = []
        
        onboardingViews.append(OnboardingItemInfo(informationImage: #imageLiteral(resourceName: "truckBadge"), title: "Vehicle Info", description: "Input Truck Number", pageIcon: #imageLiteral(resourceName: "circlegray"), color: bgColorOne, titleColor: UIColor.white, descriptionColor: UIColor.white, titleFont: titleFont, descriptionFont: descriptionFont))
        
        onboardingViews.append(OnboardingItemInfo(informationImage: #imageLiteral(resourceName: "Building"), title: "Vehicle Info", description: "Input Miles Start", pageIcon: #imageLiteral(resourceName: "circlegray"), color: bgColorTwo, titleColor: textColor, descriptionColor: textColor, titleFont: titleFont, descriptionFont: descriptionFont))
        
        onboardingViews.append(OnboardingItemInfo(informationImage: #imageLiteral(resourceName: "map"), title: "Vehicle Info", description: "Message: Earn Badge", pageIcon: #imageLiteral(resourceName: "circlegray"), color: bgColorThree, titleColor: textColor, descriptionColor: textColor, titleFont: titleFont, descriptionFont: descriptionFont))
        
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

