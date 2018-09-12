//
//  FLTableComponentController.swift
//  FLComponentDemo
//
//  Created by gitKong on 2017/5/11.
//  Copyright © 2017年 gitKong. All rights reserved.
//

import UIKit

open class FLTableComponentController: UIViewController {
    
    private(set) var handler : FLTableViewHandler = FLTableViewHandler()
    
    open lazy var tableView : UITableView = {
        let tableView : UITableView = UITableView.init(frame: self.customRect, style: self.tableViewStyle)
        return tableView
    }()
    
    open var components : Array<FLTableBaseComponent> = [] {
        didSet {
            handler.components = components
        }
    }
    
    override open func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = self.customRect
    }

    override open func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        handler.delegate = self
        view.addSubview(tableView)
        
        self.tableView.tableHeaderView = headerView(of: tableView)
        self.tableView.tableFooterView = footerView(of: tableView)
    }
    
    open func headerView(of tableView : UITableView) -> UIView? {
        return nil
    }
    
    open func footerView(of tableView : UITableView) -> UIView? {
        return nil
    }
}

extension FLTableComponentController : FLTableComponentConfiguration {
    
    var tableViewStyle: UITableViewStyle {
        return UITableViewStyle.plain
    }
    
    open var customRect: CGRect {
        return self.view.bounds
    }
    
    open func reloadComponent() {
        handler.reloadComponents()
    }
}

extension FLTableComponentController : FLTableViewHandlerDelegate {
    
    open func tableViewDidClick(_ handler: FLTableViewHandler, cellAt indexPath: IndexPath) {
        // subclass override it
    }
    
    open func tableViewDidClick(_ handler: FLTableViewHandler, headerAt section: NSInteger) {
        // subclass override it
    }
    
    open func tableViewDidClick(_ handler: FLTableViewHandler, footerAt section: NSInteger) {
        // subclass override it
    }
}




