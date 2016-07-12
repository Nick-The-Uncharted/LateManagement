//
//  SearchTableViewController.swift
//  LateManagement
//
//  Created by administrasion on 7/11/16.
//  Copyright © 2016 NJU. All rights reserved.
//

import UIKit

class SearchTableViewController: UITableViewController, UISearchResultsUpdating {
    let searchController = UISearchController(searchResultsController: nil)
    var presenters = [SearchPresentable]()
    var filteredPresenters = [SearchPresentable]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        self.definesPresentationContext = true
        
        self.tableView.tableHeaderView = searchController.searchBar
        self.tableView.tableFooterView = UIView(frame: .zero)
        
        self.tableView.registerReusableCell(TableViewCell1.self)
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 62
        
        
        self.tableView.emptyDataSetSource = self
        self.tableView.emptyDataSetDelegate = self
        
        self.getInitailData()
    }
    
    func handleInititalData(presenters: [SearchPresentable]? , error: MyError?, completionHandler: SimpleBlock?) {
        if let error = error {
            ErrorHandlerCenter.handleError(error, sender: self)
        } else if let presenters = presenters {
            self.presenters = presenters
            self.tableView.reloadData()
        } else {
            ErrorHandlerCenter.handleError(.Unknown("Program Error"), sender: self)
        }
        
        completionHandler?()
        
    }
    
    func getInitailData(completionHandler: SimpleBlock? = nil) {
        fatalError("not implemented")
    }
    
    func getPresenterAtIndexPath(indexPath: NSIndexPath) -> SearchPresentable? {
        let presenter: SearchPresentable?
        if searchController.active {
            presenter = filteredPresenters.get(indexPath.row)
        } else {
            presenter = presenters.get(indexPath.row)
        }
        
        return presenter
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.active {
            return filteredPresenters.count
        } else {
            return presenters.count
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell() as TableViewCell1
        
        if let user = self.getPresenterAtIndexPath(indexPath) {
            cell.updateWithPresenter(user)
        } else {
            log.error("no user at index \(indexPath)")
        }
        
        
        cell.accessoryType = .Checkmark
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        self.filteredPresenters = self.presenters.filter {presenter in presenter.title.containsString(searchController.searchBar.text!)}
        self.tableView.reloadData()
    }
}