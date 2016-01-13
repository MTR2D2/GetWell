//
//  GoogleAPIController.swift
//  GetWell
//
//  Created by Ju-Ching Elliott on 1/12/16.
//  Copyright © 2016 GetWell. All rights reserved.
//

//import Foundation
//
//
//class GoogleAPIController
//{
//    var delegate: GoogleAPIController
//    
//    init(delegate: GoogleAPIController)
//    {
//        self.delegate = delegate
//    }
//    
//   
//    func searchGooglePlaces(var keyboardEntry: String)
//    {
////        keyboardEntry = keyboardEntry.stringByReplacingOccurrencesOfString("", withString: "%20")
//        let urlPath = "https://maps.googleapis.com/maps/api/place/nearbysearch/json&key=AIzaSyBNoCaPsmxJ7mTK3xhnEispfLeA_t8jjFM"
//        let session = NSURLSession.sharedSession()
//        let task = session.dataTaskWithURL(url!, completionHandler: {data, response, error -> Void in
//            
//            print("Task completed")
//            
//            if  error != nil
//            {
//                print(error!.localizedDescription)
//            }
//            else
//            {
//                if let dictionary = self.parseJSON(data!)
//                {
//                    if let results: NSArray = dictionary["results"] as? NSArray
//                    {
//                        self.delegate.didReceiveAPIResults(results)
//                    }
//                }
//            }
//        })
//        task.resume()
//    }
//
//    func parseJSON(data: NSData) -> NSDictionary?
//    {
//        do
//        {
//            let dictionary: NSDictionary! = try NSJSONSerialization.JSONObjectWithData(data, options: []) as! NSDictionary
//            return dictionary
//        }
//        catch let error as NSError
//        {
//            print(error)
//            return nil
//        }
//        
//    }
//}