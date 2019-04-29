//
//  Queue.swift
//  CS4530_TA_Queue
//
//  Created by Wei-Tung Tang on 4/28/19.
//  Copyright © 2019 Wei-Tung Tang. All rights reserved.
//

import Foundation
import SwiftyJSON

struct TA {
    var username: String?
    var duration: String?
    var fullname: String?
    var helping: String?
}

struct Student {
    var username: String?
    var fullname: String?
    var location: String?
    var question: String?
}
class Queue
{
    var state: String?
    var courseName: String?
    var courseID: String?
    var taCollection = [TA]()
    var studentCollection = [Student]()
    var announcement = [(String, String, String, String)]() // id, annoucement, poster, timestamp
    var timeLimit: Int?
    var cooldown: Int?
    var length: Int?
    var helpers = [(String, String)]()
    
    
    init(json: JSON, courseID: String)
    {
        self.courseName = json["course_name"].stringValue
        self.state = json["state"].stringValue
        self.courseID = courseID
        let TAs = json["TAs"]
        let annoucements = json["announcements"]
        let students = json["queue"]
        
        if TAs.dictionary != nil{
            for (_, value): (String, JSON) in TAs
            {
                let newTA = TA(username: value["username"].stringValue, duration: value["duration"].stringValue, fullname: value["full_name"].stringValue, helping: value["helping"].stringValue)
                taCollection.append(newTA)
            }
        }
        
        if annoucements.dictionary != nil{
            for (_, value): (String, JSON) in annoucements{
                announcement.append((value["id"].stringValue,value["announcement"].stringValue,value["poster"].stringValue,value["tmstmp"].stringValue))
            }
        }
        
        if students.dictionary != nil{
            for (_, value): (String, JSON) in students
            {
               let newStudent = Student(username: value["username"].stringValue, fullname: value["full_name"].stringValue, location: value["location"].stringValue, question: value["question"].stringValue)
                studentCollection.append(newStudent)
            }
        }
        
        self.timeLimit = json["time_lim"].intValue
        self.cooldown = json["cooldown"].intValue
        self.length = json["queue_length"].intValue
    }
    
    
}
