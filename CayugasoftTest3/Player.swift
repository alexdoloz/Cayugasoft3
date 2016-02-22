//
//  Player.swift
//  
//
//  Created by Alexander on 19.02.16.
//
//

import UIKit
import AVFoundation


protocol PlayerDelegate: class {
    func observeTime(time: Int)
}


class Player {
    private var player: AVPlayer
    private var observer: AnyObject?
    weak var delegate: PlayerDelegate? {
        didSet {
            if delegate != nil {
                let interval = CMTimeMakeWithSeconds(Float64(0.1), Int32(NSEC_PER_SEC))
                self.observer = player.addPeriodicTimeObserverForInterval(interval, queue: dispatch_get_main_queue()) { [unowned self](time: CMTime) in
                    self.delegate!.observeTime(Int(CMTimeGetSeconds(time)))
                }
            }
        }
    } 
    
    var isPlaying: Bool {
        return self.player.rate != 0.0 && self.player.error == nil
    }
    
    init(url: NSURL) {
        self.player = AVPlayer(URL: url)
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Something wrong with audiosession... \(error)")
        }
    }
    
    func play() {
        player.play()
    }
    
    func pause() {
        player.pause()
    }
    
    deinit {
        if self.observer != nil {
            self.player.removeTimeObserver(self.observer!)
        }
    }
    
}
