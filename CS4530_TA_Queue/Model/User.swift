//
//  User.swift
//  CS4530_TA_Queue
//
//  Created by Wei-Tung Tang on 4/22/19.
//  Copyright © 2019 Wei-Tung Tang. All rights reserved.
//

import Foundation

class User{
    
    var uName: String = ""
    var fName: String = ""
    var lName: String = ""
    var authenticated: Bool = false
    var isAdmin: Bool = false
    var isTA: Bool = false
    var isMain: Bool = false
    
    var TACourses = [Course]()
    var StuCourses = [Course]()
    
    init(uName: String, fName: String, lName: String, authenticated: Bool, isAdmin: Bool)
    {
        self.uName = uName
        self.fName = fName
        self.authenticated = authenticated
        self.isAdmin = isAdmin
        
    }
    
    func addATACourse(course: Course)
    {
        TACourses.append(course)
    }
    
    func addAStuCours(course: Course)
    {
        StuCourses.append(course)
    }
    
}
