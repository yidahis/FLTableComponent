//
//  FLTableViewHandler.swift
//  FLComponentDemo
//
//  Created by 孔凡列 on 2017/6/16.
//  Copyright © 2017年 YY Inc. All rights reserved.
//

import UIKit

@objc protocol FLTableViewHandlerDelegate {
    @objc optional func tableViewDidClick(_ handler : FLTableViewHandler, cellAt indexPath : IndexPath)
    @objc optional func tableViewDidClick(_ handler : FLTableViewHandler, headerAt section : NSInteger)
    @objc optional func tableViewDidClick(_ handler : FLTableViewHandler, footerAt section : NSInteger)
    
    @objc optional func scrollViewDidScroll(_ scrollView: UIScrollView)
}

open class FLTableViewHandler: NSObject {
    
    private(set) lazy var componentsDict : NSMutableDictionary = {
        return NSMutableDictionary.init()
    }()
    
    var components : Array<FLTableBaseComponent> = [] {
        didSet {
            self.tableView?.handler = self
            componentsDict.removeAllObjects()
            for section in 0..<components.count {
                let component = components[section]
                component.section = section
                // same key will override the old value, so the last component will alaways remove first
                componentsDict.setValue(component, forKey: component.componentIdentifier)
            }
        }
    }
    
    weak var delegate : FLTableViewHandlerDelegate?
    
    var tableView : UITableView? {
        return components.first?.tableView
    }
    
    func cellForRow(at indexPath : IndexPath) -> UITableViewCell? {
        return self.tableView?.cellForRow(at:indexPath)
    }
    
    func headerView(forSection section: Int) -> FLTableViewHeaderFooterView? {
        let header = tableView?.headerView(forSection: section) as? FLTableViewHeaderFooterView
        return header
    }
    
    func footerView(forSection section: Int) -> FLTableViewHeaderFooterView? {
        let footer = tableView?.footerView(forSection: section) as? FLTableViewHeaderFooterView
        return footer
    }
    
}

// Mark : component control

extension FLTableViewHandler : FLTableViewHandlerProtocol {

    func component(by identifier: String) -> FLTableBaseComponent? {
        guard componentsDict.count > 0, !identifier.isEmpty else {
            return nil
        }
        return componentsDict.value(forKey: identifier)  as? FLTableBaseComponent
    }
    
    func component(at index : NSInteger) -> FLTableBaseComponent? {
        guard components.count > 0, index < components.count else {
            return nil
        }
        return components[index]
    }
    
    func exchange(_ component : FLTableBaseComponent, by exchangeComponent : FLTableBaseComponent) {
        self.components.exchange(component.section!, by: exchangeComponent.section!)
    }
    
    func replace(_ component : FLTableBaseComponent, by replacementComponent : FLTableBaseComponent) {
        self.components.replaceSubrange(component.section!...component.section!, with: [replacementComponent])
    }
    
    func addAfterIdentifier(_ component : FLTableBaseComponent, after identifier : String) {
        if let afterComponent = self.component(by: identifier) {
            self.addAfterComponent(component, after: afterComponent)
        }
    }
    
    func addAfterComponent(_ component : FLTableBaseComponent, after afterComponent : FLTableBaseComponent) {
        self.addAfterSection(component, after: afterComponent.section!)
    }
    
    func addAfterSection(_ component : FLTableBaseComponent, after index : NSInteger) {
        guard components.count > 0, index < components.count else {
            return
        }
        self.components.insert(component, at: index)
    }
    
    func add(_ component : FLTableBaseComponent) {
        guard components.count > 0 else {
            return
        }
        self.components.append(component)
    }
    
    func removeComponent(by identifier : String, removeType : FLComponentRemoveType) {
        guard components.count > 0 else {
            return
        }
        if let component = self.component(by: identifier) {
            self.componentsDict.removeObject(forKey: identifier)
            if removeType == .All {
                self.components = self.components.filter({ $0 != component })
            }
            else if removeType == .Last {
                self.removeComponent(component)
            }
        }
    }
    
    func removeComponent(_ component : FLTableBaseComponent?) {
        guard component != nil else {
            return
        }
        self.removeComponent(at: component!.section!)
    }
    
    func removeComponent(at index : NSInteger) {
        guard  index < components.count else {
            return
        }
        self.components.remove(at: index)
    }
    
    func reloadComponents() {
        self.tableView?.reloadData()
    }
    
    func reloadComponents(_ components : [FLTableBaseComponent]) {
        guard self.components.count > 0, components.count <= self.components.count else {
            return
        }
        for component in components {
            self.reloadComponent(at: component.section!)
        }
    }
    
    func reloadComponent(_ component : FLTableBaseComponent) {
        self.reloadComponent(at: component.section!)
    }
    
    func reloadComponent(at index : NSInteger) {
        guard components.count > 0, index < components.count else {
            return
        }
        self.tableView?.reloadSections(IndexSet.init(integer: index), with: UITableView.RowAnimation.none)
    }
}

extension FLTableViewHandler :  UITableViewDataSource {
    final public func numberOfSections(in tableView: UITableView) -> Int {
        return components.count
    }
    
    final public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard components.count > 0 else {
            return 0
        }
        return components[section].numberOfRows()
    }
    
    final public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard components.count > 0 else {
            return UITableViewCell()
        }
        let component : FLTableBaseComponent = components[indexPath.section]
        component.section = indexPath.section
        return component.cellForRow(at: indexPath.row)
    }
}

// MARK : header or footer customizaion

extension FLTableViewHandler {
    
    final public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?{
        guard components.count > 0 else {
            return nil
        }
        let component = components[section]
        let headerView : FLTableViewHeaderFooterView? = component.headerView()
        headerView?.delegate = self
        return headerView
    }
    
    final public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView?{
        guard components.count > 0 else {
            return nil
        }
        let component = components[section]
        let footerView : FLTableViewHeaderFooterView? = component.footerView()
        footerView?.delegate = self
        return footerView
    }
}

// MARK : Hight customization

extension FLTableViewHandler {
    
    final public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        guard components.count > 0 else {
            return 0
        }
        return components[indexPath.section].heightForRow(at: indexPath.row)
    }
    
    final public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        guard components.count > 0 else {
            return 0
        }
        return components[section].heightForHeader()
    }
    
    final public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat{
        guard components.count > 0 else {
            return 0
        }
        return components[section].heightForFooter()
    }
    
}

// MARK : Display customization

extension FLTableViewHandler {
    
    final public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath){
        guard components.count > 0, indexPath.section < components.count else {
            return
        }
        components[indexPath.section].tableView(willDisplayCell: cell, at: indexPath.row)
    }
    
    final public func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath){
        guard components.count > 0, indexPath.section < components.count else {
            return
        }
        components[indexPath.section].tableView(didEndDisplayCell: cell, at: indexPath.row)
    }
    
    final public func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int){
        guard components.count > 0, section < components.count else {
            return
        }
        components[section].tableView(willDisplayHeaderView: (view as? FLTableViewHeaderFooterView)!)
    }
    
    final public func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int){
        guard components.count > 0, section < components.count else {
            return
        }
        components[section].tableView(willDisplayFooterView: (view as? FLTableViewHeaderFooterView)!)
    }
    
    final public func tableView(_ tableView: UITableView, didEndDisplayingHeaderView view: UIView, forSection section: Int){
        guard components.count > 0, section < components.count else {
            return
        }
        components[section].tableView(didEndDisplayHeaderView: (view as? FLTableViewHeaderFooterView)!)
    }
    
    final public func tableView(_ tableView: UITableView, didEndDisplayingFooterView view: UIView, forSection section: Int){
        guard components.count > 0, section < components.count else {
            return
        }
        components[section].tableView(didEndDisplayFooterView: (view as? FLTableViewHeaderFooterView)!)
    }
}


// MARK : Event

extension FLTableViewHandler : UITableViewDelegate, FLTableComponentEvent {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.tableViewDidClick?(self, cellAt: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        guard components.count > 0, indexPath.section < components.count else {
            return false
        }
        if let cell = tableView.cellForRow(at: indexPath) {
            return components[indexPath.section].tableView(shouldHighlight: cell, at: indexPath.row)
        }
        return false
    }
    
    public func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        guard components.count > 0, indexPath.section < components.count else {
            return
        }
        if let cell = tableView.cellForRow(at: indexPath) {
            components[indexPath.section].tableView(didHighlight: cell, at: indexPath.row)
        }
    }
    
    public func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        guard components.count > 0, indexPath.section < components.count else {
            return
        }
        if let cell = tableView.cellForRow(at: indexPath) {
            components[indexPath.section].tableView(didUnHighlight: cell, at: indexPath.row)
        }
    }
    
    func tableHeaderView(_ headerView: FLTableViewHeaderFooterView, didClickSectionAt section: Int) {
        self.delegate?.tableViewDidClick?(self, headerAt: section)
    }
    
    func tableFooterView(_ footerView: FLTableViewHeaderFooterView, didClickSectionAt section: Int) {
        self.delegate?.tableViewDidClick?(self, footerAt : section)
    }
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.delegate?.scrollViewDidScroll?(scrollView)
    }
}


