//
//  AuthorizationManager.swift
//  CayugasoftTest3
//
//  Created by Alexander on 18.02.16.
//  Copyright © 2016 Alexander. All rights reserved.
//

import UIKit
import Alamofire


protocol AuthorizationManagerType {
//    var token: String? { get }
    func authorizeRequest(request: NSMutableURLRequest) -> Bool
}


enum AuthorizationError: ErrorType {
    case NetworkError(NSError), ConversionError(String)
}


typealias AuthorizationResultBlock = (error: AuthorizationError?) -> Void


class AuthorizationManager: AuthorizationManagerType {
    let tokenEndpointURLString = "\(BASE_URL_STRING)/token.php"
    
    private(set) var token: String?
    private(set) var expiresIn: Int?
    
    func getTokenFromEndpoint(completion: AuthorizationResultBlock) {
        let bodyParams = [
            "grant_type" : "client_credentials"
        ]
    
        Alamofire.request(
            .POST,
            tokenEndpointURLString,
            parameters: bodyParams,
            encoding: .URL,
            headers: basicAuthHeaders(user: APP_ID, password: APP_KEY))
        .responseJSON { response in
            switch response.result {
                case .Success(let value):
                    guard let token = value["access_token"] as? String,
                        let expiresIn = value["expires_in"] as? Int else {
                        let error = AuthorizationError.ConversionError("Wrong JSON \(value)")
                        completion(error: error)
                        return
                    }
                    self.token = token
                    self.expiresIn = expiresIn
                    completion(error: nil)
                case .Failure(let error):
                    completion(error: .NetworkError(error))
            }
        }
    }
    
    func authorizeRequest(request: NSMutableURLRequest) -> Bool {
        guard let token = self.token else { return false }
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return true
    }
}
