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
    override func viewDidLoad() {
        super.viewDidLoad()
        
        manager.getTokenFromEndpoint { error in
            if error == nil {
                print("Token \(self.manager.token!)")
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

