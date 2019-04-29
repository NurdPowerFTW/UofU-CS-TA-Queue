//
//  QueueViewController.swift
//  CS4530_TA_Queue
//
//  Created by Wei-Tung Tang on 4/28/19.
//  Copyright © 2019 Wei-Tung Tang. All rights reserved.
//

import UIKit

class QueueViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, QueueCellDelegate {
    
    var manager = Manager.shared()
    var cellID = "queueCell"
    var timer: Timer?
    
    var queueTitle: UILabel = {
        let lbl = UILabel()
        lbl.textColor = UIColor.black
        lbl.font = UIFont.boldSystemFont(ofSize: 22)
        lbl.textAlignment = .center
        return lbl
    }()
    
    var stateLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = UIColor.black
        lbl.font = UIFont.boldSystemFont(ofSize: 16)
        lbl.textAlignment = .left
        return lbl
    }()
    
    var lengthLabel:UILabel = {
        let lbl = UILabel()
        lbl.textColor = UIColor.black
        lbl.font = UIFont.boldSystemFont(ofSize: 16)
        lbl.textAlignment = .left
        return lbl
    }()
    
    var tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(queueTitle)
        view.addSubview(stateLabel)
        view.addSubview(lengthLabel)
        view.addSubview(tableView)
        
        setupContext()
        setupConstraints()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(QueueCell.self, forCellReuseIdentifier: cellID)
        tableView.allowsSelection = false
        timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(refreshQueue), userInfo: nil, repeats: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if timer != nil
        {
            timer?.invalidate()
            timer = nil
        }
    }
    func setupContext()
    {
        queueTitle.text = manager.selectedQueue?.courseName
        setStateText()
        lengthLabel.text = String(format: "Length: %d", manager.selectedQueue!.length!)
    }
    
    func setupConstraints()
    {
        queueTitle.translatesAutoresizingMaskIntoConstraints = false
        queueTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        queueTitle.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        queueTitle.heightAnchor.constraint(equalToConstant: 50).isActive = true
        queueTitle.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -view.frame.height/3.5).isActive = true
        
        stateLabel.translatesAutoresizingMaskIntoConstraints = false
        stateLabel.topAnchor.constraint(equalTo: queueTitle.bottomAnchor, constant: -20).isActive = true
        stateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: view.frame.width/12).isActive = true
        stateLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        lengthLabel.translatesAutoresizingMaskIntoConstraints = false
        lengthLabel.topAnchor.constraint(equalTo: stateLabel.topAnchor).isActive = true
        lengthLabel.leadingAnchor.constraint(equalTo: stateLabel.trailingAnchor, constant: 10).isActive = true
        lengthLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.bottomAnchor, constant: -(view.frame.height/1.5)).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        //        tableView.heightAnchor.constraint(equalToConstant: 500).isActive = true
    }
    
    func setStateText()
    {
        let stateString = "State: " + (manager.selectedQueue?.state)!
        let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: stateString)
        switch manager.selectedQueue?.state {
        case "closed":
            attributedString.setColor(color: UIColor.red, forText: "closed")
            break
        case "open":
            attributedString.setColor(color: UIColor.green, forText: "open")
            break
        case "frozen":
            attributedString.setColor(color: UIColor.blue, forText: "frozen")
            break
        default:
            break
        }
        
        stateLabel.attributedText = attributedString
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! QueueCell
        cell.delegate = self
        if indexPath.section == 0
        {
            cell.nameLabel.text = manager.selectedQueue?.taCollection[indexPath.row].fullname
            cell.assistBtn.isHidden = true
            cell.dequeueBtn.isHidden = true
            cell.enqueueBtn.isHidden = true
            cell.exitBtn.isHidden = true
            
            if (manager.selectedQueue?.taCollection[indexPath.row].helping!.count)! > 0
            {
                manager.selectedQueue?.helpers.append((cell.nameLabel.text!, (manager.selectedQueue?.taCollection[indexPath.row].helping)!))
            }
        }
        else
        {
            if manager.selectedQueue?.helpers.count == 0
            {
                cell.helperLabel.text = "Requires Help"
                cell.helperLabel.textColor = .red
            }
            for (ta, student): (String, String) in manager.selectedQueue!.helpers
            {
                if student == manager.selectedQueue?.studentCollection[indexPath.row].username
                {
                    cell.helperLabel.text = ta
                    cell.helperLabel.textColor = .blue
                }
            }
            cell.nameLabel.text = "Student: " + (manager.selectedQueue?.studentCollection[indexPath.row].fullname)!
            cell.locLabel.text = "Location: " + (manager.selectedQueue?.studentCollection[indexPath.row].location)!
            cell.queLabel.text = "Question: " + (manager.selectedQueue?.studentCollection[indexPath.row].question)!
            
        }
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0
        {
            return manager.selectedQueue!.taCollection.count
        }
        return manager.selectedQueue!.studentCollection.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        switch section {
        case 0:
            label.text = "TA on Duty"
            break
        case 1:
            label.text = "Students in Queue"
        default:
            break
        }
        label.backgroundColor = UIColor.lightGray
        label.textAlignment = .center
        return label
    }
    
    @objc func refreshQueue()
    {
        let courseID = manager.selectedQueue?.courseID
        WebService.shared.sendGetQueueRequest(courseID: courseID!, url: WebService.shared.GET_QUEUE_FOR_CLASS_API_ADDRESS + courseID!, type: "GET") { (result, done) in
            if done
            {
                self.setupContext()
                self.tableView.reloadData()
                print("Refreshing queue info")
            }
        }
    }
    
    func sendAssit() {
        let currentUser = UserDefaults.standard.string(forKey: "CurrentUser")
        let isTA = manager.selectedQueue?.taCollection.contains(where: { (TA) -> Bool in
            TA.username == currentUser
        })
        
        if isTA!
        {
            print("TA found")
        }
    }
    
    func sendDeque() {
        
    }
    
    func sendEnter() {
        
    }
    
    func sendExit() {
        
    }
}

extension NSMutableAttributedString {
    func setColor(color: UIColor, forText stringValue: String) {
        let range: NSRange = self.mutableString.range(of: stringValue, options: .caseInsensitive)
        self.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
    }
    
}

