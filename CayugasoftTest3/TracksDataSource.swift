//
//  TracksDataSource.swift
//  CayugasoftTest3
//
//  Created by Alexander on 19.02.16.
//  Copyright © 2016 Alexander. All rights reserved.
//

import UIKit

class TracksDataSource: NSObject, UITableViewDataSource, UITableViewDelegate, PlayerDelegate {
    static let defaultPageSize = 200
    var tracks: [Track] = []
    var tableView: UITableView
    var api: PleerAPI
    var currentlyPlaying: Int?
    var player: Player?
    
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

// MARK: UITableViewDataSource
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! TrackCell
        let row = indexPath.row
        let track = self.tracks[row]
        
        cell.artistLabel.text = track.artist
        cell.trackNameLabel.text = track.trackName
        cell.isPlaying = false
        if row == self.currentlyPlaying {
            cell.isPlaying = true
            cell.trackLength = track.length!
        }
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tracks.count
    }

// MARK: UITableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        self.playOrPause(indexPath.row)
    }
    
    func playOrPause(row: Int) {
        if row == self.currentlyPlaying {
            let player = self.player!
            if player.isPlaying {
                player.pause()
            } else {
                player.play()
            }
        } else {
            let track = self.tracks[row]
            if let url = track.url {
                let player = Player(url: url)
                player.delegate = self
                player.play()
                self.player = player
                self.currentlyPlaying = row
                tableView.reloadData()
            } else {
                self.api.getURLForTrackWithId(track.trackId!, completion: { url, error in
                    guard let url = url else {
                        print("Error requesting the track url")
                        return
                    }
                    track.url = url
                    self.playOrPause(row)
                })
            }
        }
    }
    
    func observeTime(time: Int) {
        guard let row = self.currentlyPlaying else { return }
        let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: row, inSection: 0))! as! TrackCell
        cell.trackProgress = time
    }
}
