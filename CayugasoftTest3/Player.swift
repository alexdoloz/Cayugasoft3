//
//  Player.swift
//  
//
//  Created by Alexander on 19.02.16.
//
//

import UIKit
import AVFoundation


//protocol PlayerDelegate: class {
//    func observeTime(time: Int)
//}


class Player: PlayerType {
    private var player: AVPlayer?
    private var observer: AnyObject?
    weak var delegate: PlayerDelegate?
    
    init() {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Something wrong with audiosession... \(error)")
        }
    }
    
    func play(url: NSURL) {
        self.player = AVPlayer(URL: url)
        let interval = CMTimeMakeWithSeconds(Float64(0.1), Int32(NSEC_PER_SEC))
        self.observer = self.player!
            .addPeriodicTimeObserverForInterval(interval, queue: dispatch_get_main_queue()) { [unowned self](time: CMTime) in
                    self.delegate?.observeTime(Int(CMTimeGetSeconds(time)))
                }

        player!.play()
    }
    
    func resume() {
        player?.play()
    }
    
    func pause() {
        player?.pause()
    }
    
    var isPlaying: Bool {
        return self.player?.rate != 0.0 && self.player?.error == nil
    }
    
    
    deinit {
//        self.player.pause()
        if self.observer != nil {
            self.player?.removeTimeObserver(self.observer!)
        }
    }
    
}
