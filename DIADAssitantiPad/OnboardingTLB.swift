//
//  OnboardingTLB.swift
//  DIADAssitantiPad
//
//  Created by Gerardo Nazarett on 1/30/19.
//  Copyright © 2019 Gerardo Nazarett. All rights reserved.
//

import UIKit
import paper_onboarding

class OnboardingTLB: UIViewController {
    
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




extension OnboardingTLB: PaperOnboardingDataSource, PaperOnboardingDelegate{
    
    func onboardingItem(at index: Int) -> OnboardingItemInfo {
        let bgColorOne = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
        let bgColorTwo = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        let bgColorThree = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
        let textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        let titleFont = UIFont(name: "HelveticaNeue-Bold", size: 18)!
        let descriptionFont = UIFont(name: "HelveticaNeue", size: 14)!
        
        
        var onboardingViews : [OnboardingItemInfo] = []
        
        onboardingViews.append(OnboardingItemInfo(informationImage: #imageLiteral(resourceName: "truckBadge"), title: "Vehicle Info", description: "Time Leaving BLDG", pageIcon: #imageLiteral(resourceName: "circlegray"), color: bgColorOne, titleColor: UIColor.white, descriptionColor: UIColor.white, titleFont: titleFont, descriptionFont: descriptionFont))
        
        onboardingViews.append(OnboardingItemInfo(informationImage: #imageLiteral(resourceName: "Building"), title: "Vehicle Info", description: "Input Time Leaving BLDG", pageIcon: #imageLiteral(resourceName: "circlegray"), color: bgColorTwo, titleColor: textColor, descriptionColor: textColor, titleFont: titleFont, descriptionFont: descriptionFont))
        
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
