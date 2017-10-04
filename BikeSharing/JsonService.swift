//
//  JsonService.swift
//  BikeSharing
//
//  Created by Vishal Bharam on 9/30/17.
//  Copyright © 2017 Vishal Bharam. All rights reserved.
//

import Foundation


// JSONService : Class to get JSON data from server
class JSONService {
    // GetData function to get JSON data
    func getData(url:String, completionHandler: @escaping (([String:Any]?) -> Void)) -> Void {
        let url: NSURL = NSURL(string: url)!
        let task = URLSession.shared.dataTask(with: url as URL, completionHandler: {data, response, error -> Void in
            if error != nil {
                print("Error: \(error!.localizedDescription)")
            } else {
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:Any]
                    //print(json)
                    return completionHandler(json)
                } catch let error as NSError {
                    print("Error: \(error.localizedDescription)")
                } catch {
                    print("Something went wrong!")
                }
            } // End of else
            return completionHandler(nil)
        }) // End of dataTaskWithURL
        task.resume()
    }// End of getData function
}// End of JSONService
