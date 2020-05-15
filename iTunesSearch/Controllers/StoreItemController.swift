//
//  StoreItemController.swift
//  iTunesSearch
//
//  Created by Jody Abney on 5/15/20.
//  Copyright © 2020 Caleb Hicks. All rights reserved.
//

import Foundation

class StoreItemController {
    
    func fetchItems(matching query: [String: String], completion: @escaping ([StoreItem]?) -> Void) {
        
        let baseURL = URL(string: "https://itunes.apple.com/search?")!
        
        guard let url = baseURL.withQueries(query) else {
            
            completion(nil)
            print("Unable to build URL with supplied queries.")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                if let data = data,
                    let rawJSON = try? JSONSerialization.jsonObject(with: data),
                    let json = rawJSON as? [String: Any],
                    let resultsArray = json["results"] as? [[String: Any]] {
                    
                    let storeItems = resultsArray.compactMap { StoreItem(json: $0) }
                    completion(storeItems)
                    
                } else {
                    print("Either no data was returned, or data was not serialized.")
                    
                    completion(nil)
                    return
                }
            }
        }
        
        task.resume()
    }
}
