//
//  ViewController.swift
//  CayugasoftTest3
//
//  Created by Alexander on 17.02.16.
//  Copyright © 2016 Alexander. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var api: PleerAPI!
    var dataSource: TracksDataSource!
// MARK: Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let authManager = (UIApplication.sharedApplication().delegate as! AppDelegate).authManager
        self.api = PleerAPI(authManager: authManager)
        self.dataSource = TracksDataSource(tableView: self.tableView, api: self.api)
        tableView.dataSource = dataSource
        tableView.delegate = dataSource
        
        self.dataSource.loadTracks("eminem")
//        
//        manager.getTokenFromEndpoint { error in
//            if error == nil {
//                print("Token \(self.manager.token!)")
//            }
//        }
//        let delay = 3 * Double(NSEC_PER_SEC)
//        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
//        dispatch_after(time, dispatch_get_main_queue()) {
//            self.api = PleerAPI(authManager: self.manager)
//            self.api.searchTracks("laika", page: 1, pageSize: 10) { (tracks, count, error) -> Void in
//                print(tracks!)
//                print(count!)
//            }
//            
//            self.api.getURLForTrackWithId("5616062Hpwi", completion: { (url, error) -> Void in
//                print(url)
//            })
//        }
//        
    }
}

