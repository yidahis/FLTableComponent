//
//  MainTableComponent.swift
//  Demo
//
//  Created by yidahis on 2018/9/12.
//  Copyright © 2018 yidahis. All rights reserved.
//

import UIKit
import FLTableComponent

class TopTableCell: UITableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initSubViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initSubViews() {
        contentView.backgroundColor = .orange
        layout()
    }
    
    func layout() {
        
    }
}


class TopTableComponent: FLTableBaseComponent {
    
    override func cellForRow(at row: Int) -> UITableViewCell {
        let cell = super.cellForRow(at: row) as! TopTableCell
        cell.textLabel?.text = "\(row) number"
        return cell
    }
    override func numberOfRows() -> NSInteger {
        return 1
    }
    
    override func heightForRow(at row: Int) -> CGFloat {

        return 120
    }
    
    override func register() {
        tableView?.register(TopTableCell.self, forCellReuseIdentifier: cellIdentifier)
    }
}


class MiddleTableCell: UITableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initSubViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initSubViews() {
        contentView.backgroundColor = .blue
        layout()
    }
    
    func layout() {
        
    }
}

class MiddleTableComponent: FLTableBaseComponent {
    
    override func cellForRow(at row: Int) -> UITableViewCell {
        let cell = super.cellForRow(at: row) as! MiddleTableCell
        cell.textLabel?.text = "\(row) number"
        return cell
    }
    override func numberOfRows() -> NSInteger {
        return 2
    }
    
    override func heightForRow(at row: Int) -> CGFloat {

        return 88
    }
    override func register() {
        tableView?.register(MiddleTableCell.self, forCellReuseIdentifier: cellIdentifier)
    }
}

class MainTableComponent: FLTableBaseComponent {
    
    override func cellForRow(at row: Int) -> UITableViewCell {
        let cell = super.cellForRow(at: row) as! MainTableViewCell
        cell.textLabel?.text = "\(row) number"
        return cell
    }
    override func numberOfRows() -> NSInteger {
        return 20
    }
    
    override func heightForRow(at row: Int) -> CGFloat {

        return 44
    }
    override func register() {
        tableView?.register(UINib.init(nibName: "MainTableViewCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
    }
}
