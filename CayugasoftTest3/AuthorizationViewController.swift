//
//  AuthorizationViewController.swift
//  CayugasoftTest3
//
//  Created by Alexander on 19.02.16.
//  Copyright © 2016 Alexander. All rights reserved.
//

import UIKit


private let ShowPlayerSegueId = "ShowPlayer"

class AuthorizationViewController: UIViewController {
    let authManager = AuthorizationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getToken()
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        precondition(segue.identifier == ShowPlayerSegueId)
        let delegate = UIApplication.sharedApplication().delegate! as! AppDelegate
        delegate.authManager = authManager
    }
    
// MARK: IBOutlets and IBActions
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var indicatorView: UIView!
    
    @IBAction func retryPressed(sender: AnyObject) {
        hideError()
        getToken()
    }
    
// MARK: Helpers
    func getToken() {
        authManager.getTokenFromEndpoint { error in
            if error == nil {
                self.showPlayer()
            } else {
                self.showError()
            }
        }
    }
    
    func showPlayer() {
        performSegueWithIdentifier(ShowPlayerSegueId, sender: nil)
    }
    
    func showError() {
        errorView.hidden = false
        indicatorView.hidden = true
    }
    
    func hideError() {
        errorView.hidden = true
        indicatorView.hidden = false
    }
}
