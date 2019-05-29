//
//  WebReponseModel.swift
//  CS4530_TA_Queue
//
//  Created by Wei-Tung Tang on 4/22/19.
//  Copyright © 2019 Wei-Tung Tang. All rights reserved.
//

import Foundation
import SwiftyJSON
class WebResponseModel{
    
    let manager = Manager.shared()
    static let shared = WebResponseModel()
    func setupLoggedInUser(param: Data)
    {
        let json = JSON(param)
        let user = User(uName: json["username"].stringValue, fName: json["first_name"].stringValue, lName: json["last_name"].stringValue, authenticated: json["authenticated"].boolValue, isAdmin: json["is_admin"].boolValue)
        manager.addUser(user: user)
        let defaults = UserDefaults.standard
        defaults.set(user.uName, forKey: "CurrentUser")
    }
    
    func setupUserCourse(param: Data)
    {
        let json = JSON(param)
        let taCouses = json["ta_courses"]
        let stuCourses = json["student_courses"]
        if taCouses.dictionary != nil
        {
            for (key, value): (String, JSON) in taCouses
            {
                let course = Course(category: "TA", name: key, id: value["course_id"].stringValue, description: value["description"].stringValue)
                manager.addUserCourse(course: course)
            }
        }
        
        if stuCourses.dictionary != nil
        {
            for (key, value): (String, JSON) in stuCourses
            {
                let course = Course(category: "Student", name: key, id: value["course_id"].stringValue, description: value["description"].stringValue)
                manager.addUserCourse(course: course)
            }
        }
    }
    
    func setupAllCourse(param: Data)
    {
        let json = JSON(param)
        for (key, value): (String, JSON) in json["all_courses"]
        {
            manager.addAllCourse(course: Course(category: "Available", name: key, id: value["course_id"].stringValue, description: value["description"].stringValue))

        }
    }
    
    func setupCourseQueue(param: Data, courseID: String)
    {
        let json = JSON(param)
        manager.addToQueue(queue: Queue(json: json, courseID:courseID))
    }
}
