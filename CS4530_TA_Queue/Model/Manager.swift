//
//  Manager.swift
//  CS4530_TA_Queue
//
//  Created by Wei-Tung Tang on 4/24/19.
//  Copyright © 2019 Wei-Tung Tang. All rights reserved.
//

import Foundation

class Manager{
    
    static var sharedManager: Manager = {
        let manager = Manager()
        return manager
    }()
    
    var users: [String : User]?
    var courses: [String: Course]?
    
    init()
    {
        self.users = [String : User]()
        self.courses = [String: Course]()
    }
    
    class func shared() -> Manager {
        return sharedManager
    }
    
    func addUser(user: User)
    {
        self.users?[user.uName] = user
    }
    
    func addCourse(course: Course)
    {
        self.courses?[course.courseID!] = course
    }
}
