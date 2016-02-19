//
//  TracksDataSource.swift
//  CayugasoftTest3
//
//  Created by Alexander on 19.02.16.
//  Copyright © 2016 Alexander. All rights reserved.
//

import UIKit


class TracksDataSource: NSObject, UITableViewDataSource, UITableViewDelegate {
    var tracks: [Track]!
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! TrackCell
        let row = indexPath.row
        cell.artistLabel.text = "Artist \(row)"
        cell.trackNameLabel.text = "Track \(row)"
        cell.isPlaying = false
        if row == 0 {
            cell.isPlaying = true
            cell.trackLength = 240
            cell.trackProgress = 50
        }
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
}
