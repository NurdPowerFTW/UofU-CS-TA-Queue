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
    var userCourses: [String: Course]?
    var allCourses: [String: Course]?
    var selectedQueue: Queue?
    
    init()
    {
        self.users = [String : User]()
        self.userCourses = [String: Course]()
        self.allCourses = [String: Course]()
        self.selectedQueue = nil
    }
    
    class func shared() -> Manager {
        return sharedManager
    }
    
    func addUser(user: User)
    {
        self.users?[user.uName] = user
    }
    
    func addUserCourse(course: Course)
    {
        self.userCourses?[course.courseID!] = course
    }
    
    func addAllCourse(course: Course)
    {
        self.allCourses?[course.courseID!] = course
    }
    
    func addToQueue(queue: Queue)
    {
        self.selectedQueue = queue
    }
}
