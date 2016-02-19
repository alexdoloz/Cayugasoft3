//
//  TracksDataSource.swift
//  CayugasoftTest3
//
//  Created by Alexander on 19.02.16.
//  Copyright © 2016 Alexander. All rights reserved.
//

import UIKit


class TracksDataSource: NSObject, UITableViewDataSource, UITableViewDelegate {
    static let defaultPageSize = 200
    var tracks: [Track] = []
    var tableView: UITableView
    var api: PleerAPI
    
    init(tableView: UITableView, api: PleerAPI) {
        self.tableView = tableView
        self.api = api
    }
    
    func loadTracks(query: String) {
        self.api.searchTracks(query, page: 0, pageSize: TracksDataSource.defaultPageSize) { tracks, count, error in
            self.tracks = tracks ?? []
            self.tableView.reloadData()
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! TrackCell
        let row = indexPath.row
        let track = self.tracks[row]
        
        cell.artistLabel.text = track.artist
        cell.trackNameLabel.text = track.trackName
        cell.isPlaying = false
        if row == 0 {
            cell.isPlaying = true
            cell.trackLength = 240
            cell.trackProgress = 50
        }
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tracks.count
    }
}
