//
//  CourseCell.swift
//  CS4530_TA_Queue
//
//  Created by Wei-Tung Tang on 4/27/19.
//  Copyright © 2019 Wei-Tung Tang. All rights reserved.
//

import UIKit

protocol CourseCellDelegate {
    func moveToQueue(course: Course)
}
class CourseCell : UITableViewCell {
    var delegate : CourseCellDelegate?
    
    var course : Course? {
        didSet {
            let courseName = course?.courseName
            let name = String((courseName?.dropFirst(9))!)
            let courseNum = String(courseName![String.Index(encodedOffset: 0)..<String.Index(encodedOffset: 7)])
            courseNumLabel.text = courseNum
            roleLNameLabel.text = course?.category
            courseNameLabel.text = name
        }
    }
    
    
    
    private let courseNumLabel : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = UIFont.boldSystemFont(ofSize: 14)
        lbl.textAlignment = .left
        return lbl
    }()

    private let roleLNameLabel: UILabel = {
       let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = UIFont.boldSystemFont(ofSize: 14)
        lbl.textAlignment = .left
        return lbl
    }()
    
    private let courseNameLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = UIFont.boldSystemFont(ofSize: 14)
        lbl.textAlignment = .left
        return lbl
    }()
    
    private let selectButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("GO/Enroll", for: .normal)
        return btn
       
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
        addSubview(courseNumLabel)
        addSubview(courseNameLabel)
        addSubview(roleLNameLabel)
        addSubview(selectButton)
        
        courseNumLabel.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: frame.size.width/3, height: 0, enableInsets: false)
        roleLNameLabel.anchor(top: topAnchor, left: courseNumLabel.rightAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: frame.size.width/3, height: 0, enableInsets: false)
        courseNameLabel.anchor(top: courseNumLabel.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, paddingTop: 10, paddingLeft: 10, paddingBottom: 10, paddingRight: 0, width: frame.size.width, height: 0, enableInsets: false)
        selectButton.anchor(top: topAnchor, left: nil, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: frame.size.width/3, height: 0, enableInsets: false)
        
        selectButton.addTarget(self, action: #selector(selectCourse), for: .touchUpInside)
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func selectCourse()
    {
        delegate?.moveToQueue(course: self.course!)
    }
    
    
}
