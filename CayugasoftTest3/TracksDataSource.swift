//
//  TracksDataSource.swift
//  CayugasoftTest3
//
//  Created by Alexander on 19.02.16.
//  Copyright © 2016 Alexander. All rights reserved.
//

import UIKit


/* Управляет воспроизведением треков */
class TracksDataSource: NSObject, UITableViewDataSource, UITableViewDelegate, PlayerDelegate {
    static let defaultPageSize = 200
    
    private(set) var tracks: [Track] = []
    private(set) var tableView: UITableView
    
    private(set) var currentlyPlaying: Int? {
        willSet(newRow) {
            guard let newRow = newRow else {
                currentlyPlayingRowChangeHandler?(track: nil, newRow: nil)
                return
            }
            let track = self.tracks[newRow]
            currentlyPlayingRowChangeHandler?(track: track, newRow: newRow)
        }
    }
    
    private var player: Player?
    var currentlyPlayingRowChangeHandler: ((track: Track?, newRow: Int?) -> Void)?
    
    init(tableView: UITableView, api: PleerAPI) {
        self.tableView = tableView
        self.api = api
    }
    
    func loadTracks(query: String) {
        self.currentlyPlaying = nil
        self.query = query
        self.fullListIsLoaded = false
        self.currentPage = 0
        self.tracks = []
        self.loadMoreTracks()
    }
    
    func play(row: Int) {
        self.player = nil
        self.currentlyPlaying = row
        self.tableView.reloadData()
        let track = self.tracks[row]
        if let url = track.url {
            let player = Player(url: url)
            player.delegate = self
            player.play()
            self.player = player
        } else {
            self.api.getURLForTrack(track, completion: { url, error in
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
    
    func playNext() {
        if let currentRow = self.currentlyPlaying {
            if currentRow < self.tracks.count - 1 {
                self.play(currentRow + 1)
            }
        }
    }
    
    func playPrev() {
        if let currentRow = self.currentlyPlaying {
            if currentRow > 0 {
                self.play(currentRow - 1)
            }
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
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if let paths = self.tableView.indexPathsForVisibleRows,
            let last = paths.last {
                let bottomMargin = 20
                if last.row > self.tracks.count - bottomMargin {
                    self.loadMoreTracks()
                }
        }
        
    }

// MARK: Private
    private var api: PleerAPI
    private var fullListIsLoaded = false
    private var isLoading = false
    private var currentPage = 0
    private var query: String!
    
    private func loadMoreTracks() {
        if self.isLoading || self.fullListIsLoaded { return }
        self.isLoading = true
        let pageSize = TracksDataSource.defaultPageSize
        let currentQuery = query
        self.api.searchTracks(self.query, page: self.currentPage + 1, pageSize: pageSize) { tracks, count, error in
            self.isLoading = false
            guard currentQuery == self.query else { return }
            guard error == nil else { return }
            if tracks.count < pageSize {
                self.fullListIsLoaded = true
            }
            self.currentPage++
            self.tracks.appendContentsOf(tracks)
            self.tableView.reloadData()
        }
    }
    
// MARK: PlayerDelegate
    func observeTime(time: Int) {
        guard let row = self.currentlyPlaying else { return }
        guard let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: row, inSection: 0)) as? TrackCell else { return }
        
        cell.trackProgress = time
    }
    
    func playbackFinished() {
        self.playNext()
    }
}
