//
//  Utils.swift
//  CayugasoftTest3
//
//  Created by Alexander on 20.02.16.
//  Copyright © 2016 Alexander. All rights reserved.
//

import Foundation

func timePrettyPrinted(timeInSeconds: Int) -> String {
    let seconds = timeInSeconds % 60
    let minutes = timeInSeconds / 60
    return String(format: "%d:%02d", minutes, seconds)
}