//
//  AuthorizationManager.swift
//  CayugasoftTest3
//
//  Created by Alexander on 18.02.16.
//  Copyright © 2016 Alexander. All rights reserved.
//

import UIKit
import Alamofire


//protocol AuthorizationManagerType {
////    var token: String? { get }
//    func authorizeRequest(request: NSMutableURLRequest) -> Bool
//}


enum AuthorizationError: ErrorType {
    case NetworkError(NSError), ConversionError(String)
}


typealias AuthorizationResultBlock = (error: AuthorizationError?) -> Void


class AuthorizationManager: AuthorizationManagerType {
    let tokenEndpointURLString = "\(BASE_URL_STRING)/token.php"
    
    private lazy var alamofireManager: Alamofire.Manager = {
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        configuration.timeoutIntervalForRequest = 10
        let manager = Alamofire.Manager(configuration: configuration)
        return manager
    }()
    
// MARK: AuthorizationManagerType
    func authorizeRequest(request: NSMutableURLRequest) -> Bool {
        guard let token = self.token else { return false }
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return true
    }
    
    func authorizeSelf(completion: ErrorCompletion) {
        self.getToken(completion)
    }
    
    func scheduleTokenRefreshing() {
        precondition(self.expiresIn != nil)
        self.scheduleTokenRefreshing(self.expiresIn!)
    }

// MARK: Private
    private(set) var token: String?
    private(set) var expiresIn: Int?
    
    private func getToken(completion: ErrorCompletion) {
        let bodyParams = [
            "grant_type" : "client_credentials"
        ]

        alamofireManager.request(
            .POST,
            tokenEndpointURLString,
            parameters: bodyParams,
            encoding: .URL,
            headers: basicAuthHeaders(user: APP_ID, password: APP_KEY))
        .responseJSON { response in
            dispatch_async(dispatch_get_main_queue()) {
                switch response.result {
                    case .Success(let value):
                        guard let token = value["access_token"] as? String,
                            let expiresIn = value["expires_in"] as? Int
                        else {
                            let error = NSError(domain: APP_ERROR_DOMAIN,
                                code: 10,
                                userInfo: nil)
                            completion(error)
                            return
                        }
                        self.token = token
                        self.expiresIn = expiresIn
                        completion(nil)
                    case .Failure(let error):
                        completion(error)
                }
            }
        }
    }
    
    private var timer: NSTimer!
    
    private func scheduleTokenRefreshing(seconds: Int) {
        timer = NSTimer.scheduledTimerWithTimeInterval(NSTimeInterval(seconds),
            target: self,
            selector: "refresh",
            userInfo: nil,
            repeats: false)
        
        NSRunLoop.mainRunLoop().addTimer(timer, forMode: NSDefaultRunLoopMode)
    }
    
    @objc func refresh() {
        self.getToken { error in
            let nextRefresh = error == nil ? self.expiresIn! : 0
            self.scheduleTokenRefreshing(nextRefresh)
        }
    }
    
}
