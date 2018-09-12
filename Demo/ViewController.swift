//
//  ViewController.swift
//  Demo
//
//  Created by yidahis on 2018/9/12.
//  Copyright © 2018 yidahis. All rights reserved.
//

import UIKit
import FLTableComponent

class ViewController: FLTableComponentController {
    var headerComponet: MainTableComponent!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        initComponets()
    }
    
    func initComponets(){
        var tmpComponents : Array<FLTableBaseComponent> = []
        
        headerComponet = MainTableComponent(tableView: tableView)
        tmpComponents.append(headerComponet)
        
        components = tmpComponents
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

