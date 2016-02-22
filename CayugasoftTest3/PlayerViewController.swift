//
//  ViewController.swift
//  CayugasoftTest3
//
//  Created by Alexander on 17.02.16.
//  Copyright © 2016 Alexander. All rights reserved.
//

import UIKit

class PlayerViewController: UIViewController, UISearchControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate {
    var api: PleerAPI!
    var dataSource: TracksDataSource!
    var searchController: UISearchController!
// MARK: Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func prevPressed(sender: AnyObject) {
        self.dataSource?.playPrev()
    }
    
    @IBAction func nextPressed(sender: AnyObject) {
        self.dataSource?.playNext()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let authManager = (UIApplication.sharedApplication().delegate as! AppDelegate).authManager
        self.api = PleerAPI(authManager: authManager)
        self.dataSource = TracksDataSource(tableView: self.tableView, api: self.api)
        self.tableView.dataSource = dataSource
        self.tableView.delegate = dataSource
        
        self.searchController = UISearchController(searchResultsController: nil)
        self.searchController.delegate = self
        self.searchController.searchResultsUpdater = self
        self.searchController.searchBar.delegate = self
        self.searchController.definesPresentationContext = true
        self.tableView.tableHeaderView = self.searchController.searchBar
        
//        self.dataSource.loadTracks("eminem")
    }
    
    func willDismissSearchController(searchController: UISearchController) {
        let query = searchController.searchBar.text!
        self.dataSource.loadTracks(query)
    }

    func updateSearchResultsForSearchController(searchController: UISearchController) {
        
    }
    
// MARK: UISearchBarDelegate
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        self.searchController.dismissViewControllerAnimated(true, completion: nil)
        let query = searchBar.text ?? ""
        self.dataSource.loadTracks(query)
    }
}

