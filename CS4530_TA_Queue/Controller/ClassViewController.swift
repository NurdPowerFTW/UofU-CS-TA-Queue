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
    
    /// View which contains the loading text and the spinner
    let loadingView = UIView()
    
    /// Spinner shown during load the TableView
    let spinner = UIActivityIndicatorView()
    
    /// Text shown during load the TableView
    let loadingLabel = UILabel()
    
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
    // Remove the activity indicator from the main view
    private func removeLoadingScreen() {
        
        // Hides and stops the text and the spinner
        spinner.stopAnimating()
        spinner.isHidden = true
        loadingLabel.isHidden = true
        tableView.isUserInteractionEnabled = true
        tableView.backgroundColor = .white
        loadingView.backgroundColor = .clear
    }
    
    // Set the activity indicator into the main view
    private func setLoadingScreen() {
        
        // Sets the view which contains the loading text and the spinner
        spinner.isHidden = false
        loadingLabel.isHidden = false
        let width: CGFloat = 120
        let height: CGFloat = 30
        let x = (tableView.frame.width / 2) - (width / 2)
        let y = (tableView.frame.height / 2) - (height / 2) - (navigationController?.navigationBar.frame.height)!
        loadingView.frame = CGRect(x: x, y: y, width: width, height: height)
        loadingView.backgroundColor = .darkGray
        
        // Sets loading text
        loadingLabel.textColor = .red
        loadingLabel.textAlignment = .center
        loadingLabel.text = "Loading..."
        loadingLabel.frame = CGRect(x: 0, y: 0, width: 140, height: 30)
        
        // Sets spinner
        spinner.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        spinner.startAnimating()
        
        // Adds text and spinner to the view
        loadingView.addSubview(spinner)
        loadingView.addSubview(loadingLabel)
        tableView.addSubview(loadingView)
        tableView.isUserInteractionEnabled = false
        
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
        label.textAlignment = .center
        return label
    }
    
    func moveToQueue(course: Course, mode: String) {
        setLoadingScreen()
        if mode == "Go"
        {
            let requestURL = WebService.shared.GET_QUEUE_ENQUEUE_FOR_CLASS_API_ADDRESS + course.courseID!
            WebService.shared.sendWebRequest(url: requestURL, type: "GET", formData: course.courseID!, mode: 7) { (result, done) in
                if done
                {
                    self.removeLoadingScreen()
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let queueVC = storyboard.instantiateViewController(withIdentifier: "QueueVC")
                    self.navigationController?.pushViewController(queueVC, animated: true)
                }
            }
        }
        else if mode == "Enroll"
        {
            let requestURL = WebService.shared.FECTH_USER_INO_API_ADDRESS + (manager.users![UserDefaults.standard.string(forKey: "CurrentUser")!]?.uName)! + "/courses/" + course.courseID! + "/student"
            WebService.shared.sendWebRequest(url: requestURL, type: "POST", formData: "", mode: 5) { (result, done) in
                if done
                {
                    self.removeLoadingScreen()
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
                    self.removeLoadingScreen()
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

