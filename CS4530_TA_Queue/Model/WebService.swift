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
    let LOGIN_ENDPOINT = 1
    let LOGOUT_API_ADDRESS = "https://ta-queue.eng.utah.edu/api/logout"
    let LOGOUT_ENDPOINT = 2
    let FECTH_USER_INO_API_ADDRESS = "https://ta-queue.eng.utah.edu/api/user/"
    let USER_INFO_ENDPOINT = 3
    let FECTH_AVAILABLE_COURSES_API_ADDRESS = "https://ta-queue.eng.utah.edu/api/courses"
    let AVAILABLE_COURSES_ENDPOINT = 4
    let ENROLL_USER_ENDPOINT = 5
    let UNENROLL_USER_ENDPOINT = 6
    let GET_QUEUE_ENDPOINT = 7
    let GET_QUEUE_ENQUEUE_FOR_CLASS_API_ADDRESS = "https://ta-queue.eng.utah.edu/api/queue/"
    let SEND_HELP_REMOVE_FOR_STUDNET_API_ADDRESS = "https://ta-queue.eng.utah.edu/api/queue/"
    
    
    func sendWebRequest(url: String, type: String, formData: String, mode: Int, handler:@escaping (String, Bool)->Void)
    {
        let postData = formData.data(using: .utf8)
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = type
        request.setValue("application/json", forHTTPHeaderField: "accept")
        
        if postData != nil && mode != 6{
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.httpBody = postData
        }
        DispatchQueue.global(qos: .userInteractive).async {
            URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                guard let data = data, let response = response as? HTTPURLResponse else{return}
                print(response.statusCode)
                if response.statusCode != 200
                {
                    DispatchQueue.main.async {
                        handler("Incorrect username or password.",false)
                    }
                }
                else
                {
                    DispatchQueue.main.async {
                        
                        switch mode
                        {
                        case self.LOGIN_ENDPOINT:
                            WebResponseModel.shared.setupLoggedInUser(param: data)
                            handler("You have logged in.", true)
                            break
                        case self.LOGOUT_ENDPOINT:
                            // remove userdefault for logged-in user
                            let defaults = UserDefaults.standard
                            defaults.removeObject(forKey: "CurrentUser")
                            handler("User logged out.", true)
                            break
                        case self.AVAILABLE_COURSES_ENDPOINT:
                            WebResponseModel.shared.setupAllCourse(param: data)
                            handler("Displaying All Courses.", true)
                            break
                        case self.USER_INFO_ENDPOINT:
                            WebResponseModel.shared.setupUserCourse(param: data)
                            handler("Displaying Courses.", true)
                            break
                        case self.ENROLL_USER_ENDPOINT:
                            WebResponseModel.shared.setupUserCourse(param: data)
                            handler("Displaying Courses.", true)
                            break
                        case self.UNENROLL_USER_ENDPOINT:
                            WebResponseModel.shared.removeUserCourse(courseID: formData)
                            handler("Displaying Courses.", true)
                            break
                        case self.GET_QUEUE_ENDPOINT:
                            print("Displaying queue:")
                            WebResponseModel.shared.setupCourseQueue(param:data, courseID:formData)
                            handler("Displaying queue.", true)
                            break
                        default:
                            break
                        }
                        
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
                        handler("Student entered...", true)
                    }
                }
            }).resume()
        }
    }
    
    func sendEnrollRequest(url: String, type: String,handler:@escaping (String, Bool)->Void)
    {
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = type
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "accept")
        //        request.httpBody = postData
        DispatchQueue.global(qos: .userInteractive).async {
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
                        handler("Change state...", true)
                    }
                }
            }).resume()
        }
    }
    
    func sendGetUserRole(url: String, type: String,handler:@escaping (String, Bool)->Void)
    {
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = type
        request.setValue("application/json", forHTTPHeaderField: "accept")
        DispatchQueue.global(qos: .userInteractive).async {
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
                        handler("Get Role...", true)
                    }
                }
            }).resume()
        }
    }
    
    func sendChangeQueueState(state: String, url: String, type: String, handler:@escaping (String, Bool)-> Void)
    {
        let postData = "state=\(state)".data(using: .utf8)
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
                        handler("Enrolling...", true)
                    }
                }
            }).resume()
        }
    }
}
