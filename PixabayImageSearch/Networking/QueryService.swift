//
//  QueryService.swift
//  PixabayImageSearch
//
//  Created by Himanshu Sonker on 13/06/20.
//  Copyright © 2020 Pixabay Wynk. All rights reserved.
//

import Foundation

class QueryService {
    
    let defaultSession = URLSession(configuration: .default)
    
    var dataTask: URLSessionDataTask?
    var errorMessage = ""
    
    var images: Images?
    
    typealias QueryResult = (Images?, String) -> Void
    
    func getSearchResults(searchTerm: String, page: Int, completion: @escaping QueryResult) {
        
        let url = PixabayAPI.imageSearchURL(withUserSearchTerms: searchTerm, page: page)
        
        let request = URLRequest(url: url)
        let task = defaultSession.dataTask(with: request) { (data, response, error) -> Void in
            if let jsonData = data {
                do {
                    let jsonDecoder = JSONDecoder()
                    self.images = try jsonDecoder.decode(Images.self, from: jsonData)
                   
                } catch let error {
                    print("Error creating JSON object: \(error)")
                    self.errorMessage += "DataTask error: " + error.localizedDescription + "\n"
                    
                }
                
            } else if let requestError = error {
                self.errorMessage += "DataTask error: " + requestError.localizedDescription + "\n"
                print("Error fetching images: \(requestError)")
                
            } else {
                self.errorMessage += "DataTask error: " + "Unexpected error with the request" + "\n"
                print("Unexpected error with the request")
                
            }
            DispatchQueue.main.sync {
                completion(self.images, self.errorMessage)
                
            }
            
        }
        task.resume()
    }
    
}
