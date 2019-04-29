//
//  QueueViewController.swift
//  CS4530_TA_Queue
//
//  Created by Wei-Tung Tang on 4/28/19.
//  Copyright © 2019 Wei-Tung Tang. All rights reserved.
//

import UIKit

class QueueViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var manager = Manager.shared()
    var cellID = "queueCell"
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
        
        queueTitle.text = manager.selectedQueue?.courseName
        setStateText()
        lengthLabel.text = String(format: "Length: %d", manager.selectedQueue!.length)
        setupConstraints()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellID")
//        tableView.backgroundColor = UIColor.blue
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
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        cell.textLabel?.text = indexPath.section == 0 ? manager.selectedQueue?.TA[indexPath.row].0 : manager.selectedQueue?.student[indexPath.row].0
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0
        {
            return manager.selectedQueue!.TA.count
        }
        return manager.selectedQueue!.student.count
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
}

extension NSMutableAttributedString {
    func setColor(color: UIColor, forText stringValue: String) {
        let range: NSRange = self.mutableString.range(of: stringValue, options: .caseInsensitive)
        self.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
    }
    
}

