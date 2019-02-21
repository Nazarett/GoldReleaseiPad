//
//  TimecardInfo.swift
//  DIADAssitantiPad
//
//  Created by Gerardo Nazarett on 11/13/18.
//  Copyright © 2018 Gerardo Nazarett. All rights reserved.
//

import Foundation

class TimecardInfo{
    let punch : String
    let date : String
    let time : String
    
    
    init(punch: String, date : String, time : String){
        self.punch = punch
        self.date = date
        self.time = time
    }
}
