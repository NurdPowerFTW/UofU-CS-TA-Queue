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
    let LOGOUT_API_ADDRESS = "https://ta-queue.eng.utah.edu/api/logout"
    let FECTH_USER_INO_API_ADDRESS = "https://ta-queue.eng.utah.edu/api/user/"
    let FECTH_AVAILABLE_COURSES_API_ADDRESS = "https://ta-queue.eng.utah.edu/api/courses"
    let GET_QUEUE_ENQUEUE_FOR_CLASS_API_ADDRESS = "https://ta-queue.eng.utah.edu/api/queue/"
    let SEND_HELP_REMOVE_FOR_STUDNET_API_ADDRESS = "https://ta-queue.eng.utah.edu/api/queue/"
    
    func sendLoginRequest(username: String, password: String, url: String, type: String, handler:@escaping (String, Bool)->Void)
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
                
                //                print(JSON(data))
                if response.statusCode != 200
                {
                    DispatchQueue.main.async {
                        handler("Incorrect username or password.",false)
                    }
                }
                else
                {
                    DispatchQueue.main.async {
                        let defaults = UserDefaults.standard
                        defaults.set(username, forKey: "CurrentUser")
                        WebResponseModel.shared.setupLoggedInUser(param: data)
                        handler("You have logged in.", true)
                    }
                }
            }).resume()
        }
    }
    
    func sendLogoutRequest(url: String, type: String, handler:@escaping (String, Bool)->Void)
    {
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = type
        request.setValue("application/json", forHTTPHeaderField: "accept")
        DispatchQueue.global(qos: .userInteractive).async {
            // Send Fetch request
            URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                guard let data = data, let response = response as? HTTPURLResponse else{return}
                //                print(JSON(data))
                if response.statusCode != 200
                {
                    DispatchQueue.main.async {
                        handler("Not authenticated.",false)
                    }
                }
                else
                {
                    DispatchQueue.main.async {
                        WebResponseModel.shared.setupUserCourse(param: data)
                        handler("User logged out.", true)
                    }
                }
            }).resume()
        }
    }
    
    func sendFetchUserCoursesRequest(url: String, type: String,  handler:@escaping (String, Bool)->Void)
    {
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = type
        request.setValue("application/json", forHTTPHeaderField: "accept")
        DispatchQueue.global(qos: .userInteractive).async {
            // Send Fetch request
            URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                guard let data = data, let response = response as? HTTPURLResponse else{return}
                //                print(JSON(data))
                if response.statusCode != 200
                {
                    DispatchQueue.main.async {
                        handler("Not authenticated.",false)
                    }
                }
                else
                {
                    DispatchQueue.main.async {
                        WebResponseModel.shared.setupUserCourse(param: data)
                        handler("Displaying Courses.", true)
                    }
                }
            }).resume()
        }
    }
    
    func sendFetchAllCoursesRequest(url: String, type: String, handler:@escaping (String, Bool)->Void)
    {
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = type
        request.setValue("application/json", forHTTPHeaderField: "accept")
        DispatchQueue.global(qos: .userInteractive).async {
            // Send Fetch request
            URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                guard let data = data, let response = response as? HTTPURLResponse else{return}
                //                                print(JSON(data))
                if response.statusCode != 200
                {
                    DispatchQueue.main.async {
                        handler("Not authenticated.",false)
                    }
                }
                else
                {
                    DispatchQueue.main.async {
                        WebResponseModel.shared.setupAllCourse(param: data)
                        handler("Displaying All Courses.", true)
                    }
                }
            }).resume()
        }
        
    }
    
    func sendGetQueueRequest(courseID: String, url: String, type: String, handler:@escaping (String, Bool)->Void)
    {
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = type
        request.setValue("application/json", forHTTPHeaderField: "accept")
        DispatchQueue.global(qos: .userInteractive).async {
            // Send Fetch request
            URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                guard let data = data, let response = response as? HTTPURLResponse else{return}
                //                print(JSON(data))
                if response.statusCode != 200
                {
                    DispatchQueue.main.async {
                        handler("Error:\(response.statusCode)",false)
                    }
                }
                else
                {
                    DispatchQueue.main.async {
                        WebResponseModel.shared.setupCourseQueue(param:data, courseID:courseID)
                        handler("Displaying queue.", true)
                    }
                }
            }).resume()
        }
    }
    
    func sendAssitStudentRequest(url: String, type: String, handler:@escaping (String, Bool)->Void)
    {
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = type
        request.setValue("application/json", forHTTPHeaderField: "accept")
        DispatchQueue.global(qos: .userInteractive).async {
            // Send Fetch request
            URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                guard let _ = data, let response = response as? HTTPURLResponse else{return}
                //                print(JSON(data))
                if response.statusCode != 200
                {
                    DispatchQueue.main.async {
                        handler("Error:\(response.statusCode)",false)
                    }
                }
                else
                {
                    DispatchQueue.main.async {
                        handler("Helping student...", true)
                    }
                }
            }).resume()
        }
    }
    
    func sendDequeueStudentRequest(url: String, type: String, handler:@escaping (String, Bool)->Void)
    {
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = type
        request.setValue("application/json", forHTTPHeaderField: "accept")
        DispatchQueue.global(qos: .userInteractive).async {
            // Send Fetch request
            URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                guard let _ = data, let response = response as? HTTPURLResponse else{return}
                //                print(JSON(data))
                if response.statusCode != 200
                {
                    DispatchQueue.main.async {
                        handler("Error:\(response.statusCode)",false)
                    }
                }
                else
                {
                    DispatchQueue.main.async {
                        handler("Removed student...", true)
                    }
                }
            }).resume()
        }
    }
    
    func sendEnqueueRequest(question: String, location: String, url: String, type: String, handler:@escaping (String, Bool)->Void)
    {
        let postData = "question=\(question)&location=\(location)".data(using: .utf8)
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = type
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "accept")
        request.httpBody = postData
        DispatchQueue.global(qos: .userInteractive).async {
            // Send Fetch request
            URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                guard let data = data, let response = response as? HTTPURLResponse else{return}
                print(JSON(data))
                if response.statusCode != 200
                {
                    DispatchQueue.main.async {
                        handler("Error:\(response.statusCode)",false)
                    }
                }
                else
                {
                    DispatchQueue.main.async {
                        handler("Student entered...", true)
                    }
                }
            }).resume()
        }
    }
}
