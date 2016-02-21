//
//  Protocols.swift
//  CayugasoftTest3
//
//  Created by Alexander on 21.02.16.
//  Copyright © 2016 Alexander. All rights reserved.
//


import UIKit

protocol PlayerDelegate: class {
    func observeTime(time: Int)
    func playbackFinished()
}

protocol PlayerType: class {
    func play(url: NSURL)
    func pause()
    func resume()
//    var url: NSURL { get }
    var isPlaying: Bool { get }
    
    weak var delegate: PlayerDelegate? { get set }
}

typealias TracksCompletion = (tracks: [Track], count: Int?, error: NSError?) -> Void
typealias URLCompletion = (url: NSURL?, error: NSError?) -> Void
typealias ErrorCompletion = (NSError?) -> Void

protocol AuthorizationManagerType {
//    func getToken(completion: ErrorCompletion)
    func authorizeSelf(completion: ErrorCompletion)
    func authorizeRequest(request: NSMutableURLRequest) -> Bool
    func scheduleTokenRefreshing()
}

protocol PleerAPIType {
    func searchTracks(query: String, page: Int, pageSize: Int, completion: TracksCompletion)
    func getURLForTrack(track: Track, completion: URLCompletion)
    var authManager: AuthorizationManagerType { get }
}

protocol TracksLoaderType {
    init(query: String, pageSize: Int)
    var pageSize: Int { get set }
    var totalTrackCount: Int { get }
    var tracks: [Track] { get }
    var api: PleerAPIType { get }
    func loadMoreTracks(completion: (success: Bool) -> Void)
}

protocol TracksTableManagerType: UITableViewDataSource, UITableViewDelegate, PlayerDelegate {
    var loader: TracksLoaderType { get }
    var currentlyPlayingRow: Int? { get set }
    func pause()
    func resume()
}


