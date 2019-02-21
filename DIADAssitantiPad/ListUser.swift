//
//  ListUser.swift
//  DIADAssitantiPad
//
//  Created by Gerardo Nazarett on 1/31/19.
//  Copyright © 2019 Gerardo Nazarett. All rights reserved.
//

import Foundation

class ListUser{
    let name : String
    let doh : String?
    let uid : String
    
    init(name : String, doh : String?,
         uid: String){
        self.name = name
        self.doh = doh
        self.uid = uid
    }
}
