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
    
    func despose()
    {
        self.userCourses?.removeAll()
        self.allCourses?.removeAll()
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
    func removeUserCourse(courseID: String)
    {
        self.userCourses?.removeValue(forKey: courseID)
    }
    
    func addAllCourse(course: Course)
    {
        // don't add the exisiting user courses to the available courses to reflect the
        // correct course category
        if (userCourses?.contains(where: { ($0.1.courseID == course.courseID)}))!
        {
            let entry = userCourses?.first(where: {$0.1.courseID == course.courseID})
            self.allCourses?[entry!.key] = entry?.value
        }
        else
        {
            self.allCourses?[course.courseID!] = course
        }
        
    }
    
    func addToQueue(queue: Queue)
    {
        self.selectedQueue = queue
    }
}
