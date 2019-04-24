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
    
    static let shared = WebResponseModel()
    var user: User!
    func setupUser(param: Data)
    {
        let json = JSON(param)
        user = User(uName: json["username"].stringValue, fName: json["first_name"].stringValue, lName: json["last_name"].stringValue, authenticated: json["authenticated"].boolValue, isAdmin: json["is_admin"].boolValue)
    }
}
