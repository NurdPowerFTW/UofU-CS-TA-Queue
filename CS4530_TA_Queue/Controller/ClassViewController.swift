//
//  ClassViewController.swift
//  CS4530_TA_Queue
//
//  Created by Wei-Tung Tang on 4/25/19.
//  Copyright © 2019 Wei-Tung Tang. All rights reserved.
//

import UIKit

class ClassViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CourseCellDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    let manager = Manager.shared()
    let fetchService = WebService()
    var myCourseCellID = "myCourse"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let manager = Manager.shared()
        let currentUser = manager.users![UserDefaults.standard.string(forKey: "CurrentUser")!]
        let url = WebService.shared.FECTH_USER_INO_API_ADDRESS + currentUser!.uName + "/courses"
        fetchService.sendFetchUserCoursesRequest(url: url, type: "GET") { (result, done) in
            if done {
                print(result)
            }
            else
            {
                print(result)
            }
            self.tableView.reloadData()
        }
        
        fetchService.sendFetchAllCoursesRequest(url: WebService.shared.FECTH_AVAILABLE_COURSES_API_ADDRESS, type: "GET") { (result, done) in
            if done {
                print(result)
            }
            else
            {
                print(result)
            }
            self.tableView.reloadData()
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .singleLine
        tableView.register(CourseCell.self, forCellReuseIdentifier: myCourseCellID)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true)
        let backItem = UIBarButtonItem(title: "Log Out", style: .done, target: self, action: #selector(logout))
        navigationItem.leftBarButtonItem = backItem
        navigationItem.title = "My Courses"
        navigationController?.navigationBar.barTintColor = UIColor.lightGray
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    @objc func logout()
    {
        print("logging out")
        WebService.shared.sendLogoutRequest(url: WebService.shared.LOGOUT_API_ADDRESS, type: "POST") { (result, done) in
            if done {
                print(result)
                self.navigationController?.popViewController(animated: true)
            }
            else
            {
                print(result)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: myCourseCellID, for: indexPath) as! CourseCell
        let course = indexPath.section == 0 ? Array(manager.userCourses!)[indexPath.row].value : Array(manager.allCOurses!)[indexPath.row].value
        cell.delegate = self
        cell.course = course
        if course.category == "Available"
        {
            cell.selectButton.setTitle("Enroll", for: .normal)
        }
        else
        {
            cell.selectButton.setTitle("Go", for: .normal)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0
        {
            return manager.userCourses!.count
        }
        return manager.allCOurses!.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        switch section {
        case 0:
            label.text = "Enrolled Courses"
            break
        case 1:
            label.text = "All Courses"
        default:
            break
        }
        label.backgroundColor = UIColor.red
        return label
    }
    
    func moveToQueue(course: Course) {
        let requestURL = WebService.shared.GET_QUEUE_FOR_CLASS_API_ADDRESS + course.courseID!
        WebService.shared.sendGetQueueRequest(name: course.courseName!, url: requestURL, type: "GET") { (result, done) in
            if done
            {
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let queueVC = storyboard.instantiateViewController(withIdentifier: "QueueVC")
                self.navigationController?.pushViewController(queueVC, animated: true)
            }
        }
    }

}

