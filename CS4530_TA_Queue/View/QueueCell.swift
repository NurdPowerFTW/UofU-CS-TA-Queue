//
//  QueueCell.swift
//  CS4530_TA_Queue
//
//  Created by Wei-Tung Tang on 4/29/19.
//  Copyright © 2019 Wei-Tung Tang. All rights reserved.
//

import UIKit
protocol QueueCellDelegate {
    func sendAssit()
    func sendDeque()
    func sendEnter()
    func sendExit()
}

class QueueCell: UITableViewCell {
    var delegate: QueueCellDelegate?
    
    var nameLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = UIFont.systemFont(ofSize: 12)
        lbl.textAlignment = .left
        return lbl
    }()
    
    var locLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = UIFont.systemFont(ofSize: 12)
        lbl.textAlignment = .left
        return lbl
    }()
    
    var queLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = UIFont.systemFont(ofSize: 12)
        lbl.textAlignment = .left
        return lbl
    }()
    
    var helperLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .red
        lbl.font = UIFont.systemFont(ofSize: 12)
        lbl.textAlignment = .left
        return lbl
    }()
    
    var assistBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("ASSIT", for: .normal)
        return btn
    }()
    
    var dequeueBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("REMOVE", for: .normal)
        return btn
    }()
    
    var enqueueBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("ENTER", for: .normal)
        return btn
    }()
    
    var exitBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("EXIT", for: .normal)
        return btn
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(nameLabel)
        addSubview(locLabel)
        addSubview(queLabel)
        addSubview(helperLabel)
        addSubview(assistBtn)
        addSubview(dequeueBtn)
        addSubview(enqueueBtn)
        addSubview(exitBtn)
        
        nameLabel.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 5, paddingBottom: 5, paddingRight: 5, width: 100, height: 0, enableInsets: false)
        locLabel.anchor(top: topAnchor, left: nameLabel.rightAnchor, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 10, paddingBottom: 10, paddingRight: 10, width: 100, height: 0, enableInsets: false)
        queLabel.anchor(top: nameLabel.bottomAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 5, paddingBottom: 5, paddingRight: 5, width: 100, height: 0, enableInsets: false)
        helperLabel.anchor(top: locLabel.bottomAnchor, left: queLabel.rightAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 10, paddingBottom: 10, paddingRight: 10, width: 100, height: 0, enableInsets: false)
        
        assistBtn.addTarget(self, action: #selector(assistTriggered), for: .touchUpInside)
        dequeueBtn.addTarget(self, action: #selector(dequeueTriggered), for: .touchUpInside)
        enqueueBtn.addTarget(self, action: #selector(enqueueTriggered), for: .touchUpInside)
        exitBtn.addTarget(self, action: #selector(exitTriggered), for: .touchUpInside)
        
        let stackView = UIStackView(arrangedSubviews: [assistBtn,dequeueBtn,enqueueBtn, exitBtn ])
        stackView.distribution = .equalSpacing
        stackView.axis = .horizontal
        stackView.spacing = 5
        addSubview(stackView)
        stackView.anchor(top: topAnchor, left: nil, bottom: bottomAnchor, right: rightAnchor, paddingTop: 15, paddingLeft: 5, paddingBottom: 15, paddingRight: 10, width: 0, height: 0, enableInsets: false)
    
    }

    @objc func assistTriggered()
    {
        delegate?.sendAssit()
    }

    @objc func dequeueTriggered()
    {
        delegate?.sendDeque()
    }
    
    @objc func enqueueTriggered()
    {
        delegate?.sendEnter()
    }
    
    @objc func exitTriggered()
    {
        delegate?.sendExit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
