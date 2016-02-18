//
//  PleerAPI.swift
//  CayugasoftTest3
//
//  Created by Alexander on 18.02.16.
//  Copyright © 2016 Alexander. All rights reserved.
//

import Foundation
import Alamofire


typealias PleerAPITracksCompletion = (tracks: [Track]?, error: NSError?) -> Void
typealias PleerAPIURLCompletion = (url: NSURL?, error: NSError?) -> Void


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
                params["results_on_page"] = String(pageSize)
        }
        let encoding = Alamofire.ParameterEncoding.URL
        (result, _) = encoding.encode(result, parameters: params)
        return result
    }
}

class PleerAPI {
    private(set) var authManager: AuthorizationManager
    
    init(authManager: AuthorizationManager) {
        self.authManager = authManager
    }
    
    private func authorizeRequest(request: NSMutableURLRequest) -> Bool {
        guard let token = self.authManager.token else { return false }
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return true
    }

    func searchTracks(query: String, page: Int, pageSize: Int, completion: PleerAPITracksCompletion) {
        let router = Router.SearchTracks(query: query, page: pageSize, pageSize: pageSize)
        let request = router.URLRequest
        authorizeRequest(request)
        Alamofire.request(request).responseString { (response) -> Void in
            print(response.result.value!)
        }
    }
    
    func getURLForTrackWithId(trackId: String, completion: PleerAPIURLCompletion) {
        let router = Router.GetTrackURL(trackId: trackId)
        let request = router.URLRequest
        authorizeRequest(request)
        Alamofire.request(request).responseString { (response) -> Void in
            print(response.result.value!)
        }
    }
}