//
//  User.swift
//  CS4530_TA_Queue
//
//  Created by Wei-Tung Tang on 4/22/19.
//  Copyright © 2019 Wei-Tung Tang. All rights reserved.
//

import Foundation

class User{
    enum UserType {
        case Student
        case TA
        case Administrator
    }
    var uName: String = ""
    var fName: String = ""
    var lName: String = ""
    var authenticated: Bool = false
    var isAdmin: Bool = false
    
    init(uName: String, fName: String, lName: String, authenticated: Bool, isAdmin: Bool)
    {
        self.uName = uName
        self.fName = fName
        self.authenticated = authenticated
        self.isAdmin = isAdmin
    }
    
    
}
