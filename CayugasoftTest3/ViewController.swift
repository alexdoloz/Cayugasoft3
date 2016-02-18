//
//  ViewController.swift
//  CayugasoftTest3
//
//  Created by Alexander on 17.02.16.
//  Copyright © 2016 Alexander. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let manager = AuthorizationManager()
    var api: PleerAPI!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        manager.getTokenFromEndpoint { error in
            if error == nil {
                print("Token \(self.manager.token!)")
            }
        }
        let delay = 3 * Double(NSEC_PER_SEC)
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(time, dispatch_get_main_queue()) {
            self.api = PleerAPI(authManager: self.manager)
            self.api.searchTracks("laika", page: 1, pageSize: 10) { (tracks, error) -> Void in
            
            }
            
            self.api.getURLForTrackWithId("5616062Hpwi", completion: { (url, error) -> Void in
                
            })
        }
        
    }
}

