//
//  QueueAPI.swift
//  CS4530_TA_Queue
//
//  Created by William Tang on 6/5/19.
//  Copyright © 2019 Wei-Tung Tang. All rights reserved.
//

import Foundation
import Siesta


class QueueAPI: Service{
    init(){
        super.init(baseURL: "https://ta-queue.eng.utah.edu/api/")
        
    }
    
    var courses: Resource {return resource("/courses")}
    
}
