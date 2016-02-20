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
    var currentlyPlaying: Int? {
        willSet {
            self.tableView.reloadData()
        }
    }
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
        var cellState: CellState = .NotPlaying

        if row == self.currentlyPlaying {
            cell.trackLength = track.length!
            guard self.player != nil else { return cell }
            cellState = self.player!.isPlaying ? .Playing : .Paused
            cell.cellState = cellState
        }
        UIView.performWithoutAnimation { cell.cellState = cellState }
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tracks.count
    }

// MARK: UITableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if indexPath.row == self.currentlyPlaying {
            guard let player = self.player else { return }
            var cellState: CellState
            if player.isPlaying {
                player.pause()
                cellState = .Paused
            } else {
                player.play()
                cellState = .Playing
            }
            let cell = tableView.cellForRowAtIndexPath(indexPath)! as! TrackCell
            cell.cellState = cellState
        } else {
            self.play(indexPath.row)
        }
    }
    
    func play(row: Int) {
        self.player = nil
        self.currentlyPlaying = row
        let track = self.tracks[row]
        if let url = track.url {
            let player = Player(url: url)
            player.delegate = self
            player.play()
            self.player = player
        } else {
            self.api.getURLForTrackWithId(track.trackId!, completion: { url, error in
                guard let url = url else {
                    print("Error requesting the track url \(error)")
                    return
                }
                track.url = url
                if row == self.currentlyPlaying {
                    self.play(row)
                }
            })
        }
    }
    
    func observeTime(time: Int) {
        guard let row = self.currentlyPlaying else { return }
        guard let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: row, inSection: 0)) as? TrackCell else { return }
        
        cell.trackProgress = time
    }
}
