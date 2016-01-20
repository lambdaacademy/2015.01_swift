//
//  VoteUploader.swift
//  Voter
//
//  Created by Wojciech Nagrodzki on 22/02/15.
//  Copyright (c) 2015 Lambda Academy. All rights reserved.
//

import Foundation

let updateURL = "http://xmpp.lambdadays.org/talk_api/update"
let talksURL = "http://xmpp.lambdadays.org/talk_api/index"

class VoteUploader: NSObject
{
    func submitVotes(votes: NSDictionary, succeded: (() -> Void)?, failed: ((error: NSError?) -> Void)? = nil )
    {
        print("Votes: \(votes)")
        let request = NSMutableURLRequest(URL: NSURL(string: updateURL)!)
        request.HTTPMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        print("Request: \(request)")
        
        let bodyData: NSData?
        do {
            bodyData = try NSJSONSerialization.dataWithJSONObject(votes, options: NSJSONWritingOptions(rawValue: 0))
        } catch let error as NSError {
            // TODO failed
            bodyData = nil
        }
        print("string: \(NSString(data: bodyData!, encoding: NSUTF8StringEncoding))")
        request.HTTPBody = bodyData
        print("bodyData: \(bodyData)")
        print("headers: \(request.allHTTPHeaderFields)")
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            let httpResp = response as! NSHTTPURLResponse
            print("Response: \(response)")
            let strData = NSString(data: data!, encoding: NSUTF8StringEncoding)
            print("Body: \(strData)")
//            var err: NSError?
//            var json = NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves, error: &err)
            if (httpResp.statusCode == 200) {
                if let s = succeded {
                    s()
                }
            }
            else {
                if let f = failed {
                    f(error: error)
                }
            }
        })
        
        task.resume()
    }
    
    func getTalks(succeded: ((NSArray) -> Void)?, failed: ((error: NSError?) -> Void)? = nil )
    {
        let request = NSMutableURLRequest(URL: NSURL(string: talksURL)!)
        request.HTTPMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        print("Request: \(request)")
        

        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            print("Response: \(response)")
            print("Error: \(error)")
            
            if let httpResp = response as? NSHTTPURLResponse {
                let strData = NSString(data: data!, encoding: NSUTF8StringEncoding)
                print("Body: \(strData)")

                do {
                    let json: NSDictionary! = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableLeaves) as! NSDictionary
                    if (httpResp.statusCode == 200 && json != nil) {
                        if let s = succeded {
                            s(json["talks"] as! NSArray!)
                        }
                    }
                    else {
                        if let f = failed {
                            f(error: error)
                        }
                    }
                }
                catch {
                    if let f = failed {
                        f(error: nil)
                    }
                }
            }
        })
        
        task.resume()
    }
}
