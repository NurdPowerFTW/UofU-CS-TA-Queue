//
//  Course.swift
//  CS4530_TA_Queue
//
//  Created by Wei-Tung Tang on 4/25/19.
//  Copyright © 2019 Wei-Tung Tang. All rights reserved.
//

import Foundation

class Course
{
    var category: String?
    var courseName: String?
    var courseID: String?
    var description: String?
    
    init(category: String, name: String, id: String, description: String) {
        self.courseID = id
        self.description = description
        self.courseName = name
        self.category = category
    }
}
