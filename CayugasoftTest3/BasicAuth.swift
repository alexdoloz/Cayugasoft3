//
//  Alamofire+BasicAuth.swift
//  CayugasoftTest3
//
//  Created by Alexander on 18.02.16.
//  Copyright © 2016 Alexander. All rights reserved.
//

import Foundation

func basicAuthHeaders(user user: String, password: String) -> [String : String] {
    let userPassword = "\(user):\(password)" as NSString
    let data = userPassword.dataUsingEncoding(NSUTF8StringEncoding)!
    let base64 = data.base64EncodedStringWithOptions([])
    let header = "Basic \(base64)"
    return ["Authorization" : header]
}