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
    var courseID: Int?
    var description: String?
    
    init(id: Int, description: String) {
        courseID = id
        self.description = description
    }
}
