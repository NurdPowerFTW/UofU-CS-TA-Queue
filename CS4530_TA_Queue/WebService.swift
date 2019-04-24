//
//  WebService.swift
//  CS4530_TA_Queue
//
//  Created by Wei-Tung Tang on 4/22/19.
//  Copyright © 2019 Wei-Tung Tang. All rights reserved.
//

import Foundation
import SwiftyJSON

class WebService{
    static let shared = WebService()
    let LOGIN_API_ADDRESS = "https://ta-queue.eng.utah.edu/api/login"
    func sendLoginRequest(username: String, password: String, url: String, type: String,handler:@escaping (String, Bool)->Void)
    {
        let postData = "username=\(username)&password=\(password)".data(using: .utf8)
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = type
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody = postData
        DispatchQueue.global(qos: .userInteractive).async {
            // Send login request
            URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                guard let data = data, let response = response as? HTTPURLResponse else{return}
                
                if response.statusCode != 200
                {
                    DispatchQueue.main.async {
                        handler("Incorrect email or password!",false)
                    }
                }
                else
                {
//                    print(JSON(data))
                    DispatchQueue.main.async {
                        WebResponseModel.shared.setupUser(param: data)
                        //handler(WebResponseModel.shared.user.userRole, true)
                    }
                }
            }).resume()
        }
    }
}
