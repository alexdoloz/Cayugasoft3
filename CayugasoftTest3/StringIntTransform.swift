//
//  StringIntTransform.swift
//  CayugasoftTest3
//
//  Created by Alexander on 19.02.16.
//  Copyright © 2016 Alexander. All rights reserved.
//

import Foundation
import ObjectMapper


class StringIntTransform: TransformType {
    func transformFromJSON(value: AnyObject?) -> Int? {
        if !(value is String) { return nil }
        return Int(value as! String)
    }
    
	func transformToJSON(value: Int?) -> String? {
        return String(value)
    }
}