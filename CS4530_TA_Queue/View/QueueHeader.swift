//
//  QueueHeader.swift
//  CS4530_TA_Queue
//
//  Created by Wei-Tung Tang on 4/28/19.
//  Copyright © 2019 Wei-Tung Tang. All rights reserved.
//

import UIKit

class QueueHeader: UIView {

//    var queue: Queue? {
//        didSet{
//            titleLabel.text = queue?.courseName
//            stateLabel.text = queue?.state
//            switch queue?.state {
//            case "Closed":
//                stateLabel.textColor = UIColor.red
//                break
//            case "Open":
//                stateLabel.textColor = UIColor.green
//                break
//            case "Frozen":
//                stateLabel.textColor = UIColor.blue
//                break
//            default:
//                break
//            }
//        }
//    }
    
    var titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = UIFont.boldSystemFont(ofSize: 25)
        lbl.textAlignment = .center
        return lbl
    }()
    
    var stateLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = UIFont.boldSystemFont(ofSize: 14)
        lbl.textAlignment = .center
        return lbl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
//        titleLabel.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 10, paddingBottom: 10, paddingRight: 10, width: frame.size.width, height: 0, enableInsets: false)
//        stateLabel.anchor(top: titleLabel.bottomAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 10, paddingBottom: 10, paddingRight: 10, width: frame.size.width/3, height: 0, enableInsets: false)
        
        titleLabel.text = "123"
        stateLabel.text = "yeah"
        addSubview(titleLabel)
        addSubview(stateLabel)
    }
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
