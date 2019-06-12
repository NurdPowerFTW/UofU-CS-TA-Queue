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
    var enrollCourses = [(key: String, value: Course)]()
    var avaiCourses = [(key: String, value: Course)]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presentCourses()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .singleLine
        self.tableView.register(CourseCell.self, forCellReuseIdentifier: self.myCourseCellID)
        
    }
    
    func presentCourses()
    {
        let currentUser = manager.users![UserDefaults.standard.string(forKey: "CurrentUser")!]
        let url = WebService.shared.FECTH_USER_INO_API_ADDRESS + currentUser!.uName + "/courses"
        fetchService.sendWebRequest(url: url, type: "GET", formData: "", mode: 3) { (result, done) in
            if done {
                self.tableView.reloadData()
                self.fetchService.sendWebRequest(url: WebService.shared.FECTH_AVAILABLE_COURSES_API_ADDRESS, type: "GET", formData: "", mode: 4) { (result, done) in
                    if done {
                        self.enrollCourses = (Manager.shared().userCourses?.sorted(by: {$0.0 < $1.0}))!
                        self.avaiCourses = (Manager.shared().allCourses?.sorted(by: {$0.0 < $1.0}))!
                        self.tableView.reloadData()
                    }
                }
            }
            
        }
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
        WebService.shared.sendWebRequest(url: WebService.shared.LOGOUT_API_ADDRESS, type: "POST", formData: "", mode: 2) { (result, done) in
            if done {
                print(result)
                self.manager.despose()
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
        let course = indexPath.section == 0 ? Array(self.enrollCourses)[indexPath.row].value : Array(self.avaiCourses)[indexPath.row].value
        cell.delegate = self
        cell.course = course
        
        
        if indexPath.section == 0
        {
            cell.selectButton.setTitle("GO", for: .normal)
            cell.selectButton.setTitleColor(.blue, for: .normal)
        }
        else
        {
            if course.category == "Available"
            {
                cell.selectButton.setTitle("Enroll", for: .normal)
                cell.selectButton.setTitleColor(.blue, for: .normal)
                cell.selectButton.isEnabled = true
            }
            else if course.category == "TA"
            {
                cell.selectButton.setTitle("TA", for: .normal)
                cell.selectButton.isEnabled = false
                cell.selectButton.setTitleColor(.lightGray, for: .disabled)
            }
            else
            {
                cell.selectButton.setTitle("Leave", for: .normal)
                cell.selectButton.setTitleColor(.red, for: .normal)
                cell.selectButton.isEnabled = true
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0
        {
            return enrollCourses.count
        }
        return avaiCourses.count
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
    
    func moveToQueue(course: Course, mode: String) {
        if mode == "Go"
        {
//            let requestURL = WebService.shared.GET_QUEUE_ENQUEUE_FOR_CLASS_API_ADDRESS + course.courseID!
//            WebService.shared.sendGetQueueRequest(courseID: course.courseID!, url: requestURL, type: "GET") { (result, done) in
//                if done
//                {
//
//                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                    let queueVC = storyboard.instantiateViewController(withIdentifier: "QueueVC")
//                    self.navigationController?.pushViewController(queueVC, animated: true)
//                }
//            }
        }
        else if mode == "Enroll"
        {
            let requestURL = WebService.shared.FECTH_USER_INO_API_ADDRESS + (manager.users![UserDefaults.standard.string(forKey: "CurrentUser")!]?.uName)! + "/courses/" + course.courseID! + "/student"
            WebService.shared.sendWebRequest(url: requestURL, type: "POST", formData: "", mode: 5) { (result, done) in
                if done
                {
                    let alert = UIAlertController(title: "Course added!", message: "You now can get TA help by going to the added class above.", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { _ in
                    }))
                    self.present(alert,animated: true,completion: nil)
                    self.presentCourses()
                }
            }
        }
        else
        {
            let requestURL = WebService.shared.FECTH_USER_INO_API_ADDRESS + (manager.users![UserDefaults.standard.string(forKey: "CurrentUser")!]?.uName)! + "/courses/" + course.courseID! + "/student"
            WebService.shared.sendWebRequest(url: requestURL, type: "DELETE", formData: course.courseID!, mode: 6) { (result, done) in
                if done
                {
                    let alert = UIAlertController(title: "Course Removed!", message: "Course Unenrolled Successfully", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { _ in
                    }))
                    self.present(alert,animated: true,completion: nil)
                    self.presentCourses()
                }
            }
        }
        self.tableView.reloadData()
        
    }
    
}

