//
//  TrackCell.swift
//  CayugasoftTest3
//
//  Created by Alexander on 19.02.16.
//  Copyright © 2016 Alexander. All rights reserved.
//

import UIKit

class TrackCell: UITableViewCell {
    @IBOutlet weak var artistLabel: UILabel!

    @IBOutlet weak var trackNameLabel: UILabel!
    @IBOutlet weak var playProgress: UIProgressView!
    @IBOutlet weak var playTimeLabel: UILabel!
    
    var trackLength: Int = 0
    var trackProgress: Int = 0 {
        didSet {
            playProgress.progress = Float(trackProgress) / Float(trackLength)
            playTimeLabel.text = "\(trackProgress)"
        }
    }

    var isPlaying: Bool = false {
        didSet {
            changePlayInfoVisibility(isPlaying)
        }
    }
    
    func changePlayInfoVisibility(value: Bool) {
        playProgress.hidden = !value
        playTimeLabel.hidden = !value
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        isPlaying = false
    }


    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
