//
//  Player.swift
//  
//
//  Created by Alexander on 19.02.16.
//
//

import UIKit
import AVFoundation


class Player: NSObject {
    private var player: AVPlayer
    
    init(url: NSURL) {
        self.player = AVPlayer(URL: url)
    }
    
    func play() {
        player.play()
    }
    
    func pause() {
        player.pause()
    }
    
}
