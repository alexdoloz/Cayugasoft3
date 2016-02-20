//
//  TrackCell.swift
//  CayugasoftTest3
//
//  Created by Alexander on 19.02.16.
//  Copyright © 2016 Alexander. All rights reserved.
//

import UIKit


enum CellState {
    case Playing, Paused, NotPlaying
    var playerImage: UIImage? {
        switch self {
            case .Playing: return UIImage(named: "pause")
            case .Paused: return UIImage(named: "play")
            case .NotPlaying: return nil
        }
    }
}

class TrackCell: UITableViewCell {
    @IBOutlet weak var artistLabel: UILabel!

    @IBOutlet weak var trackNameLabel: UILabel!
    @IBOutlet weak var playProgress: UIProgressView!
    @IBOutlet weak var playTimeLabel: UILabel!
    @IBOutlet weak var playerImageView: UIImageView!
    
    @IBOutlet weak var spaceToCellConstraint: NSLayoutConstraint!
    @IBOutlet weak var spaceToImageConstraint: NSLayoutConstraint!
    
    var trackLength: Int = 1
    var trackProgress: Int = 0 {
        didSet {
            playProgress.progress = Float(trackProgress) / Float(trackLength)
            playTimeLabel.text = "\(timePrettyPrinted(trackProgress))"
        }
    }
    
    var cellState: CellState = .NotPlaying {
        willSet(newState) {
            let isCurrentCell = newState != .NotPlaying
            changePlayInfoVisibility(isCurrentCell)
            changeImage(newState.playerImage)
        }
    }
    
    func changePlayInfoVisibility(value: Bool) {
        playProgress.hidden = !value
        playTimeLabel.hidden = !value
    }
    
    func changeImage(image: UIImage?) {
        let imageViewHidden = image == nil
        let newAlpha: CGFloat = imageViewHidden ? 0.0 : 1.0
        spaceToCellConstraint.active = false
        spaceToImageConstraint.active = false // чтобы не возникало Unable to simultaneously satisfy constraints
        spaceToCellConstraint.active = imageViewHidden
        spaceToImageConstraint.active = !imageViewHidden
        
        if let image = image {
            self.playerImageView.image = image
        }
        UIView.animateWithDuration(0.25) {
            self.playerImageView.alpha = newAlpha
            self.layoutIfNeeded()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        UIView.performWithoutAnimation {
            self.cellState = .NotPlaying
        }
        self.trackProgress = 0
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
