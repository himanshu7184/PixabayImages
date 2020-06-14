//
//  PixabayApi.swift
//  PixabayImageSearch
//
//  Created by Himanshu Sonker on 12/06/20.
//  Copyright © 2020 Pixabay Wynk. All rights reserved.
//

import Foundation

struct PixabayAPI {
    
    private static let baseURLString = Constants.PIXABAY_SERVER_URL
    private static let api_key = Constants.PIXABAY_API_KEY
    
    
    //New: function that takes search terms entered at run time by user
    // and calls the private function with those parameters to make the URL
    static func imageSearchURL(withUserSearchTerms searchTerms: String?, page: Int) -> URL {
        guard let searchParameterString = searchTerms else {
            return pixabayURL(parameters: ["q": ""])
        }
        let searchParameter = ["q": searchParameterString, "page": "\(page)"]
        return pixabayURL(parameters: searchParameter)
    }
    
    private static func pixabayURL(parameters: [String:String]?) -> URL {
        //TO DO: use the endpoint string with parameters to construct the URL
        
        var components = URLComponents(string: baseURLString)!
        
        var queryItems = [URLQueryItem]()
        
        let baseParams = [
            "key": api_key,
            "image_type": "photo"
            ]
        
        //iterate through baseParams & append each key: value pair to queryItems
        for (key, value) in baseParams {
            let item = URLQueryItem(name: key, value: value)
            queryItems.append(item)
        }
        
        //iterate through additionalParams & append each key: value pair to queryItems
        if let additionalParams = parameters {
            for (key, value) in additionalParams {
                let item = URLQueryItem(name: key, value: value)
                queryItems.append(item)
            }
        }
        
        components.queryItems = queryItems
        
        return components.url!
    }
}
