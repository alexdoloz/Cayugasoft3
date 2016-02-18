//
//  Track.swift
//  CayugasoftTest3
//
//  Created by Alexander on 18.02.16.
//  Copyright © 2016 Alexander. All rights reserved.
//

import UIKit
import ObjectMapper


class Track: Mappable, CustomStringConvertible {
    var trackId: String?
    var length: Int?
    var artist: String?
    var trackName: String?
    
	required init?(_ map: Map) {}
    
	func mapping(map: Map) {
        trackId <- map["id"]
        length <- map["length"]
        artist <- map["artist"]
        trackName <- map["track"]
    }
    var description: String {
        return "TRACK \(trackId ?? "--"): \(artist ?? "--") - \(trackName ?? "--")"
    }
}
