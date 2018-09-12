//
//  MainTableComponent.swift
//  Demo
//
//  Created by yidahis on 2018/9/12.
//  Copyright © 2018 yidahis. All rights reserved.
//

import UIKit
import FLTableComponent

class MainTableComponent: FLTableBaseComponent {
    
    override func cellForRow(at row: Int) -> UITableViewCell {
        let cell = super.cellForRow(at: row) as! MainTableViewCell

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
