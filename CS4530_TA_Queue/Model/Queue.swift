//
//  Queue.swift
//  CS4530_TA_Queue
//
//  Created by Wei-Tung Tang on 4/28/19.
//  Copyright © 2019 Wei-Tung Tang. All rights reserved.
//

import Foundation

class Queue
{
    var state: String?
    var courseName: String?
    var student = [(String, String, String)]()
    var timeLimit: Int = 0
    var length: Int = 0
    var announcement = [(String, String, String, String)]()
    var TA = [(String, String, String, String)]()
    
    init(state: String, name: String)
    {
        self.state = state
        self.courseName = name
    }
    
    
}
