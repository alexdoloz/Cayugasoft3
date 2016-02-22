//
//  PleerAPI.swift
//  CayugasoftTest3
//
//  Created by Alexander on 18.02.16.
//  Copyright © 2016 Alexander. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper


//typealias PleerAPITracksCompletion = (tracks: [Track], count: Int?, error: NSError?) -> Void
//typealias PleerAPIURLCompletion = (url: NSURL?, error: NSError?) -> Void


enum Router: URLRequestConvertible {
    case SearchTracks(query: String, page: Int, pageSize: Int)
    case GetTrackURL(trackId: String)

    var URLRequest: NSMutableURLRequest {
        let url = NSURL(string: "\(BASE_URL_STRING)/index.php")!
        var result = NSMutableURLRequest(URL: url)
        result.HTTPMethod = Alamofire.Method.POST.rawValue
        var params: [String : String] = [:]
        switch self {
            case .GetTrackURL(let trackId):
                params[API_METHOD_KEY] = "tracks_get_download_link"
                params["track_id"] = trackId
                params["reason"] = "listen"
            
            case .SearchTracks(let query, let page, let pageSize):
                params[API_METHOD_KEY] = "tracks_search"
                params["query"] = query
                params["page"] = String(page)
                params["result_on_page"] = String(pageSize)
        }
        let encoding = Alamofire.ParameterEncoding.URL
        (result, _) = encoding.encode(result, parameters: params)
        return result
    }
}




class PleerAPI {
    private(set) var authManager: AuthorizationManager
    private var notAuthorizedError: NSError
    private var wrongDataError: NSError
    
    
    init(authManager: AuthorizationManager) {
        self.authManager = authManager
        self.notAuthorizedError = NSError(domain: APP_ERROR_DOMAIN, code: 100, userInfo: nil)
        self.wrongDataError = NSError(domain: APP_ERROR_DOMAIN, code: 200, userInfo: nil)
    }

    func searchTracks(query: String, page: Int, pageSize: Int, completion: TracksCompletion) {
        let router = Router.SearchTracks(query: query, page: page, pageSize: pageSize)
        let request = router.URLRequest
        guard authManager.authorizeRequest(request) else {
            completion(tracks: [], count: nil, error: notAuthorizedError)
            return
        }
        Alamofire.request(request)
            .responseJSON { response in
            switch response.result {
                case .Success(let value):
                    guard let json = value as? [String : AnyObject],
                        let jsonTracks = json["tracks"],
                        let jsonCount = json["count"]
                    else {
                        completion(tracks: [], count: nil, error: self.wrongDataError)
                        return
                    }
                    
                    let tracks = Mapper<Track>()
                        .mapDictionary(jsonTracks)?
                        .map { $1 }
                    
                    var count: Int!
                    if jsonCount is Int {
                        count = jsonCount as! Int
                    } else if jsonCount is String {
                        count = Int(jsonCount as! String)
                    }
                    
                    completion(tracks: tracks ?? [], count: count, error: nil)
                case .Failure(let error):
                    completion(tracks: [], count: nil, error: error)
            }
        }
    }
    
    func getURLForTrack(track: Track, completion: URLCompletion) {
        let router = Router.GetTrackURL(trackId: track.trackId!)
        let request = router.URLRequest
        guard authManager.authorizeRequest(request) else {
            completion(url: nil, error: notAuthorizedError)
            return
        }
        Alamofire.request(request).responseJSON { response in
            switch response.result {
                case .Success(let value):
                    guard let json = value as? [String : AnyObject],
                        let urlString = json["url"] as? String,
                        let url = NSURL(string: urlString)
                    else {
                        completion(url: nil, error: self.wrongDataError)
                        return
                    }
                    completion(url: url, error: nil)
                case .Failure(let error):
                    completion(url: nil, error: error)
            }
        }
    }
}