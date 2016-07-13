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
    var selectedIndexes = Set<NSIndexPath>()
    var selelctedPresenters: [SearchPresentable] {
        return selectedIndexes.map {$0.row}.sort().map {presenters[$0]}
    }
    
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
        
        if selectedIndexes.contains(indexPath) {
            cell.accessoryType = .Checkmark
        } else {
            cell.accessoryType = .None
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        guard let cell = tableView.cellForRowAtIndexPath(indexPath) else {return}
        if selectedIndexes.contains(indexPath) {
            selectedIndexes.remove(indexPath)
            cell.accessoryType = .None
        } else {
            selectedIndexes.insert(indexPath)
            cell.accessoryType = .Checkmark
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        if searchController.searchBar.text!.isEmpty {
            self.filteredPresenters = self.presenters
        } else {
            self.filteredPresenters = self.presenters.filter {presenter in
                presenter.title.containsString(searchController.searchBar.text!)
                || presenter.content.containsString(searchController.searchBar.text!)
            }
        }
        
        self.tableView.reloadData()
    }
}